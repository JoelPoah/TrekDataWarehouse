-- Sales/Products/brands/categories/inventory

use BikeSalesDWMinions
GO
select TOP 15 p.product_name, 
	sum(sf.order_quantity) as totalsold,
	max(p.quantity) as totalcount,
	DATEADD(
		month, max(p.quantity)/sum(sf.order_quantity),
		(
			Select Top 1 latest.FullDateUK from salesfacts as sf ,
			time as latest
			where sf.ship_time_key = latest.time_key
			order by latest.FullDateUK desc 
		)
	) as 'RestockBy' -- Predicts Restock date for fast selling product
from salesfacts as sf
inner join product p on sf.product_key = p.product_key
inner join [time] as pastweek on sf.ship_time_key = pastweek.time_key
where sf.order_status != 3
	and pastweek.fullDateUK>=(DATEADD(week,-4,
		(Select Top 1
			latest.FullDateUK
			from salesfacts as sf ,
			time as latest
			where sf.ship_time_key = latest.time_key
			order by latest.FullDateUK desc
		) -- Selects Latest date
	))
group by p.product_name
order by RestockBy asc