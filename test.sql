use BikeSalesMinions
select * from sales.orders

SELECT CAST(format(PARSE(o.order_date AS date USING 'AR-LB'),'yyyyMMdd') as int)
from Sales.orders as o

Select CONVERT(INT,REPLACE(o.order_date,'/',''),3) as order_date,
	   CONVERT(INT,REPLACE(o.required_date,'/',''),3) as required_date,
	   CONVERT(INT,REPLACE(o.shipped_date,'/',''),3) as shipped_date
from Sales.orders o




select * from Sales.orders


   SELECT 
        c.customer_id,
        s.staff_id,
        st.store_id,
        p.product_id,
        o.order_status,
        o.order_id,
        ot.quantity,
        ot.list_price,
        ot.discount
    FROM
    BikeSalesMinions.sales.[order_items] as ot INNER JOIN BikeSalesMinions.sales.[orders] as o
    ON o.order_id = ot.order_id
    INNER JOIN BikeSalesMinions.sales.[staffs] as s ON o.staff_id = s.staff_id
    INNER JOIN BikeSalesDWMinions..[Store] st ON o.store_id = st.store_id
    INNER JOIN BikeSalesDWMinions..[Customer] c ON o.customer_id = c.customer_id
    INNER JOIN BikeSalesDWMinions..[Product] p  ON ot.product_id = p.product_id



select distinct t.[Quarter], p.category_name,
	RANK() OVER 
		SUM(f.list_price * f.order_quantity * f.discount) OVER(PARTITION BY p.category_name, t.quarter) AS revenue
from SalesFacts f
inner join time t on f.order_time_key = t.time_key
inner join product p on f.product_key = p.product_key
order by t.quarter asc, revenue desc


select p.category_name, (f.list_price * f.order_quantity * (1-f.discount)),
	RANK() OVER
		(PARTITION BY p.category_id ORDER BY (f.list_price * f.order_quantity * (1-f.discount)) DESC) AS [rank]
from SalesFacts f
inner join time t on f.order_time_key = t.time_key
inner join product p on f.product_key = p.product_key


select p.category_name, t.Quarter,
	SUM(f.list_price * f.order_quantity * f.discount) AS revenue
from SalesFacts f
inner join time t on f.order_time_key = t.time_key
inner join product p on f.product_key = p.product_key
group by p.category_name, t.Quarter
order by t.quarter asc, revenue desc




select * from salesfacts

select * from time

select * from Product

select * from staff