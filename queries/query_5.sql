-- Sales/Products/brands/categories/inventory
-- how to select current stock even if product dimension is outdated 

-- getting current stock info is unlikely because, a stocktake has to be conducted, meaning "current" stock quantity 
-- is dependent on when stock take occurs

-- orders involving products do not cause stock quantity to decrease in product dimension as stock take does not occur frequently
-- this causes stock information to be outdated

-- solution may be to get the most up to date stock information which is purely basedon stock take date
-- OR deduct the quantities ordered iff an order is completed, as products would be sent to customers

-- would probably need to keep track of stock for each store
-- but it is not explicitly stated which products belong in which stores
use BikeSalesDWMinions
select p.product_name, SUM(sf.order_quantity) as 'total_order_qty'
from SalesFacts as sf
inner join Product as p on sf.product_key = p.product_key
where sf.order_status = 4
group by p.product_name;

-- cannot get difference between product quantity and total order quantity for each item
select p.product_name, (p.quantity - SUM(sf.order_quantity)) as 'current_stock'
from SalesFacts as sf
inner join Product as p on sf.product_key = p.product_key
group by sf.order_id, p.product_name,p.quantity;

-- Get rate of stock change in past week for each product , state brand and category 

/**IDEA
handle stock take lag compared to salesfact (leave as idea for now can implement later)
duration: stock change in past week 
projection: product ,category , brand , stock 
hypothesis insight: get product rate of product stock change in past week
predict when the stock will run out

**/

   /** 

total count sold in a month for example 6
Then take the remaining stock /6 = months it will last 
dateadd the days it will last for each product 
Order by the earliest product which is running out
**/
-- Average count sold for each product in the past month
/**Cons: this query can only show products that were sold in the past month
and attempt to predict the date at which the owner should restock the**/
use BikeSalesDWMinions
select p.product_name,CAST(sum(sf.order_quantity) AS FLOAT) as totalsold,
avg(p.quantity) as totalcount,DATEADD(month,avg(p.quantity)/sum(sf.order_quantity),
(Select Top 1
latest.FullDateUK
from salesfacts as sf ,
time as latest
where sf.ship_time_key = latest.time_key
order by latest.FullDateUK desc)) as 'RestockBy'
from salesfacts as sf ,product as p,time as pastweek
where p.product_key = sf.product_key and sf.order_status =4
and pastweek.time_key = sf.ship_time_key
and pastweek.fullDateUK>=(DATEADD(week,-4,(Select Top 1
latest.FullDateUK
from salesfacts as sf ,
time as latest
where sf.ship_time_key = latest.time_key
order by latest.FullDateUK desc)
))
group by p.product_name
order by totalsold desc,totalcount asc




