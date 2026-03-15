CREATE DATABASE quecourt_db;
USE quecourt_db;
CREATE TABLE Court_Building (
    building_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    capacity INT CHECK (capacity > 0)
);

CREATE TABLE Courtroom (
    courtroom_id INT PRIMARY KEY,
    courtroom_type ENUM('criminal', 'family', 'small_claims', 'civil') NOT NULL,
    floor INT NOT NULL,
    building_id INT,
    FOREIGN KEY (building_id) REFERENCES Court_Building(building_id)
);

CREATE TABLE Room (
    room_id INT PRIMARY KEY,
    room_type ENUM('library', 'detention', 'meeting', 'office') NOT NULL,
    floor INT NOT NULL,
    building_id INT,
    FOREIGN KEY (building_id) REFERENCES Court_Building(building_id)
);

CREATE TABLE Judge (
    judge_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    appointment_date DATE NOT NULL,
    specialization VARCHAR(100) NOT NULL
);

CREATE TABLE Case_File (
    case_id INT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    case_type ENUM('civil', 'criminal', 'family', 'small_claims') NOT NULL,
    status ENUM('open', 'closed', 'appealed') NOT NULL,
    file_date DATE NOT NULL,
    case_ruling TEXT,
    case_finding TEXT,
    case_order TEXT,
    building_id INT,
    FOREIGN KEY (building_id) REFERENCES Court_Building(building_id)
);

CREATE TABLE Person (
    person_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role ENUM('plaintiff', 'defendant', 'lawyer') NOT NULL,
    contact_info VARCHAR(255),
    case_id INT,
    FOREIGN KEY (case_id) REFERENCES Case_File(case_id)
);

CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    position VARCHAR(100) NOT NULL,
    certifications TEXT,
    education TEXT,
    supervisor_id INT,
    FOREIGN KEY (supervisor_id) REFERENCES Employee(employee_id)
);

CREATE TABLE Incident_Report (
    report_id INT PRIMARY KEY,
    incident_type ENUM('threat', 'hazard', 'theft', 'technical') NOT NULL,
    description TEXT NOT NULL,
    report_date DATE NOT NULL
);

CREATE TABLE Presides_Over (
    judge_id INT,
    case_id INT,
    PRIMARY KEY (judge_id, case_id),
    FOREIGN KEY (judge_id) REFERENCES Judge(judge_id),
    FOREIGN KEY (case_id) REFERENCES Case_File(case_id)
);

CREATE TABLE Reports (
    employee_id INT,
    report_id INT,
    PRIMARY KEY (employee_id, report_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (report_id) REFERENCES Incident_Report(report_id)
);
