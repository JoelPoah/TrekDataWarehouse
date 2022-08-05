-- Query 3 (Sales/Seasons of Sales/Time)
USE BikeSalesDWMinions
GO

-- formatted query 3
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



SELECT [Quarter], [Mountain Bikes], [Road Bikes], [Cruisers Bicycles], [Electric Bikes], [Cyclocross Bicycles], [Comfort Bicycles], [Children Bicycles]
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



-- added percentage change to lagged query
SELECT *,
	(([avg revenue per quarter] - lag1_Revenue) / [avg revenue per quarter]) * 100 'pct diff'
FROM (
	select
		t.Quarter,
		p.category_name,
		SUM(f.list_price * f.order_quantity * (1-f.discount)) / COUNT(DISTINCT YEAR(FullDateUK)) 'avg revenue per quarter',
		LAG(SUM(f.list_price * f.order_quantity * (1-f.discount)) / COUNT(DISTINCT YEAR(FullDateUK)), 1, 0) OVER (PARTITION BY [category_name] ORDER BY [Quarter] ASC) 'lag1_Revenue'
	from SalesFacts f
	inner join time t on f.ship_time_key = t.time_key
	inner join product p on f.product_key = p.product_key
	where YEAR(t.FullDateUK) IN ('2016','2017')
	group by t.Quarter, p.category_name
) as p


-- made lag query more efficient
select 
	t.Quarter,
	p.category_name,
	SUM(f.list_price * f.order_quantity * (1-f.discount)) / COUNT(DISTINCT YEAR(FullDateUK)) 'avg revenue per quarter',
	LAG(SUM(f.list_price * f.order_quantity * (1-f.discount)) / COUNT(DISTINCT YEAR(FullDateUK)), 1, 0) OVER (PARTITION BY [category_name] ORDER BY [Quarter] ASC) 'PrevSales'
from SalesFacts f
inner join time t on f.ship_time_key = t.time_key
inner join product p on f.product_key = p.product_key
where YEAR(t.FullDateUK) IN ('2016','2017')
group by t.Quarter, p.category_name



-- new pivot query
SELECT [Quarter], [Mountain Bikes], [Road Bikes], [Cruisers Bicycles], [Electric Bikes], [Cyclocross Bicycles], [Comfort Bicycles], [Children Bicycles]
FROM (
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
AS quarterly_revenue
PIVOT (max([avg revenue per quarter]) FOR [category_name] IN ([Mountain Bikes], [Road Bikes], [Cruisers Bicycles], [Electric Bikes], [Cyclocross Bicycles], [Comfort Bicycles], [Children Bicycles]))
AS pivoted_table


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