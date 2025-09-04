#!/bin/bash

# Load environmental variable
if [ -f .env ]; then
    source .env
else
    echo "Error: .env file not found"
    exit 1
fi 

# Access the .env variable and store in a variable in our script
URL=$DOWNLOAD_URL

# Folder destination name 
DOWNLOAD_FOLDER="raw"

# Creating the new folder in the current working directory
mkdir -p "$(pwd)/$DOWNLOAD_FOLDER"
DOWNLOAD_PATH="$(pwd)/$DOWNLOAD_FOLDER"
echo "New folder created at: $DOWNLOAD_PATH"

# Download the file into folder "raw"
FILE_NAME=$(basename "$URL")

if curl -o "$DOWNLOAD_PATH/$FILE_NAME" "$URL"; then
    echo "File '$FILE_NAME' downloaded successfully to '$DOWNLOAD_PATH'."
else
    echo "Error: Failed to download file from $URL"
    exit 1
fi

# Replace column named "Variable_code" to "variable_code"
INPUT="$DOWNLOAD_PATH/$FILE_NAME"
OUTPUT="$DOWNLOAD_PATH/df.csv"

(head -n 1 "$INPUT" | sed 's/Variable_code/variable_code/') > "$OUTPUT"

tail -n +2 "$INPUT" >> "$OUTPUT"

echo "Column 'Variable_code' renamed to 'variable_code' in $OUTPUT"

# Create new Folder "Transformed"
TRANSFORM_FOLDER="Transformed"

# Creating the "Transformed" folder in the current working directory
mkdir -p "$(pwd)/$TRANSFORM_FOLDER"
TRANSFORMED_PATH="$(pwd)/$TRANSFORM_FOLDER"
echo "New folder created at: $TRANSFORMED_PATH"

# Select only columns "year", "Value", "Units", "variable_code"
TRANSFORMED_FILE_NAME="$TRANSFORMED_PATH/2023_year_finance.csv"

awk -F, 'NR==1 {
  # Find the columns in the header with Loop
  for (i=1; i<=NF; i++) {
    if ($i=="year") col1=i
    if ($i=="Value")  col2=i
    if ($i=="Units")   col3=i
    if ($i=="variable_code") col4=i
  }
  # Print the headers
  print $col1 "," $col2 "," $col3 "," $col4
  next
}
{
  # Print the data in same order
  print $col1 "," $col2 "," $col3 "," $col4
}' $OUTPUT > $TRANSFORMED_FILE_NAME

echo "Created Transformed file with selected columns at: $TRANSFORMED_FILE_NAME"

# Create new Folder "Gold"
GOLD_FOLDER="Gold"

# Create "Gold" folder in current working directory
mkdir -p "$(pwd)/$GOLD_FOLDER"
GOLD_PATH="$(pwd)/$GOLD_FOLDER"
echo "New folder created at: $GOLD_PATH"

# Copy the Transformed file into Gold
cp "$TRANSFORMED_FILE_NAME" "$GOLD_PATH"

echo "Just copied the Transformed file to: $GOLD_PATH"

# Confirm that the file exists in Gold
GOLD_FILE_NAME="$GOLD_PATH/2023_year_finance.csv"

if [ -f "$GOLD_FILE_NAME" ]; then
    echo "File successfully loaded into Gold folder: $GOLD_FILE_NAME"
else
    echo "Error: Failed to load file into Gold folder"
    exit 1
fi