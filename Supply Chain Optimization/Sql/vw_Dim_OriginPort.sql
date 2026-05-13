CREATE VIEW dbo.vw_Dim_OriginPort AS
SELECT DISTINCT
    Origin_Port AS Port_Name
FROM dbo.Global_Supply_Chain_Risk_FE;
