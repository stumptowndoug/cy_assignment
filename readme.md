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
----------------------------------------------------------------
--CREATE sales_order_detail TABLE IN ATHENA
----------------------------------------------------------------


CREATE EXTERNAL TABLE IF NOT EXISTS sales_order_detail (
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


----------------------------------------------------------------
--CREATE sales_order_header TABLE IN ATHENA
----------------------------------------------------------------


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


----------------------------------------------------------------
--CREATE sales_territory TABLE IN ATHENA
----------------------------------------------------------------


CREATE EXTERNAL TABLE IF NOT EXISTS sales_territory (
TerritoryID INT,
Name STRING,
CountryRegionCode STRING,
group STRING,
SalesYTD DECIMAL,
SalesLastYear DECIMAL,
CostYTD DECIMAL,
CostLastYear DECIMAL,
rowguid STRING,
ModifiedDate TIMESTAMP
)

 ROW FORMAT DELIMITED
  FIELDS TERMINATED BY '\t'
  ESCAPED BY '\\'
  LINES TERMINATED BY '\n' 
LOCATION 's3://doug-cy-test/salesterritory';


----------------------------------------------------------------
--CREATE employee TABLE IN ATHENA
----------------------------------------------------------------


CREATE EXTERNAL TABLE IF NOT EXISTS employee (
BusinessEntityID INT,
NationalIDNumber STRING,
LoginID STRING,    
Org STRING,
OrganizationLevel INT,
JobTitle STRING,
BirthDate DATE,
MaritalStatus STRING,
Gender STRING,
HireDate DATE,
SalariedFlag INT,
VacationHours INT,
SickLeaveHours INT,
CurrentFlag INT,
rowguid STRING,
ModifiedDate TIMESTAMP
)

 ROW FORMAT DELIMITED
  FIELDS TERMINATED BY '\t'
  ESCAPED BY '\\'
  LINES TERMINATED BY '\n' 
LOCATION 's3://doug-cy-test/employee';


----------------------------------------------------------------
--CREATE person TABLE IN ATHENA
----------------------------------------------------------------


CREATE EXTERNAL TABLE IF NOT EXISTS person (
NameStyle INT,
Title STRING,
FirstName STRING,
MiddleName STRING,
LastName STRING,
Suffix STRING,
EmailPromotion INT,
AdditionalContactInfo STRING,
Demographics STRING,
rowguid STRING,
ModifiedDate TIMESTAMP
)

 ROW FORMAT DELIMITED
  FIELDS TERMINATED BY '\t'
  ESCAPED BY '\\'
  LINES TERMINATED BY '\n' 
LOCATION 's3://doug-cy-test/person';

----------------------------------------------------------------
--CREATE sales_store TABLE IN ATHENA
----------------------------------------------------------------


CREATE EXTERNAL TABLE IF NOT EXISTS sales_store (
BusinessEntityID INT,
Name STRING,
SalesPersonID INT,
Demographics STRING,
rowguid STRING,
ModifiedDate TIMESTAMP
)

 ROW FORMAT DELIMITED
  FIELDS TERMINATED BY '\t'
  ESCAPED BY '\\'
  LINES TERMINATED BY '\n' 
LOCATION 's3://doug-cy-test/store';

----------------------------------------------------------------
--CREATE sales_customer TABLE IN ATHENA
----------------------------------------------------------------

CREATE EXTERNAL TABLE IF NOT EXISTS sales_customer (
CustomerID INT,
PersonID INT,
StoreID INT,
TerritoryID INT,
AccountNumber STRING,
rowguid STRING,
ModifiedDate TIMESTAMP
)

 ROW FORMAT DELIMITED
  FIELDS TERMINATED BY '\t'
  ESCAPED BY '\\'
  LINES TERMINATED BY '\n' 
LOCATION 's3://doug-cy-test/customer';


----------------------------------------------------------------
--CREATE sales_customer TABLE IN ATHENA
----------------------------------------------------------------


CREATE EXTERNAL TABLE IF NOT EXISTS product (
ProductID INT,
Name STRING,
ProductNumber STRING,
MakeFlag INT,
FinishedGoodsFlag INT,
Color STRING,
SafetyStockLevel INT,
ReorderPoint INT,
StandardCost DECIMAL,
ListPrice DECIMAL,
Size STRING,
SizeUnitMeasureCode STRING,
WeightUnitMeasureCode STRING,
Weight DECIMAL,
DaysToManufacture INT,
ProductLine STRING,
Class STRING,
Style STRING,
ProductSubcategoryID INT,
ProductModelID INT,
SellStartDate TIMESTAMP,
SellEndDate TIMESTAMP,
DiscontinuedDate TIMESTAMP,
rowguid STRING,
ModifiedDate TIMESTAMP
)

 ROW FORMAT DELIMITED
  FIELDS TERMINATED BY '\t'
  ESCAPED BY '\\'
  LINES TERMINATED BY '\n' 
LOCATION 's3://doug-cy-test/product';
```


