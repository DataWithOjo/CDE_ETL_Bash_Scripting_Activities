#!/bin/bash

# Load environmental variable
if [ -f .env ]; then
    source .env
else
    echo "Error: .env file not found"
    exit 1
fi 

# Test the connection credentials
echo "Testing postgres connection..."

# Export the password so psql can use it
export PGPASSWORD="$DB_PASSWORD"

psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d postgres -c "SELECT version();"

if [ $? -eq 0 ]; then
    echo "Connection was successful"
else
    echo "Failed during connection"
    exit 1
fi

# Create database named "posey" if it does not exist
DB_EXIST=$(psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'")
if [ "$DB_EXIST" != "1" ]; then
    echo "Database $DB_NAME does not exist. Creating it..."
    createdb -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" "$DB_NAME"
    echo "Database $DB_NAME created successfully"
else
    echo "Database $DB_NAME already exist"
fi

# Create schema if it does not exist
psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d "$DB_NAME" -c "
    CREATE SCHEMA IF NOT EXISTS \"$SCHEMA_NAME\";
"
echo "Schema $SCHEMA_NAME is ready"

# Iterate over csv files in CSV folder and load them
SOURCE_FOLDER="$(pwd)/CSV"

# Load CSV files
for file in "$SOURCE_FOLDER"/*.csv; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        table_name="${filename%.csv}"

        # Normalize line endings to Unix style
        sed -i 's/\r$//' "$file"
        
        # Extract CSV header
        header=$(head -n 1 "$file")
        
        # Convert header to PostgreSQL column names by replacing characters and ensuring TEXT type
        columns=$(echo "$header" | sed -E 's/[^a-zA-Z0-9_,]/_/g' | sed 's/ /_/g' | sed 's/,/ TEXT,/g')
        columns=$(echo "${columns% TEXT,}")
        columns="${columns} TEXT"

        # Create the table dynamically
        psql -v ON_ERROR_STOP=1 -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d "$DB_NAME" -c "
            DROP TABLE IF EXISTS \"$SCHEMA_NAME\".\"$table_name\";
            CREATE TABLE \"$SCHEMA_NAME\".\"$table_name\" ($columns);
        "

        # Convert the path to Windows format with cygpath for \copy
        win_file_path=$(cygpath -w "$file")

        # Load data using \copy
        psql -v ON_ERROR_STOP=1 -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d "$DB_NAME" <<EOF
SET client_encoding TO 'UTF8';
\copy "$SCHEMA_NAME"."$table_name" FROM '$win_file_path' WITH (FORMAT csv, HEADER true, DELIMITER ',');
EOF

        echo "Finished loading $filename into $SCHEMA_NAME.$table_name"
        
        # Verifies row count after load
        psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d "$DB_NAME" -c "SELECT COUNT(*) FROM \"$SCHEMA_NAME\".\"$table_name\";"
    fi
done

echo "All CSV files have been loaded into schema $SCHEMA_NAME in database $DB_NAME"