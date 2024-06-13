TRIGGERS  
 
 
 
 
3.5.1 VAULT 
create TRIGGER "ADMIN"."LOG_VAULT_CHANGES"  
AFTER INSERT OR UPDATE ON Vault 
FOR EACH ROW 
DECLARE 
    v_action VARCHAR2(10); 
    v_capacity NUMBER(15, 2);   
BEGIN 
    IF INSERTING THEN 
        v_action := 'INSERT'; 

  
    ELSIF UPDATING THEN 
        v_action := 'UPDATE'; 
    END IF; 
    SELECT SUM(CAPACITY_STATUS) INTO v_capacity FROM VAULT WHERE BANKID 
= :NEW.BANKID; 
    IF v_capacity > 50000000 THEN 
        DBMS_OUTPUT.PUT_LINE('Maximum capacity reached for BankID: ' || 
:NEW.BANKID); 
    END IF; 
    DBMS_OUTPUT.PUT_LINE('VaultID: ' || :NEW.VaultID || ', BankID: ' || :NEW.BankID || ', 
Capacity_status: ' || :NEW.Capacity_status || ', Action: ' || v_action || ', Timestamp: ' || 
TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS')); 
END; 

3.5.2 CREDIT CARD 
create or replace TRIGGER CREDIT_CARD_CONSTRAINTS_TRIGGER 
BEFORE INSERT OR UPDATE ON CREDITCARD 
FOR EACH ROW 
DECLARE 
    V_CURRENT_DATE DATE; 
BEGIN 
    IF LENGTH(:NEW.CARDNUMBER) > 16 THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Card number cannot exceed 16 digits.'); 
    END IF; 
  
    SELECT SYSTIMESTAMP INTO V_CURRENT_DATE FROM DUAL; 
    IF :NEW.EXPIRYDATE <= V_CURRENT_DATE THEN 
        RAISE_APPLICATION_ERROR(-20002, 'Expiry date must be in the future.'); 
    END IF; 
END; 
/ 

  
3.5.3 PHONENUMBER 
CREATE OR REPLACE EDITIONABLE TRIGGER 
"ADMIN"."LOG_PHONENUMBER_CHANGES"  
BEFORE INSERT OR UPDATE OF PHONE ON PhoneNumber 
FOR EACH ROW 
DECLARE 
    v_action VARCHAR2(10); 
BEGIN 
    IF INSERTING THEN 
        v_action := 'INSERT'; 
    ELSIF UPDATING THEN 
        v_action := 'UPDATE'; 
    ELSE 
        v_action := 'DELETE'; 
    END IF; 
    IF LENGTH(:NEW.Phone) > 10 THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Phone number cannot exceed 10 digits.'); 
    END IF; 
    DBMS_OUTPUT.PUT_LINE('PhoneNumberID: ' || :NEW.PhoneNumberID || ', CustomerID: 
' || :NEW.CustomerID || ', Phone: ' || :NEW.Phone || ', Action: ' || v_action || ', Timestamp: ' || 
TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS')); 
END; 
/ 
ALTER TRIGGER "ADMIN"."LOG_PHONENUMBER_CHANGES" ENABLE; 

  
3.5.4 ATM 
CREATE OR REPLACE EDITIONABLE TRIGGER "ADMIN"."LOG_ATM_CHANGES"  
BEFORE INSERT OR UPDATE OF ATMID ON ATM 
FOR EACH ROW 
DECLARE 
    v_action VARCHAR2(10); 
BEGIN 
    IF INSERTING THEN 
        v_action := 'INSERT'; 
    ELSIF UPDATING THEN 
        v_action := 'UPDATE'; 
    ELSE 
        v_action := 'DELETE'; 
    END IF; 
    IF LENGTH(TO_CHAR(:NEW.ATMID)) <> 3 THEN 
        RAISE_APPLICATION_ERROR(-20001, 'ATMID must be 3 digits.'); 
    END IF; 

  
    DBMS_OUTPUT.PUT_LINE('ATMID: ' || :NEW.ATMID || ', BranchID: ' || :NEW.BranchID 
|| ', Location: ' || :NEW.Location || ', Action: ' || v_action || ', Timestamp: ' || 
TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS')); 
END; 
/ 
ALTER TRIGGER "ADMIN"."LOG_ATM_CHANGES" ENABLE; 

 
3.5.5 BANK 
CREATE OR REPLACE TRIGGER enforce_bankid_range 
BEFORE INSERT OR UPDATE ON Bank 
FOR EACH ROW 
DECLARE 
    v_bank_id NUMBER; 
BEGIN 
    v_bank_id := TO_NUMBER(:NEW.BankID); 
    IF v_bank_id < 100 OR v_bank_id > 300 THEN 
        RAISE_APPLICATION_ERROR(-20001, 'BankID must be between 100 and 300'); 
    END IF; 
END; 
/ 

  
3.5.6 BRANCH 
CREATE OR REPLACE TRIGGER enforce_location_not_empty 
BEFORE INSERT OR UPDATE ON Branch 
FOR EACH ROW 
BEGIN 
    IF :NEW.Location IS NULL OR TRIM(:NEW.Location) = '' THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Location cannot be empty'); 
    END IF; 
END; 
/ 

 
3.5.7 EMPLOYEES 
CREATE OR REPLACE TRIGGER enforce_unique_employee_name 
BEFORE INSERT OR UPDATE ON Employees 
FOR EACH ROW 
DECLARE 
    v_count NUMBER; 
BEGIN 
    SELECT COUNT(*) 
    INTO v_count 
    FROM Employees 
    WHERE UPPER(EmployeeName) = UPPER(:NEW.EmployeeName) 
      AND (:NEW.EmployeeID IS NULL OR EmployeeID != :NEW.EmployeeID); 
    IF v_count > 0 THEN 
        RAISE_APPLICATION_ERROR(-20001, 'EmployeeName must be unique'); 
    END IF; 

END; 
/ 

3.5.8 MANAGER 
CREATE OR REPLACE TRIGGER enforce_manager_experience 
BEFORE INSERT ON Manager 
FOR EACH ROW 
DECLARE 
v_years_of_experience NUMBER; 
BEGIN -- Calculate the years of experience based on the provided value 
v_years_of_experience := :NEW.YearsOfExperience; -- Check if the manager has less than 5 years of experience 
IF v_years_of_experience < 5 THEN 
RAISE_APPLICATION_ERROR(-20001, 'Manager must have at least 5 years of 
experience'); 
END IF; 
END; 
/ 

CREATE OR REPLACE TRIGGER enforce_customer_id_length 
BEFORE INSERT OR UPDATE ON Customer 
23 
3.5.9 CUSTOMER 
  
FOR EACH ROW 
BEGIN 
    -- Check if the length of CustomerID is not equal to 3 digits 
    IF LENGTH(:NEW.CustomerID) != 3 THEN 
        RAISE_APPLICATION_ERROR(-20001, 'CustomerID must be 3 digits'); 
    END IF; 
END; 
/ 

 
3.5.10 LOAN TABLE 
CREATE OR REPLACE TRIGGER enforce_positive_loan_amount 
BEFORE INSERT OR UPDATE ON Loan 
FOR EACH ROW 
BEGIN 
    -- Check if the amount of the loan is negative 
    IF :NEW.Amount < 0 THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Loan amount cannot be negative'); 
    END IF; 
END; 
/ 

 
 
 

  
3.5.11 ACCOUNT  
ALTER TABLE Account ADD AccountStatus VARCHAR2(20); 
CREATE OR REPLACE TRIGGER update_account_status 
BEFORE INSERT OR UPDATE OF Balance ON Account 
FOR EACH ROW 
BEGIN 
    IF :NEW.Balance >= 0 THEN 
        :NEW.AccountStatus := 'Active'; 
    ELSE 
        :NEW.AccountStatus := 'Inactive'; 
    END IF; 
END; 
/ 
UPDATE Account 
SET AccountStatus = CASE 
                        WHEN Balance > 0 THEN 'Active' 
                        ELSE 'Inactive' 
                    END; 

 
 
3.5.12 PERSON 
Calculating Age Trigger: 
ALTER TABLE Person ADD Age NUMBER; 
CREATE OR REPLACE TRIGGER update_age_on_insert 
BEFORE INSERT ON Person 
FOR EACH ROW 
BEGIN 

  
    :NEW.Age := FLOOR(MONTHS_BETWEEN(SYSDATE, :NEW.DateOfBirth) / 12); 
END; 
/ 
CREATE OR REPLACE TRIGGER update_age_on_update 
BEFORE UPDATE ON Person 
FOR EACH ROW 
BEGIN 
    :NEW.Age := FLOOR(MONTHS_BETWEEN(SYSDATE, :NEW.DateOfBirth) / 12); 
END; 
/ 
UPDATE Person SET Age = FLOOR(MONTHS_BETWEEN(SYSDATE, DateOfBirth) / 12); 
 
Invalid Age Trigger: 
CREATE OR REPLACE TRIGGER enforce_minimum_age 
BEFORE INSERT OR UPDATE ON Person 
FOR EACH ROW 
DECLARE 
    v_age NUMBER; 
BEGIN 
    -- Calculate the age based on DateOfBirth 
    v_age := FLOOR(MONTHS_BETWEEN(SYSDATE, :NEW.DateOfBirth) / 12); 
    -- Check if the person is at least 18 years old 
    IF v_age < 18 THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Person must be at least 18 years old'); 
    END IF; 
END; 
/ 
3.5.13 TRANSACTIONS 
CREATE OR REPLACE TRIGGER enforce_transaction_amount_range 
BEFORE INSERT OR UPDATE ON Transactions 

  
FOR EACH ROW 
DECLARE 
BEGIN 
    IF :NEW.Amount < 0 THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Transaction amount cannot be negative'); 
    ELSIF :NEW.Amount > 10000 THEN 
        RAISE_APPLICATION_ERROR(-20002, 'Transaction amount cannot exceed $10,000'); 
    END IF; 
END; 
/ 

 
3.5.14 PAYMENT 
CREATE OR REPLACE TRIGGER enforce_positive_payment_amount 
BEFORE INSERT OR UPDATE ON Payment 
FOR EACH ROW 
BEGIN 
    IF :NEW.Amount < 0 THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Payment amount cannot be negative'); 
    END IF; 
END; 
/ 
3.5.15 WITHDRAWAL 
CREATE OR REPLACE TRIGGER check_withdrawal_amount 
BEFORE INSERT ON Withdrawal 
FOR EACH ROW 
DECLARE 
    v_current_balance NUMBER; 

  
BEGIN 
    SELECT Balance INTO v_current_balance 
    FROM Account 
    WHERE AccountNumber = :NEW.AccountNumber; 
    IF (:NEW.Amount > v_current_balance) THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Withdrawal amount exceeds account balance'); 
    END IF; 
END; 
/ 

 
3.5.16 OVERDRAFT 
CREATE OR REPLACE TRIGGER enforce_positive_overdraft 
BEFORE INSERT OR UPDATE ON Overdraft 
FOR EACH ROW 
BEGIN 
    IF :NEW.MaxOverdraft < 0 THEN 
        RAISE_APPLICATION_ERROR(-20001, 'MaxOverdraft cannot be negative'); 
    END IF; 
END; 
/ 
