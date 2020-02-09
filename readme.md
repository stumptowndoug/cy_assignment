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





