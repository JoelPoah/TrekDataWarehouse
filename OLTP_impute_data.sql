USE BikeSalesMinions
GO

-- category.txt
BULK INSERT production.categories
FROM 'C:\deng_ca2_data\category.txt'
WITH (fieldterminator='\t', rowterminator='\n')
GO

-- brand.txt
BULK INSERT production.brands
FROM 'C:\deng_ca2_data\brand.txt'
WITH (fieldterminator='\t', rowterminator='\n')
GO

-- stores.txt
BULK INSERT sales.stores
FROM 'C:\deng_ca2_data\stores.txt'
WITH (fieldterminator='\t', rowterminator='\n')
GO

-- staff.txt
BULK INSERT sales.staffs
FROM 'C:\deng_ca2_data\staff.txt'
WITH (fieldterminator='\t', rowterminator='\n')
GO

-- stocks.csv
BULK INSERT production.stocks
FROM 'C:\deng_ca2_data\Stocks.csv'
WITH (FIRSTROW = 2,fieldterminator=',', rowterminator='\n')
GO
-- customers.csv
BULK INSERT sales.customers
FROM 'C:\deng_ca2_data\customers.csv'
WITH (
	FIRSTROW = 2, -- 1st row is header
	FIELDTERMINATOR = ',', -- csv field delimiter
	ROWTERMINATOR = '\n'
)
UPDATE sales.customers SET phone = NULLIF(phone,'NULL') -- changed NULL from string value to actual NULL value
FROM sales.customers;
GO
-- orderitems.csv
BULK INSERT sales.order_items
FROM 'C:\deng_ca2_data\OrderItems.csv'
WITH (FIRSTROW = 2,fieldterminator=',', rowterminator='\n')
GO

-- orders.csv
-- data type in create table is varchar for date attributes
BULK INSERT sales.orders    
FROM 'C:\deng_ca2_data\Orders.csv'
WITH (FIRSTROW = 2,fieldterminator=',', rowterminator='\n')
UPDATE sales.orders SET order_date = NULLIF(order_date,'NULL') -- changed NULL from string value to actual NULL value
UPDATE sales.orders SET required_date = NULLIF(required_date,'NULL') -- changed NULL from string value to actual NULL value
UPDATE sales.orders SET shipped_date = NULLIF(shipped_date,'NULL') -- changed NULL from string value to actual NULL value
FROM sales.orders;
GO
GO

-- products.json
Declare @Products varchar(max)
Select @Products =
BulkColumn
from OPENROWSET(BULK 'C:\deng_ca2_data\products.json', SINGLE_BLOB) JSON
Insert into production.products
Select * From OpenJSON(@Products, '$')
with (
product_id varchar(10) '$.product_id',
product_name VARCHAR (255) '$.product_name',
brand_id varchar(5) '$.brand_id',
category_id varchar(5) '$.category_id',
model_year int '$.model_year',
list_price DECIMAL (10, 2) '$.list_price')


