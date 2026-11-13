-- One patient's history: each visit with its diagnosis and prescription.
SELECT appt.scheduled_at::date AS visit_date,
       diag.description AS diagnosis,
       presc.drug_name,
       presc.dosage
FROM appointment appt
JOIN patient pat USING (patient_id)
LEFT JOIN diagnosis diag     ON diag.appointment_id = appt.appointment_id
LEFT JOIN prescription presc ON presc.appointment_id = appt.appointment_id
WHERE pat.mrn = 'MRN-001'
ORDER BY appt.scheduled_at;

-- Appointments per doctor.
SELECT doc.full_name, count(*) AS appointments
FROM appointment appt
JOIN doctor doc USING (doctor_id)
GROUP BY doc.doctor_id, doc.full_name
ORDER BY appointments DESC;

-- Upcoming booked appointments.
SELECT pat.full_name AS patient, doc.full_name AS doctor, appt.scheduled_at
FROM appointment appt
JOIN patient pat USING (patient_id)
JOIN doctor doc USING (doctor_id)
WHERE appt.status = 'BOOKED'
ORDER BY appt.scheduled_at;
