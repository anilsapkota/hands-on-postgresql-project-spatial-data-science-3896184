# Run an initial setup script for the MariaDB database
# if [ -f .devcontainer/setup-postgresql.sql ]; then
#   psql -h 127.0.0.1 -U postgres postgres < .devcontainer/setup-postgresql.sql
# fi


#!/bin/bash

# Start PostgreSQL service
service postgresql start

# Wait for PostgreSQL to start (you might adjust the sleep time as necessary)
sleep 5

# Check if the SQL setup file exists and run it
if [ -f .devcontainer/setup-postgresql.sql ]; then
  sleep 20
  echo "Executing PostgreSQL setup script..."
  # Replace 'postgres' with your actual username and 'postgres' with your database name if needed
  psql -h 127.0.0.1 -U postgres -d postgres -f .devcontainer/setup-postgresql.sql

  if [ $? -eq 0 ]; then
    echo "PostgreSQL setup script executed successfully."
  else
    echo "Error executing PostgreSQL setup script."
    exit 1
  fi
else
  echo "SQL setup file not found."
fi

# Optionally, run your GeoJSON setup script
if [ -f .devcontainer/setup-geojson.py ]; then
  sleep 20
  echo "Loading GeoJSON data..."
  python3 .devcontainer/setup-geojson.py

  if [ $? -eq 0 ]; then
    echo "GeoJSON data loaded successfully."
  else
    echo "Error loading GeoJSON data."
    exit 1
  fi
else
  echo "GeoJSON setup script not found."
fi

echo "Startup script completed."
