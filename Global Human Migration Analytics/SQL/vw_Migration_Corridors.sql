CREATE VIEW dbo.vw_Migration_Corridors AS
SELECT 
    origin_country,
    destination_country,
    year,
    migrant_stock,
    corridor
FROM dbo.MigrationCorridors;
