-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

-- A database for a fictional hospital named "North Suburban Hospital"

CREATE TABLE "patients" (
    "unique_patient_id" INT,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "emergent" BOOLEAN NOT NULL,
    "urgent" BOOLEAN NOT NULL,
    "complaints" TEXT
    "insurance" TEXT,
    "prescriptions" TEXT,
    "diagnosis" TEXT,
    "medical_history" TEXT,
    "heart_rate" INT NOT NULL,
    "blood_pressure" TEXT NOT NULL,
    "blood_oxygen_level" FLOAT NOT NULL,
    "room_number" INT,
    "appointment_id" INT NOT NULL,
    PRIMARY KEY("unique_id"),
    FOREIGN KEY("appointment_id") REFERENCES "appointments"("appointment_id")


);

CREATE TABLE "current_employees" (
    "unique_employee_id" INT,
    "first_name" TEXT,
    "last_name" TEXT,
    "job" TEXT,
    "start_date" DATETIME,
    "end_date" DATETIME,
    "notes" TEXT,
    PRIMARY KEY("unique_employee_id")
);

CREATE TABLE "surgeries" (
    "name" TEXT,
    "elective" BOOLEAN,
    "potential_complications" TEXT,
    "patient_first_name" TEXT,
    "patient_last_name" TEXT,
    "patient_unique_id" INT NOT NULL,
    "surgeon_first_name" TEXT NOT NULL,
    "surgeon_last_name" TEXT NOT NULL,
    "secondary_surgeon_first_name" TEXT,
    "secondary_surgeon_last_name" TEXT,
    "nurse_first_name" TEXT NOT NULL,
    "nurse_last_name" TEXT NOT NULL,
    "secondary_nurse_first_name" TEXT,
    "secondary_nurse_last_name" TEXT,
    "surgeon_employee_id" INT NOT NULL,
    "secondary_surgeon_employee_id" INT NOT NULL,
    "nurse_employee_id" INT NOT NULL,
    "secondary_nurse_employee_id" INT NOT NULL,
    "supplies_requisition_full_name" TEXT,
    "secondary_supplies_requisition_full_name" TEXT,
    "supplies_requisition_common_name" TEXT,
    "secondary_supplies_requisition_common_name" TEXT,
    "Department" TEXT,
    PRIMARY KEY("patient_first_name", "patient_last_name", "surgeon_employee_id"),
    FOREIGN KEY "patient_unique_id" REFERENCES "patients"("unique_patient_id"),
    FOREIGN KEY "surgeon_unique_id" REFERENCES "current_employees"("unique_employee_id"),
    FOREIGN KEY "secondary_surgeon_unique_id" REFERENCES "current_employees"("unique_employee_id"),
    FOREIGN KEY "nurse_employee_id" REFERENCES "current_employees"("unique_employee_id"),
    FOREIGN KEY "secodary_nurse_unique_id" REFERENCES "current_employees"("unique_employee_id")
);

--Creates table for patients to recieve diagnostic testing and keeps track of the requesting physician and technician information
CREATE TABLE "diagnostic_test"(
    "unique_test_id" INT,
    "unique_patient_id" INT,
    "patient_first_name" TEXT,
    "patient_last_name" TEXT,
    "technician_employee_id" INT,
    "technician_first_name" TEXT,
    "technician_last_name" TEXT,
    "date" DATETIME,
    "type" TEXT,
    "requesting_physician_id" INT,
    "recommended_surgery" TEXT,
    "secondary_recommended_surgery" TEXT,
    PRIMARY KEY("unique_test_id"),
    FOREIGN KEY "unique_patient_id" REFERENCES "patients"("unique_patient_id"),
    FOREIGN KEY "technician_employee_id" REFERENCES "current_employees"("unique_employee_id"),
    FOREIGN KEY "requesting_physician_id" REFERENCES "current_employees"("unique_employee_id"),
    FOREIGN KEY "recommeneded_surgery" REFERENCES "surgery"("name"),
    FOREIGN KEY "secondary_recommeneded_surgery" REFERENCES "surgery"("name")
);

--Creates the appointment tables for when patients require non-emergent care
CREATE TABLE "appointments" (
    "appointment_id" INT,
    "patient_first_name" TEXT,
    "patient_last_name" TEXT,
    "unique_patient_id" INT,
    "physician_first_name" TEXT NOT NULL,
    "physician_last_name" TEXT NOT NULL,
    "physician_employee_id" INT NOT NULL,
    "nurse_first_name" TEXT NOT NULL,
    "nurse_last_name" TEXT NOT NULL,
    "nurse_employee_id" INT NOT NULL
    "date" DATETIME,
    "notes" TEXT,
    "insurance" TEXT,
    "recommended_test" TEXT,
    "recommended_test_id" INT,
    "secondary_recommended_test" TEXT,
    "secondary_recommended_test_id" INT,
    PRIMARY KEY("appointment_id"),
    FOREIGN KEY "unique_patient_id" REFERENCES "patients"("unique_patient_id"),
    FOREIGN KEY "physician_employee_id" REFERENCES "current_employees"("unique_employee_id"),
    FOREIGN KEY "nurse_employee_id" REFERENCES "current_employees"("unique_employee_id"),
    FOREIGN KEY "recommended_test_id" REFERENCES "diagnostic_test"("unique_test_id"),
    FOREIGN KEY "recommended_test" REFERENCES "diagnostic_test"("type"),
    FOREIGN KEY "secondary_recommended_test_id" REFERENCES "diagnostic_test"("unique_test_id"),
    FOREIGN KEY "secondary_recommended_test" REFERENCES "diagnostic_test"("type")
);

--A log of supplies/medications the hospital has
CREATE TABLE "supplies" (
    "unique_product_id" INT,
    "full_name" TEXT,
    "common_name" TEXT,
    PRIMARY KEY("unique_product_id")
);

--A log to help the hospital keep track of the supplies
CREATE TABLE "supplies_log"(
    "log_id" INT,
    "unique_product_id" INT,
    "full_name" TEXT,
    "common_name" TEXT,
    "second_full_name" TEXT,
    "second_common_name" TEXT,
    "intended_purpose" TEXT,
    PRIMARY KEY("log_id"),
    FOREIGN KEY "unique_product_id" REFERENCES "supplies"("unique_product_id")
);

--Makes sure surgeries and their supplies requisitions are noted when a surgery is scheduled.
CREATE TRIGGER "new_surgery"
AFTER INSERT ON "surgeries"
FOR EACH ROW
BEGIN
    INSERT INTO "supplies_log" ("full_name", "common_name", "second_full_name", "second_common_name", "requesting_physician_employee_id", "intended_purpose")
    VALUES ("surgeries"."supplies_requisition_full_name", "surgeries"."supplies_requisition_common_name", "surgeries"."secondary_supplies_requisition_full_name", "secondary_supplies_requisition_common_name", "surgeries"."surgeon_employee_id", "surgeries"."surgery"."name");
    UPDATE "supplies_log" SET "unique_product_id" = "supplies"."unique_product_id" WHERE "supplies_log"."full_name" = "supplies"."full_name";
END;

--Index to help with retreival of patient, physician, surgeon and technician information
CREATE INDEX "patient_index" ON "patients" ("first_name", "last_name");
CREATE INDEX "employee_index" ON "current_employees" ("first_name", "last_name");
CREATE INDEX "appointment_index" ON "appointments" ("patient_first_name", "patient_last_name", "physician_first_name", "physician_last_name");
CREATE INDEX "surgery_index" ON "surgeries" ("patient_first_name", "patient_last_name", "surgeon_first_name", "surgeon_last_name");
CREATE INDEX "test_index" ON "diagnostic_test" ("patient_first_name", "patient_last_name", "technician_first_name", "technician_last_name");
