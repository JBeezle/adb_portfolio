-- Clinic records. Run once after creating the five empty tables.
BEGIN;

INSERT INTO doctor (full_name, specialty, email) VALUES
 ('Dr. Amina Bello', 'Family Medicine', 'amina.bello@meridian.ng'),
 ('Dr. Chukwuma Obi', 'Cardiology', 'chukwuma.obi@meridian.ng'),
 ('Dr. Yusuf Sani', 'General Medicine', 'yusuf.sani@meridian.ng');

INSERT INTO patient (mrn, full_name, date_of_birth, phone) VALUES
 ('MRN-001', 'Folake Adewale', '1971-06-12', '08030000001'),
 ('MRN-002', 'Chidi Okonkwo',  '1994-03-08', '08030000002'),
 ('MRN-003', 'Aisha Mohammed', '1989-11-21', '08030000003'),
 ('MRN-004', 'Emeka Obi',      '1982-01-30', '08030000004');

-- Appointments. Folake has two completed visits; the rest are a mix.
INSERT INTO appointment (patient_id, doctor_id, scheduled_at, status)
VALUES
 ((SELECT patient_id FROM patient WHERE mrn='MRN-001'),
  (SELECT doctor_id  FROM doctor  WHERE email='amina.bello@meridian.ng'),
  '2026-10-05 09:00+01', 'COMPLETED'),
 ((SELECT patient_id FROM patient WHERE mrn='MRN-001'),
  (SELECT doctor_id  FROM doctor  WHERE email='chukwuma.obi@meridian.ng'),
  '2026-10-26 11:00+01', 'COMPLETED'),
 ((SELECT patient_id FROM patient WHERE mrn='MRN-002'),
  (SELECT doctor_id  FROM doctor  WHERE email='amina.bello@meridian.ng'),
  '2026-10-12 10:00+01', 'COMPLETED'),
 ((SELECT patient_id FROM patient WHERE mrn='MRN-003'),
  (SELECT doctor_id  FROM doctor  WHERE email='yusuf.sani@meridian.ng'),
  '2026-11-16 14:00+01', 'BOOKED'),
 ((SELECT patient_id FROM patient WHERE mrn='MRN-004'),
  (SELECT doctor_id  FROM doctor  WHERE email='yusuf.sani@meridian.ng'),
  '2026-10-20 15:00+01', 'CANCELLED');

-- Diagnoses on the completed visits.
INSERT INTO diagnosis (appointment_id, description)
SELECT appointment_id, d.description
FROM appointment a
JOIN (VALUES
 ('MRN-001','2026-10-05 09:00+01','Essential hypertension'),
 ('MRN-001','2026-10-26 11:00+01','Type 2 diabetes mellitus'),
 ('MRN-002','2026-10-12 10:00+01','Plasmodium falciparum malaria')
) AS d(mrn, at, description)
  ON a.scheduled_at = d.at::timestamptz
 AND a.patient_id = (SELECT patient_id FROM patient WHERE mrn = d.mrn);

-- Prescriptions on the same visits.
INSERT INTO prescription (appointment_id, drug_name, dosage)
SELECT appointment_id, p.drug_name, p.dosage
FROM appointment a
JOIN (VALUES
 ('MRN-001','2026-10-05 09:00+01','Amlodipine','5 mg'),
 ('MRN-001','2026-10-26 11:00+01','Metformin','500 mg'),
 ('MRN-002','2026-10-12 10:00+01','Artemether/Lumefantrine','80/480 mg')
) AS p(mrn, at, drug_name, dosage)
  ON a.scheduled_at = p.at::timestamptz
 AND a.patient_id = (SELECT patient_id FROM patient WHERE mrn = p.mrn);

COMMIT;
