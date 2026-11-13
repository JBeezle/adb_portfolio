# Portfolio Summary

Name: Basil Ohuruogu. Student ID: 301924283. Date: 13 November 2026.

Repository: https://github.com/JBeezle/adb_portfolio

Case study: Meridian Medical Centre, an outpatient clinic. The same database runs through all five portfolios.

## Portfolio 1: Database Design

Five tables: `patient`, `doctor`, `appointment`, `diagnosis` and `prescription`. Surrogate ids for joins, unique keys on the medical record number and the doctor email, foreign keys, and checks on status and date of birth. A partial unique index stops a doctor being double-booked for the same time. The schema is in 3NF: repeating diagnoses and drugs are their own rows, and patient and doctor details sit with the patient and doctor rather than the appointment. `Ohuruogu_Basil_301924283_constraint_tests.sql` has six statements that are each rejected.

## Portfolio 2: Query Optimisation

Three reports: a patient's history, appointments per doctor, and upcoming bookings. The clinic tables are small, so the index test uses a separate 100,000-row benchmark table. Counting one day's appointments goes from a sequential scan of all the rows to an index-only scan of the 24 that match, after adding one index on `scheduled_at`. The pages read drop from 768 to 3.

## Portfolio 3: Transactions and Concurrency

A committed booking is saved. A transaction that hits the double-booking constraint rolls back completely, so a valid insert made earlier in it is also undone. For concurrency, two sessions try to book the same doctor and time. The second waits for the first and then fails with the unique violation, so the doctor is never double-booked.

## Portfolio 4: NoSQL

A consultation is modelled as one MongoDB document with its diagnoses and prescriptions inside it, loaded from JSON with `mongoimport`. The queries count the documents, find consultations by a diagnosis inside the array, and read a whole consultation without a join. The relational database still handles the reports across patients and the booking rules.

## Portfolio 5: Distributed and Cloud

A written discussion: a PostgreSQL primary with read replicas for reports and failover, a note that Meridian is too small to shard, strong consistency on the primary with a small lag on the replicas, and a managed cloud deployment with tested backups.

## Reflection

Keeping the real data small and using a separate benchmark table for the index test kept things simple. The main thing I took from Portfolio 2 was to look at the buffer counts in the plan, not just the run time, since that is what showed the index doing less work. The double-booking rule showed up in three places: it is a constraint in the design, it is what makes the failed transaction roll back, and it is what blocks the second booking when two people try to book at once.
