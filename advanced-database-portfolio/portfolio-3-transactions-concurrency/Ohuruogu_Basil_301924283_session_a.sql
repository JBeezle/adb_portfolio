-- Window A (first Query Tool window). Book Dr Amina at a new time and keep the
-- transaction open. Do not commit yet. Switch to window B and run its script.
BEGIN;
INSERT INTO appointment (patient_id, doctor_id, scheduled_at, status)
VALUES ((SELECT patient_id FROM patient WHERE mrn='MRN-001'),
        (SELECT doctor_id  FROM doctor  WHERE email='amina.bello@meridian.ng'),
        '2026-12-01 09:00+01', 'BOOKED');

-- After window B is waiting, run this line to finish:
-- COMMIT;
