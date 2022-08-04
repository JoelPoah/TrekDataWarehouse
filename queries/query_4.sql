-- Query 4 Sales/Orders/Customers
/**Efficiency of company; find mean/median time taken in 
delivering the bicycle(shipped_date - required_date) to various customers 
(group by city in which they are in) if they are always late in delivery means
 got problem and should do something about the delivery in that particular city 
 **/
use BikeSalesDWMinions
select count(sf.order_id) as CountOfSales,c.state,c.city,SUM(order_quantity*list_price*(1-discount)) as totalrevenue,
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

use BikeSalesDWMinions
select 
    count(sf.order_id) as CountOfSales, c.state, c.city,
    SUM(order_quantity*list_price*(1-discount)) as totalrevenue,
    AVG(DATEDIFF(Day,ordered.FullDateUK,shipped.FullDateUK)) as 'DayTaken', 
    AVG(DATEDIFF(DAY,required.FullDateUK,shipped.FullDateUK)) as 'DayLate'
from SalesFacts as sf, time as shipped, time as required, time as ordered, customer as c 
where sf.order_time_key = ordered.time_key 
    and required.time_key = sf.required_time_key 
    and sf.ship_time_key = shipped.time_key 
    and c.customer_key = sf.customer_key
    and sf.order_status = 4	
GROUP BY c.state,c.city
ORDER BY DayTaken desc

-- tweaking query 4
use BikeSalesDWMinions
select 
    count(sf.order_id) as CountOfSales, c.state, c.city,
    SUM(order_quantity*list_price*(1-discount)) as totalrevenue,
    AVG(DATEDIFF(DAY, req.FullDateUK, shipped.FullDateUK)) as 'DayLate'
from SalesFacts sf
inner join [Time] req on sf.required_time_key = req.time_key
inner join [Time] shipped on sf.ship_time_key = shipped.time_key 
inner join Customer c on sf.customer_key = c.customer_key
GROUP BY c.state,c.city
ORDER BY 'DayLate' DESC, totalrevenue DESC