-- Query 2
use BikeSalesDWMinions

select 
	s.staff_id, concat(s.first_name, ' ', s.last_name) 'staff_name', s.store_id, 
	case 
		when s.staff_id in (
			select distinct manager_id 
			from Staff 
			where manager_id is not null
		) then 'Manager'
		else 'Normal'
	end as 'staff_type',
	isnull(round(sum(sf.order_quantity * sf.list_price * (1-sf.discount)), 2), 0) 'revenue'
from SalesFacts sf
full outer join staff s on sf.staff_key = s.staff_key
group by s.staff_id, concat(s.first_name, ' ', s.last_name), s.store_id, s.manager_id
order by s.store_id, [revenue] desc