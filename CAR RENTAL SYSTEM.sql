CREATE DATABASE CAR_RENTAL;
USE CAR_RENTAL;
CREATE TABLE VEHICLE
(
CARID INT PRIMARY KEY,
MAKE VARCHAR(50),
MODEL VARCHAR(50),
YEAR INT,
DAILYRATE FLOAT(50),
STATUS INT,
PASCAP INT,
ENGCAP INT
);
CREATE TABLE CUSTOMER
(
CID INT PRIMARY KEY,
FNAME VARCHAR(50),
LNAME VARCHAR(50),
EMAIL VARCHAR (50),
PHONE CHAR(10),
);
CREATE TABLE LEASE
(
LID INT PRIMARY KEY,
CARID INT FOREIGN KEY (CARID) REFERENCES [dbo].[VEHICLE]([CARID]),
CID INT FOREIGN KEY (CID) REFERENCES [dbo].[CUSTOMER]([CID]),
STARTDATE DATE,
ENDDATE DATE,
TYPE VARCHAR(50)
);
CREATE TABLE PAYMENT
(
PAYID INT PRIMARY KEY,
LID INT FOREIGN KEY (LID) REFERENCES [dbo].[LEASE]([LID]),
PAYDATE DATE,
AMT FLOAT
);

INSERT INTO [dbo].[VEHICLE]([CARID],[MAKE],[MODEL],[YEAR],[DAILYRATE],[STATUS],[PASCAP],[ENGCAP])
VALUES(1,'TOYOTA','CAMRY',2022,50.00,1,4,1450),(2,'HONDA','CIVIC',2023,45.00,1,7,1500),
(3,'FORD','FOCUS',2022,48.00,0,4,1400),(4,'NISSAN','ALTIMA',2023,52.00,1,7,1200),
(5,'CHEVROLET','MALIBU',2022,47.00,1,4,1800),(6,'HYUNDAI','SONATA',2023,49.00,0,7,1400),
(7,'BMW','3SERIES',2023,60.00,1,7,2499),(8,'MERCEDES','C-CLASS',2022,58.00,1,8,2599),
(9,'AUDI','A4',2022,55.00,0,4,2500),(10,'LEXUS','ES',2023,54.00,1,4,2500);

INSERT INTO [dbo].[CUSTOMER]([CID],[FNAME],[LNAME],[EMAIL],[PHONE])
VALUES (1,' John',' Doe', 'johndoe@example.com', 555-555-5555),
(2,' Jane', 'Smith', 'janesmith@example.com', 555-123-4567),
(3 ,'Robert' ,'Johnson' ,'robert@example.com ',555-789-1234),
(4,' Sarah',' Brown',' sarah@example.com', 555-456-7890),
(5 ,'David' ,'Lee ','david@example.com ',555-987-6543),
(6,' Laura', 'Hall', 'laura@example.com', 555-234-5678),
(7, 'Michael ','Davis' ,'michael@example.com ',555-876-5432),
(8, 'Emma', 'Wilson',' emma@example.com ',555-432-1098),
(9,'William',' Taylor', 'william@example.com', 555-321-6547),
(10, 'Olivia',' Adams', 'olivia@example.com', 555-765-4321);

INSERT INTO [dbo].[LEASE]([LID],[CARID],[CID],[STARTDATE],[ENDDATE],[TYPE])
VALUES (1, 1, 1, '2023-01-01', '2023-01-05', 'Daily'),
(2, 2,2,' 2023-02-15',' 2023-02-28',' Monthly'),
(3, 3, 3,' 2023-03-10', '2023-03-15',' Daily'),
(4, 4, 4, '2023-04-20', '2023-04-30',' Monthly'),
(5, 5, 5,' 2023-05-05',' 2023-05-10',' Daily'),
(6, 4, 3,' 2023-06-15',' 2023-06-30',' Monthly'),
(7, 7 ,7, '2023-07-01',' 2023-07-10',' Daily'),
(8, 8,8, '2023-08-12',' 2023-08-15',' Monthly'),
(9, 3, 3, '2023-09-07',' 2023-09-10', 'Daily'),
(10, 10, 10, '2023-10-10',' 2023-10-31',' Monthly');

INSERT INTO [dbo].[PAYMENT]([PAYID],[LID],[PAYDATE],[AMT])
VALUES (1, 1,' 2023-01-03', 200.00),(2, 2,' 2023-02-20', 1000.00),
(3, 3,' 2023-03-12', 75.00),(4, 4 ,'2023-04-25', 900.00),
(5 ,5,' 2023-05-07', 60.00),(6 ,6 ,'2023-06-18' ,1200.00),
(7 ,7,' 2023-07-03', 40.00),(8 ,8 ,'2023-08-14 ',1100.00),
(9 ,9,' 2023-09-09', 80.00),(10 ,10,' 2023-10-25', 1500.00);

--Q1
UPDATE [dbo].[VEHICLE] SET [DAILYRATE]=[DAILYRATE]+10 WHERE [MAKE]='MERCEDES';
--Q2
DELETE  FROM PAYMENT
WHERE LID IN (SELECT LID FROM LEASE WHERE CID = (SELECT CID FROM Customer WHERE FNAME = 'John' AND LNAME = 'Doe'));
DELETE FROM LEASE
WHERE CID = (SELECT CID FROM CUSTOMER WHERE FNAME = 'John' AND LNAME = 'Doe');
DELETE FROM CUSTOMER
WHERE FNAME = 'John' AND LNAME = 'Doe';
--Q3
ALTER TABLE [dbo].[PAYMENT] RENAME COLUMN [PAYDATE] TO [TRANSDATE] ;
--Q4
SELECT * FROM [dbo].[CUSTOMER]
WHERE [EMAIL] = 'emma@example.com';
--Q5
SELECT *FROM LEASE
WHERE CID = (SELECT CID FROM CUSTOMER WHERE FNAME = 'Olivia' AND LNAME = 'Adams')  AND StartDate <= GETDATE()
AND EndDate >= GETDATE();
--Q6
SELECT *FROM PAYMENT
WHERE LID IN (SELECT LID FROM LEASE WHERE CID = (SELECT CID FROM Customer WHERE PHONE = '555-765-4321'));
--Q7
SELECT[MAKE] ,AVG ([DAILYRATE])'AVG' FROM [dbo].[VEHICLE]
GROUP BY [MAKE];
--Q8
SELECT [MAKE],MAX([DAILYRATE]) 'MAX' FROM [dbo].[VEHICLE]
GROUP BY [MAKE]
ORDER BY [MAKE] ASC
OFFSET 1 ROWS
FETCH NEXT 1 ROWS ONLY;
--Q9
SELECT [MAKE].*FROM [VEHICLE] AS V
JOIN LEASE AS L ON V.CID = L.CID
JOIN MAKE AS C ON L.CARID = C.CARID
WHERE V.EMAIL = 'sarah@example.com';
--Q10
SELECT LEASE.*, VEHICLE.MAKE, VEHICLE.MODEL, CUSTOMER.FNAME, CUSTOMER.LNAME
FROM LEASE
JOIN VEHICLE ON LEASE.CARID = VEHICLE.CARID
JOIN CUSTOMER ON LEASE.CID = CUSTOMER.CID
ORDER BY LEASE.STARTDATE DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY;
--Q11
SELECT * FROM Payment
WHERE YEAR(PAYDATE) = 2023;
--Q12
SELECT Customers.* FROM Customers
LEFT JOIN Payment ON Customers.CID = Payment.CID
WHERE Payment.CID IS NULL;
--Q13
SELECT VEHICLE.*, SUM(Payment.AMT) AS TotalPayments FROM VEHICLE
LEFT JOIN Lease ON VEHICLE.CarID = Lease.CarID
LEFT JOIN Payment ON Lease.LID = Payment.LID
GROUP BY VEHICLE.CARID;
--Q14
SELECT Customers.CID, Customers.FNAME, SUM(Payment.AMT) AS TotalPayments FROM Customers
LEFT JOIN Payment ON Customers.CID = Payment.CID
GROUP BY Customers.CID, Customers.FNAME;
--Q15
SELECT Lease.LID,Lease.startDate,Lease.endDate,
    Vehicle.CARID,Vehicle.make,Vehicle.modeL FROM Lease
JOIN Vehicle ON Lease.CARID = Vehicle.CARID;
--Q16
SELECT LEASE.*, CUSTOMER.FNAME, CUSTOMER.LNAME, Vehicle.make, Vehicle.model FROM Lease
JOIN Customer ON Lease.CID = Customer.CID
JOIN Vehicle ON Lease.CARID = Vehicle.CARID
WHERE endDate >= GETDATE();
--Q17
SELECT Customer.CID,Customer.FNAME,Customer.LNAME,SUM(Payment.AMT) AS totalPayments
FROM Customer
LEFT JOIN Lease ON Customer.CID = Lease.CID
LEFT JOIN Payment ON Lease.LID = Payment.LID
GROUP BY Customer.CID, Customer.FNAME, Customer.LNAME
ORDER BY totalPayments DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY;
--Q18
SELECT Vehicle.*, Lease.startDate, Lease.endDate, Customer.FNAME, Customer.LNAME FROM Vehicle
LEFT JOIN LEASE ON VEHICLE.CARID = Lease.CARID
LEFT JOIN CUSTOMER ON LEASE.CID = CUSTOMER.CID
