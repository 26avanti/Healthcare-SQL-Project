-- ==============================
-- 🏥 HealthcareDB_v2 (MySQL 8+)
-- Realistic mini EHR + billing dataset for SQL practice
-- NOTE: Running this script will DROP and recreate the database.
-- ==============================

SET FOREIGN_KEY_CHECKS = 0;
DROP DATABASE IF EXISTS HealthcareDB_v2;
SET FOREIGN_KEY_CHECKS = 1;
CREATE DATABASE HealthcareDB_v2;
USE HealthcareDB_v2;

-- ---------- SCHEMA ----------

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DeptName VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName  VARCHAR(50) NOT NULL,
    Gender ENUM('Male','Female','Other') NOT NULL,
    DateOfBirth DATE NOT NULL,
    City VARCHAR(100),
    State VARCHAR(100),
    INDEX idx_patients_city (City),
    INDEX idx_patients_state (State)
) ENGINE=InnoDB;

CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName  VARCHAR(50) NOT NULL,
    DepartmentID INT NOT NULL,
    YearsExperience INT CHECK (YearsExperience >= 0),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    INDEX idx_doctors_dept (DepartmentID)
) ENGINE=InnoDB;

CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATETIME NOT NULL,
    VisitType ENUM('New','Follow-up') NOT NULL,
    Notes VARCHAR(255),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
    INDEX idx_appt_date (AppointmentDate),
    INDEX idx_appt_patient (PatientID),
    INDEX idx_appt_doctor (DoctorID)
) ENGINE=InnoDB;

CREATE TABLE Diagnoses (
    DxCode VARCHAR(10) PRIMARY KEY,
    DxDescription VARCHAR(200) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE AppointmentDiagnoses (
    AppointmentID INT NOT NULL,
    DxCode VARCHAR(10) NOT NULL,
    PRIMARY KEY (AppointmentID, DxCode),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID),
    FOREIGN KEY (DxCode) REFERENCES Diagnoses(DxCode)
) ENGINE=InnoDB;

CREATE TABLE Billing (
    BillID INT PRIMARY KEY,
    AppointmentID INT NOT NULL UNIQUE,
    TotalAmount DECIMAL(10,2) NOT NULL CHECK (TotalAmount >= 0),
    InsuranceCovered DECIMAL(10,2) NOT NULL CHECK (InsuranceCovered >= 0),
    PatientPayable DECIMAL(10,2) AS (ROUND(GREATEST(TotalAmount - InsuranceCovered, 0), 2)) STORED,
    BillDate DATE NOT NULL,
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID),
    INDEX idx_billing_date (BillDate)
) ENGINE=InnoDB;

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    BillID INT NOT NULL,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount >= 0),
    Method ENUM('Cash','Card','UPI','Insurance') NOT NULL,
    FOREIGN KEY (BillID) REFERENCES Billing(BillID),
    INDEX idx_payments_bill (BillID),
    INDEX idx_payments_date (PaymentDate)
) ENGINE=InnoDB;

-- ---------- DATA ----------

INSERT INTO Departments (DepartmentID, DeptName) VALUES
(1, 'Cardiology'),
(2, 'Dermatology'),
(3, 'Orthopedics'),
(4, 'General Medicine');

INSERT INTO Patients (PatientID, FirstName, LastName, Gender, DateOfBirth, City, State) VALUES
(1, 'Rohan', 'Mehta', 'Male',   '1993-04-10', 'Pune',      'Maharashtra'),
(2, 'Sneha', 'Kulkarni', 'Female','1980-09-05', 'Mumbai',    'Maharashtra'),
(3, 'Arjun', 'Patil',   'Male',   '1996-02-22', 'Nagpur',    'Maharashtra'),
(4, 'Priya', 'Sharma',  'Female', '1975-06-13', 'Delhi',     'Delhi'),
(5, 'Vikram','Singh',   'Male',   '1988-01-08', 'Jaipur',    'Rajasthan'),
(6, 'Ananya','Rao',     'Female', '1992-12-15', 'Bengaluru', 'Karnataka'),
(7, 'Kunal', 'Shah',    'Male',   '1985-07-20', 'Ahmedabad', 'Gujarat'),
(8, 'Meera', 'Iyer',    'Female', '1999-03-30', 'Chennai',   'Tamil Nadu'),
(9, 'Saurabh','Jain',   'Male',   '1990-11-11', 'Indore',    'Madhya Pradesh'),
(10,'Kavita','Das',     'Female', '1983-05-18', 'Kolkata',   'West Bengal');

INSERT INTO Doctors (DoctorID, FirstName, LastName, DepartmentID, YearsExperience) VALUES
(101, 'Amit',  'Deshmukh', 1, 12),
(102, 'Neha',  'Joshi',    2,  8),
(103, 'Karan', 'Gupta',    3, 10),
(104, 'Priya', 'Nair',     4,  6),
(105, 'Rahul', 'Verma',    4,  9),
(106, 'Sneha', 'Patil',    1,  7);

INSERT INTO Appointments (AppointmentID, PatientID, DoctorID, AppointmentDate, VisitType, Notes) VALUES
(1001, 1, 101, '2025-07-01 10:00:00', 'New',       'Elevated BP'),
(1002, 2, 102, '2025-07-02 11:00:00', 'New',       'Rash on arms'),
(1003, 3, 103, '2025-07-05 15:00:00', 'New',       'Knee pain after running'),
(1004, 4, 101, '2025-07-07 09:30:00', 'Follow-up', 'BP follow-up'),
(1005, 5, 104, '2025-07-08 12:00:00', 'New',       'Fever and cold'),
(1006, 6, 104, '2025-07-10 16:00:00', 'New',       'Acidity and reflux'),
(1007, 7, 106, '2025-07-12 10:30:00', 'New',       'High BP'),
(1008, 8, 102, '2025-07-14 14:00:00', 'Follow-up', 'Dermatitis check'),
(1009, 9, 103, '2025-07-18 13:15:00', 'New',       'Knee pain'),
(1010, 10,104, '2025-07-20 10:45:00', 'New',       'Cold and cough'),
(1011, 1, 101, '2025-08-01 10:15:00', 'Follow-up', 'BP check'),
(1012, 2, 102, '2025-08-03 11:20:00', 'Follow-up', 'Dermatitis improving'),
(1013, 3, 103, '2025-08-05 15:30:00', 'Follow-up', 'Knee physio'),
(1014, 4, 106, '2025-08-07 09:00:00', 'New',       'Palpitations'),
(1015, 5, 104, '2025-08-10 12:30:00', 'Follow-up', 'Fever resolved'),
(1016, 6, 105, '2025-08-12 16:20:00', 'New',       'General check-up'),
(1017, 7, 101, '2025-08-15 10:10:00', 'Follow-up', 'BP management'),
(1018, 8, 102, '2025-08-18 14:05:00', 'New',       'Skin allergy flare');

INSERT INTO Diagnoses (DxCode, DxDescription) VALUES
('I10', 'Primary hypertension'),
('E11', 'Type 2 diabetes mellitus'),
('J06', 'Acute upper respiratory infection'),
('M25', 'Pain in joint (knee)'),
('L20', 'Atopic dermatitis'),
('K21', 'Gastro-esophageal reflux disease'),
('E78', 'Disorders of lipoprotein metabolism (hyperlipidemia)');

INSERT INTO AppointmentDiagnoses (AppointmentID, DxCode) VALUES
(1001, 'I10'),
(1002, 'L20'),
(1003, 'M25'),
(1004, 'I10'), (1004, 'E78'),
(1005, 'J06'),
(1006, 'K21'),
(1007, 'I10'),
(1008, 'L20'),
(1009, 'M25'),
(1010, 'J06'),
(1011, 'I10'), (1011, 'E78'),
(1012, 'L20'),
(1013, 'M25'),
(1014, 'I10'),
(1015, 'J06'),
(1016, 'K21'),
(1017, 'I10'),
(1018, 'L20');

INSERT INTO Billing (BillID, AppointmentID, TotalAmount, InsuranceCovered, BillDate) VALUES
(2001, 1001, 5000.00, 3000.00, '2025-07-01'),
(2002, 1002, 1500.00,    0.00, '2025-07-02'),
(2003, 1003, 4000.00, 2000.00, '2025-07-05'),
(2004, 1004, 5500.00, 3500.00, '2025-07-07'),
(2005, 1005, 1200.00,    0.00, '2025-07-08'),
(2006, 1006, 2200.00,    0.00, '2025-07-10'),
(2007, 1007, 4800.00, 2500.00, '2025-07-12'),
(2008, 1008, 1600.00,    0.00, '2025-07-14'),
(2009, 1009, 4200.00, 2000.00, '2025-07-18'),
(2010, 1010, 1300.00,    0.00, '2025-07-20'),
(2011, 1011, 5000.00, 3000.00, '2025-08-01'),
(2012, 1012, 1500.00,    0.00, '2025-08-03'),
(2013, 1013, 4000.00, 2000.00, '2025-08-05'),
(2014, 1014, 5200.00, 3200.00, '2025-08-07'),
(2015, 1015, 1400.00,    0.00, '2025-08-10'),
(2016, 1016, 2300.00,    0.00, '2025-08-12'),
(2017, 1017, 4900.00, 2900.00, '2025-08-15'),
(2018, 1018, 1550.00,    0.00, '2025-08-18');

INSERT INTO Payments (PaymentID, BillID, PaymentDate, Amount, Method) VALUES
(3001, 2001, '2025-07-02', 2000.00, 'Card'),
(3002, 2002, '2025-07-03', 1000.00, 'UPI'),
(3003, 2003, '2025-07-06', 2000.00, 'Cash'),
(3004, 2004, '2025-07-08', 2000.00, 'Insurance'),
-- 2005 unpaid
(3005, 2006, '2025-07-11', 1000.00, 'UPI'),
(3006, 2007, '2025-07-13', 2300.00, 'Card'),
(3007, 2008, '2025-07-15', 1600.00, 'Cash'),
(3008, 2009, '2025-07-19', 1000.00, 'UPI'),
(3009, 2010, '2025-07-21', 1300.00, 'UPI'),
(3010, 2011, '2025-08-02', 2000.00, 'Card'),
-- 2012 unpaid
(3011, 2013, '2025-08-06', 2000.00, 'UPI'),
(3012, 2014, '2025-08-08',  500.00, 'Cash'),
(3013, 2015, '2025-08-11', 1400.00, 'Cash'),
(3014, 2016, '2025-08-13', 1000.00, 'Card'),
(3015, 2017, '2025-08-16', 2000.00, 'Insurance');
-- 2018 unpaid

-- ---------- VIEWS (Convenience) ----------

CREATE OR REPLACE VIEW vw_appointments_detailed AS
SELECT
    a.AppointmentID,
    a.AppointmentDate,
    a.VisitType,
    CONCAT(p.FirstName, ' ', p.LastName) AS Patient,
    CONCAT(d.FirstName, ' ', d.LastName) AS Doctor,
    dept.DeptName AS Department,
    GROUP_CONCAT(dx.DxDescription ORDER BY dx.DxCode SEPARATOR ', ') AS Diagnoses
FROM Appointments a
JOIN Patients p  ON p.PatientID = a.PatientID
JOIN Doctors d   ON d.DoctorID  = a.DoctorID
JOIN Departments dept ON dept.DepartmentID = d.DepartmentID
LEFT JOIN AppointmentDiagnoses ad ON ad.AppointmentID = a.AppointmentID
LEFT JOIN Diagnoses dx ON dx.DxCode = ad.DxCode
GROUP BY a.AppointmentID;

CREATE OR REPLACE VIEW vw_billing_status AS
SELECT
    b.BillID,
    b.AppointmentID,
    a.AppointmentDate,
    CONCAT(p.FirstName, ' ', p.LastName) AS Patient,
    CONCAT(doc.FirstName, ' ', doc.LastName) AS Doctor,
    dept.DeptName AS Department,
    b.TotalAmount,
    b.InsuranceCovered,
    b.PatientPayable,
    COALESCE(SUM(pay.Amount), 0) AS AmountPaid,
    ROUND(b.PatientPayable - COALESCE(SUM(pay.Amount), 0), 2) AS Outstanding,
    CASE
        WHEN COALESCE(SUM(pay.Amount), 0) = 0 THEN 'Unpaid'
        WHEN COALESCE(SUM(pay.Amount), 0) < b.PatientPayable THEN 'Partial'
        ELSE 'Paid'
    END AS PaymentStatus
FROM Billing b
JOIN Appointments a ON a.AppointmentID = b.AppointmentID
JOIN Patients p     ON p.PatientID = a.PatientID
JOIN Doctors doc    ON doc.DoctorID = a.DoctorID
JOIN Departments dept ON dept.DepartmentID = doc.DepartmentID
LEFT JOIN Payments pay ON pay.BillID = b.BillID
GROUP BY b.BillID;

-- ---------- PRACTICE QUERIES ----------

-- 1) All appointments with patient, doctor, department, diagnoses
SELECT * FROM vw_appointments_detailed ORDER BY AppointmentDate;

-- 2) Revenue snapshot
SELECT
    SUM(b.TotalAmount)          AS TotalBilled,
    SUM(b.InsuranceCovered)     AS InsuranceCovered,
    SUM(b.PatientPayable)       AS TotalPatientPayable,
    SUM(vbs.AmountPaid)         AS TotalCollected,
    SUM(vbs.Outstanding)        AS TotalOutstanding
FROM Billing b
JOIN vw_billing_status vbs ON vbs.BillID = b.BillID;

-- 3) Outstanding bills (who owes money?)
SELECT BillID, Patient, Department, PatientPayable, AmountPaid, Outstanding, PaymentStatus
FROM vw_billing_status
WHERE PaymentStatus <> 'Paid'
ORDER BY Outstanding DESC;

-- 4) Top 3 diagnoses in last 45 days
SELECT dx.DxDescription, COUNT(*) AS Cases
FROM AppointmentDiagnoses ad
JOIN Diagnoses dx ON dx.DxCode = ad.DxCode
JOIN Appointments a ON a.AppointmentID = ad.AppointmentID
WHERE a.AppointmentDate >= DATE_SUB(CURDATE(), INTERVAL 45 DAY)
GROUP BY dx.DxDescription
ORDER BY Cases DESC
LIMIT 3;

-- 5) Appointments by department
SELECT dept.DeptName, COUNT(*) AS Visits
FROM Appointments a
JOIN Doctors d ON d.DoctorID = a.DoctorID
JOIN Departments dept ON dept.DepartmentID = d.DepartmentID
GROUP BY dept.DeptName
ORDER BY Visits DESC;

-- 6) Average bill and patient payable by department
SELECT dept.DeptName,
       ROUND(AVG(b.TotalAmount),2) AS AvgTotalBill,
       ROUND(AVG(b.PatientPayable),2) AS AvgPatientPayable
FROM Billing b
JOIN Appointments a ON a.AppointmentID = b.AppointmentID
JOIN Doctors d ON d.DoctorID = a.DoctorID
JOIN Departments dept ON dept.DepartmentID = d.DepartmentID
GROUP BY dept.DeptName
ORDER BY AvgTotalBill DESC;

-- 7) Doctors ranked by number of appointments (last 30 days)
SELECT
    CONCAT(d.FirstName, ' ', d.LastName) AS Doctor,
    dept.DeptName,
    COUNT(*) AS VisitCount,
    DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS RankByVisits
FROM Appointments a
JOIN Doctors d ON d.DoctorID = a.DoctorID
JOIN Departments dept ON dept.DepartmentID = d.DepartmentID
WHERE a.AppointmentDate >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY d.DoctorID
ORDER BY VisitCount DESC;

-- 8) Patient-level balance summary
SELECT Patient,
       SUM(PatientPayable) AS TotalPayable,
       SUM(AmountPaid)     AS TotalPaid,
       SUM(Outstanding)    AS BalanceOutstanding
FROM vw_billing_status
GROUP BY Patient
ORDER BY BalanceOutstanding DESC;

-- 9) Monthly revenue (billed vs collected) for 2025-07 to 2025-08
SELECT
    DATE_FORMAT(b.BillDate, '%Y-%m') AS YearMonth,
    ROUND(SUM(b.TotalAmount),2) AS Billed,
    ROUND(SUM(vbs.AmountPaid),2) AS Collected
FROM Billing b
JOIN vw_billing_status vbs ON vbs.BillID = b.BillID
WHERE b.BillDate BETWEEN '2025-07-01' AND '2025-08-31'
GROUP BY DATE_FORMAT(b.BillDate, '%Y-%m')
ORDER BY YearMonth;

-- 10) Patients with repeat visits (>=2) in last 60 days
SELECT
    CONCAT(p.FirstName, ' ', p.LastName) AS Patient,
    COUNT(*) AS VisitsLast60Days
FROM Appointments a
JOIN Patients p ON p.PatientID = a.PatientID
WHERE a.AppointmentDate >= DATE_SUB(CURDATE(), INTERVAL 60 DAY)
GROUP BY p.PatientID
HAVING COUNT(*) >= 2
ORDER BY VisitsLast60Days DESC;

-- End of script
