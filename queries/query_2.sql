-- Query 2 Sales/Staff/stores


-- Query 2 Sales/Staff/stores
-- formatted query
use BikeSalesDWMinions
select 
	s.store_id, s.staff_id, concat(s.first_name, ' ', s.last_name) as 'staff_name', 
	-- Add column to show whether a staff is a manager or not 	
	case 
		when s.staff_id in (
			select distinct manager_id 
			from Staff 
			where manager_id is not null
		)
		then 'Manager'
		else 'Normal'
		end as 'staff_type',
	-- Add column to show avg yearly revenue generated for each staff 	
	isnull(round(sum(sf.order_quantity * sf.list_price * (1-sf.discount)), 2), 0) / count(distinct year(t.FullDateUK)) as 'revenue',
	-- Rank column indicates which staff is performing better/worse	
	rank() over (
		partition by s.store_id 
		order by isnull(round(sum(sf.order_quantity * sf.list_price * (1-sf.discount)), 2), 0) desc
	) as 'rank'
from SalesFacts as sf
inner join staff s on sf.staff_key = s.staff_key
inner join Time t on sf.ship_time_key = t.time_key
-- The revenue from pending = 1, processing = 2, and completed = 4 orders will be used to calculate the revenue for each staff
where sf.order_status != 3
-- Revenue will be taken from the last two years excluding 2018 as DW does not contain data for the entire year of 2018
and year(t.FullDateUK) in ('2016', '2017')
group by s.store_id, s.staff_id, concat(s.first_name, ' ', s.last_name)



use BikeSalesDWMinions
select 
	s.store_id, s.staff_id, concat(s.first_name, ' ', s.last_name) as 'staff_name', 
	-- Add column to show whether a staff is a manager or not 	
	case 
		when s.staff_id in (
			select distinct manager_id 
			from Staff 
			where manager_id is not null
		) then 'Manager'
		else 'Normal'
	end as 'staff_type',
	-- Add column to show avg yearly revenue generated for each staff 	
	isnull(
		round(sum(sf.order_quantity * sf.list_price * (1-sf.discount)), 2), 0
	) / count(distinct year(t.FullDateUK)) as 'revenue',
	-- Rank column indicates which staff is performing better/worse	
	rank() over(
		partition by s.store_id 
		order by isnull(round(sum(sf.order_quantity * sf.list_price * (1-sf.discount)), 2), 0) desc) as 'rank'
from SalesFacts as sf
inner join staff s on sf.staff_key = s.staff_key
inner join Time t on sf.ship_time_key = t.time_key
-- The revenue from pending = 1, processing = 2, and completed = 4 orders will be used to calculate the revenue for each staff
where sf.order_status != 3
-- Revenue will be taken from the last two years excluding 2018 as DW does not contain data for the entire year of 2018
and year(t.FullDateUK) in ('2016', '2017')
group by s.store_id, s.staff_id, concat(s.first_name, ' ', s.last_name)
