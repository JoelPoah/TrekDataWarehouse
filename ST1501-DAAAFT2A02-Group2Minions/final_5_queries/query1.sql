-- Query 1 Sales/Profits/Discounts/revenue
use BikeSalesDWMinions
SELECT * FROM(
	select 
		p.product_name, SUM((sf.list_price*sf.order_quantity)*(1-sf.discount)) as revenue,
		SUM((sf.list_price*sf.order_quantity)*sf.discount) as TotalDiscounted, -- shows total amount of money rebated
		concat(past3month.[MonthName],' ',past3month.[Year]) as ShippedDate, -- Show Month and Year in a single column
		RANK() OVER (PARTITION BY concat(past3month.[MonthName],' ',past3month.[Year]) ORDER BY SUM((sf.list_price*sf.order_quantity)*(1-sf.discount)) DESC) as rank
		-- Partition by Month and Year Column , Rank them by Highest Revenue 
    from 
		SalesFacts as sf, product as p, [time] as past3month
    where 
		p.product_key = sf.product_key and sf.order_status=4
        and past3month.time_key = sf.ship_time_key
        -- Filter products that were sold in the past 3 months
        and past3month.fullDateUK >=
        (DATEADD(MONTH,-3,
			(
				Select Top 1 latest.FullDateUK
				from salesfacts as sf, [time] as latest
				where sf.ship_time_key = latest.time_key
				order by latest.FullDateUK desc
			)
        ))
        AND 
        -- Filter out products that were not sold in the current month(april) as it has not ended yet
        month(past3month.fullDateUK) <
        (
			Select Top 1 month(latest.FullDateUK)
			from salesfacts as sf, [time] as latest
			where sf.ship_time_key = latest.time_key
			order by latest.FullDateUK desc
		)    
    group by concat(past3month.MonthName,' ',past3month.Year),p.product_name
) as test
where test.rank <=5 -- Only consider the past 5 products in each month
order by MONTH(ShippedDate) DESC -- order by the month