# Customer-Complaint-Analytics-
# SQL Project 




# 📣 Customer Complaint Analytics  
**SQL Analytics Project | SLA Monitoring • Risk Detection • Regulatory Insight**

---

## 📌 Project Overview
This project analyzes a large-scale **customer complaint dataset (CFPB-style)** to uncover:
- Operational bottlenecks  
- Regulatory risk signals  
- Product-level failure patterns  

It answers the kind of questions a **Head of Compliance or Customer Operations** would ask:
- Where are we breaching SLAs?  
- What issues are trending upward?  
- Where should we focus remediation efforts?  

All analysis was performed using **SQL Server** on a high-volume dataset (~800k+ records).

---

## 🎯 Objective
Transform raw complaint data into **actionable insights** that improve:
- Customer experience  
- SLA compliance  
- Regulatory readiness  

---

## 🚀 Key Business Goals
- ⏱️ Measure SLA performance across channels, states, and products  
- 📈 Detect emerging complaint trends before regulatory escalation  
- 🧩 Evaluate resolution effectiveness (real fix vs. superficial closure)  
- 🌍 Identify geographic and product-level risk hotspots  
- 💡 Translate findings into **clear operational and compliance actions**  

---

## 🧠 Skills Demonstrated

| Category | Skills |
|----------|--------|
| **SQL Server** | CTEs, Window Functions (`LAG`, `SUM() OVER`), `PERCENTILE_CONT`, Date Functions |
| **Analytics** | YoY Growth Analysis, SLA Monitoring, Outlier Detection, Trend Normalization |
| **Business Thinking** | Regulatory Risk Analysis, Root Cause Detection, Ops Optimization |
| **Data Quality** | NULL Handling, Noise Filtering (`HAVING`), Low-Sample Bias Control |
| **Communication** | Insight storytelling, executive-ready recommendations |

---

## 🗂️ Data Overview

### 📊 `customer_complaints` (Fact Table)
- **Grain:** One row per complaint  
- **Volume:** ~800k+ records  

| Column | Description |
|--------|------------|
| `complaint_id` | Unique identifier |
| `submitted_via` | Channel (Web, Phone, Email, etc.) |
| `date_submitted`, `date_received` | SLA tracking timestamps |
| `response_time` | Days to company response |
| `state` | Geographic location |
| `product`, `sub_product` | Product classification |
| `issue`, `sub_issue` | Complaint category |
| `company_response_to_consumer` | Resolution type |
| `company_public_response` | Public statement flag |
| `timely_response` | SLA compliance flag |

---

## ⚙️ Data Transformation Highlights
- 📆 **Time Bucketing:** Monthly/Quarterly trends via `DATEFROMPARTS`  
- 🔁 **YoY Comparison:** `LAG(12)` for seasonally adjusted growth  
- 🚨 **Spike Detection:** Rolling 3-month baseline (noise-resistant)  
- 📊 **SLA Metrics:** Conditional aggregation for compliance rates  
- 🧹 **Noise Filtering:** `HAVING COUNT(*) >= 20`  
- 🌍 **Normalization:** Complaints per million using population data  

---

## 🏗️ Analytical Approach
All queries follow a clean, modular structure:




- **Staging:** Data cleaning, filtering, feature engineering  
- **Metrics:** Aggregations + window functions  
- **Insights:** Ranking, comparisons, anomaly detection  

---

## 📊 Business Questions Answered

| # | Business Question | Method |
|---|------------------|--------|
| 1 | Which channel responds fastest? | `AVG(response_time)` + SLA % by state/channel |
| 2 | What issues are growing fastest? | YoY growth using `LAG(12)` |
| 3 | Do responses actually resolve complaints? | Distribution of resolution types |
| 4 | Which sub-issues dominate? | % share using `SUM() OVER` |
| 5 | Where are SLA breaches happening? | Monthly breach rate by product |
| 6 | Do public responses improve speed? | Compare response times |
| 7 | Which states are over-indexed? | Complaints per million population |
| 8 | Which issues take longest? | `AVG` + `P90` response time trends |
| 9 | Are repeat complaints occurring? | High-frequency detection in 90-day window |

📁 All SQL queries available in `/sql/` with business context.

---

## 💡 Key Insights & Recommendations

### ⏱️ SLA Performance
- Email channel (TX) → **71% SLA vs Phone 94%**
- 📈 *Action:* Re-route high-risk complaints or increase staffing

### 🚨 Emerging Risk
- Debt collection issue **+158% YoY**
- 📈 *Action:* Audit vendors before regulatory escalation

### ⚖️ Resolution Quality Gap
- Mortgage complaints → 92% “closed with explanation”, 0% relief
- 📈 *Action:* Review fairness of resolution policies

### 🤖 Automation Opportunity
- 70% of credit complaints = “incorrect information”
- 📈 *Action:* Build self-serve dispute system

### 📅 Seasonal SLA Breach
- January spike → **22% SLA breach (checking accounts)**
- 📈 *Action:* Pre-staff or automate responses in Q4

### 🌍 Geographic Risk
- Delaware → **2,100 complaints per million vs CA 180**
- 📈 *Action:* Assign regional compliance oversight

### ⚡ Process Improvement Win
- Loan servicing P90 improved **28 → 14 days**
- 📈 *Action:* Scale this workflow across products

### 🔁 Repeat Complaint Risk
- NY debt collection issue appeared **47 times in 90 days**
- 📈 *Action:* Investigate vendor misconduct immediately

---

## 🧾 Conclusion
Complaint data is a powerful **early warning system** for:
- Regulatory exposure  
- Operational inefficiencies  
- Customer experience breakdowns  

This project demonstrates how SQL can:
- Detect trends early  
- Quantify risk  
- Drive actionable decisions  

It bridges the gap between **data analysis and real business impact**.

---

## 👤 Author
**Yakubu Hamza Ugbedeojo**  
📧 mailx0hamza@gmail.com  

---

