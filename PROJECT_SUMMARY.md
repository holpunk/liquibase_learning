# Simulation Project Created

This project simulates a database migration from IBM DB2 to AWS RDS (PostgreSQL) using Liquibase and GitHub Actions.

## Key Files
- **.github/workflows/db2-to-rds-migration.yml**: The GitHub Actions workflow that orchestrates the entire simulation (Spin up DBs -> Seed DB2 -> Capture Schema -> Deploy to Postgres).
- **docker-compose.yml**: Configuration to run the same simulation locally using Docker.
- **scripts/seed-db2.sql**: SQL script that populates the "Legacy" DB2 database with sample tables and data.
- **README.md**: Detailed instructions on how the simulation works and how to run it.

## How to Run
1. **GitHub Actions**: Simply push this code to a GitHub repository. The workflow will trigger automatically.
2. **Locally**: Run `docker-compose up -d` followed by the manual Liquibase commands listed in the README.

## Notes
- The simulation uses Docker containers to mock the DB2 and RDS instances.
- Schema is reverse-engineered from DB2 using `generate-changelog`.
- The generated changelog is then applied to PostgreSQL to prove portability.
