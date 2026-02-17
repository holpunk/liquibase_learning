#!/bin/bash

# Create drivers directory if it doesn't exist
mkdir -p drivers

# Download IBM DB2 JDBC Driver (JCC)
# Using version 11.5.8.0 from Maven Central
DRIVER_URL="https://repo1.maven.org/maven2/com/ibm/db2/jcc/11.5.8.0/jcc-11.5.8.0.jar"
OUTPUT_FILE="drivers/db2jcc4.jar"

if [ -f "$OUTPUT_FILE" ]; then
    echo "Driver already exists at $OUTPUT_FILE"
else
    echo "Downloading DB2 JDBC driver..."
    curl -o "$OUTPUT_FILE" "$DRIVER_URL"
    echo "Download complete."
fi

# Download PostgreSQL JDBC Driver
PG_DRIVER_URL="https://jdbc.postgresql.org/download/postgresql-42.6.0.jar"
PG_OUTPUT_FILE="drivers/postgresql.jar"

if [ -f "$PG_OUTPUT_FILE" ]; then
    echo "Postgres driver already exists at $PG_OUTPUT_FILE"
else
    echo "Downloading Postgres JDBC driver..."
    curl -o "$PG_OUTPUT_FILE" "$PG_DRIVER_URL"
    echo "Download complete."
fi

chmod 644 drivers/*.jar
