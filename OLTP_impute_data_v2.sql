/**
Author: Jun Jie

Re-doing the integration of various data files into the OLTP database, while solving the problems that may come up during
the process

Documentation can be found in the discord group chat
**/


-- customers.csv (1445 rows, NULL values: phone attibute)
BULK INSERT sales.customers
FROM 'C:\deng_ca2_data\customers.csv'
WITH (
	FIRSTROW = 2, -- 1st row is header
	FIELDTERMINATOR = ',', -- csv field delimiter
	ROWTERMINATOR = '\n'
)
UPDATE sales.customers SET phone = NULLIF(phone,'NULL') -- changed NULL from string value to actual NULL value
FROM sales.customers;


-- stores.txt
BULK INSERT sales.stores 
FROM 'c:\deng_ca2_data\stores.txt'
WITH (
    ROWTERMINATOR ='\t'
)
