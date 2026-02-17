# Liquibase DB2 to RDS Migration Simulation

This project demonstrates how to use GitHub Actions and Liquibase to simulate a database schema migration from an on-premise **IBM DB2** database to an **AWS RDS (PostgreSQL)** database.

## Overview

The workflow simulates the following scenario:
1.  **Legacy System**: An IBM DB2 database with existing schema and data.
2.  **Migration Tool**: Liquibase is used to reverse-engineer the DB2 schema into a database-agnostic format (XML/YAML).
3.  **Target System**: An AWS RDS PostgreSQL database where the captured schema is applied.

## Workflow Steps

The GitHub Actions workflow `.github/workflows/db2-to-rds-migration.yml` performs the following:

1.  **Spin up Services**: Starts Docker containers for DB2 and PostgreSQL to simulate the environments.
2.  **Seed Data**: Connects to the DB2 instance and creates sample tables (`CUSTOMERS`, `ORDERS`) to simulate an existing legacy database.
3.  **Generate Changelog**: Uses `liquibase generate-changelog` to read the schema from DB2 and save it as `db2-schema.xml`.
4.  **Deploy to RDS**: Uses `liquibase update` to apply `db2-schema.xml` to the PostgreSQL instance.
5.  **Verify**: Checks the PostgreSQL database to confirm the tables were created successfully.

## Prerequisites

-   GitHub Actions usage is free for public repositories or within your plan limits.
-   No actual AWS or IBM Cloud accounts are required; everything runs in Docker containers within the CI runner.

## Local Simulation (Optional)

You can also run this simulation on your local machine if you have Docker installed.

1.  **Configure Environment**:
    Copy `.env.example` to `.env`:
    ```bash
    cp .env.example .env
    ```
    *You can adjust the passwords in `.env` if desired.*

2.  **Download Drivers**:
    Because we mount a custom drivers directory, we need to download both the DB2 driver AND the PostgreSQL driver into it. Run:
    ```bash
    ./scripts/download-driver.sh
    ```

3.  **Start the databases**:
    ```bash
    docker-compose up -d
    ```
    *Note: The DB2 container make take several minutes to start.*

3.  **Seed the Source DB (DB2)**:
    ```bash
    # Load variables from .env
    source .env
    
    docker-compose run --rm liquibase \
      --url="jdbc:db2://db2:50000/${DB2_DB_NAME}" \
      --username=db2inst1 \
      --password=${DB2_PASSWORD} \
      execute-sql \
      --sql-file=/liquibase/scripts/seed-db2.sql
    ```

4.  **Generate Changelog (Capture Schema)**:
    ```bash
    source .env
    
    docker-compose run --rm liquibase \
      --url="jdbc:db2://db2:50000/${DB2_DB_NAME}" \
      --username=db2inst1 \
      --password=${DB2_PASSWORD} \
      --changeLogFile=/liquibase/changelogs/db2-legacy.xml \
      generate-changelog
    ```

5.  **Modify Changelog**:
    Manually remove `schemaName="DB2INST1"` and `catalogName="TESTDB"` attributes from the generated XML to make it compatible with the target Postgres database.

6.  **Deploy to Target DB (Postgres)**:
    ```bash
    source .env
    
    docker-compose run --rm liquibase \
      --url="jdbc:postgresql://postgres:5432/${POSTGRES_DB}" \
      --username=${POSTGRES_USER} \
      --password=${POSTGRES_PASSWORD} \
      --changeLogFile=/liquibase/changelogs/db2-legacy.xml \
      update
    ```
