USE BikeSalesMinions
GO

-- category.txt
BULK INSERT production.categories
FROM 'C:\deng_ca2_data\category.txt'
WITH (fieldterminator=' ', rowterminator='\n')
GO

-- brand.txt
BULK INSERT production.brands
FROM 'C:\deng_ca2_data\brand.txt'
WITH (fieldterminator=' ', rowterminator='\n')
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

-- customers.csv

-- orderitems.csv

-- orders.csv

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


