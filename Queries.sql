/*1. Provide the list of markets in which customer "Atliq Exclusive" operates its
business in the APAC region.*/


select market 
from dim_customer
where customer='atliq exclusive' and region='apac'
group by market
order by market;



/*2. What is the percentage of unique product increase in 2021 vs. 2020? The 
final output contains these fields,
unique_products_2020
unique_products_2021
percentage_chg*/


WITH unique_products_2020 as (
select count(distinct(product_code)) as unique_count_2020
from fact_sales_monthly
where fiscal_year=2020
),
unique_products_2021 as(
select count(distinct(product_code)) as unique_count_2021
from fact_sales_monthly
where fiscal_year=2021
)
select * , round((unique_count_2020 - unique_count_2021 )*100/ unique_count_2021,2) as percentage_chg
from unique_products_2020,unique_products_2021;



/*3. Provide a report with all the unique product counts for each segment and
sort them in descending order of product counts. The final output contains
2 fields,
segment
product_count*/


select segment, count(distinct product_code) as product_count
from dim_product
group by segment
order by product_count desc;



/*4. Follow-up: Which segment had the most increase in unique products in
2021 vs 2020? The final output contains these fields,
segment,product_count_2020,
product_count_2021,difference*/


WITH cte1 as (
select p.segment as segment, count(distinct(s.product_code)) as product_count_2020
from fact_sales_monthly as s
join dim_product as p
on p.product_code=s.product_code
where fiscal_year=2020
group by segment
),
cte2 as (
select p.segment , count(distinct(s.product_code)) as product_count_2021
from fact_sales_monthly as s
join dim_product as p
on p.product_code=s.product_code
where fiscal_year=2021
group by segment
)
select cte1.segment,cte1.product_count_2020,
	cte2.product_count_2021, 
    (cte2.product_count_2021 - product_count_2020) as difference
from cte1
join cte2
on cte1.segment=cte2.segment
order by difference desc;



/*5. Get the products that have the highest and lowest manufacturing costs.
The final output should contain these fields,
product_code
product
manufacturing_cost*/


select m.product_code, p.product, m.manufacturing_cost
from fact_manufacturing_cost as m
join dim_product as p
on m.product_code=p.product_code
where m.manufacturing_cost in ( 
      select max(manufacturing_cost) from fact_manufacturing_cost
      union
      select min(manufacturing_cost) from fact_manufacturing_cost
      )
order by manufacturing_cost desc;
 
 
 
 /*6. Generate a report which contains the top 5 customers who received an
average high pre_invoice_discount_pct for the fiscal year 2021 and in the
Indian market. The final output contains these fields,
customer_code
customer
average_discount_percentage*/


with cte as (select customer_code, avg(pre_invoice_discount_pct) as average
from fact_pre_invoice_deductions
where fiscal_year=2021
group by customer_code
)
select c.customer_code, c.customer,cte.average 
from cte
join dim_customer as c
on cte.customer_code=c.customer_code
where c.market="india"
order by cte.average desc
limit 5;



/*7. Get the complete report of the Gross sales amount for the customer “Atliq
Exclusive” for each month. This analysis helps to get an idea of low and
high-performing months and take strategic decisions.
The final report contains these columns:
Month
Year
Gross sales Amount*/


select CONCAT(MONTHNAME(fs.date), ' (', YEAR(fs.date), ')') AS 'month', fs.fiscal_year,
       ROUND(SUM(g.gross_price*fs.sold_quantity), 2) AS gross_sales_Amount
from fact_sales_monthly as fs 
join dim_customer c 
on fs.customer_code = c.customer_code 
join fact_gross_price g 
on fs.product_code = g.product_code
where c.customer = 'Atliq Exclusive'
group by month, fs.fiscal_year 
order by fs.fiscal_year;



/*8. In which quarter of 2020, got the maximum total_sold_quantity? The final
output contains these fields sorted by the total_sold_quantity,
Quarter
total_sold_quantity*/


SELECT 
    (CASE
        WHEN date BETWEEN '2020-01-01' AND '2020-03-31' THEN 'Q1'
        WHEN date BETWEEN '2020-04-01' AND '2020-06-30' THEN 'Q2'
        WHEN date BETWEEN '2020-07-01' AND '2020-09-30' THEN 'Q3'
        WHEN date BETWEEN '2020-10-01' AND '2020-12-31' THEN 'Q4'
	END ) AS Quarter,
    SUM(sold_quantity) AS total_sold_quantity
FROM fact_sales_monthly
WHERE fiscal_year = 2020
GROUP BY Quarter
ORDER BY total_sold_quantity DESC;



/*9. Which channel helped to bring more gross sales in the fiscal year 2021
and the percentage of contribution? The final output contains these fields,
channel
gross_sales_mln
percentage*/



with cte as (
select s.customer_code,g.product_code, g.gross_price, s.sold_quantity, s.fiscal_year
from fact_gross_price as g
join fact_sales_monthly as s
on g.product_code=s.product_code),
channel_sales as (
select c.channel, 
	   round(sum((cte.gross_price*cte.sold_quantity)/1000000),2) as gross_sales_mln
from dim_customer as c
join cte
on c.customer_code=cte.customer_code
where cte.fiscal_year=2021
group by c.channel
)
select cs.channel,
       cs.gross_sales_mln, 
       round((cs.gross_sales_mln*100/(select sum(gross_sales_mln) from channel_sales)),2) as percentage
from channel_sales as cs
order by gross_sales_mln desc;



/*10. Get the Top 3 products in each division that have a high
total_sold_quantity in the fiscal_year 2021? The final output contains these fields,
division
product_code
product
total_sold_quantity
rank_order*/ 


with cte as (
select p.product_code, p.division, p.product, 
       sum(s.sold_quantity) as total_sold_quantity
from  dim_product as p
join fact_sales_monthly as s
on p.product_code=s.product_code
group by p.division,p.product_code,p.product
),
cte_ranks as (
select division, product_code, product, total_sold_quantity,
       rank() over(partition by division order by total_sold_quantity desc) as rank_orders
from cte)
select * 
from cte_ranks
where rank_orders<4;



/*11. Number of products that were 
discontinued in year 2021 from 2020 */ 


select distinct p.product_code, p.product, p.segment,s.fiscal_year
from fact_sales_monthly as s
join dim_product as p
on s.product_code=p.product_code
where p.product_code not in (select distinct product_code
		                     from fact_sales_monthly
		                      where fiscal_year=2021 ) 
   and fiscal_year=2020;
                           


















