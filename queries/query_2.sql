-- Query 2
select 
	s.staff_id, concat(s.first_name, ' ', s.last_name) 'staff_name', s.store_id,
	ISNULL(round(sum(sf.order_quantity * sf.list_price * (1-sf.discount)), 2), 0) 'revenue'
from SalesFacts sf
full outer join staff s on sf.staff_key = s.staff_key
group by s.staff_id, concat(s.first_name, ' ', s.last_name), s.store_id
order by s.store_id, [revenue] desc