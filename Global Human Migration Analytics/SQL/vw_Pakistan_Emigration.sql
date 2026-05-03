CREATE VIEW dbo.vw_Pakistan_Emigration AS
SELECT 
    year,
    workers_emigrated,
    skilled_pct,
    semi_skilled_pct,
    unskilled_pct,
    skilled_workers,
    semi_skilled_workers,
    unskilled_workers,
    top_destination
FROM dbo.PakistanAnnualEmigration;
