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

select p.product_name, SUM(sf.order_quantity) as 'total_order_qty'
from SalesFacts as sf
inner join Product as p on sf.product_key = p.product_key
where sf.order_status = 4
group by p.product_name;

-- cannot get difference between product quantity and total order quantity for each item
select p.product_name, (p.quantity - SUM(sf.order_quantity)) as 'current_stock'
from SalesFacts as sf
inner join Product as p on sf.product_key = p.product_key
group by p.product_name;


select * from SalesFacts;

select * from Product;
