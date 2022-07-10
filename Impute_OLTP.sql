USE BikeSalesMinions
GO

BULK INSERT production.categories
FROM 'C:\deng_ca2_data\category.txt'
WITH (fieldterminator=' ', rowterminator='\n')

GO
BULK INSERT production.brands
FROM 'C:\deng_ca2_data\brand.txt'
WITH (fieldterminator=' ', rowterminator='\n')
GO
BULK INSERT sales.stores
FROM 'C:\deng_ca2_data\stores.txt'
WITH (fieldterminator='\t', rowterminator='\n')
GO
/**
INSERT INTO sales.stores VALUES ('ST1','Santa Cruz Bikes','(831) 476-4321','santacruz@bikes.shop','3700 Portola Drive','Santa Cruz','CA',95060)
INSERT INTO sales.stores VALUES ('ST2','Baldwin Bikes','(516) 379-8888','baldwin@bikes.shop','4200 Chestnut Lane','Baldwin','NY',11432)
INSERT INTO sales.stores VALUES ('ST3','Rowlett Bikes','(972) 530-5555','rowlett@bikes.shop','8000 Fairway Avenue','Rowlett','TX',75088)
**/
BULK INSERT sales.staffs
FROM 'C:\deng_ca2_data\staff.txt'
WITH (fieldterminator='\t', rowterminator='\n')
GO


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


