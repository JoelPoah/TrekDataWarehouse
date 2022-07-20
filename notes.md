> For better viewing, install Markdown Preview Enchanced extension, **ctrl-shift-v** to preview.

## Things to take note when doing ETL/designing warehouse.

1. Realise that there are 8 products not in stock table
select product_id from production.products where product_id not in(select product_id from Production.stocks)

<br>

2. Performing a inner join will leave out the 8 products
select * from production.products p,Production.stocks s
where s.product_id = p.product_id

<br>

3. Make sure to either use a left join or full outer join (do read up more to explain)

```sql
SELECT * FROM production.products p
LEFT JOIN Production.stocks s 
ON p.product_id = s.product_id;

SELECT * FROM production.products p
FULL OUTER JOIN Production.stocks s 
ON p.product_id = s.product_id;

SELECT * FROM production.stocks s
FULL OUTER JOIN Production.products p 
ON p.product_id  = s.product_id;
```


```sql
-- IF DENORMALIZE GOT TO FILL IN NULL VALUES 
SELECT * FROM production.stocks s
FULL OUTER JOIN Production.products p 
ON p.product_id  = s.product_id
WHERE p.product_id = 'RDB320'; 
```


3. Keeping order date, required date and shipped date is a must to trackefficiency but also bluntly stated on page 5 of CA2. Thus design must differ from Practical E 

