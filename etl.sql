-- ETL Script
USE BikeSalesMinions
GO

-- Product Dimension working query (have not added insert into dw)
SELECT p.product_id, p.product_name, p.brand_id, p.category_id, p.model_year, ISNULL(s.[Stock Quantity], 0) 'Stock Quantity'
FROM Production.products AS p
LEFT JOIN (
	SELECT product_id, SUM(quantity) 'Stock Quantity' FROM Production.stocks
	GROUP BY product_id
) AS s
ON p.product_id = s.product_id


-- working etl queries

-- Staff Dimension
INSERT INTO BikeSalesDWMinions..Staff
SELECT s.staff_id, s.first_name, s.last_name, 
    s.email, s.phone, s.active, s.store_id
FROM Sales.staffs AS s;

-- Store Dimension
INSERT INTO BikeSalesDWMinions..Store
SELECT st.store_id, st.store_name, st.phone, st.email, 
    st.street, st.city, st.state, st.zip_code
FROM Sales.stores AS st;

-- Customer Dimension
INSERT INTO BikeSalesDWMinions..Customer
SELECT c.customer_id, c.first_name, c.last_name, c.phone, 
    c.email, c.street, c.city, c.state, c.zip_code
FROM Sales.customers AS c;
