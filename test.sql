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