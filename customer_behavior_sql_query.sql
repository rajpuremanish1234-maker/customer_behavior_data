--q1 what is the total revenue genrated by male & female customers ?
select gender ,sum(purchase_amount) as revenue
from customer 
group by gender

--q2 which customer used discount but still spend more than the average perchase amount?
select customer_id,purchase_amount
from customer
where discount_applied='yes' and purchase_amount >=(select AVG(purchase_amount)from customer)

---q3 which are the tow 5 products which has higest avg review rating ?
select item_purchased,ROUND(AVG(review_rating::numeric),2) as "average product rating"
from customer
group by item_purchased
order by avg(review_rating) desc 
limit 5;

--q4 compare the average purchase amount with stand and express shipping ?
select shipping_type,
ROUND(AVG(purchase_amount),2)
from customer 
where shipping_type in ('standard','express shiping')
group by shipping_type;

--q5 do subscribed customer spend more ? compare avg spend and total revenue between subscriber and non subscriber 
select * from customer ; 
select subscription_status ,
COUNT(customer_id ) as total_customer, 
AVG(purchase_amount ) as avg_spend ,
SUM(purchase_amount)as total_revenue
from customer 
group by subscription_status 
order by total_revenue,avg_spend desc;

---6 which 5 products have the higest perchentage of purchase with discount applied ??
select item_purchased,
ROUND(100*SUM(case when discount_applied='yes' then 1 else 0 end )/COUNT(*),2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit(5)
---q7  segment customer into new , loyal amd returning on bases of their purchases?
with customer_type as (
select customer_id ,previous_purchases,
CASE 
     WHEN previous_purchases=1 THEN 'New'
	 WHEN previous_purchases between 2 and 10 then 'returning'
	 else 'loyal'
	 end as customer_segment
from customer)

select customer_segment ,COUNT(*) AS "NUMBER OF CUSTOMER"
from customer_type
group by customer_segment 

---q8 what are the top 3 most purchased products within each category ?

WITH item_count AS (
    SELECT 
        category, 
        item_purchased,
        COUNT(customer_id) AS total_orders,
        ROW_NUMBER() OVER(
            PARTITION BY category 
            ORDER BY COUNT(customer_id) DESC
        ) AS rn
    FROM customer
    GROUP BY category, item_purchased
)

SELECT * 
FROM item_count;

---q9 are customer who are repeate buyers more than 5 previous purchases also likely to subscribe 

select subscription_status ,
count(customer_id) as repeat_buyers
from customer 
where previous_purchases>5
group by  subscription_status

---q10  what is the revenue contribution for each age group ?

select age_group ,
sum(purchase_amount) as total_revenue 
from customer 
group by age_group 
order by total_revenue desc;