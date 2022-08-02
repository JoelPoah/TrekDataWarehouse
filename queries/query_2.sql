-- Query 2
select 
	s.staff_id, s.first_name, s.store_id,
	sum(sf.order_quantity * sf.list_price * (1-sf.discount)) 'revenue'
from SalesFacts sf
inner join staff s on sf.staff_key = s.staff_key
group by s.staff_id, s.first_name, s.store_id
order by [revenue] desc