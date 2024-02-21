


1. Ulitlity does not contain atomic values, so it must be split into a separate table called ' ultilities' 





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