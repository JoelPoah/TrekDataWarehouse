USE BikeSalesMinions
GO

BULK INSERT production.categories
FROM 'C:\Users\LG\OneDrive - Singapore Polytechnic\Desktop\DENG\CA2\category.txt'
WITH (fieldterminator='\t', rowterminator='\n')

GO
BULK INSERT production.brands
FROM 'C:\Users\LG\OneDrive - Singapore Polytechnic\Desktop\DENG\CA2\brand.txt'
WITH (fieldterminator='\t', rowterminator='\n')
GO

Use BikeSalesMinions
Declare @Products varchar(max)
Select @Products =
BulkColumn
from OPENROWSET(BULK 'C:\Users\LG\OneDrive - Singapore Polytechnic\Desktop\DENG\CA2\products.json', SINGLE_BLOB) JSON
Insert into production.products
Select * From OpenJSON(@Products, '$')
with (
product_id varchar(10) '$.product_id',
product_name VARCHAR (255) '$.product_name',
brand_id varchar(5) '$.brand_id',
category_id varchar(5) '$.category_id',
model_year int '$.model_year',
list_price DECIMAL (10, 2) '$.list_price')


