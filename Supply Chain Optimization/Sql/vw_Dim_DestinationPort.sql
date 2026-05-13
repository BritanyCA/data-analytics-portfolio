CREATE VIEW dbo.vw_Dim_DestinationPort AS
SELECT DISTINCT
    Destination_Port AS Port_Name
FROM dbo.Global_Supply_Chain_Risk_FE;
