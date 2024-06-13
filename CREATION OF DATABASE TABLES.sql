CREATION OF DATABASE TABLES 
 
1. Bank  
CREATE TABLE Bank ( 
    BankID INT PRIMARY KEY, 
    BankName VARCHAR(100) NOT NULL, 
    HeadquartersLocation VARCHAR(100) NOT NULL, 
    CEO VARCHAR(100) NOT NULL 
); 
 
 
2. Branch  
CREATE TABLE Branch ( 
    BranchID INT PRIMARY KEY, 
    BankID INT NOT NULL, 
    BranchName VARCHAR(100) NOT NULL, 
    Location VARCHAR(100) NOT NULL, 
    FOREIGN KEY (BankID) REFERENCES Bank(BankID) 
); 
 
3. Employees 
CREATE TABLE Employees ( 
    EmployeeID INT PRIMARY KEY, 
    PersonID INT NOT NULL, 
    EmployeeName VARCHAR(100) NOT NULL, 
    Position VARCHAR(100) NOT NULL, 
    Salary DECIMAL(15,2) NOT NULL, 
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID) 
); 
 
4.Manager  
CREATE TABLE Manager ( 
    ManagerID INT PRIMARY KEY, 
     
    PersonID INT NOT NULL, 
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID) 
); 
 
 
5.ATM  
CREATE TABLE ATM ( 
    ATMID INT PRIMARY KEY, 
    BranchID INT NOT NULL, 
    Location VARCHAR(100) NOT NULL, 
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID) 
); 
 
6.Vault
 
CREATE TABLE Vault ( 
    VaultID INT PRIMARY KEY, 
    BankID INT NOT NULL, 
    Capacity_status VARCHAR(50) NOT NULL, 
    FOREIGN KEY (BankID) REFERENCES Bank(BankID) 
); 
 
7.Customer  
CREATE TABLE Customer ( 
    CustomerID INT PRIMARY KEY, 
    FirstName VARCHAR(50) NOT NULL, 
    LastName VARCHAR(50) NOT NULL, 
    DateOfBirth DATE NOT NULL, 
    Balance DECIMAL(15,2) DEFAULT 0.00, 
    Email VARCHAR(100) NOT NULL 
 
 
8.Credit Card  
CREATE TABLE CreditCard ( 
    CardNumber INT PRIMARY KEY, 
    CustomerID INT NOT NULL, 
    CVV INT NOT NULL, 
    ExpiryDate DATE NOT NULL, 
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) 
); 
 
9.Loan  
CREATE TABLE Loan ( 
    LoanID INT PRIMARY KEY, 
    CustomerID INT NOT NULL, 
    Amount DECIMAL(15,2) NOT NULL, 
    InterestRate DECIMAL(5,2) NOT NULL, 
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) 
); 
 
 
10.Account  
CREATE TABLE Account ( 
    AccountNumber INT PRIMARY KEY, 
    CustomerID INT NOT NULL, 
    Balance DECIMAL(15,2) DEFAULT 0.00, 
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) 
  
11.Person  
CREATE TABLE Person ( 
    PersonID INT PRIMARY KEY, 
    FirstName VARCHAR(50) NOT NULL, 
    LastName VARCHAR(50) NOT NULL, 
    DateOfBirth DATE NOT NULL, 
    Address VARCHAR(200), 
    Phone VARCHAR(20), 
    Email VARCHAR(100) NOT NULL 
); 
 
 
12.Transactions 
CREATE TABLE Transactions ( 
    TransactionID INT PRIMARY KEY, 
    AccountNumber INT NOT NULL, 
    TransactionDate DATETIME NOT NULL, 
    Amount DECIMAL(15,2) NOT NULL, 
    TransactionType VARCHAR(50) NOT NULL, 
    FOREIGN KEY (AccountNumber) REFERENCES Account(AccountNumber) 
); 
  
13.Payment  
CREATE TABLE Payment ( 
    PaymentID INT PRIMARY KEY, 
    CustomerID INT NOT NULL, 
    PaymentDate DATETIME NOT NULL, 
    Amount DECIMAL(15,2) NOT NULL, 
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) 
); 
 
 
14.Withdrawal  
CREATE TABLE Withdrawal ( 
    WithdrawalID INT PRIMARY KEY, 
    AccountNumber INT NOT NULL, 
    WithdrawalDate DATETIME NOT NULL, 
    Amount DECIMAL(15,2) NOT NULL, 
    FOREIGN KEY (AccountNumber) REFERENCES Account(AccountNumber) 
); 
 
15.Overdraft  
CREATE TABLE Overdraft ( 
    AccountNumber INT PRIMARY KEY, 
    MaxOverdraft DECIMAL(15,2) NOT NULL, 
    FOREIGN KEY (AccountNumber) REFERENCES Account(AccountNumber) 
); 
  
 
16.Phone Number  
CREATE TABLE PhoneNumber ( 
    PhoneNumberID INT PRIMARY KEY, 
    CustomerID INT NOT NULL, 
    Phone VARCHAR(20) NOT NULL, 
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) 
);