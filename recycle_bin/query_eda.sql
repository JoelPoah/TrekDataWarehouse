/* 
Performing exploratory data analysis to find out more about the data in this data warehouse and generate interesting
insights so that final query to present can be selected
*/
use BikeSalesDWMinions
select * from SalesFacts

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


-- Query 2


-- Query 3 (Sales/Seasons of Sales/Time)
-- top 3 best selling categories per quarter
use BikeSalesDWMinions
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




-- Query 4 Sales/Orders/Customers
/**Efficiency of company; find mean/median time taken in 
delivering the bicycle(shipped_date - required_date) to various customers 
(group by city in which they are in) if they are always late in delivery means
 got problem and should do something about the delivery in that particular city 
 **/
use BikeSalesDWMinions
select c.state,c.city,AVG(order_quantity*list_price*(1-discount)) as revenue,
AVG(DATEDIFF(Day,ordered.FullDateUK,shipped.FullDateUK)) as 'DayTaken' 
,AVG(DATEDIFF(DAY,required.FullDateUK,shipped.FullDateUK)) as 'DayLate'
from SalesFacts as sf,time as shipped,time as required,
time as ordered,customer as c 
where sf.order_time_key = ordered.time_key and required.time_key = sf.required_time_key and
sf.ship_time_key = shipped.time_key and c.customer_key = sf.customer_key
and sf.order_status = 4	
GROUP BY c.state,c.city
ORDER BY DayTaken desc
/**
Conclusion cities in NY such as Tonawanda and Westbury are
taking long time to deliver the bicycle.
Revenue also justifies the delay in delivery.
**/
-- Query 5