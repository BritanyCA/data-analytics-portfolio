
# 📊 Customer Churn Analysis & Retention Strategy  
### Power BI Dashboard | Portfolio Project  
**Author:** Britany Campos **Tools:** Power BI, DAX, Excel. 

---

## 📌 Project Overview  
This project analyzes customer churn behavior for a telecommunications company and develops a complete data‑driven retention strategy.  
The dashboard highlights behavioral patterns, churn drivers, high‑risk segments, and actionable retention opportunities.

---

## 🎯 Objectives  
- Identify key churn drivers  
- Analyze customer behavior and segmentation  
- Build risk‑based customer groups  
- Simulate retention scenarios using a What‑If parameter  
- Design a professional multi‑page Power BI dashboard  

---

## 🗂 Dashboard Structure  

### **Page 1 — Overview & KPIs**  
- Total customers  
- Churn rate  
- Revenue impact  
- High‑level segmentation  

### **Page 2 — Customer Profile**  
- Tenure distribution  
- Contract types  
- Internet service breakdown  
- Payment methods  

### **Page 3 — Churn Drivers**  
- Monthly Charges (Churned vs Retained)  
- Average Tenure  
- Churn by TechSupport  
- Churn by OnlineSecurity  
- Churn by InternetService  
- Decomposition Tree  

### **Page 4 — Retention Opportunities**  
- High‑risk customer segments  
- Opportunity Matrix  
- Discount Simulation (What‑If)  
- Recommended Retention Actions  
- Retention Funnel  

---

## 🧠 Key Insights  
- Customers with **higher monthly charges** churn more frequently.  
- **Low‑tenure customers** are the most likely to churn.  
- Lack of **TechSupport** and **OnlineSecurity** significantly increases churn risk.  
- **Month‑to‑month contracts** are the strongest churn driver.  
- Fiber optic customers show the **highest churn rate**.  
- Retention strategies can reduce churn by **10–20%**.

---

# 📐 Key DAX Measures (with detailed explanations)

---

## **1. Churn Rate**  
Calculates the percentage of customers who churned.

```DAX
Churn Rate =
DIVIDE(
    CALCULATE(COUNTROWS(Customers), Customers[Churn] = "Yes"),
    COUNTROWS(Customers)
)
```
## **2. Tenure Group**
Creates categorical tenure buckets to simplify analysis.
```DAX
Tenure Group =
SWITCH(
    TRUE(),
    Customers[tenure] <= 6, "0–6",
    Customers[tenure] <= 12, "7–12",
    Customers[tenure] <= 24, "13–24",
    Customers[tenure] <= 48, "25–48",
    "48+"
)
```
## **3. Adjusted Churn Rate (What if Simulation)**
Simulates how churn would change if a discount is applied.
```DAX
Adjusted Churn Rate =
[Churn Rate] *
(1 - 'Discount Parameter'[Discount Parameter Value Selected] / 100)
```
## **4. Funnel Metrics**
- Contacted Rate: % of high‑risk customers contacted.
- Engagement Rate: % of contacted customers who engaged.
- Offer Acceptance Rate: % of engaged customers who accepted an offer.
- Retention Rate: % of customers ultimately retained.
```DAX
Contacted Rate = DIVIDE([Contacted], [High-Risk Customers])
Engagement Rate = DIVIDE([Engaged], [Contacted])
Offer Acceptance Rate = DIVIDE([Offered Retention Plan], [Engaged])
Retention Rate = DIVIDE([Retained], [Offered Retention Plan])
```
