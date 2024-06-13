
 CONSTRAINTS 
3.1.1 Employee Table 
 ALTER TABLE Employees 
ADD CONSTRAINT Employees_Salary_Check 
CHECK (Salary >= 0.00); 
            
3.1.2 Customer Table 
ALTER TABLE Customer 
ADD CONSTRAINT ck_Employees_Email 
CHECK (REGEXP_LIKE(Email, '^[a-zA-Z0-9]{4}@gmail\.com$')) 
ENABLE NOVALIDATE; 
 
3.1.3 Bank Table 
ALTER TABLE Bank ADD CONSTRAINT ck_bank_name  
CHECK (LENGTH(BankName) >= 3); 

 
3.1.4 Branch Table 
ALTER TABLE Branch ADD CONSTRAINT ck_branch_name  
CHECK (LENGTH(BranchName) >= 3); 
 
3.1.3 Employee Table 
ALTER TABLE Employees ADD CONSTRAINT ck_employee_name  
CHECK (LENGTH(EmployeeName) >= 3); 

3.1.3 Customer Table 
ALTER TABLE Customer ADD CONSTRAINT ck_customer_name  
CHECK (LENGTH(FirstName) >= 2 AND LENGTH(LastName) >= 2);