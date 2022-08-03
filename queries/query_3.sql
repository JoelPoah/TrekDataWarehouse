-- Query 3 (Sales/Seasons of Sales/Time)
-- top 3 best selling categories per quarter
select * from (
	select 
		p.category_name,
		t.Quarter,
		t.QuarterName,
		SUM(f.list_price * f.order_quantity * f.discount) AS revenue,
		rank() over (partition by t.Quarter order by SUM(f.list_price * f.order_quantity * f.discount) desc) as [rank]
	from SalesFacts f
	inner join time t on f.order_time_key = t.time_key
	inner join product p on f.product_key = p.product_key	
	group by p.category_name, t.QuarterName, t.Quarter
) t
where t.[rank] <= 3


-- Sales of each bike category per quarter
DROP VIEW IF EXISTS [pivoted_table];
GO

CREATE VIEW [pivoted_table] AS
WITH pivot_data AS (
	select 
		t.Quarter,
		p.category_name,
		SUM(f.list_price * f.order_quantity * (1-f.discount)) 'revenue of category per quarter'
	from SalesFacts f
	inner join time t on f.ship_time_key = t.time_key
	inner join product p on f.product_key = p.product_key
	group by t.Quarter, p.category_name
)
SELECT [Quarter], [Mountain Bikes], [Road Bikes], [Cruisers Bicycles], [Electric Bikes], [Cyclocross Bicycles], [Comfort Bicycles], [Children Bicycles]
FROM pivot_data
PIVOT (max([revenue of category per quarter]) FOR [category_name] IN ([Mountain Bikes], [Road Bikes], [Cruisers Bicycles], [Electric Bikes], [Cyclocross Bicycles], [Comfort Bicycles], [Children Bicycles]))
AS p
GO

select * from pivoted_table pt
INNER JOIN (
	SELECT t.[Quarter], SUM(f.list_price * f.order_quantity * (1-f.discount)) 'revenue per quarter'
	FROM SalesFacts f
	INNER JOIN [Time] t ON f.ship_time_key = t.time_key
	GROUP BY t.[Quarter]
) qt
ON pt.[Quarter] = qt.[Quarter]
GO