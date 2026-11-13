-- Run the sections in order, once, on the loaded sample data.

-- 1. Commit a new booking.
BEGIN;
INSERT INTO appointment (patient_id, doctor_id, scheduled_at, status)
VALUES ((SELECT patient_id FROM patient WHERE mrn='MRN-002'),
        (SELECT doctor_id  FROM doctor  WHERE email='yusuf.sani@meridian.ng'),
        '2026-11-20 09:00+01', 'BOOKED');
COMMIT;

-- The booking is saved.
SELECT count(*) AS booked_for_mrn002
FROM appointment appt JOIN patient pat USING (patient_id)
WHERE pat.mrn = 'MRN-002';

-- 2. A transaction that fails rolls back everything in it.
-- Book a valid slot, then try to double-book Dr Amina at a time she already has.
BEGIN;
INSERT INTO appointment (patient_id, doctor_id, scheduled_at, status)
VALUES ((SELECT patient_id FROM patient WHERE mrn='MRN-004'),
        (SELECT doctor_id  FROM doctor  WHERE email='amina.bello@meridian.ng'),
        '2026-11-21 10:00+01', 'BOOKED');
-- This clashes with Folake's 2026-10-05 slot and raises a unique violation.
INSERT INTO appointment (patient_id, doctor_id, scheduled_at, status)
VALUES ((SELECT patient_id FROM patient WHERE mrn='MRN-004'),
        (SELECT doctor_id  FROM doctor  WHERE email='amina.bello@meridian.ng'),
        '2026-10-05 09:00+01', 'BOOKED');
COMMIT;

-- The valid booking from the failed transaction did not persist.
SELECT count(*) AS mrn004_nov21
FROM appointment appt JOIN patient pat USING (patient_id)
WHERE pat.mrn = 'MRN-004' AND appt.scheduled_at = '2026-11-21 10:00+01';
