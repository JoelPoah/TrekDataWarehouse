/* 
Performing exploratory data analysis to find out more about the data in this data warehouse and generate interesting
insights so that final query to present can be selected
*/
use BikeSalesDWMinions
select * from SalesFacts

-- Query 1

--Select Top 100 Best products based on revenue and average discount also must 
-- take note of order_status not equal 3
select top 100 p.product_name, sum(sf.order_quantity*sf.list_price) as revenue,
MAX(sf.discount) as discount
from BikeSalesDWMinions..SalesFacts as sf 
INNER JOIN BikeSalesDWMinions..[Product] as p ON sf.product_key = p.product_key
group by p.product_name
order by revenue desc 


select top 100 p.product_name , sum(sf.order_quantity*sf.list_price) as revenue,
AVG(sf.discount) as Averagediscount, a.WorstProduct as WorstProducts, a.worstdiscount
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

-- Sales are alays highest in Quarter 1 and Lowest in Quarter 4, with a decreasing trend as the year progresses.
select t.[Quarter] , SUM(f.list_price * f.order_quantity * f.discount) 'revenue' from SalesFacts f
inner join time t on f.order_time_key = t.time_key
group by t.[Quarter] order by t.[Quarter]




-- Query 4
/**Efficiency of company; find mean/median time taken in 
delivering the bicycle(shipped_date - required_date) to various customers 
(group by city in which they are in) if they are always late in delivery means
 got problem and should do something about the delivery in that particular city 
 **/
use BikeSalesDWMinions
select * from salesfacts

select distinct c.city, MAX(DATEDIFF(Day,shipped.FullDateUK,received.FullDateUK)) as 'DayTaken' ,
RANK () OVER (PARTITION BY)
from SalesFacts as sf,time as shipped,
time as received ,customer as c ,Store as st
where sf.required_time_key = received.time_key and
sf.ship_time_key = shipped.time_key and c.customer_key = sf.customer_key
and sf.order_status = 4 and DATEDIFF(Day,shipped.FullDateUK,received.FullDateUK)>0
GROUP BY c.city
ORDER BY DayTaken DESC

select * from time


-- Query 5