-- Question 1
select r.region_description , t.territory_description 
from region r inner join territories t on t.region_id = r.region_id 

-- Question 2
select  c.category_name, count(*) 
from categories c inner join products p on p.category_id = c.category_id 
where p.discontinued = 1
group by c.category_name
order by count(*) desc 

--Question 3
select o.order_id, sum( od.unit_price * od.quantity * (1-od.discount) ) as "cost" 
from orders o, order_details od 
where od.order_id = o.order_id 
group by o.order_id 
order by o.order_id
------
select o.customer_id, sum( od.unit_price * od.quantity * (od.discount) )
from orders o, order_details od 
where od.order_id = o.order_id
group by o.customer_id
order by sum( od.unit_price * od.quantity * (od.discount) ) desc 
limit 10

--Question 4
select od.product_id, count(od.product_id) as "Factor number"
from order_details od
group by od.product_id 
order by count(od.product_id) desc
limit 10

--Question 5
select p.product_name 
from products p 
where not exists 
(select p.product_id
from order_details od
where od.product_id=p.product_id)

--Quesiton 6
select c.category_name, sum(od.quantity) as "product sold",count(od.order_id) as "orders"
from categories c 
left join products p on c.category_id = p.category_id 
inner join order_details od on od.product_id = p.product_id 
group by c.category_name

--Question 7
WITH temporaryTable as
    (
    SELECT od.order_id as id, sum( (od.unit_price*od.quantity)*(1-od.discount) ) as total_sale
    from order_details od
    group by od.order_id 
    )
select  e.employee_id, e.first_name, e.last_name, sum(tt.total_sale) as total_income
FROM employees e inner join orders o on o.employee_id = e.employee_id 
inner join temporaryTable tt on o.order_id = tt.id 
where date_part('year', o.order_date) = 1996 and o.order_id in (select order_id from temporaryTable) 
group by e.employee_id 
order by sum(tt.total_sale) desc
limit 1

--Question 8
SELECT o.order_id,
CASE
    WHEN o.shipped_date-o.order_date = 0 THEN 'Fantastic'
    WHEN o.shipped_date-o.order_date < 3 THEN 'Good'
    ELSE 'Not good'
END AS lable
FROM orders o;

--Question 9
with recursive company_hierarchy as (
  select  ee.employee_id,
          ee.first_name,
          ee.last_name,
          ee.reports_to,
        0 as hierarchy_level
  from employees ee
  where ee.reports_to is null
 
  union all
   
  select e.employee_id,
         e.first_name,
         e.last_name,
         e.reports_to,
         hierarchy_level + 1
  from employees e, company_hierarchy ch
  where e.reports_to = ch.employee_id
)
select ch.employee_id as employee_id,
	   ch.first_name AS employee_first_name,
       ch.last_name AS employee_last_name,
       e.first_name AS boss_first_name,
       e.last_name AS boss_last_name,
       hierarchy_level
from company_hierarchy ch, employees e
where ch.employee_id = e.employee_id
order by ch.hierarchy_level, ch.reports_to

--Question 10
create view reorder_product as 
select p.product_name, p.units_in_stock
from products p 
where p.units_in_stock < p.reorder_level 
order by units_in_stock 

select * 
from reorder_product

--Question 11
select c.category_name, count(o.order_id)
from orders o inner join order_details od on o.order_id = od.order_id 
inner join products p on p.product_id = od.product_id 
inner join categories c on c.category_id = p.category_id 
where o.ship_country = 'Germany'
group by c.category_name 
order by count(o.order_id) desc

--Question 12
select c.customer_id, c.company_name
from customers c 
where c.fax is null



