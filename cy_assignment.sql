
--Adventure Works Test
	--By Doug Dement

--NOTES:   	I have a mac as my personal computer so I am trying to avoid
--	       	setting up a version of windows just to install SQLServer.
--			I decided to try and use Athena + Quicksight to accomplish
--			the assigned task


--Step 1:  	Cloned the sql-server files from github
--			git clone git@github.com:stumptowndoug/sql-server-samples.git


--Step 2:  	Setup a personal S3 bucket to store the .csv files 
--			s3://doug-cy-test

--Step 3:   Find Data Dictionary for AdventureWorks
--			http://dataedo.com/samples/html/AdventureWorks/doc/AdventureWorks_2/modules/Sales_12/module.html


--Setp 4: 	Create db in Athena

----------------------------------------------------------------
--CREATE DATABSE IN ATHENA
----------------------------------------------------------------


CREATE DATABASE cy_test;


--Step 5:  Create adventureworks tables in Athena
--	       Data populated from .csv files in S3 folder


----------------------------------------------------------------
--CREATE sales_order_detail TABLE IN ATHENA
----------------------------------------------------------------


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




--Step 5:  	Create views for reporting requests
--	       	sales-rep
--			sales-management
--			part-aquisition team



----------------------------------------------------------------
--CREATE assignment_data_view VIEW IN ATHENA
----------------------------------------------------------------


CREATE OR REPLACE VIEW assignment_data_view AS
SELECT
a.salespersonid as sales_person_id,
DATE_TRUNC('MONTH',a.orderdate) AS order_date,
p.firstname||' '||p.lastname AS sales_person,
CASE
 WHEN s.salesquota IS NULL AND a.salespersonid IS NOT NULL
 THEN 250000
 ELSE s.salesquota
END as quota,
c.storeid as store_id,
ss.name as store_name,
st.name as territory_name,
a.onlineorderflag as online_flag,
CASE
 WHEN a.onlineorderflag = 1
 THEN 'Online'
 ELSE 'Reseller'
END AS sale_type,
pd.name as product_name,
SUM(sd.linetotal) as amount

FROM
sales_order_header as a
LEFT JOIN sales_order_detail sd
 ON a.salesorderid = sd.salesorderid
LEFT JOIN employee e
 ON a.salespersonid = e.businessentityid
LEFT JOIN sales_person s
 ON a.salespersonid = s.businessentityid
LEFT JOIN person p
 ON e.businessentityid = p.businessentityid
LEFT JOIN sales_territory st
 ON a.territoryid = st.territoryid
LEFT JOIN sales_customer c
 ON a.customerid = c.customerid
LEFT JOIN sales_store ss
 ON c.storeid = ss.businessentityid
LEFT JOIN product pd
 ON sd.productid = pd.productid

GROUP BY
a.salespersonid,
DATE_TRUNC('MONTH',a.orderdate),
p.firstname||' '||p.lastname,
c.storeid,
st.name,
a.onlineorderflag,
s.salesquota,
s.salesytd,
ss.name,
pd.name

