-- Question 1.
-- top selling products
-- query the top 10 products by total sales value
-- include product name,total quantity sold,and total sales value


-- approach 
-- create a column called total_sale=quantity*price_per_unit at order_items

-- join order_items and products table 




ALTER TABLE order_items
ADD COLUMN total_sale FLOAT

UPDATE  order_items
SET total_sale=quantity*price_per_unit


SELECT oi.product_id,p.product_name,
sum(oi.total_sale) as "total_sale"
from order_items oi
join products p
on oi.product_id=p.product_id
group by 1,2
order by 3 desc
limit 10



--------------------------- ************ ---------------------------------------
--------------------------- ************* --------------------------------------



-- Question 2.
-- Revenue by category 
-- calculate total revenue generated by each product category
-- include the percentage contribution of each category on total revenue


-- approach join category ,product and order_items table



select 
p.category_id,
c.category_name,
sum(oi.total_Sale) as "total_sale",
sum(oi.total_sale)/(select sum(total_sale)from order_items) * 100 as "contribution"

from order_items oi
join products p
on p.product_id=oi.product_id
left join category c
on c.category_id=p.category_id

group by 1,2
order by 3 desc



-------------------------------  *********************** ----------------------------
-------------------------------  *********************** ----------------------------



-- Question 3.
-- Average order value 
-- compute the average order value from each customer
-- include only customers with more than 5 customers 

--- join customers,orders, order_items
-- AOV = total_sale/no. of orders

select 
o.customer_id,
concat(c.first_name,' ',c.last_name) as "name",
count(o.order_id) as "total_order",
sum(oi.total_sale)/count(o.order_id) as "AOV"

from customers c
join orders o
on c.customer_id=o.customer_id
left join order_items oi
on oi.order_id=o.order_id
group by 1,2
having count(o.order_id)>5


------------------------- ************* --------------------------------------
------------------------- ************** -------------------------------------


-- Question 4.
-- monthly sales trend 
-- query monthly total sales over the past year
-- display the sales trend grouping by month return current sales and previous sales


-- use a subquery to extract month year and total_Sale 
-- then use a window function LAG to find the previous sale


select 
month,
year,
total_sale as "current_month_sale",
LAG(total_sale) OVER(order by month,year ) as "last_month_sale"

from
(
select 
extract(month from o.order_date) as "month",
extract(year from o.order_date) as "year",
round(sum(oi.total_sale::numeric),2 )as "total_sale"
from orders o
join order_items as oi
on oi.order_id=o.order_id
where o.order_date>= current_date- interval '1 year'
group by 1,2

)as t1



---------------------------- ************ ----------------------------------
---------------------------- *********** ------------------------------------


-- Question 5.
-- customers with no purchases 
-- find customers who have registered but never placed an order

select * from customers
where customer_id not in(
select distinct customer_id from orders
)


---------------------- ***** ---------------------------------------------------
---------------------- **** ----------------------------------------------------


-- Question 6.
-- least selling category by state
-- identify the best selling product category for each state
-- include the total sell for that category within each state
--

-- customers->orders->prder_items->product->category
-- and use a RANK()

with ranking_table as
(
select 
c.state,
cat.category_name,
sum(oi.total_sale) as "total_sale",
RANK() OVER(PARTITION BY c.state order by sum(oi.total_sale) asc) as "rank"
from
orders o
join customers c
on o.customer_id=c.customer_id
join order_items oi
on o.order_id=oi.order_id
join  products p
on oi.product_id=p.product_id
join category  cat
on cat.category_id=p.category_id
group by 1,2
)

select state,category_name,total_sale from ranking_table
where rank =1

------------------------------- ******** ----------------------------------
------------------------------- ******** ----------------------------------



-- Question 7.
-- customer lifetime value
-- calculate the total value of orders placed by each customer over their life time
-- rank customer based on the customer life time value 


-- join customer ->orders ->order_items
-- customer_id group by sum(total_sale)
-- order by total sale
-- rank()



select 
o.customer_id,
concat(c.first_name,' ',c.last_name) as "name",
sum(total_sale) as "CTLV",
DENSE_RANK() OVER(ORDER BY sum(total_sale) desc) as "cx_ranking"
from customers c
join orders o
on c.customer_id=o.customer_id
left join order_items oi
on oi.order_id=o.order_id
group by 1,2
order by 3 desc




------------------- ******* -----------------------------
------------------- ******* -----------------------------

-- Question 8.
-- inventory stock alerts
-- query products with stock levels below a certain threshold(e.g. less than 10 units)
-- include last restock date and warehouse information




select 
i.inventory_id,
p.product_name,
i.stock as "current_stock_left",
i.last_stock_date,
i.warehouse_id
from inventory i
join products p
on p.product_id=i.product_id
where stock<10



---------------- ****** ------------------------------------------
---------------- ****** ------------------------------------------




-- Question 9.
-- identify orders where the shipping date is later than 3 days after the order date
-- include customer order details and delivery provider

-- customer - orders - shipping join


select 
c.*,
o.*,
s.shipping_providers,
s.shipping_date-o.order_date as "day_took_to_ship"
from orders o
join customers c
on c.customer_id=o.customer_id
join shippings s
on o.order_id=s.order_id
where s.shipping_date-o.order_date>3




---------------------- *********** -----------------------------------------
--------------------- ************* ----------------------------------------





-- Question 10.
-- calculate the percentage of successful payments across all orders 
-- include breakdown by payment status (failed,pending)


select payment_status,
count(payment_status)  as "total_payment",
(COUNT(payment_status) * 100.0 / (SELECT COUNT(*) FROM payments)) AS percentage
from payments 
group by 1
order by 2 desc



---------------- *********** ------------------------------------------
---------------- *********** ------------------------------------------



-- Question 11.
-- top performing sellers
-- find the top 5 sellers based on sale value
-- include both successful and failed orders and display their percentage 



-- use top_seller as cte join orders -> sellers -> order_items
-- create another cte called seller_report join seller_report and orders and count the total_order (count*)
-- use case statement to calculate the complete and cancled number 

with top_seller as 

(
	select
 s.seller_id,
 s.seller_name,
 sum(oi.total_sale)
 from
orders o
join sellers s
on o.seller_id=s.seller_id
join order_items oi
on oi.order_id=o.order_id
group by 1,2
order by 3 desc
limit 5
),
seller_report as
(
	select
	o.seller_id,
	ts.seller_name,
	o.order_status,
	count(*) as "total_order"
	from orders o
	join top_seller ts
	on ts.seller_id=o.seller_id
	where order_status not in ('Inprogress','Returned')
	group by 1,2,3
	
 )
 
 select
 seller_id,
 seller_name,
 sum(case when order_status='Completed' then total_order end ) as "order_completed",
 sum(case when order_status='Cancelled' then total_order end ) as "order_cancelled",
 sum(total_order),
  sum(case when order_status='Completed' then total_order end ) :: numeric / sum(total_order) * 100 
  as "success_percentage"
 from seller_report
 group by 1,2
 order by 1




------------------- ******* ----------------------------
------------------- ******** ---------------------------




-- Question 12.
-- product profit margin
-- calculate the profit margin for each product(difference between price and cost of goods sold)
-- ranking products by their profit margin showing highest to lowest

-- profit margin = total_sale - (cost of goods sale * quantity)/ total_sale *100
-- use DENSE_RANK()



select 
product_id,
product_name,
DENSE_RANK() OVER(order by profit_margin desc) as "rank"
from

(
	select 
p.product_id,
p.product_name,
sum(oi.total_sale-(p.cogs*oi.quantity))/sum(oi.total_sale) *100 as "profit_margin"
from order_items oi
join products  p
on oi.product_id=p.product_id
group by 1,2
) as t1



---------- *******--------------------------
---------- ******* -------------------------




-- Question 13.
-- most returned product
-- query the top products by the number of returns 
-- display the return rate as a percentage of total units sold

select 
p.product_id,
p.product_name,
count(*) as "total_unit_sold",
sum(case when order_status='Returned' then 1 else 0 end) as "total_returned",
sum(case when order_status='Returned' then 1 else 0 end)::numeric /count(*)::numeric as "return_percentage" 
from order_items oi
join products p 
on oi.product_id=p.product_id
join orders o
on o.order_id=oi.order_id
group by 1,2


------------- ****** -----------------------------------
------------- ****** -----------------------------------


-- Question 14.
-- inactive sellers 
-- identify sellers who haven't made any salles in last 6 months


select * from sellers
where seller_id not in(select seller_id from orders where order_date>= current_date - interval '6 month')



---------------------- ************ ---------------------------
----------------------- ************ --------------------------



