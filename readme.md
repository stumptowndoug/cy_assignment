# AdventureWorks Assignment

## Notes
I have a mac as my personal computer so I wanted to avoide setting up a new version of windows just to install SQLServer. I also wanted to avoid spinning up a whole new RDS server just to get the AdventureWorks data. Instead, I decided to setup an Athena database using S3 as the staging ground for the AdventureWorks data.


## Step 1
Cloned the git repository from SQLServer and found the correct .csv files to import into Athena

```
git clone git@github.com:stumptowndoug/sql-server-samples.git
```

## Step 2
Setup a personal S3 bucket to store the .csv files 


## Step 3
I found a helpful data dictionary for AdventureWorks:

[AdventureWorks Data Dictionary](http://dataedo.com/samples/html/AdventureWorks/doc/AdventureWorks_2/modules/Sales_12/module.html "Dataedo AdventureWorks Data Dictionary")

## Step 4
Created Athena Database

```
CREATE DATABASE cy_test;
```

## Setp 5
Setup Athena Tables using DDL

```
CREATE EXTERNAL TABLE IF NOT EXISTS SalesOrderDetail (
SalesOrderID INT,
SalesOrderDetailID INT,
CarrierTrackingNumber STRING,
OrderQty INT,
ProductID INT,
SpecialOfferID INT,
UnitPrice DECIMAL,
UnitPriceDiscount DECIMAL,
LineTotal DECIMAL,
rowguid STRING,
ModifiedDate TIMESTAMP
  ) 

 ROW FORMAT DELIMITED
  FIELDS TERMINATED BY '\t'
  ESCAPED BY '\\'
  LINES TERMINATED BY '\n' 
LOCATION 's3://doug-cy-test/salesorderdetail';
```

```
CREATE EXTERNAL TABLE IF NOT EXISTS sales_order_header (
    SalesOrderID INT,
    RevisionNumber INT,
    OrderDate TIMESTAMP,
    DueDate TIMESTAMP,
    ShipDate TIMESTAMP,
    Status INT,
    OnlineOrderFlag INT,
    SalesOrderNumber STRING,
    PurchaseOrderNumber STRING,
    AccountNumber STRING,
    CustomerID INT,
    SalesPersonID INT,
    TerritoryID INT,
    BillToAddressID INT,
    ShipToAddressID INT,
    ShipMethodID INT,
    CreditCardID INT,
    CreditCardApprovalCode STRING,
    CurrencyRateID INT,
    SubTotal DECIMAL,
    TaxAmt DECIMAL,
    Freight DECIMAL,
    TotalDue DECIMAL,
    Comment1 STRING,
    rowguid STRING,
    ModifiedDate TIMESTAMP
  ) 

 ROW FORMAT DELIMITED
  FIELDS TERMINATED BY '\t'
  ESCAPED BY '\\'
  LINES TERMINATED BY '\n' 
LOCATION 's3://doug-cy-test/salesorderheader';
```

```
----------------------------------------------------------------
--CREATE sales_person TABLE IN ATHENA
----------------------------------------------------------------


CREATE EXTERNAL TABLE IF NOT EXISTS sales_person (
BusinessEntityID INT,
TerritoryID INT,
SalesQuota DECIMAL,
Bonus DECIMAL,
CommissionPct DECIMAL,
SalesYTD DECIMAL,
SalesLastYear DECIMAL,
rowguid STRING,
ModifiedDate TIMESTAMP
) 

 ROW FORMAT DELIMITED
  FIELDS TERMINATED BY '\t'
  ESCAPED BY '\\'
  LINES TERMINATED BY '\n' 
LOCATION 's3://doug-cy-test/salesperson';
```
