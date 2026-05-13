
--Make work table
SELECT *
INTO dbo.Global_Supply_Chain_Risk_FE
FROM dbo.Global_Supply_Chain_Risk_2026;

--Risk per time delivery variation
-- 1. Create column
ALTER TABLE dbo.Global_Supply_Chain_Risk_FE
ADD Lead_Time_Category VARCHAR(20);
GO

-- 2. Actualizar Lead_Time_Category
UPDATE dbo.Global_Supply_Chain_Risk_FE
SET Lead_Time_Category =
    CASE
        WHEN Lead_Time_Days < 10 THEN 'Fast'
        WHEN Lead_Time_Days BETWEEN 10 AND 25 THEN 'Normal'
        ELSE 'Slow'
    END;
GO

--Clustering/ Distance Category
ALTER TABLE dbo.Global_Supply_Chain_Risk_FE
ADD Distance_Category VARCHAR(20);
GO

UPDATE dbo.Global_Supply_Chain_Risk_FE
SET Distance_Category =
    CASE
        WHEN Distance_km < 500 THEN 'Short'
        WHEN Distance_km BETWEEN 500 AND 3000 THEN 'Medium'
        ELSE 'Long'
    END;
    GO

--Composed Risk Score
ALTER TABLE dbo.Global_Supply_Chain_Risk_FE
ADD Composite_Risk_Score FLOAT;
Go

UPDATE dbo.Global_Supply_Chain_Risk_FE
SET Composite_Risk_Score =
    (Geopolitical_Risk_Score * 0.35) +
    ((100 - Carrier_Reliability_Score) * 0.25) +
    (Fuel_Price_Index * 0.20) +
    (Lead_Time_Days * 0.20);
GO

--Seasonality
ALTER TABLE dbo.Global_Supply_Chain_Risk_FE
ADD Month INT,
    Quarter INT;
GO

UPDATE dbo.Global_Supply_Chain_Risk_FE
SET Month = MONTH(Date),
    Quarter = DATEPART(QUARTER, Date);
GO

--High Risk Route
ALTER TABLE dbo.Global_Supply_Chain_Risk_FE
ADD High_Risk_Route BIT;
GO

UPDATE dbo.Global_Supply_Chain_Risk_FE
SET High_Risk_Route =
    CASE 
        WHEN Origin_Port IN ('Shanghai', 'Shenzhen', 'Busan')
         AND Destination_Port IN ('Los Angeles', 'Long Beach', 'Seattle')
        THEN 1
        ELSE 0
    END;
GO

--Fuel Cost Impact
ALTER TABLE dbo.Global_Supply_Chain_Risk_FE
ADD Fuel_Cost_Impact FLOAT;
GO

UPDATE dbo.Global_Supply_Chain_Risk_FE
SET Fuel_Cost_Impact = Fuel_Price_Index / (SELECT AVG(Fuel_Price_Index) FROM dbo.Global_Supply_Chain_Risk_FE);
GO

--Weight-Distance Interaction
ALTER TABLE dbo.Global_Supply_Chain_Risk_FE
ADD Weight_Distance_Interaction FLOAT;
GO

UPDATE dbo.Global_Supply_Chain_Risk_FE
SET Weight_Distance_Interaction = Weight_MT * Distance_km;
GO

--Dummy Variables (One-Hot Encoding)
--Transport_Mode → dummies
ALTER TABLE dbo.Global_Supply_Chain_Risk_FE
ADD Mode_Sea BIT,
    Mode_Air BIT,
    Mode_Road BIT;
GO

UPDATE dbo.Global_Supply_Chain_Risk_FE
SET Mode_Sea  = CASE WHEN Transport_Mode = 'Sea'  THEN 1 ELSE 0 END,
    Mode_Air  = CASE WHEN Transport_Mode = 'Air'  THEN 1 ELSE 0 END,
    Mode_Road = CASE WHEN Transport_Mode = 'Road' THEN 1 ELSE 0 END;
GO

--Product_Category → dummies
ALTER TABLE dbo.Global_Supply_Chain_Risk_FE
ADD Cat_Electronics BIT,
    Cat_Food BIT,
    Cat_Automotive BIT,
    Cat_Pharma BIT;
GO

UPDATE dbo.Global_Supply_Chain_Risk_FE
SET Cat_Electronics = CASE WHEN Product_Category = 'Electronics' THEN 1 ELSE 0 END,
    Cat_Food        = CASE WHEN Product_Category = 'Food'        THEN 1 ELSE 0 END,
    Cat_Automotive  = CASE WHEN Product_Category = 'Automotive'  THEN 1 ELSE 0 END,
    Cat_Pharma      = CASE WHEN Product_Category = 'Pharma'      THEN 1 ELSE 0 END;
GO

--Origin_Port → dummies
ALTER TABLE dbo.Global_Supply_Chain_Risk_FE
ADD Port_Origin_Shanghai BIT,
    Port_Origin_Rotterdam BIT,
    Port_Origin_LA BIT,
    Port_Origin_Dubai BIT;
GO

UPDATE dbo.Global_Supply_Chain_Risk_FE
SET Port_Origin_Shanghai = CASE WHEN Origin_Port = 'Shanghai' THEN 1 ELSE 0 END,
    Port_Origin_Rotterdam = CASE WHEN Origin_Port = 'Rotterdam' THEN 1 ELSE 0 END,
    Port_Origin_LA        = CASE WHEN Origin_Port = 'Los Angeles' THEN 1 ELSE 0 END,
    Port_Origin_Dubai     = CASE WHEN Origin_Port = 'Dubai' THEN 1 ELSE 0 END;
GO

--Destination_Port → dummies
ALTER TABLE dbo.Global_Supply_Chain_Risk_FE
ADD Port_Dest_Shanghai BIT,
    Port_Dest_Rotterdam BIT,
    Port_Dest_LA BIT,
    Port_Dest_Dubai BIT;
GO

UPDATE dbo.Global_Supply_Chain_Risk_FE
SET Port_Dest_Shanghai = CASE WHEN Destination_Port = 'Shanghai' THEN 1 ELSE 0 END,
    Port_Dest_Rotterdam = CASE WHEN Destination_Port = 'Rotterdam' THEN 1 ELSE 0 END,
    Port_Dest_LA        = CASE WHEN Destination_Port = 'Los Angeles' THEN 1 ELSE 0 END,
    Port_Dest_Dubai     = CASE WHEN Destination_Port = 'Dubai' THEN 1 ELSE 0 END;
GO

--Weather_Conditions → dummies
ALTER TABLE dbo.Global_Supply_Chain_Risk_FE
ADD Weather_Clear BIT,
    Weather_Rain BIT,
    Weather_Storm BIT,
    Weather_Fog BIT;
GO

UPDATE dbo.Global_Supply_Chain_Risk_FE
SET Weather_Clear = CASE WHEN Weather_Condition = 'Clear' THEN 1 ELSE 0 END,
    Weather_Rain  = CASE WHEN Weather_Condition = 'Rain'  THEN 1 ELSE 0 END,
    Weather_Storm = CASE WHEN Weather_Condition = 'Storm' THEN 1 ELSE 0 END,
    Weather_Fog   = CASE WHEN Weather_Condition = 'Fog'   THEN 1 ELSE 0 END;
GO

--Final Validation
SELECT TOP 50 *
FROM dbo.Global_Supply_Chain_Risk_FE;

