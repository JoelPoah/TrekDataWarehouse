-- Query 3 (Sales/Seasons of Sales/Time)
USE BikeSalesDWMinions
GO

SELECT [Quarter], 
	[Mountain Bikes] 'Mountain Bikes (% change)', 
	[Road Bikes] 'Road Bikes (% change)', 
	[Cruisers Bicycles] 'Cruisers Bicycles (% change)', 
	[Electric Bikes] 'Electric Bikes (% change)', 
	[Cyclocross Bicycles] 'Cyclocross Bicycles (% change)', 
	[Comfort Bicycles] 'Comfort Bicycles (% change)', 
	[Children Bicycles] 'Children Bicycles (% change)'
FROM (
	SELECT [Quarter], category_name,
		(([avg revenue per quarter] - lag1_Revenue) / (CASE WHEN [lag1_Revenue]=0 THEN [avg revenue per quarter] ELSE [lag1_Revenue] END)) * 100 'pct diff' -- formula for percentage difference per quarter
	FROM (
		select
			t.Quarter,
			p.category_name,
			SUM(f.list_price * f.order_quantity * (1-f.discount)) / COUNT(DISTINCT YEAR(FullDateUK)) 'avg revenue per quarter',
			-- the avg revenue per quarter has to be lagged by 1 quarter so pct change formula can be applied
			LAG(SUM(f.list_price * f.order_quantity * (1-f.discount)) / COUNT(DISTINCT YEAR(FullDateUK)), 1, 0) OVER (PARTITION BY [category_name] ORDER BY [Quarter] ASC) 'lag1_Revenue'
		from SalesFacts f
		inner join time t on f.ship_time_key = t.time_key
		inner join product p on f.product_key = p.product_key
		where YEAR(t.FullDateUK) IN ('2016','2017')
		group by t.Quarter, p.category_name -- so that SUM aggregate function calculates revenue by quarter and category
	) as p
) AS quarterly_revenue
-- pivot table to make each bike category a column so that pct change per quarter can be seen easily
PIVOT (max([pct diff]) FOR [category_name] IN ([Mountain Bikes], [Road Bikes], [Cruisers Bicycles], [Electric Bikes], [Cyclocross Bicycles], [Comfort Bicycles], [Children Bicycles]))
AS pivoted_table