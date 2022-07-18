-- check if joins would work and viualise denormalization if it was in the data warehouse 

-- this join would mimics an order dimension within the dw (orders + order_items)
SELECT *
FROM sales.orders
INNER JOIN sales.order_items
ON sales.orders.order_id = sales.order_items.order_id


-- this join mimics an product dimension within the dw (brand + categories + products)
SELECT *
FROM production.products p
INNER JOIN production.categories c
ON p.category_id = c.category_id
INNER JOIN production.brands b
ON p.brand_id = b.brand_id


