-- Query 4 Sales/Orders/Customers

use BikeSalesDWMinions
select top 10
    count(sf.order_id) as CountOfSales, c.state, c.city,
    SUM(order_quantity*list_price*(1-discount)) as totalrevenue,
	AVG(DATEDIFF(Day, ordered.FullDateUK, shipped.FullDateUK)) as 'DayTaken', --total amount of days from order to shipped
    AVG(DATEDIFF(DAY, req.FullDateUK, shipped.FullDateUK)) as 'DayLate'
from SalesFacts sf
inner join [Time] ordered on sf.order_time_key = ordered.time_key
inner join [Time] req on sf.required_time_key = req.time_key
inner join [Time] shipped on sf.ship_time_key = shipped.time_key 
inner join Customer c on sf.customer_key = c.customer_key
WHERE sf.order_status=4
GROUP BY c.state,c.city
ORDER BY 'DayLate' DESC, totalrevenue asc