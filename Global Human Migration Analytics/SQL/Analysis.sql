/*SQL Analysis*/

/*JOINS*/
/*INNER JOIN because we want rows in the both tables*/
SELECT
MigrationCorridors.origin_country,
MigrationCorridors.destination_country,
MigrationCorridors.year,
MigrationCorridors.migrant_stock,
DiasporaPopulationByCountry.diaspora_population,
DiasporaPopulationByCountry.migration_type
FROM dbo.MigrationCorridors
INNER JOIN dbo.DiasporaPopulationByCountry
ON MigrationCorridors.origin_country = DiasporaPopulationByCountry.origin_country
AND MigrationCorridors.destination_country= DiasporaPopulationByCountry.destination_country
AND MigrationCorridors.year = DiasporaPopulationByCountry.year_estimate;

/*Check remittances from Pakistan*/
SELECT
RemittancesSouthAsia.year,
RemittancesSouthAsia.remittances_usd_billion,
MigrationStockTotals.Pakistan_total_emigrants
FROM RemittancesSouthAsia
INNER JOIN dbo.MigrationStockTotals
ON RemittancesSouthAsia.year = MigrationStockTotals.year
WHERE RemittancesSouthAsia.country='Pakistan'
ORDER BY RemittancesSouthAsia.year;

/*Pakistan Annual Emigration + Remittances South Asia*/
/*LEFT JOIN because	Pakistan Annual Mig have records from 80´s 
and Remittances have records from 2k*/
SELECT
PakistanAnnualEmigration.year,
PakistanAnnualEmigration.workers_emigrated,
PakistanAnnualEmigration.unskilled_workers,
RemittancesSouthAsia.remittances_usd_billion
FROM dbo.PakistanAnnualEmigration
LEFT JOIN dbo.RemittancesSouthAsia
ON PakistanAnnualEmigration.year = RemittancesSouthAsia.year
AND RemittancesSouthAsia.country='Pakistan'
ORDER BY PakistanAnnualEmigration.year;

SELECT
MigrationCorridors.origin_country,
MigrationCorridors.destination_country,
MigrationCorridors.year,
MigrationCorridors.migrant_stock,
RemittancesSouthAsia.remittances_usd_billion,
MigrationStockTotals.Pakistan_total_emigrants
FROM dbo.MigrationCorridors
LEFT JOIN dbo.RemittancesSouthAsia
ON MigrationCorridors.year = RemittancesSouthAsia.year
AND MigrationCorridors.origin_country= RemittancesSouthAsia.country
LEFT JOIN dbo.MigrationStockTotals
ON MigrationCorridors.year= MigrationStockTotals.year
WHERE MigrationCorridors.origin_country ='Pakistan'
ORDER BY MigrationCorridors.year;

/*CTEs WITH, Emigration growing over the years LAG() Check 
the previous value*/
WITH Emigration AS(
	SELECT
		year,
		Pakistan_total_emigrants,
		LAG(Pakistan_total_emigrants) OVER (ORDER BY Year) AS prev_year
		FROM DBO.MigrationStockTotals
)
SELECT 
	year,
	Pakistan_total_emigrants,
	prev_year,
	Pakistan_total_emigrants - prev_year AS growth
	FROM Emigration
ORDER BY year;

/*CTE Growing by country*/
WITH Totales AS(
	SELECT
		year,
		Pakistan_total_emigrants AS Pakistan,
		India_total_emigrants AS India,
		Bangladesh_total_emigrants AS Bangladesh,
		Sri_Lanka_total_emigrants AS SriLanka,
		Nepal_total_emigrants AS Nepal
	FROM dbo.MigrationStockTotals
),
Crecimiento AS (
SELECT
	year,
	Pakistan,
	LAG(Pakistan) OVER (ORDER BY year) AS Pak_prev,
	India,
	LAG(India) OVER (ORDER BY year) AS Ind_prev,
	Bangladesh,
	LAG(Bangladesh) OVER (ORDER BY year) AS Ban_prev,
	SriLanka,
	LAG(SriLanka) OVER (ORDER BY year) AS SL_prev,
	Nepal,
	LAG(Nepal) OVER (ORDER BY year) AS Nep_prev
FROM Totales
)
SELECT
	year,
	Pakistan - Pak_prev AS Pakistan_growth,
	India - Ind_prev AS India_growth,
	Bangladesh - Ban_prev AS Bangladesh_growth,
	SriLanka - SL_prev AS SriLanka_growth,
	Nepal - Nep_prev AS Nepal_growth
FROM Crecimiento
ORDER BY year;

/*Windows Function*/
/*Rank assign positions*/
SELECT 
	destination_country,
	diaspora_population,
	RANK() OVER (ORDER BY diaspora_population DESC) AS rank_population
FROM dbo.DiasporaPopulationByCountry
WHERE origin_country='Pakistan'
ORDER BY rank_population;

/*Average Remittances*/
/*ROWS BETWEEN 2 PRECEDING AND CURRENT ROW = ventana móvil de 3 años*/
SELECT
	year,
	remittances_usd_billion,
	AVG(remittances_usd_billion)
		OVER (ORDER BY year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
		AS moving_avg_3yr
FROM dbo.RemittancesSouthAsia
WHERE country='Pakistan'
ORDER BY year;
