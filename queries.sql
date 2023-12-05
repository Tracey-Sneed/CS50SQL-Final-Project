--Typical SQL queries users may run on the database

--query to search all surgeries that are elective
SELECT * FROM "surgeries" WHERE "elective" IS TRUE;

SELECT * FROM "employees" WHERE "job" LIKE "Nurse";

SELECT * FROM "diagnostic_test" WHERE "type" LIKE "MRI" OR "type" LIKE "CT";

-- A insert to add a patient to the patients table
INSERT INTO "patients" ("first_name", "last_name", "emergent", "urgent", "complaints", "insurance", "heart_rate", "blood_pressure", "blood_oxygen_level")
VALUES ('John', 'Doe', FALSE, TRUE, 'sore throat', 'Cigna United', 96, '110/80', 97);

-- An insert to add a surgery
INSERT INTO "surgeries" ("name", "elective", "potential complications", "patient_first_name", "patient_last_name", "patient_unique_id", "surgeon_first_name", "surgeon_last_name", "surgeon_employee_id", "supplies_requisition_full_name", "supplies_requisition_common_name")
VALUES ('Appendectomy', FALSE, 'Infection, sore abdomen', 'Janice', 'Doe', 123456, 'Joseph', 'Doe', 54311, '2,6-diisopropylphenol', 'Propofol');

--An insert to add an appointment
INSERT INTO "appointments" ("patient_first_name", "patient_last_name", "unique_patient_id" "physician_first_name", "physician_last_name", "date", "notes", "insurance")
VALUES ('Jimmy', 'Doe', 'Jasmine', 'Doe', '242953901', 2023-11-28 09:00:00, 'Patient reports of intermittent vomiting since October 10, 2023', 'Aetna');

--Changing an appointment date
UPDATE "appointments"
SET "date" = 2024-01-13 09:00:00
WHERE "unique_patient_id" = 242953901;

--Cancelling an appointment
DELETE FROM "appointments"
WHERE "unique_patient_id" = 242953901;
