-- A separate benchmark table so the real clinic tables stay small and untouched.
-- 100,000 appointments, one per hour, used only to compare query plans.
CREATE SCHEMA IF NOT EXISTS p2_benchmark;

DROP TABLE IF EXISTS p2_benchmark.appointment_history;
CREATE TABLE p2_benchmark.appointment_history AS
SELECT g AS id,
       TIMESTAMPTZ '2020-01-01 00:00:00+00' + g * INTERVAL '1 hour' AS scheduled_at,
       'COMPLETED' AS status
FROM generate_series(1, 100000) AS g;

ANALYZE p2_benchmark.appointment_history;

-- Count one day's appointments, before the index:
EXPLAIN (ANALYZE, BUFFERS)
SELECT count(*) FROM p2_benchmark.appointment_history
WHERE scheduled_at >= TIMESTAMPTZ '2021-06-01 00:00:00+00'
  AND scheduled_at <  TIMESTAMPTZ '2021-06-02 00:00:00+00';

-- Add an index on scheduled_at.
CREATE INDEX appointment_history_scheduled_idx
    ON p2_benchmark.appointment_history (scheduled_at);

-- The same count again, after the index:
EXPLAIN (ANALYZE, BUFFERS)
SELECT count(*) FROM p2_benchmark.appointment_history
WHERE scheduled_at >= TIMESTAMPTZ '2021-06-01 00:00:00+00'
  AND scheduled_at <  TIMESTAMPTZ '2021-06-02 00:00:00+00';
