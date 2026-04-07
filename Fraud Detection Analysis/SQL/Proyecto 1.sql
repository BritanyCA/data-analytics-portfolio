/*Preparation for the DB*/

CREATE DATABASE Project_1;
USE Project_1;

/*Tables*/
CREATE TABLE transactions(
Transaction_ID INTEGER PRIMARY KEY,
User_ID INTEGER,
Amount INTEGER,
Transaction_Type VARCHAR(50),
Merchant_Category VARCHAR(100),
Country VARCHAR(4),
Hour TIME,
Device_Risk_Score DECIMAL(22,21),
IP_risk_Score DECIMAL (22,21),
Fraud INTEGER);
--Drop table
DROP TABLE IF EXISTS dbo.transactions;

--NEW TABLE
CREATE TABLE transactions(
    Transaction_ID INT PRIMARY KEY,
    User_ID INT NOT NULL,
    Amount DECIMAL(10,2),
    Transaction_Type VARCHAR(50),
    Merchant_Category VARCHAR(100),
    Country VARCHAR(50),
    Hour TIME,
    Device_Risk_Score DECIMAL(22,21),
    IP_Risk_Score DECIMAL(22,21),
    Fraud INT
);

--ADD INFORMATION
INSERT INTO dbo.transactions
SELECT
    TRY_CAST(transaction_id AS INT),
    TRY_CAST(user_id AS INT),
    TRY_CAST(amount AS DECIMAL(10,2)),
    transaction_type,
    merchant_category,
    country,
    TRY_CAST(CONCAT(hour, ':00') AS TIME),
    TRY_CAST(device_risk_score AS DECIMAL(22,21)),
    TRY_CAST(ip_risk_score AS DECIMAL(22,21)),
    TRY_CAST(is_fraud AS INT)
FROM dbo.synthetic_fraud_dataset;

--VIEW THE FIRST 20
SELECT TOP 20 * FROM dbo.transactions;

--HOW MANY ROWS WE HAVE
SELECT COUNT(*)
FROM dbo.transactions;

--VERIFY NULL INFORMATION
SELECT 
    SUM(CASE WHEN Amount IS NULL THEN 1 ELSE 0 END) AS Null_Amount,
    SUM(CASE WHEN Hour IS NULL THEN 1 ELSE 0 END) AS Null_Hour,
    SUM(CASE WHEN Device_Risk_Score IS NULL THEN 1 ELSE 0 END) AS Null_DeviceRisk,
    SUM(CASE WHEN IP_Risk_Score IS NULL THEN 1 ELSE 0 END) AS Null_IPRisk
FROM dbo.transactions;

--Compare fraudulent vs non-fraudulent transactions
--Using window functions to calculate metrics per group (Fraud=  or 1)
--Amount distribution 
SELECT DISTINCT
    Fraud, --Group identifier
    COUNT(*) OVER (PARTITION BY Fraud) AS n_tx,--# of ttal trx per group
    AVG(Amount) OVER (PARTITION BY Fraud) AS avg_amount, --average  amount of fraud per group
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Amount) --median amount per group
        OVER (PARTITION BY Fraud) AS median_amount --Partition by divide the data in the group
FROM dbo.transactions;

--Time of fraud during the day
--Count transactions per hour, separated by fraud status
SELECT DATEPART(HOUR,Hour) AS hour_24, --Extract hour from TIME
       Fraud,-- Fraud group
       COUNT(*) AS n_tx --# of trx in that hour and fraud group.
FROM dbo.transactions
GROUP BY DATEPART(HOUR,Hour), Fraud
ORDER BY hour_24, Fraud;


--Risk Country category
--Fraud rate by merchant category and country
SELECT Merchant_Category, -- Type of commerce
       Country, -- Country where fraud committed.
       SUM(CASE WHEN Fraud =1 THEN 1 ELSE 0 END) AS Fraud_tx, --If fraud is 1 summarise.
       COUNT(*) AS total_tx, --- Summarise overall
       1.0 * SUM(CASE WHEN Fraud =1 THEN 1 ELSE 0 END) / COUNT(*) AS Fraud_rate --When Fraud is 1 summarise,
       --then divide of total and give a rate
FROM dbo.transactions
GROUP BY Merchant_Category,Country --Grouping
ORDER BY Fraud_rate DESC;

--Anomalies patterns (Find weird things)
--Detect unusually high amounts (outliners)
SELECT *
FROM dbo.transactions
WHERE Amount >(
     SELECT AVG(Amount) + 3 * STDEV(Amount) FROM dbo.transactions --Standard deviation from amount
     );

--Extreme risk scores
--Detect trx with very high risk scores
SELECT *
FROM dbo.transactions
WHERE Device_Risk_Score > 0.9
    OR IP_Risk_Score >0.9;

--Customers with suspicious behavior
--Detect users with unusually high fraud rates
SELECT User_ID,
    COUNT (*) AS total_tx, --Ttal trx by user
    SUM (CASE WHEN Fraud= 1 THEN 1 ELSE 0 END) AS fraud_tx, --Fraud count
    1.0 *SUM(CASE WHEN Fraud=1 THEN 1 ELSE 0 END)/ COUNT(*) AS fraud_rate --Fraud rate
FROM dbo.transactions
GROUP BY User_ID
HAVING COUNT (*) >=10 --Filters groups with at least 10 trx.
ORDER BY fraud_rate DESC;
