-- ETL Script
USE BikeSalesMinions
GO


-- Product Dimension working query (have not added insert into dw)
INSERT INTO BikeSalesDWMinions..Product
SELECT p.product_id, p.product_name, p.brand_id, p.category_id, p.model_year, 
ISNULL(s.[Stock Quantity], 0) 'Stock Quantity',
 CAST(GETDATE() AS Date) 'Stock Take Date'
FROM Production.products AS p
LEFT JOIN (
	SELECT product_id, SUM(quantity) 'Stock Quantity' FROM Production.stocks
	GROUP BY product_id
) AS s ON p.product_id = s.product_id
INNER JOIN Production.brands b ON p.brand_id = b.brand_id
INNER JOIN Production.categories c ON p.category_id = c.category_id
GO


-- Staff Dimension
INSERT INTO BikeSalesDWMinions..Staff
SELECT s.staff_id, s.first_name, s.last_name, 
    s.email, s.phone, s.active, s.store_id
FROM Sales.staffs AS s;
GO

-- Store Dimension
INSERT INTO BikeSalesDWMinions..Store
SELECT st.store_id, st.store_name, st.phone, st.email, 
    st.street, st.city, st.state, st.zip_code
FROM Sales.stores AS st;
GO


-- Customer Dimension
INSERT INTO BikeSalesDWMinions..Customer
SELECT c.customer_id, c.first_name, c.last_name, c.phone, 
    c.email, c.street, c.city, c.state, c.zip_code
FROM Sales.customers AS c;
GO

--Time Dimension 


Use BikeSalesDWMinions

DECLARE @StartDate DATETIME = '20160101' --Starting value of Date Range
DECLARE @EndDate DATETIME = '20221231' --End Value of Date Range

DECLARE @curDate DATE
DECLARE @FirstDayMonth DATE
DECLARE @QtrMonthNo int
DECLARE @FirstDayQtr DATE

SET @curdate = @StartDate
while @curDate < @EndDate 
  Begin
		   
    SET @FirstDayMonth = DateFromParts(Year(@curDate), Month(@curDate), '01')
	SET @QtrMonthNo = ((DatePart(Quarter, @CurDate) - 1) * 3) + 1 
    Set @FirstDayQtr = DateFromParts(Year(@curDate), @QtrMonthNo, '01')

	INSERT INTO [Time]
    select 
	  CONVERT (char(8),@curDate,112) as time_key, -- 112 here is code for yy,mm,dd
	  @CurDate AS Date,
	  CONVERT (char(10), @CurDate,103) as FullDateUK,

	  DATEPART(Day, @curDate) AS DayOfMonth,
	  DATENAME(WeekDay, @curDate) AS DayName,

	  DatePart(Month, @curDate) AS Month,
	  Datename(Month, @curDate) AS MonthName,

	  DatePart(Quarter, @curDate) as Quarter,
	  CASE DatePart(Quarter, @curDate)
			WHEN 1 THEN 'First'
			WHEN 2 THEN 'Second'
			WHEN 3 THEN 'Third'
			WHEN 4 THEN 'Fourth'
	  END AS QuarterName,
	  DatePart(Year, @curDate) as Year,


	  CASE
		WHEN DATEPART(WeekDay, @curDate) in (1, 7) THEN 0
		WHEN DATEPART(WeekDay, @curDate) in (2, 3, 4, 5, 6) THEN 1
	  END as IsWeekDay
   	
		
    /* Increate @curDate by 1 day */
	SET @curDate = DateAdd(Day, 1, @curDate)
  End




-- Fact table

use BikeSalesDWMinions

DELETE FROM SalesFacts

INSERT INTO BikeSalesDWMinions..SalesFacts(customer_key,staff_key,store_key,
product_key,order_time_key,required_time_key,ship_time_key,
  order_status,order_id,order_quantity,list_price,discount)
    SELECT 
        c.customer_key,
        s.staff_key,
        st.store_key,
        p.product_key,
        CAST(format(o.order_date,'yyyyMMdd') as int) as order_date_key,
        CAST(format(o.required_date,'yyyyMMdd') as int) as required_date_key,
        CAST(format(o.shipped_date,'yyyyMMdd') as int) as shipped_date_key,
        o.order_status,
        o.order_id,
        ot.quantity,
        ot.list_price,
        ot.discount
    FROM
    BikeSalesMinions.sales.[order_items] as ot INNER JOIN BikeSalesMinions.sales.[orders] as o
    ON ot.order_id = o.order_id
    INNER JOIN BikeSalesDWMinions..[Staff] as s ON o.staff_id = s.staff_id
    INNER JOIN BikeSalesDWMinions..[Store] st ON o.store_id = st.store_id
    INNER JOIN BikeSalesDWMinions..[Customer] c ON o.customer_id = c.customer_id
    INNER JOIN BikeSalesDWMinions..[Product] p  ON ot.product_id = p.product_id



use BikeSalesDWMinions
select * from SalesFacts
