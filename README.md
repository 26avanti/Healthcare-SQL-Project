# 🏥 HealthcareDB_v2 — Realistic SQL Project (MySQL 8)

A small but realistic **healthcare (hospital) database** you can run locally to practice **SQL joins, aggregations, views, window functions, and reporting**. Built for interviews and portfolios.

> ⚠️ The SQL script drops and recreates the database named `HealthcareDB_v2`. Run on your own machine only.

---

## 📂 What’s Inside
- `HealthcareDB_v2.sql` — One-click setup: creates schema, inserts realistic data, builds helpful views, and includes practice queries.
- Tables (8 total):
  - **Departments** — Cardiology, Dermatology, Orthopedics, General Medicine
  - **Patients** — Demographics
  - **Doctors** — Providers linked to departments
  - **Appointments** — Visits with timestamps & notes
  - **Diagnoses** — ICD-like codes
  - **AppointmentDiagnoses** — Junction (many-to-many)
  - **Billing** — Charges per appointment (+ generated PatientPayable)
  - **Payments** — Payment events & methods

---

## 🚀 How to Run (MySQL Workbench)
1. Open **MySQL Workbench** → connect to your local server.
2. Open a **New SQL Tab**.
3. Copy–paste the contents of `HealthcareDB_v2.sql`.
4. Press the **lightning bolt** to run (or `Ctrl+Shift+Enter` to run all).
5. On the **Schemas** panel, right‑click → **Refresh All** → expand `HealthcareDB_v2`.
6. Try: `SELECT * FROM vw_appointments_detailed;` and `SELECT * FROM vw_billing_status;`

---
