-- create new database called RealEstateDB
CREATE DATABASE RealEstateDB;

-- Connect to RealEstateDB
\c realestatedb

-- Enable PostGIS
CREATE EXTENSION IF NOT EXISTS postgis;

-- create the table PropertyDetails, which will have 9 columns
CREATE TABLE PropertyDetails (
PropertyID SERIAL PRIMARY KEY,
Address VARCHAR(255),
City VARCHAR(100),
State VARCHAR(50),
Country VARCHAR(50),
ZoningType VARCHAR(100),
Utility VARCHAR(100),
GeoLocation GEOMETRY(Point, 4326), -- Spatial data type
CityPopulation INT
);

-- populate PropertyDetails with the data of three addresses
INSERT INTO  PropertyDetails (PropertyID, Address, City, State, Country, ZoningType, Utility, GeoLocation, CityPopulation) VALUES
(1, '155 Colony Rd', 'New Haven', 'CT', 'USA', 'Residential', 'Gas, Water, Electric', ST_GeomFromText('POINT(-72.929916 41.310726)', 4326), '135081'),
(2, '52 Holywood St', 'Worcester', 'MA', 'USA', 'Multi-family Residential', 'Gas, Water, Electric', ST_GeomFromText('POINT(-71.798889 42.271389)', 4326) , '205918'),
(3, '43 Broadway', 'New Haven', 'CT', 'USA', 'Commerical', 'Gas, Water, Electric, Central Heat, Central Cool', ST_GeomFromText('POINT(-72.929916 41.310726)', 4326) , '135081');


---------------------------------- Original Table above...  Steps to 1NF Below

-- Create a table without the Utilities
CREATE TABLE Properties(
PropertyID SERIAL PRIMARY KEY,
Address VARCHAR(255),
City VARCHAR(100),
State VARCHAR(50),
Country VARCHAR(50),
ZoningType VARCHAR(100),
GeoLocation GEOMETRY(Point, 4326), -- Spatial data type
CityPopulation INT
);

-- 
CREATE TABLE Utilities (
UtilityID SERIAL PRIMARY KEY,
PropertyID INT,
Utility VARCHAR(255),
FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID)
);

INSERT INTO Properties (PropertyID, Address, City, State, Country, ZoningType, GeoLocation, CityPopulation) VALUES
(1, '155 Colony Rd', 'New Haven', 'CT', 'USA', 'Residential', ST_GeomFromText('POINT(-72.929916 41.310726)', 4326), '135081'),
(2, '52 Holywood St', 'Worcester', 'MA', 'USA', 'Multi-family Residential', ST_GeomFromText('POINT(-71.798889 42.271389)', 4326) , '205918'),
(3, '43 Broadway', 'New Haven', 'CT', 'USA', 'Commerical', ST_GeomFromText('POINT(-72.929916 41.310726)', 4326) , '135081');


INSERT INTO Utilities (PropertyID, Utility) VALUES
(1, 'Gas'), 
(1, 'Water'),
(1, 'Electric'),
(2, 'Gas'), 
(2, 'Water'),
(2, 'Electric'),
(3, 'Gas'), 
(3, 'Water'),
(3, 'Electric'),
(3, 'Central Heat'), 
(3, 'Central Cool');



--our tables are automatically in 2NF becase they are in 1NF and there are no partial dependencies
-------------------------------- 1NF above/2NF, #NF Below 

