-- Table creation
CREATE TABLE Users (
  UserID INT PRIMARY KEY,
  UserName VARCHAR(50)
);

CREATE TABLE Bikes (
  BikeID INT PRIMARY KEY,
  BikeName VARCHAR(50),
  Status VARCHAR(10) DEFAULT 'Available',
  DailyRate NUMBER(10,2)
);

CREATE TABLE Rentals (
  RentalID INT PRIMARY KEY,
  UserID INT,
  BikeID INT,
  RentalDate DATE,
  ReturnDate DATE,
  TotalCost DECIMAL(10,2),
  FOREIGN KEY (UserID) REFERENCES Users(UserID),
  FOREIGN KEY (BikeID) REFERENCES Bikes(BikeID)
);
/
--ALTER TABLE Bikes ADD DailyRate NUMBER(10,2);
--UPDATE Bikes SET DailyRate=6500 WHERE BikeID=110;



SELECT * FROM Users;
SELECT * FROM Bikes;
SELECT * FROM Rentals;


--UPDATE   Bikes SET status='Availabel' WHERE status = 'Occupied';
--DROP TABLE Users;
--DROP TABLE Bikes;
--DROP TABLE Rentals;

desc Bikes;
desc Users;
desc Rentals;








