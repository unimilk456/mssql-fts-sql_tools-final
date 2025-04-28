#!/bin/bash

# Проверка переменных окружения
if [ -z "$SA_PASSWORD" ]; then
  echo "ERROR: SA_PASSWORD is not set!"
  exit 1
fi

if [ -z "$DB_NAME" ]; then
  echo "ERROR: DB_NAME is not set!"
  exit 1
fi

# Запуск MSSQL Server в фоне
/opt/mssql/bin/sqlservr &

# Получаем PID процесса
MSSQL_PID=$!

echo "Waiting for SQL Server to start..."

# Цикл ожидания доступности SQL Server
#RETRIES=30
#until /opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P "$SA_PASSWORD" -Q "SELECT 1" > /dev/null 2>&1
#do
#    sleep 5
#    RETRIES=$((RETRIES-1))
#    echo -n "."
#    if [ $RETRIES -le 0 ]; then
#      echo "SQL Server did not start in time."
#      kill $MSSQL_PID
#      exit 1
#    fi
#done

echo ""
sleep 40
echo "SQL Server is up!"

# Проверка и создание базы данных
echo "Checking and creating database $DB_NAME..."
/opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P "$SA_PASSWORD" -C -Q "IF DB_ID(N'$DB_NAME') IS NULL CREATE DATABASE [$DB_NAME];"

if [ $? -eq 0 ]; then
  echo "Database check completed successfully."
else
  echo "Failed to execute database creation command."
fi

# Ожидание завершения процесса MSSQL
wait $MSSQL_PID
