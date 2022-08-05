-- Run the commented code below if you want to drop the OLTP db
/**
use master
Alter Database BikeSalesMinions
SET SINGLE_USER 
WITH ROLLBACK IMMEDIATE 
DROP DATABASE BikeSalesMinions
**/

CREATE DATABASE BikeSalesMinions
GO 

Use BikeSalesMinions
GO

CREATE SCHEMA Sales -- create schema sales to contain sales tables 
GO

CREATE SCHEMA Production -- create schema production to contain production tables
GO

/**
Changes that did not exist the original script in Appendix 1 will be commented
**/

CREATE TABLE Sales.stores ( -- Table 1: stores
    store_id VARCHAR(5) PRIMARY KEY,
    store_name VARCHAR(255) NOT NULL,
    phone VARCHAR(25),
    email VARCHAR(255),
    street VARCHAR(255),
    city VARCHAR(255),
    [state] VARCHAR(10),
    zip_code VARCHAR(5)
);


CREATE TABLE Sales.staffs ( -- Table 2: staffs
    staff_id VARCHAR(5) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(25),
    active INT NOT NULL,
    store_id VARCHAR(5) NOT NULL,
    manager_id VARCHAR(5) NULL, -- Added default NULL

    FOREIGN KEY (store_id) REFERENCES Sales.stores(store_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (manager_id) REFERENCES Sales.staffs(staff_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);


CREATE TABLE Production.categories ( -- Table 3: categories
    category_id VARCHAR(5) PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL
);


CREATE TABLE Production.brands ( -- Table 4: brands
    brand_id VARCHAR(5) PRIMARY KEY,
    brand_name VARCHAR(255) NOT NULL
);


CREATE TABLE Production.products ( -- Table 5: products
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    brand_id VARCHAR(5) NOT NULL,
    category_id VARCHAR(5) NOT NULL,
    model_year INT NOT NULL,
    list_price DECIMAL(10, 2) NOT NULL,

    FOREIGN KEY (category_id) REFERENCES Production.categories(category_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (brand_id) REFERENCES Production.brands(brand_id)
        -- Original script referenced wrong schema 'Sales.brands'
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


CREATE TABLE Sales.customers ( -- Table 6: customers
    customer_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    phone VARCHAR(25),
    email VARCHAR(255) NOT NULL,
    street VARCHAR(255),
    city VARCHAR(50),
    [state] VARCHAR(25),
    zip_code VARCHAR(5)
);


CREATE TABLE Sales.orders ( -- Table 7: orders
    order_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10),
    order_status INT NOT NULL,
    -- Order status: 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
    -- dates will be in string, will be converted to date dtype during ETL
    order_date VARCHAR(10) NOT NULL,
    required_date VARCHAR(10) NOT NULL,
    shipped_date VARCHAR(10),
    -- Inconsistent datatype, changed INT to VARCHAR(5) for store_id and staff_id
    store_id VARCHAR(5) NOT NULL,
    staff_id VARCHAR(5) NOT NULL,

    FOREIGN KEY (customer_id) REFERENCES Sales.customers (customer_id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,

    FOREIGN KEY (store_id) REFERENCES Sales.stores (store_id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,

    FOREIGN KEY (staff_id) REFERENCES Sales.staffs (staff_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);




CREATE TABLE Sales.order_items( -- Table 8: order_items
    order_id VARCHAR(10),
    item_id INT,
    product_id VARCHAR(10) NOT NULL,
    quantity INT NOT NULL,
    list_price DECIMAL(10, 2) NOT NULL,
    discount DECIMAL(4, 2) NOT NULL DEFAULT 0,
    PRIMARY KEY (order_id, item_id),

    FOREIGN KEY (order_id) REFERENCES Sales.orders (order_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (product_id) REFERENCES Production.products (product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


CREATE TABLE Production.stocks ( -- Table 9: stocks
    store_id VARCHAR(5),
    product_id VARCHAR(10),
    quantity INT,
    PRIMARY KEY (store_id, product_id),

    FOREIGN KEY (store_id) REFERENCES Sales.stores (store_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (product_id) REFERENCES Production.products (product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);