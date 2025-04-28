#!/bin/bash

if [ -z "$SA_PASSWORD" ]; then
  echo "ERROR: SA_PASSWORD is not set!"
  exit 1
fi

if [ -z "$DB_NAME" ]; then
  echo "ERROR: DB_NAME is not set!"
  exit 1
fi

/opt/mssql/bin/sqlservr &

MSSQL_PID=$!

echo "Waiting for SQL Server to start..."


echo ""
sleep 40
echo "SQL Server is up!"

echo "Checking and creating database $DB_NAME..."
/opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P "$SA_PASSWORD" -C -Q "IF DB_ID(N'$DB_NAME') IS NULL CREATE DATABASE [$DB_NAME];"

if [ $? -eq 0 ]; then
  echo "Database check completed successfully."
else
  echo "Failed to execute database creation command."
fi

wait $MSSQL_PID
