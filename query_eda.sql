/* 
Performing exploratory data analysis to find out more about the data in this data warehouse and generate interesting
insights so that final query to present can be selected
*/


-- Query 1


-- Query 2


-- Query 3 (Sales/Seasons of Sales/Time)

-- Sales are alays highest in Quarter 1 and Lowest in Quarter 4, with a decreasing trend as the year progresses.
select t.[Quarter] , SUM(f.list_price * f.order_quantity * f.discount) 'revenue' from SalesFacts f
inner join time t on f.order_time_key = t.time_key
group by t.[Quarter] order by t.[Quarter]




-- Query 4


-- Query 5