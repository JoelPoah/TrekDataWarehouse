-- Query 1 Sales/Profits/Discounts/revenue
/**Firstly is how do we determine the best products or worst products
Select duration : 'Year' + 'Month'(only past 3 months{performance of current quarter})
To determine latest: Order by shipped latest
Revenue: column wise used to calculate (list_price*quantity)*(1-discount)
**/


use BikeSalesDWMinions
SELECT * FROM(
select p.product_name, SUM((sf.list_price*sf.order_quantity)*(1-sf.discount)) as revenue,
    concat(past3month.MonthName,' ',past3month.Year) as ShippedDate,
    RANK() OVER (PARTITION BY concat(past3month.MonthName,' ',past3month.Year) ORDER BY SUM((sf.list_price*sf.order_quantity)*(1-sf.discount)) DESC) as rank
    from SalesFacts as sf,
        product as p, time as past3month
    where p.product_key = sf.product_key and sf.order_status=4
        and past3month.time_key = sf.ship_time_key
        and past3month.fullDateUK >=
        (DATEADD(
            MONTH,-3,(Select Top 1
            latest.FullDateUK
        from salesfacts as sf ,
            time as latest
        where sf.ship_time_key = latest.time_key
        order by latest.FullDateUK desc)
        ))
        AND 
        month(past3month.fullDateUK) <
        (Select Top 1
            month(latest.FullDateUK)
        from salesfacts as sf ,
            time as latest
        where sf.ship_time_key = latest.time_key
        order by latest.FullDateUK desc)    
    group by past3month.month,concat(past3month.MonthName,' ',past3month.Year),p.product_name
    order by past3month.month desc,revenue desc offset 0 rows
) as test
where test.rank <=5


-- use BikeSalesDWMinions
-- SELECT * FROM(
-- select p.product_name, SUM((sf.list_price*sf.order_quantity)*(1-sf.discount)) as revenue,
--     concat(past3month.MonthName,' ',past3month.Year) as ShippedDate,
--     lag(sf.discount) OVER (PARTITION BY concat(past3month.MonthName,' ',past3month.Year) ORDER BY SUM((sf.list_price*sf.order_quantity)*(1-sf.discount)) DESC) as discountchange
--     from SalesFacts as sf,
--         product as p, time as past3month
--     where p.product_key = sf.product_key and sf.order_status=4
--         and past3month.time_key = sf.ship_time_key
--         and past3month.fullDateUK >=
--         (DATEADD(
--             MONTH,-3,(Select Top 1
--             latest.FullDateUK
--         from salesfacts as sf ,
--             time as latest
--         where sf.ship_time_key = latest.time_key
--         order by latest.FullDateUK desc)
--         ))
--         AND 
--         month(past3month.fullDateUK) <
--         (Select Top 1
--             month(latest.FullDateUK)
--         from salesfacts as sf ,
--             time as latest
--         where sf.ship_time_key = latest.time_key
--         order by latest.FullDateUK desc)    
--     group by past3month.month,concat(past3month.MonthName,' ',past3month.Year),p.product_name,sf.discount
--     order by past3month.month desc,revenue desc offset 0 rows
-- ) as test
-- where test.discountchange <=5




/**


--Select Top 100 Best products based on revenue and average discount also must 
-- take note of order_status not equal 3
select top 100
    p.product_name as worst, sum(sf.order_quantity*sf.list_price) as revenue,
    AVG(sf.discount) as discount
from BikeSalesDWMinions..SalesFacts as sf
    INNER JOIN BikeSalesDWMinions..[Product] as p ON sf.product_key = p.product_key
group by p.product_name
order by revenue asc

-- I want to know the difference of discounts in the past months 

-- select product , average revenue using rank() over partition by month 
select p.product_name as product, month(shipped.FullDateUK) as MonthOfYear, avg(sf.order_quantity*sf.list_price) as revenue,
    AVG(discount) as discount,
    rank() over (partition by month(shipped.fullDateUK) order by avg(sf.order_quantity*sf.list_price) desc) as rank
from BikeSalesDWMinions..SalesFacts as sf
    INNER JOIN BikeSalesDWMinions..[Product] as p ON sf.product_key = p.product_key
    INNER JOIN BikeSalesDWMinions..[Time] as shipped ON sf.ship_time_key = shipped.time_key
group by p.product_name, month(shipped.fullDateUK)
order by revenue desc


use BikeSalesDWMinions

-- Select top 100 best and worst 
select top 100
    p.product_name , sum(sf.order_quantity*sf.list_price) as revenue,
    AVG(sf.discount) as Averagediscount, a.WorstProduct as WorstProducts, a.worstdiscount
from BikeSalesDWMinions..SalesFacts as sf , BikeSalesDWMinions..Product as p,
    (select top 100
        p.product_name as WorstProduct, sum(sf.order_quantity*sf.list_price) as revenue,
        AVG(sf.discount) as worstdiscount
    from BikeSalesDWMinions..SalesFacts as sf
        INNER JOIN BikeSalesDWMinions..[Product] as p ON sf.product_key = p.product_key
    group by p.product_name
    order by revenue asc
) as a
WHERE sf.product_key=p.product_key
group by p.product_name , a.WorstProduct,a.worstdiscount
order by revenue desc
