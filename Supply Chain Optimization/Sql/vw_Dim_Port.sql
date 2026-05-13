CREATE VIEW vw_Dim_Port AS
SELECT DISTINCT Origin_Port AS Port_Name
FROM vw_Fact_SupplyChainRisk
WHERE Origin_Port IS NOT NULL

UNION

SELECT DISTINCT Destination_Port
FROM vw_Fact_SupplyChainRisk
WHERE Destination_Port IS NOT NULL;
