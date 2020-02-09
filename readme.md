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

## Step 5
Setup Athena Tables using DDL:

[Athena Table Creation SQL](https://github.com/stumptowndoug/cy_assignment/blob/master/cy_assignment.sql)

## Step 6
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

## Step 7
Exported data from Athena view.

[Export-Data-File](https://github.com/stumptowndoug/cy_assignment/blob/master/data-files/cy_assignment_data.csv)


## Assignment Question 1

```
How are sales-reps using each territory to meet their quotas (by percentage)?
```

<script src="https://public.tableau.com/views/Cy_assingment/QuotavsSales?:display_count=y&publish=yes&:origin=viz_share_link"></script>

<!DOCTYPE html>
<html>
<head>
<title>
sample web page
</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0"> <meta charset="utf-8">
</head>
<body>
<noscript>
<a href='#'><img alt='Dashboard 1 ' src='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Ex&#47;Exercise1-LobbyingSpending&#47;Dashboard1&#47;1_rss.png' style='border: none' /></a>
</noscript>
<object class="tableauViz" style="display:none;">
<param name='host_url' value='https%3A%2F%2Fpublic.tableau.com%2F' /> <param name='embed_code_version' value='3' /> <param name='site_root' value='' /><param name='name' value='Exercise1-LobbyingSpending&#47;Dashboard1' /><param name='tabs' value='no' /><param name='toolbar' value='yes' /><param name='static_image' value='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Ex&#47;Exercise1-LobbyingSpending&#47;Dashboard1&#47;1.png' /> <param name='animate_transition' value='yes' /><param name='display_static_image' value='yes' /><param name='display_spinner' value='yes' /><param name='display_overlay' value='yes' /><param name='display_count' value='yes' />
</object>

                <script type='text/javascript'>                    var divElement = document.getElementById('viz1523986136198');                    var vizElement = divElement.getElementsByTagName('object')[0];                    vizElement.style.width='1000px';vizElement.style.height='827px';                    var scriptElement = document.createElement('script');                    scriptElement.src = 'https://public.tableau.com/javascripts/api/viz_v1.js';                    vizElement.parentNode.insertBefore(scriptElement, vizElement);                

</script>
</body>
</html>









