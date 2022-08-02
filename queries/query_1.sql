-- Query 1 Sales/Profits/Discounts/revenue

--Select Top 100 Best products based on revenue and average discount also must 
-- take note of order_status not equal 3
select top 100 p.product_name as worst, sum(sf.order_quantity*sf.list_price) as revenue,
AVG(sf.discount) as discount
from BikeSalesDWMinions..SalesFacts as sf 
INNER JOIN BikeSalesDWMinions..[Product] as p ON sf.product_key = p.product_key
group by p.product_name
order by revenue asc


-- select product , average revenue using rank() over partition by month 
select p.product_name as product,month(shipped.FullDateUK) as MonthOfYear, avg(sf.order_quantity*sf.list_price) as revenue,
AVG(discount) as discount,
rank() over (partition by month(shipped.fullDateUK) order by avg(sf.order_quantity*sf.list_price) desc) as rank
from BikeSalesDWMinions..SalesFacts as sf
INNER JOIN BikeSalesDWMinions..[Product] as p ON sf.product_key = p.product_key
INNER JOIN BikeSalesDWMinions..[Time] as shipped ON sf.ship_time_key = shipped.time_key
group by p.product_name, month(shipped.fullDateUK)
order by revenue desc



-- select top 100 p.product_name , sum(sf.order_quantity*sf.list_price) as revenue,
-- AVG(sf.discount) as Averagediscount, a.WorstProduct as WorstProducts, a.worstdiscount
-- from BikeSalesDWMinions..SalesFacts as sf , BikeSalesDWMinions..Product as p,
-- (select top 100 p.product_name as WorstProduct, sum(sf.order_quantity*sf.list_price) as revenue,
-- AVG(sf.discount) as worstdiscount
-- from BikeSalesDWMinions..SalesFacts as sf 
-- INNER JOIN BikeSalesDWMinions..[Product] as p ON sf.product_key = p.product_key
-- group by p.product_name
-- order by revenue asc
-- ) as a
-- WHERE sf.product_key=p.product_key
-- group by p.product_name , a.WorstProduct,a.worstdiscount
-- order by revenue desc
