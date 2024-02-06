--WRITE BLOCK SUCH THAT IT TAKE USERNAME AND BIKENAME FROM USER 
--AND ALLOT IT TO USER  
SET SERVEROUTPUT ON;
ACCEPT Name CHAR PROMPT'ENTER YOUR NAME: ';
ACCEPT BikeName CHAR PROMPT'Which Bike you Need?: ';
ACCEPT Days NUMBER PROMPT'How Many Days you need bike for ? ';

DECLARE 
      UName VARCHAR(50):= '&Name';
      UBike VARCHAR(50):= '&BikeName';
      udays NUMBER := &Days;
      uid  NUMBER;
      bid  NUMBER;
BEGIN 
     SELECT UserID into uid FROM Users  where username = UName;
     SELECT BikeID into bid FROM Bikes where bikename=UBike ;
     RENT.rentbike(uid,bid,udays);
END;     
