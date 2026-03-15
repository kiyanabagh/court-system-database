# Court System Database

A relational database for managing court system operations, built with MySQL.
Designed as a group project for CSCE 4350 (Database Systems) at the
University of North Texas.

## Schema Overview

The database (`quecourt_db`) models the structure and operations of a court system
across multiple buildings, with 12 tables covering physical facilities, personnel,
legal cases, and incident tracking.

**Core tables:**
- `Court_Building` — physical locations with address and capacity
- `Courtroom` — courtroom type (criminal, civil, family, small claims) tied to a building
- `Room` — non-courtroom spaces: libraries, detention areas, offices, meeting rooms
- `Judge` — judge records with appointment date and specialization
- `Case_File` — case records including type, status, rulings, findings, and orders
- `Person` — plaintiffs, defendants, and lawyers linked to cases
- `Employee` — court staff with certifications, education, and a self-referencing supervisor hierarchy
- `Incident_Report` — threat, hazard, theft, and technical incidents
- `Work_Log` — employee hours by date
- `Presides_Over` — many-to-many relationship between judges and cases
- `Reports` — many-to-many relationship between employees and incident reports

## Files

- `schema.sql` — full schema definition with all table creation and constraints
- `projec.sql` — sample data inserts and DML (UPDATE, DELETE) queries
- `projectPart4sql.sql` — analytical queries (see below)

## Sample Queries

- Total civil cases grouped by court location
- Court location with the most threat incidents
- Judge(s) with the most hearings on a specific date (nested aggregate subquery)
- Court buildings in Arizona that have both libraries and detention facilities (EXISTS)
- Payroll report for a date range: employee name, hours worked, total salary
- Delete employees working under 5 hours in a given week
- Give a 23% raise to employees working over 5 hours in a given week

## Setup
```bash
mysql -u root -p < schema.sql
mysql -u root -p < projec.sql
```

Then run queries from `projectPart4sql.sql` in your MySQL client of choice.

## Requirements

- MySQL 8.0+
