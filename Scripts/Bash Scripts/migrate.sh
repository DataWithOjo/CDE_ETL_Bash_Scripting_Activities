#!/bin/bash

# Set Folder location as variable
SOURCE_FOLDER="$(pwd)/Data"

# Create the "json_and_CSV" folder if not exists

mkdir -p "$(pwd)/json_and_CSV"
TARGET_FOLDER="$(pwd)/json_and_CSV"
echo "New folder created at: $TARGET_FOLDER"

# Iterate over each file in the source folder
for file in "$SOURCE_FOLDER"/*; do
    # Checking if it is a regular file and not a directory
    if [ -f "$file" ]; then
        # Get the file extension
        extension="${file##*.}"
        
        # Move only CSV and JSON files
        if [ "$extension" = "csv" ] || [ "$extension" = "json" ]; then
            mv "$file" "$TARGET_FOLDER/"
            echo "Moved $(basename "$file") to $TARGET_FOLDER/"
        fi
    fi
done

echo "All CSV and JSON files moved successfully."
