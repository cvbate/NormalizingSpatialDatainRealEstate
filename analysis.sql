-- Spatial Databases IDCE 376 Assignment 3
-- Clio Bate 
-- 02/21/2024

-- STEP 1. create the table PropertyDetails, which will have 9 columns and will be a nonnormalized table storing all the original information
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
(3, '43 Broadway', 'New Haven', 'CT', 'USA', 'Commerical', 'Gas, Water, Electric, Central Heat, Central Cool', ST_GeomFromText('POINT(-72.9312 41.3116)', 4326) , '135081');


--STEP 2.---------------------------------------------- Original Table above...  Steps to 1NF Below
-- Now the datatables need to be normalized. Each column needs to have atomic values and depend on a unique primary key
--The column, "utlitlies" does not have atomic values, and therefore our data table needs to be split into two tables.
-- Utilities will be split from PropertyDetails with PropertyID as the foreign key.


-- create a table to store the utility information. Set the forign key, 'PropertyID' in 'Utilities' to reference 'PropertyID' in 'PropertyDetails'
CREATE TABLE Utilities (
UtilityID SERIAL PRIMARY KEY,
PropertyID INT,
Utility VARCHAR(255),
FOREIGN KEY (PropertyID) REFERENCES PropertyDetails(PropertyID)
);


-- Interset data into 'Utilities.'  with 'PropertyID' referencing 'PropertyID' from 'PropertyDetails' table
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

-- drop the redundance column 'Utility' from 'PropertyDetails'
ALTER TABLE PropertyDetails DROP COLUMN Utility;

--our tables are in 2NF becase they are in 1NF and there are no partial dependencies
--STEP 3---------------------------------------------- 1NF/2NF above, 3NF Below 
-- for 3NF we must remove all transitive dependenies. In this case 'State', 'Country', and 'CityPopulation' have a transtitive dependency on 'City'
-- to do this we willl create a table, 'CityDemographics' to store this information


-- Create table CityDemographics to store City, State, Country, and City Population with City as primary ID
CREATE TABLE CityDemographics (
City VARCHAR(100) PRIMARY KEY, -- note that this is not "serial" because it is non-numeric
State VARCHAR(50),
Country VARCHAR(50),
CityPopulation INT
);

-- insert into 'CityDemographics' all information dependent on the city
INSERT INTO CityDemographics (City, State, Country, CityPopulation) VALUES
('New Haven', 'CT', 'USA', '135081'), -- New Haven
('Worcester', 'MA', 'USA', '205918') -- Worcester
;

-- drop redundacnt columns, CityPopulation, State, and Country in PropertyDetails
ALTER TABLE PropertyDetails DROP COLUMN CityPopulation, DROP COLUMN State, DROP COLUMN Country;

--STEP 4----------------------------------------------3NF Above, 4NF below
-- There is a Multivariate dependency for Property Zoning meaning that Zoning
-- is not ddirectly related to City, but they both rely directly on the Primary Key 
-- therefore, we must split Zoning off into a separate table and ensure that it references PropetyDetails


CREATE TABLE PropertyZoning (
    PropertyZoningID SERIAL PRIMARY KEY,
    PropertyID INT REFERENCES PropertyDetails(PropertyID),
    ZoningType VARCHAR(100)
);

INSERT INTO PropertyZoning (PropertyID, ZoningType) VALUES
(1, 'Residential'),
(2, 'Multi-family Residential'),
(3, 'Commerical')
;

-- in the lab we are supposed to do ulitilites here as well, but I did that earlier because it was non-atomic and so it didn't fit into 1NF

ALTER TABLE Properties DROP COLUMN ZoningType;


--STEP 5------------------------------------- Spatial Data Manipulation

INSERT INTO PropertyDetails (PropertyID, Address, City, GeoLocation) VALUES 
(4, '950 Main St', 'Worcester', ST_GeomFromText('POINT(-71.8245 42.2520)', 4326));

-- need to edit
SELECT Address, City
FROM Properties
WHERE ST_DWithin(
    GeoLocation,
    ST_GeomFromText('POINT(-71.8245 42.2520)', 4326),
    10000 -- 10km radius
);

