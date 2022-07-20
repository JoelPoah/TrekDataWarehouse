-- ETL Script

-- Product Dimension
INSERT INTO Product
SELECT p.product_id, p.product_name, c.category_name, 
    p.model_year, b.brand_name, s.quantity, GETDATE() 'Stock Take Date'
FROM Production.products AS p, Production.categories AS c, Production.brands as b, Production.stocks as s;

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

