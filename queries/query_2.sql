<<<<<<< HEAD
-- Query 2 Sales/Staff/stores
=======
-- Query 2 (Sales/Staff/stores)
--
>>>>>>> cf0b39c1ecea54e6c269ea9e4e1ef097031252fb
use BikeSalesDWMinions

select 
	s.store_id, s.staff_id, concat(s.first_name, ' ', s.last_name) as 'staff_name', 
	case 
		when s.staff_id in (
			select distinct manager_id 
			from Staff 
			where manager_id is not null
		) then 'Manager'
		else 'Normal'
	end as 'staff_type',
	isnull(
		round(sum(sf.order_quantity * sf.list_price * (1-sf.discount)), 2), 0
	) as 'revenue',
	rank() over(
		partition by s.store_id 
		order by isnull(round(sum(sf.order_quantity * sf.list_price * (1-sf.discount)), 2), 0) desc) as 'rank'
from SalesFacts as sf
full outer join staff s on sf.staff_key = s.staff_key
group by s.store_id, s.staff_id, concat(s.first_name, ' ', s.last_name)