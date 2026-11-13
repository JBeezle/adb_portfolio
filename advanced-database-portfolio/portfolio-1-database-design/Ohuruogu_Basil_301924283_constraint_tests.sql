-- Each statement here breaks a rule and should fail.
-- Run them one at a time.

-- 1. Medical record number already exists (unique mrn).
INSERT INTO patient (mrn, full_name, date_of_birth)
VALUES ('MRN-001', 'Someone Else', '1990-01-01');

-- 2. Doctor email already exists (unique email).
INSERT INTO doctor (full_name, specialty, email)
VALUES ('Dr. Grace Nduka', 'General Medicine', 'amina.bello@meridian.ng');

-- 3. Date of birth in the future (check constraint).
INSERT INTO patient (mrn, full_name, date_of_birth)
VALUES ('MRN-999', 'Future Child', '2099-01-01');

-- 4. Status outside the allowed list (check constraint).
INSERT INTO appointment (patient_id, doctor_id, scheduled_at, status)
VALUES (1, 1, '2026-12-01 09:00+01', 'PENDING');

-- 5. Appointment for a patient that does not exist (foreign key).
INSERT INTO appointment (patient_id, doctor_id, scheduled_at)
VALUES (9999, 1, '2026-12-01 09:00+01');

-- 6. Same doctor booked twice at the same time (partial unique index).
INSERT INTO appointment (patient_id, doctor_id, scheduled_at, status)
VALUES ((SELECT patient_id FROM patient WHERE mrn='MRN-003'),
        (SELECT doctor_id  FROM doctor  WHERE email='amina.bello@meridian.ng'),
        '2026-10-05 09:00+01', 'BOOKED');
