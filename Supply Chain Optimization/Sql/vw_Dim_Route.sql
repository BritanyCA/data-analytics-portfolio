CREATE VIEW vw_Dim_Route AS
SELECT DISTINCT
    Origin_Port,
    Destination_Port
FROM vw_Fact_SupplyChainRisk
WHERE Origin_Port IS NOT NULL
  AND Destination_Port IS NOT NULL;
