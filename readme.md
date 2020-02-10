# AdventureWorks Assignment

## Notes
I have a mac as my personal computer so I wanted to avoide setting up a new version of windows just to install SQLServer. I also wanted to avoid spinning up a whole new RDS server just to get the AdventureWorks data. Instead, I decided to setup an Athena database using S3 as the staging ground for the AdventureWorks data.


### Step 1
Cloned the git repository from SQLServer and found the correct .csv files to import into Athena

```
git clone -n https://github.com/Microsoft/sql-server-samples
```

### Step 2
Setup a personal S3 bucket to store the .csv files 


### Step 3
I found a helpful data dictionary for AdventureWorks:

[AdventureWorks Data Dictionary](http://dataedo.com/samples/html/AdventureWorks/doc/AdventureWorks_2/modules/Sales_12/module.html "Dataedo AdventureWorks Data Dictionary")

### Step 4
Created Athena Database

```
CREATE DATABASE cy_assignment;
```

### Step 5
Setup Athena Tables using DDL:

[Athena Table Creation SQL](https://github.com/stumptowndoug/cy_assignment/blob/master/cy_assignment.sql)

### Step 6
Setup view in Athena for necessary reporting requests

```SQL
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
```

### Step 7
Exported data from Athena view.

[Export-Data-File](https://github.com/stumptowndoug/cy_assignment/blob/master/data-files/cy_assignment_data.csv)


# Assignment Questions 

## Question 1: How are sales-reps using each territory to meet their quotas (by percentage)?


In this view I wanted to specifically show how reps were doing against quota. All sales people for the exception of 3 are well beyond quota YTD.


![Sales-vs-Quota](https://cy-assignment.s3-us-west-2.amazonaws.com/Quota+vs+Sales.png)


This is a view of each sales person and the distribution of sales YTD by territory.

![Sales-by-Territory](https://cy-assignment.s3-us-west-2.amazonaws.com/Sales+by+Territory.png)


## Question 2: In which territories are internet sales out-pacing reseller sales (and by how much)?


The following visualization shows the difference in amount between Onlines vs Reseller sales. Australia and Germany being the two territories with more online sales.


![Sales-by-Territory](https://cy-assignment.s3-us-west-2.amazonaws.com/Internet+vs+Reseller+Var.png)


## Question 2: Create a report that shows all sales by territory, with drill-downs into orders by store and the top-selling reps at each store; the target audience for this report is the AdventureWorks sales-management team.








