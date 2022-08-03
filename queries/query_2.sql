-- Query 2
select 
	s.staff_id, s.first_name, s.store_id,
	round(sum(sf.order_quantity * sf.list_price * (1-sf.discount)), 2) 'revenue'
from SalesFacts sf
inner join staff s on sf.staff_key = s.staff_key
group by s.staff_id, s.first_name, s.store_id
order by [revenue] desc