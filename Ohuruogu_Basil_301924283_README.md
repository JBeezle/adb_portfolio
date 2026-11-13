# MIT 8103 Advanced Database Systems Portfolio

Name: Basil Ohuruogu

Student ID: 301924283

Date: 13 November 2026

Repository: https://github.com/JBeezle/adb_portfolio

## Case study

Meridian Medical Centre is an outpatient clinic. The database registers patients and doctors, books appointments, records diagnoses and prescriptions, and lets staff look up a patient's history.

## Setup

In pgAdmin, create a database called `meridian`, then run these two scripts from the Query Tool:

- `portfolio-1-database-design/Ohuruogu_Basil_301924283_schema.sql`
- `portfolio-1-database-design/Ohuruogu_Basil_301924283_sample_data.sql`

That gives 3 doctors, 4 patients, 5 appointments, 3 diagnoses and 3 prescriptions.

## Portfolios

**1. Database design.** Five tables (patient, doctor, appointment, diagnosis, prescription) with surrogate keys, a unique medical record number and doctor email, foreign keys, and checks on status and date of birth. A partial unique index stops a doctor being booked twice for the same time. Normalised to 3NF. `Ohuruogu_Basil_301924283_constraint_tests.sql` holds six statements that are each rejected.

**2. Query optimisation.** `Ohuruogu_Basil_301924283_queries.sql` has three reports (patient history, appointments per doctor, upcoming bookings). `Ohuruogu_Basil_301924283_optimisation.sql` builds a 100,000-row benchmark table and compares the same count query before and after an index on the date, which turns a sequential scan into an index-only scan.

**3. Transactions and concurrency.** `Ohuruogu_Basil_301924283_transactions.sql` shows a commit, then a transaction that fails on a double-booking and rolls back completely. `Ohuruogu_Basil_301924283_session_a.sql` and `Ohuruogu_Basil_301924283_session_b.sql`, run in two windows, show one booking waiting for the other and then failing, so a doctor is never double-booked.

**4. NoSQL.** A consultation modelled as one MongoDB document with its diagnoses and prescriptions inside it. `Ohuruogu_Basil_301924283_consultations.json` is the data and `Ohuruogu_Basil_301924283_queries.mongodb` runs the queries.

**5. Distributed and cloud.** A written discussion of replication, failover, sharding, consistency and a cloud deployment.

Each folder has its scripts and a `screenshots` folder holding the run evidence.
