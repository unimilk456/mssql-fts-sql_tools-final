#!/bin/bash

if [ -z "$SA_PASSWORD" ]; then
  echo "ERROR: SA_PASSWORD is not set!"
  exit 1
fi

# Запуск MSSQL Server в фоне
/opt/mssql/bin/sqlservr &

# Получаем PID процесса
MSSQL_PID=$!

echo "Waiting for SQL Server to start..."
sleep 20

echo "Checking and creating database $DB_NAME..."
/opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P "$SA_PASSWORD" -C -Q "IF DB_ID(N'$DB_NAME') IS NULL CREATE DATABASE [$DB_NAME];" \
&& echo " Database check completed." \
|| echo "Failed to execute database creation command."
# Ожидание завершения MSSQL процесса (он будет работать в foreground)
wait $MSSQL_PID
