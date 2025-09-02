# Task 1: Bash ETL Pipeline Implementation

## Project Setup
- Created a working directory using `mkdir` to organize project files.
- Initialized a Git repository and linked it to the remote repository.
- Created a new branch `dev` to work on the task without affecting `main`.
- Added a `.gitignore` file to exclude all `.csv` files and `.env` to prevent sensitive data and large files from being pushed.

## Environment and Script Setup
- Created a `.env` file to store environment variables, including the dataset URL.
- Developed the main Bash script `etl.sh` which uses the `.env` file to perform ETL operations.

## Bash Script ETL Pipeline

### Extract
- Downloaded the dataset from the URL into a newly created folder `raw`.

### Transform
- Renamed the column `Variable_code` to `variable_code` using `sed`.
- Selected only the columns `year`, `Value`, `Units`, and `variable_code` using `awk`.
- Iterated over all column names in the header to identify correct column positions.
- Saved the transformed dataset in a new folder `Transformed` as `2023_year_finance.csv`.

### Load
- Created a new folder `Gold` and copied the transformed file to represent the final, production-ready dataset.

## Automation
- Scheduled the script to run daily at 12:00 AM using `crontab -e`.
- Preferred the `vim` editor to edit cron jobs.
- Set the cron expression as `0 0 * * *` and included the full script path.
- Configured logging so that script output is appended to a log file for monitoring.

## Git Workflow
- After successfully running the project on the `dev` branch, merged changes back into the `main` branch.
- Pushed changes to `origin dev` and created a pull request.
- Followed best practices for branching, development, and merging.