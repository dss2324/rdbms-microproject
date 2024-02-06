SET SERVEROUTPUT ON;
CREATE SEQUENCE RENT_ID_SEQ
    START WITH 1001
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
/
CREATE OR REPLACE TRIGGER RENTID_TRIGGER
BEFORE INSERT ON Rentals
FOR EACH ROW
BEGIN
    SELECT RENT_ID_SEQ.NEXTVAL INTO :NEW.RentalID FROM DUAL;
END;
/
-- PACKAGE SPECIFICATION

CREATE OR REPLACE PACKAGE RENT
IS
    PROCEDURE RentBike(p_user_id INT,p_bike_id INT,p_rental_days INT);
    PROCEDURE ReturnBike(p_bike_name VARCHAR2,p_user_name VARCHAR2);
    FUNCTION CalculateRentalCost(p_rental_days INT,p_daily_rate DECIMAL) RETURN DECIMAL;
END RENT;
/
--PACKAGE BODY
CREATE OR REPLACE PACKAGE BODY RENT
IS
    -- Function for rental cost calculation
     FUNCTION CalculateRentalCost(p_rental_days INT,p_daily_rate DECIMAL) RETURN DECIMAL 
     IS
      v_cost DECIMAL(10,2);
    BEGIN
      v_cost := p_rental_days * p_daily_rate;
      RETURN v_cost;
    END;
    -- Procedure for renting a bike
    PROCEDURE RentBike(p_user_id INT,p_bike_id  INT,p_rental_days INT) 
    IS
      v_daily_rate DECIMAL(10,2);
      v_total_cost DECIMAL(10,2);
      v_bike_id NUMBER;
      v_status VARCHAR(10);
    BEGIN
        SELECT BikeID INTO v_bike_id from Bikes WHERE BikeID = p_bike_id;
        SELECT Status INTO v_status from Bikes WHERE BikeID = p_bike_id; 
        IF v_bike_id = p_bike_id AND v_status = 'Occupied' THEN
            RAISE_APPLICATION_ERROR(-20008,'BIKE IS ALREADY OCCUPIED');
        ELSE
          -- Get daily rate from Bike table
          
           SELECT DailyRate INTO v_daily_rate FROM Bikes WHERE BikeID = p_bike_id;
        
          -- Calculate total cost using the function
           v_total_cost := CalculateRentalCost(p_rental_days, v_daily_rate);
           dbms_output.put_line('YOUR TOTAL COST IS'||v_total_cost);
          -- Insert rental record
           INSERT INTO Rentals (UserID, BikeID, RentalDate, ReturnDate, TotalCost)
           VALUES (p_user_id, p_bike_id, SYSDATE, NULL, v_total_cost);
           
          -- Update bike status
           UPDATE Bikes SET status = 'Occupied' WHERE BikeID = p_bike_id;
        
           COMMIT;
          
        END IF;
    END;
    
    --Procedure to return a bike
    PROCEDURE ReturnBike (p_bike_name VARCHAR2,p_user_name VARCHAR2)
    IS
       v_return_date DATE := SYSDATE;
       v_total_cost DECIMAL(10,2);
       v_rental_days INT;
       v_daily_rate DECIMAL(10,2);
    BEGIN
       --UPDATE RENTURNDATE FOR THE RENTAL
       UPDATE Rentals r set returndate=v_return_date WHERE 
       r.bikeid IN (SELECT BikeID FROM Bikes WHERE Bikename = p_bike_name)
       AND r.userid IN (SELECT userid FROM Users WHERE username = p_user_name)
       AND returndate IS NULL;
       
       COMMIT;
    END;       
END RENT;
--end of package RENT
/
-- Trigger to update bike status after return
CREATE OR REPLACE TRIGGER UpdateBikeStatus
AFTER UPDATE ON Rentals
FOR EACH ROW
BEGIN
 --CHECK IF THE RENTAL WAS MARKED AS RETURNED
  IF :NEW.ReturnDate IS NOT NULL 
  AND :OLD.ReturnDate IS NULL  THEN
    UPDATE Bikes SET Status = 'Available' WHERE BikeID = :NEW.BikeID;
  END IF;
END;
/