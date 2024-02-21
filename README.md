
1. Submission includes SQL scripts and a Markdown report detailing how the normalization principles are applied.

2. GitHub repository is organized with a comprehensive README.md and the report details how each SQL command satisfies normalization principles. Collaborators are invited for review.

3. The Markdown report should detail the journey from 1NF through to 4NF, providing specific examples from your SQL scripts and explaining why each step satisfies the corresponding normalization form.

4. Pay special attention to the clarity of your explanations in the Markdown report. The goal is to demonstrate your understanding of database normalization and spatial data management through detailed examples and explanations.

5. Include a section in your README.md on how to set up PostGIS and prerequisites for running your SQL scripts, alongside the Markdown report for normalization explanation.

1. Ulitlity does not contain atomic values, so it must be split into a separate table called ' ultilities' 

# Normalizing Spatial Data in a Real Estate Database 
## Spatial Databases IDCE 376 | Assignment 3: | Clio Bate | 02/21/2024

This project was created as part of the class Spatial Databases at Clark University Spring, 2024. The objective of this assignent is to continue to work with the concept of database normalization by creating a non-normal database of addresses that include geospatial locations and city population data and working with PostGIS. We are to normalize it all the way through to 4NF. To write and implement the SQL script I used the SQLShell to interact with PGAdmin with PostGIS extension and used VSCode to manage my repository and store my SQL script.     
The full assignment instructions can be found on the class website, [here](https://studyingplace.space/spatial-database/labs/A3-Real_Estate_Database.html#part-4-normalize-to-4nf)  

**What is PostGIS?** PostGIS is an extension that allows you to work with geospatial objects and perform spatial queries.

Database normalization rules:  
**1NF**: A 1NF table should have all atomic values—there should be no repeating values within a column— and each row should be uniquely idenfiable by a primary key
**2NF**: A 2NF table should meet at 1NF standards and also not have any partial dependencies— aka no column should depend on any other column other than the primary key.  
**3NF**: A 3NF table should meet all 2NF standards annd also not have any transisitive depencencies— aka the primary key must fully define all non-key columns and each column cannot depend on another column other than said primary key.  
**4NF**: A 4NF table should meet all 3NF standards and not have any non multivariate dependencies. MVD occurs when two(or more) columns in a table are independent of each other buth both depend on the same Primary Key.  



### This repository includes
1. README.MD (this document): A Markdown file containing the Normalization Report.
1. analysis.sql : SQL script that created and normaled tables
1. Screenshots showing the structures of my final tablesin pgAdmin. The screenshots of each table includes:  
    - Pets_Ive_Had_table1 = 'orignal' table 
    - Pets_table2 = lists pets with PetID as primary key = 1NF
    - Pets_Descrip_table3 = lists decriptions with DescripID as primary key  = 1NF
    - Descrip_table4  = 2NF



### Methods

Before trying to replicate this Database setup using SQL Shell to interact is PgAdmin:
- create new database called RealEstateDB
`CREATE DATABASE RealEstateDB;`

- Ensure that the shell is connected to RealEstateDB
`\c realestatedb`

- Enable PostGIS
`CREATE EXTENSION IF NOT EXISTS postgis;`



Challenges: I tried to make Utilies prim key dependent on the foreing key from property descriptions instead of properties, which resulted in the error
ERROR:  duplicate key value violates unique constraint "utilities_pkey"
DETAIL:  Key (propertyid)=(1) already exists.
which made me realize that i forgot to create a new talble 'Properties' which does not include utilities of which Utilities should depend on- NOT the original table.... but then i was still getting that proble, and I realized that i set Property ID as my serial primary key instead of Utility ID so instead of this:  
`CREATE TABLE Utilities (
UtilityID SERIAL PRIMARY KEY,
PropertyID INT,
Utility VARCHAR(255),
FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID)
);`  
I had... This:  
`CREATE TABLE Utilities (
PropertyID SERIAL PRIMARY KEY,
Utility VARCHAR(255),
FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID)
);`

Challenge: When trying to preform spatal analaysis
INSERT INTO Properties (Address, City, GeoLocation) VALUES
realestatedb-# ('950 Main St', 'Worcester', ST_GeomFromText('POINT(-71.8245 42.2520)', 4326));
ERROR:  duplicate key value violates unique constraint "properties_pkey"
DETAIL:  Key (propertyid)=(1) already exists.


Challenge - I will ask in class/office hours, but writing this down here as well
Questios: Why is it that in CityDemographics the column 'City' is used as a primary key? why is it not a serial primary key called CityID with 'City' as a separate column'? Is it because it is atomic? Furthermore, in the SQL query we didn't set them to reference the original table, I suppose this is because City in PropertyDetails is not a Primary Key, but then , how does the database know the two tables are linked?

Another question: why is it that address and city are not considered to have a partial dependency?

