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

## 🏗️ ER Model (high level)
```
Departments 1───* Doctors 1───* Appointments *───* Diagnoses (via AppointmentDiagnoses)
            │
            └─────────────────────────────── Patients 1───* Appointments
Appointments 1───1 Billing 1───* Payments
```

---

## 🚀 How to Run (MySQL Workbench)
1. Open **MySQL Workbench** → connect to your local server.
2. Open a **New SQL Tab**.
3. Copy–paste the contents of `HealthcareDB_v2.sql`.
4. Press the **lightning bolt** to run (or `Ctrl+Shift+Enter` to run all).
5. On the **Schemas** panel, right‑click → **Refresh All** → expand `HealthcareDB_v2`.
6. Try: `SELECT * FROM vw_appointments_detailed;` and `SELECT * FROM vw_billing_status;`

---

## 🧪 Practice Queries Included
- Appointments with patient, doctor, department, and diagnoses (via `GROUP_CONCAT`).
- Revenue snapshot (billed vs collected vs outstanding).
- Outstanding bills & payment status (Paid / Partial / Unpaid).
- Top diagnoses (last N days).
- Appointments & average bills by department.
- Doctors ranked by recent visits (window functions).
- Patient-level balances & monthly revenue trends.

---

## 🧠 What You’ll Demonstrate
- Schema design for healthcare ops & billing
- Strong SQL (joins, aggregates, window functions, views)
- Real-world analysis questions
- Clean documentation

---

## 🧳 Portfolio Tips
- Keep this repo **public** and link it in your resume (Projects section).
- Add a short case study: What insights did you derive? (e.g., “Cardiology has the highest avg bill; dermatitis most frequent dx in Aug 2025.”)
- Extend the dataset (more patients/appointments), or add **Medications/Prescriptions/LabResults** tables.

---

## 📄 License
Feel free to fork and use for learning or interviews. Attribution appreciated.
