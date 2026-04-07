# Fraud Detection Analysis — Full SQL Project 

## 1. What patterns and behaviors characterize normal vs fraudulent transactions?

### 1.1 Objective
Identify behavioral differences between legitimate and fraudulent transactions using SQL-based exploratory analysis.

### 1.2 Methodology
- Compare transaction amounts  
- Analyze hourly patterns  
- Evaluate merchant categories and countries  
- Use window functions and group-based aggregation  

---

## 1.3 SQL Analysis

#### Amount Distribution (Count, Average, Median)

```sql
SELECT DISTINCT
    Fraud,
    COUNT(*) OVER (PARTITION BY Fraud) AS n_tx,
    AVG(Amount) OVER (PARTITION BY Fraud) AS avg_amount,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Amount)
        OVER (PARTITION BY Fraud) AS median_amount
FROM dbo.transactions;
```
#### Fraud by Hour of Day
```sql
SELECT DATEPART(HOUR, Hour) AS hour_24,
       Fraud,
       COUNT(*) AS n_tx
FROM dbo.transactions
GROUP BY DATEPART(HOUR, Hour), Fraud
ORDER BY hour_24, Fraud;
```
#### Fraud Rate by Merchant Category & Country
```sql
SELECT Merchant_Category,
       Country,
       SUM(CASE WHEN Fraud = 1 THEN 1 ELSE 0 END) AS Fraud_tx,
       COUNT(*) AS total_tx,
       1.0 * SUM(CASE WHEN Fraud = 1 THEN 1 ELSE 0 END) / COUNT(*) AS Fraud_rate
FROM dbo.transactions
GROUP BY Merchant_Category, Country
ORDER BY Fraud_rate DESC;
```
## 2. What anomalies or unusual patterns can be detected in the transaction data?

### Objective
Identify outliners extreme risk scores, and suspicious user behaviors.

### 2.2 Methodology
- Statistical outliner detection
- Risk score thresholds
- Group-level fraud rate analysis
- HAVING clause for filtering groups

### 2.3 SQL Analysis
#### Outliners in Amount
```Sql
SELECT *
FROM dbo.transactions
WHERE Amount > (
    SELECT AVG(Amount) + 3 * STDEV(Amount)
    FROM dbo.transactions
);
```

#### Extreme Risk Scores
```sql
SELECT *
FROM dbo.transactions
WHERE Device_Risk_Score > 0.9
   OR IP_Risk_Score > 0.9;
```
#### Suspicious Users
```sql
SELECT User_ID,
       COUNT(*) AS total_tx,
       SUM(CASE WHEN Fraud = 1 THEN 1 ELSE 0 END) AS fraud_tx,
       1.0 * SUM(CASE WHEN Fraud = 1 THEN 1 ELSE 0 END) / COUNT(*) AS fraud_rate
FROM dbo.transactions
GROUP BY User_ID
HAVING COUNT(*) >= 10
ORDER BY fraud_rate DESC;
```
## What recommendations can be made to reduce fraud risk?

### 3.1 Recommendations

#### 1. Strengthen monitoring during high-risk hours

- Real-time alerts.
- Additional authentication.
- Temporary transactions limits

#### 2. Apply stricter controls to high riks merchant categories and countries.

- Additional verification
- Lower transaction thresholds
- Flag unusual cross-border activity

### 3. Use risk scores to trigger manual review 
Flag transactions with:
- Device_Risk_Score >0.9
- IP_Risk_Score >0.9

### 4. Monitor users with suspicious behavior
Users with:
- High fraud rate
- High transaction volume
- Repeated anomalies 
Should be placed under enhanced monitoring.

## 3.3 Conclusion
The analysis provides clear behavioral differences between fraudulent and legitimate transactions and supports targeted fraud‑prevention strategies.