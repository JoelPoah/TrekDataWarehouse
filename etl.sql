-- ETL Script

-- Product Dimension
-- query has issues
INSERT INTO BikeSalesDWMinions..Product(product_id, product_name, brand_name, category_name, model_year, quantity, stock_take_date)
SELECT s.product_id, p.product_name, REPLACE(b.brand_name, ' ', '') 'brand_name', 
	c.category_name, p.model_year,  SUM(s.quantity) 'quantity', GETDATE() 'stock-date'
FROM Production.products AS p, Production.categories AS c, Production.brands as b, Production.stocks as s
GROUP BY s.product_id, p.product_name;

-- table join stocks with other tables
SELECT s.product_id, p.product_name,SUM(s.quantity) as 'Total'
FROM Production.stocks AS s,Production.products as p
where p.product_id= s.product_id
GROUP BY s.product_id,p.product_name;


-- Staff Dimension
INSERT INTO Staff
SELECT s.staff_id, s.first_name, s.last_name, 
    s.email, s.phone, s.active, st.store_id
FROM Sales.staffs AS s, Sales.stores AS st;

-- Store Dimension
INSERT INTO Store
SELECT st.store_id, st.store_name, st.phone, st.email, 
    st.street, st.city, st.state, st.zip_code
FROM Sales.stores AS st;

-- Customer Dimension
INSERT INTO Customer
SELECT c.customer_id, c.first_name, c.last_name, c.phone, 
    c.email, c.street, c.city, c.state, c.zip_code
FROM Sales.customer AS c;

