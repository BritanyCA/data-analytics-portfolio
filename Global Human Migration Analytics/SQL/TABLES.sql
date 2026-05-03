/*Creation of tables for use in the analysis */
CREATE TABLE DiasporaPopulationByCountry(
	OriginCountry VARCHAR(100) NOT NULL,
	DestinationCountry VARCHAR (100) NOT NULL,
	DestinationRegion VARCHAR (100) NULL,
	DiasporaPopulation INT NOT NULL,
	MigrationType VARCHAR (100) NOT NULL,
	YearEstimate INT NOT NULL,
	Source VARCHAR (200) NULL,
	Continent VARCHAR (100) NULL,
	CONSTRAINT PK_DiasporaPopulationByCountry
		PRIMARY KEY (OriginCountry,	DestinationCountry, YearEstimate, MigrationType)
);

CREATE TABLE MigrationCorridors(
	OriginCountry VARCHAR (100) NOT NULL,
	DestinationCountry VARCHAR (100) NOT NULL,
	Year INT NOT NULL,
	Corridor VARCHAR (200) NULL,
	CONSTRAINT PK_MigrationCorridors
		PRIMARY KEY (OriginCountry, DestinationCountry, Year)
);

CREATE TABLE MigrationStockTotals(
	Year INT NOT NULL PRIMARY KEY,
	PakistanTotalEmigrants INT NULL,
	IndianTotalEmigrants INT NULL,
	BangladeshTotalEmigrants INT NULL,
	SriLankaTotalEmigrants INT NULL,
	NepalTotalEmigrants INT NULL,
	SouthAsiaTotal INT NULL,
);

CREATE TABLE PakistanAnnualEmigration(
	Year INT NOT NULL PRIMARY KEY,
	WorkersEmigrated INT NOT NULL,
	TopDestination VARCHAR (100) NOT NULL,
	SkilledPct DECIMAL(5,2) NOT NULL,
	UnSkilledPct DECIMAL (5,2) NOT NULL,
	SemiSkilled DECIMAL(5,2) NOT NULL,
	SkilledWorkers INT NOT NULL,
	SemiSkilledWorkers INT NOT NULL,
	UnSkilledWorkers INT NOT NULL,
	);

CREATE TABLE RemittancesSouthAsia(
Year INT NOT NULL,
Country VARCHAR (100) NOT NULL,
RemittancesUsdBillions DECIMAL (10,2) NOT NULL,
RemittancesPctGdp DECIMAL (10,2),
CONSTRAINT PK_RemittancesSouthAsia
	PRIMARY KEY (Year, Country)
	);