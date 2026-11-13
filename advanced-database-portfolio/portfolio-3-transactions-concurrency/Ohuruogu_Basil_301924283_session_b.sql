-- Window B (second Query Tool window). Try to book the same doctor and time
-- while window A is still open. This statement waits for A. When A commits it
-- fails with a unique violation (the slot is taken). If A rolls back it succeeds.
INSERT INTO appointment (patient_id, doctor_id, scheduled_at, status)
VALUES ((SELECT patient_id FROM patient WHERE mrn='MRN-002'),
        (SELECT doctor_id  FROM doctor  WHERE email='amina.bello@meridian.ng'),
        '2026-12-01 09:00+01', 'BOOKED');
