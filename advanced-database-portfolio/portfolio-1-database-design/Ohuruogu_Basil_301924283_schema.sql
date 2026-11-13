-- Meridian Medical Centre clinic database.
BEGIN;

CREATE TABLE patient (
    patient_id    BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    mrn           VARCHAR(20) NOT NULL UNIQUE,
    full_name     VARCHAR(120) NOT NULL,
    date_of_birth DATE NOT NULL,
    phone         VARCHAR(20),
    CONSTRAINT patient_dob_not_future CHECK (date_of_birth <= CURRENT_DATE)
);

CREATE TABLE doctor (
    doctor_id  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name  VARCHAR(120) NOT NULL,
    specialty  VARCHAR(80) NOT NULL,
    email      VARCHAR(254) NOT NULL UNIQUE
);

CREATE TABLE appointment (
    appointment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id     BIGINT NOT NULL REFERENCES patient (patient_id),
    doctor_id      BIGINT NOT NULL REFERENCES doctor (doctor_id),
    scheduled_at   TIMESTAMPTZ NOT NULL,
    status         VARCHAR(20) NOT NULL DEFAULT 'BOOKED'
                     CHECK (status IN ('BOOKED','COMPLETED','CANCELLED','NO_SHOW'))
);

CREATE TABLE diagnosis (
    diagnosis_id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    appointment_id BIGINT NOT NULL REFERENCES appointment (appointment_id),
    description    VARCHAR(200) NOT NULL
);

CREATE TABLE prescription (
    prescription_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    appointment_id  BIGINT NOT NULL REFERENCES appointment (appointment_id),
    drug_name       VARCHAR(100) NOT NULL,
    dosage          VARCHAR(60) NOT NULL
);

-- A doctor cannot be booked twice for the same time. Cancelled and no-show
-- slots are freed, so that time can be booked again.
CREATE UNIQUE INDEX appointment_no_double_book
    ON appointment (doctor_id, scheduled_at)
    WHERE status IN ('BOOKED','COMPLETED');

COMMIT;
