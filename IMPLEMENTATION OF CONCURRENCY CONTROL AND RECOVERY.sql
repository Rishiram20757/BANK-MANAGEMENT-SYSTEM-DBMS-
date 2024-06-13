IMPLEMENTATION OF CONCURRENCY CONTROL AND RECOVERY 
MECHANISMS 
 
5.1 CONCURRENCY CONTROL 
5.1.1 ISOLATION AND EXCLUSIVE LOCK MECHANISMS 
 
SESSION 1: 
BEGIN 
    DECLARE 
       v_balance NUMBER; 
    BEGIN 
        SELECT Balance INTO v_balance FROM Account WHERE AccountNumber = 9001 FOR 
UPDATE NOWAIT; 
        UPDATE Account SET Balance = Balance + 50 WHERE AccountNumber = 9001; 
        DBMS_LOCK.SLEEP(10); 
        COMMIT; 
    END; 
END; 
SESSION 2: 
DECLARE 
    v_balance NUMBER; 
    v_locked BOOLEAN := TRUE; 
    v_retries INTEGER := 0;  -- Track number of lock attempt retries 
44 
  
BEGIN 
    WHILE v_locked LOOP 
        v_retries := v_retries + 1;  -- Increment retry count 
        BEGIN 
            SELECT Balance INTO v_balance FROM Account WHERE AccountNumber = 9001 
FOR UPDATE NOWAIT; 
            v_locked := FALSE; -- If no exception occurs, the lock was successful 
            DBMS_OUTPUT.PUT_LINE('Lock acquired. Continuing with the transaction...'); 
        EXCEPTION 
            WHEN OTHERS THEN 
                IF v_retries <= 3 THEN  -- Limit retries to 3 attempts 
                    DBMS_OUTPUT.PUT_LINE('Session timeout, retrying (' || v_retries || ' 
attempt(s))'); 
                    DBMS_LOCK.SLEEP(1);  -- Wait for a short duration before retrying 
                ELSE 
                    DBMS_OUTPUT.PUT_LINE('Error: Unable to acquire lock after retries. Waiting 
for Session 1 to complete...'); 
                    DBMS_LOCK.SLEEP(3);  -- Wait for Session 1 to complete 
                END IF; 
        END; 
    END LOOP; 
    UPDATE Account SET Balance = Balance - 2 WHERE AccountNumber = 9001  
    DBMS_LOCK.SLEEP(3); 
    COMMIT; 
END;/ 
 
  
5.1.2 DEADLOCK HANDLING  
 
SESSION 2: 
DECLARE 
    v_balance1 NUMBER; 
    v_balance2 NUMBER; 
BEGIN 
    SELECT Balance INTO v_balance1 FROM Account WHERE AccountNumber = 9001 FOR 
UPDATE NOWAIT; 
    DBMS_LOCK.SLEEP(10); 
    BEGIN 
        SELECT Balance INTO v_balance2 FROM Account WHERE AccountNumber = 9002 
FOR UPDATE NOWAIT; 
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Session 1: Waiting for Account 9002 to be available...'); 
            DBMS_LOCK.SLEEP(5); -- Simulate waiting for the other transaction 
    END; 
    UPDATE Account SET Balance = Balance - 100 WHERE AccountNumber = 9001; 
    COMMIT; 
END; 
SESSION 2: 
DECLARE 
    v_balance1 NUMBER; 
    v_balance2 NUMBER; 
  
BEGIN 
    SELECT Balance INTO v_balance2 FROM Account WHERE AccountNumber = 9002 FOR 
UPDATE NOWAIT; 
    DBMS_LOCK.SLEEP(10); 
    BEGIN 
        SELECT Balance INTO v_balance1 FROM Account WHERE AccountNumber = 9001 
FOR UPDATE NOWAIT; 
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Session 2: Waiting for Account 9001 to be available...'); 
            DBMS_LOCK.SLEEP(5); -- Simulate waiting for the other transaction 
    END; 
    UPDATE Account SET Balance = Balance + 100 WHERE AccountNumber = 9002; 
    COMMIT; 
END; 
5.2 RECOVERY MECHANISM  
 
QUERY  
CREATE OR REPLACE PROCEDURE InsertIntoPayment( 
    p_PaymentID INT, 
    p_CustomerID INT, 
    p_PaymentDate DATE, 
    p_Amount DECIMAL 
  
) AS 
    v_RetryLimit NUMBER := 3;  -- Maximum number of retry attempts 
    v_RetryCount NUMBER := 0;  -- Current retry attempt count 
BEGIN 
    LOOP 
        BEGIN 
            BEGIN 
                INSERT INTO Payment (PaymentID, CustomerID, PaymentDate, Amount)  
                VALUES (p_PaymentID, p_CustomerID, p_PaymentDate, p_Amount); 
                COMMIT;     
                DBMS_OUTPUT.PUT_LINE('Data inserted successfully into Payment.'); 
                EXIT;   
            END; 
        EXCEPTION 
            WHEN OTHERS THEN 
                v_RetryCount := v_RetryCount + 1;  -- Increment retry count 
                ROLLBACK 
                DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM) 
                IF v_RetryCount >= v_RetryLimit THEN 
                    DBMS_OUTPUT.PUT_LINE('Maximum retry limit reached. Exiting...'); 
                    EXIT;  -- Exit loop if retry limit reached 
                ELSE 
                    DBMS_OUTPUT.PUT_LINE('Please provide new input values:'); 
                    -- Example: p_PaymentID := <new value>; 
                    --           p_CustomerID := <new value>; 
                    --           p_PaymentDate := <new value>; 
                    --           p_Amount := <new value>; 
                END IF; 
        END; 
    END LOOP; 
END; 