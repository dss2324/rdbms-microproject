SET SERVEROUTPUT ON;
ACCEPT Name CHAR PROMPT'ENTER YOUR NAME: ';
ACCEPT BikeName CHAR PROMPT'Which Bike you are returning: ';
DECLARE
     uname VARCHAR(50) := '&Name';
     ubike VARCHAR(50):= '&BikeName';
BEGIN
    RENT.returnbike(ubike,uname);
END;