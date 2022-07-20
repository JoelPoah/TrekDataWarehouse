CREATE DATABASE BikeSalesDWMinions
GO

USE BikeSalesDWMinions
GO

CREATE TABLE Customer (
    customer_key INT IDENTITY(1,1) PRIMARY KEY, --surrogate key
    customer_id VARCHAR(10) NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    phone VARCHAR(25),
    email VARCHAR(255) NOT NULL,
    street VARCHAR(255),
    city VARCHAR(50),
    [state] VARCHAR(25),
    zip_code VARCHAR(5),
);
GO

CREATE TABLE Staff (
    staff_key INT IDENTITY(1,1) PRIMARY KEY, --surrogate key
    staff_id VARCHAR(5) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(25),
    active INT NOT NULL,
    store_id VARCHAR(5) NOT NULL,
);
GO

CREATE TABLE Store (
    store_key INT IDENTITY(1,1) PRIMARY KEY, --surrogate key
    store_id VARCHAR(5) NOT NULL,
    store_name VARCHAR(255) NOT NULL,
    phone VARCHAR(25),
    email VARCHAR(255),
    street VARCHAR(255),
    city VARCHAR(255),
    [state] VARCHAR(10),
    zip_code VARCHAR(5)
);
GO

CREATE TABLE Product (
    product_key INT IDENTITY(1,1) PRIMARY KEY, --surrogate key
    product_id VARCHAR(10) NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    brand_name VARCHAR(255) NOT NULL,  -- joined from oltp brands table
    category_name VARCHAR(255) NOT NULL, -- joined from oltp categories table
    model_year INT NOT NULL,
    quantity INT NOT NULL, -- joined from oltp stocks table
    stock_take_date DATETIME NOT NULL -- takes current date when quantity is updated
);
GO

CREATE TABLE [Time] (
    time_key INT IDENTITY(1,1) PRIMARY KEY, --surrogate key
    [time] DATE NOT NULL,
    day_of_week VARCHAR(9) NOT NULL,
    season VARCHAR(6) NOT NULL
);
GO

CREATE TABLE SalesFacts (
    customer_key INT NOT NULL FOREIGN KEY REFERENCES Customer(customer_key),
    staff_key INT NOT NULL FOREIGN KEY REFERENCES Staff(staff_key),
    store_key INT NOT NULL FOREIGN KEY REFERENCES Store(store_key),
    product_key INT NOT NULL FOREIGN KEY REFERENCES Product(product_key),
    time_key INT NOT NULL FOREIGN KEY REFERENCES [Time](time_key),
    order_status INT NOT NULL,
    order_id VARCHAR(10) NOT NULL,
    order_quantity INT NOT NULL,
    list_price DECIMAL(10, 2) NOT NULL,
    discount DECIMAL(4, 2) NOT NULL,

    PRIMARY KEY (customer_key, staff_key, store_key, product_key, time_key)
)