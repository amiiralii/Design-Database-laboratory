CREATE TRIGGER product_price_check 
    BEFORE INSERT ON products
    FOR EACH ROW EXECUTE PROCEDURE product_price_check();

CREATE OR REPLACE FUNCTION product_price_check()
    RETURNS TRIGGER
    SET SCHEMA 'public'
    LANGUAGE plpgsql
    AS $$
    BEGIN
    IF NEW.unit_price = 0 THEN
        RAISE EXCEPTION 'Product must have price.';
    END IF;
 
    RETURN NEW;
    END;
    $$;
   
INSERT INTO products VALUES (80, 'Plastic', 15, 4, '10 - 500 g pkgs.', 0, 26, 0, 0, 0);
     
CREATE TRIGGER products_actions
    BEFORE insert or update on products 
    FOR EACH ROW EXECUTE PROCEDURE products_actions();
CREATE TABLE products_audit (
    product_name varchar(40) not null,
    product_id int2,
    operation varchar,
    effective_at timestamp not null default now(),
    userid name not null default session_user
);
CREATE OR REPLACE FUNCTION products_actions()
    RETURNS TRIGGER
    SET SCHEMA 'public'
    LANGUAGE plpgsql
    AS $$
    BEGIN
    INSERT INTO products_audit (product_name, product_id, operation) 
      VALUES (new.product_name, new.product_id, TG_OP);
    RETURN new;
    END;
    $$;
INSERT INTO products VALUES (81, 'Asbab bazi', 15, 4, '20 - 250 g pkgs.', 99, 26, 0, 0, 0);
update products set product_name = 'GamePlay!' where product_id = 81;

select * 
from products_audit





alter table categories
add constraint category_name_not_hashtag
check (position('#' in category_name)=0);

INSERT INTO categories VALUES (8, 'foods#', 'something to eat', '\x');



select od.product_id, o.customer_id, od.unit_price * od.quantity as order_price,
ROW_NUMBER() OVER(
        PARTITION BY od.product_id
        ORDER by od.unit_price * od.quantity desc
    ) as order_number
from order_details od inner join orders o on o.order_id = od.order_id 





select od.product_id, o.customer_id, o.order_date, od.discount,
SUM(
        CASE
            WHEN od.discount!=0 THEN 1
            ELSE 0
        END
    ) OVER(
        PARTITION BY o.customer_id
        order by o.order_date ROWS BETWEEN 2 PRECEDING AND 0 PRECEDING
    ) as discount_number
from order_details od inner join orders o on o.order_id = od.order_id 



select o.order_id, o.customer_id, o.order_date,
LAG(o.order_date  , 1) OVER(
        PARTITION BY o.customer_id
        ORDER BY o.order_date
    ) as previous_order
from orders o 











