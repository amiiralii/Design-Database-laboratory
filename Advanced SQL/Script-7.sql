select p.product_id from products p


with price_ranks as ( 
	select p.product_id, p.category_id, p.price,
	    ROW_NUMBER() OVER(
	        PARTITION BY p.category_id
	        ORDER BY p.price
	    ) as price_rank
	from products p
),
price_ranks_2 as ( 
	select p.product_id, p.category_id, p.price,
	    ROW_NUMBER() OVER(
	        PARTITION BY p.category_id
	        ORDER BY p.price desc
	    ) as price_rank
	from products p
)
select pr.category_id, pr.product_id, pr.price
from price_ranks pr inner join price_ranks_2 pr2 on pr.product_id = pr2.product_id
where pr.price_rank <= 10 or pr2.price_rank <= 10





