-- Sales/Products/brands/categories/inventory
-- how to select current stock even if product dimension is outdated 

-- getting current stock info is unlikely because, a stocktake has to be conducted, meaning "current" stock quantity 
-- is dependent on when stock take occurs

-- orders involving products do not cause stock quantity to decrease in product dimension as stock take does not occur frequently
-- this causes stock information to be outdated

-- solution may be to get the most up to date stock information which is purely basedon stock take date
-- OR deduct the quantities ordered iff an order is completed, as products would be sent to customers

-- would probably need to keep track of stock for each store

select s.store_id, sf. order_id, p.product_name, (p.quantity - sf.order_quantity) as 'current_stock' 
from SalesFacts as sf, Product as p, Store as s
where order_status = 4
and p.product_key = sf.product_key
and sf.store_key = s.store_key
group by s.store_id, sf. order_id, p.product_name, (p.quantity - sf.order_quantity);

select * from SalesFacts;

select * from Product;