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

-- oldest date and newest date in dataset
SELECT MIN(t.FullDateUK) 'Oldest date', MAX(t.FullDateUK) 'Latest date' FROM SalesFacts f
INNER JOIN Time t on f.ship_time_key = t.time_key

-- math function for the number of years excluding 2018
SELECT COUNT(DISTINCT YEAR(FullDateUK)) FROM SalesFacts f
INNER JOIN Time t on f.ship_time_key = t.time_key
where t.FullDateUK <= '2017-12-31'


-- Sales of each bike category per quarter
DROP VIEW IF EXISTS [pivoted_table];
GO

CREATE VIEW [pivoted_table] AS
WITH pivot_data AS (
	select 
		t.Quarter,
		p.category_name,
		SUM(f.list_price * f.order_quantity * (1-f.discount)) / COUNT(DISTINCT YEAR(FullDateUK)) 'avg revenue per quarter'
	from SalesFacts f
	inner join time t on f.ship_time_key = t.time_key
	inner join product p on f.product_key = p.product_key
	where t.FullDateUK <= '2017-12-31'
	group by t.Quarter, p.category_name
)
SELECT [Quarter], [Mountain Bikes], [Road Bikes], [Cruisers Bicycles], [Electric Bikes], [Cyclocross Bicycles], [Comfort Bicycles], [Children Bicycles]
FROM pivot_data
PIVOT (max([avg revenue per quarter]) FOR [category_name] IN ([Mountain Bikes], [Road Bikes], [Cruisers Bicycles], [Electric Bikes], [Cyclocross Bicycles], [Comfort Bicycles], [Children Bicycles]))
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