/* 
Performing exploratory data analysis to find out more about the data in this data warehouse and generate interesting
insights so that final query to present can be selected
*/
use BikeSalesDWMinions
select * from SalesFacts

-- Query 1

--Select Top 100 Best products based on revenue and average discount
select top 100 p.product_name, sum(sf.order_quantity*sf.list_price) as revenue,
AVG(sf.discount) as discount
from BikeSalesDWMinions..SalesFacts as sf 
INNER JOIN BikeSalesDWMinions..[Product] as p ON sf.product_key = p.product_key
group by p.product_name
order by revenue desc, discount desc 


select top 100 p.product_name , sum(sf.order_quantity*sf.list_price) as revenue,
AVG(sf.discount) as discount, a.WorstProduct as WorstProducts, a.worstdiscount
from BikeSalesDWMinions..SalesFacts as sf , BikeSalesDWMinions..Product as p,
(select top 100 p.product_name as WorstProduct, sum(sf.order_quantity*sf.list_price) as revenue,
AVG(sf.discount) as worstdiscount
from BikeSalesDWMinions..SalesFacts as sf 
INNER JOIN BikeSalesDWMinions..[Product] as p ON sf.product_key = p.product_key
group by p.product_name
order by revenue asc
) as a
WHERE sf.product_key=p.product_key
group by p.product_name , a.WorstProduct,a.worstdiscount
order by revenue desc


-- Query 2


-- Query 3 (Sales/Seasons of Sales/Time)
-- top 3 best selling categories per quarter
select * from (
	select 
		p.category_name,
		t.Quarter,
		t.QuarterName,
		SUM(f.list_price * f.order_quantity * f.discount) AS revenue,
		rank() over (partition by t.Quarter order by SUM(f.list_price * f.order_quantity * f.discount) desc) as [rank]
	from SalesFacts f
	inner join time t on f.order_time_key = t.time_key
	inner join product p on f.product_key = p.product_key	
	group by p.category_name, t.QuarterName, t.Quarter
) t
where t.[rank] <= 3




-- Query 4


-- Query 5