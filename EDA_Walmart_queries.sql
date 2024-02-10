show databases;
create database walmart_EDA;
use walmart_EDA;
select * from walmart_sales;

-- time_of_day
select case when time between '06:00:00' and '11:59:59' then 'Morning' when time between '12:00:00' and '17:59:59' then 'Afternoon' else 'Night' end as day_of_time from walmart_sales;
alter table walmart_sales add column time_of_day varchar(15);
update walmart_sales set time_of_day = case when time between '06:00:00' and '11:59:59' then 'Morning' when time between '12:00:00' and '17:59:59' then 'Afternoon' else 'Evening' end;

-- day name
select dayname(date) from walmart_sales;
alter table walmart_sales add column day_name varchar(15);
update walmart_sales set day_name = dayname(date);

-- month name
select monthname(date) from walmart_sales;
alter table walmart_sales add column month_name varchar(15);
update walmart_sales set month_name = monthname(date);

-- general questions

-- 1) How many unique cities does the data have?
select distinct city from walmart_sales;

-- 2) In which city is each branch?
select distinct city,branch from walmart_sales;

-- product related questions

-- 1) How many unique product lines does the data have?
select distinct product_line from walmart_sales;

-- 2) What is the most common payment method?
select max(payment_method) from walmart_sales;
select payment_method, count(payment_method) as use_count from walmart_sales group by payment_method order by use_count desc limit 1;

-- 3) What is the most selling product line?
select max(product_line) from walmart_sales;

-- 4) What is the total revenue by month?
select month_name, sum(gross_income) from walmart_sales group by month_name;

-- 5) What month had the largest COGS?
select month_name, sum(cogs) as sum_cogs from walmart_sales group by month_name order by sum_cogs desc limit 1;

-- 6) What product line had the largest revenue?
select product_line, sum(gross_income) as largest_revenue from walmart_sales group by product_line order by largest_revenue desc limit 1;

-- 7) What is the city with the largest revenue?
select city, sum(gross_income) as largest_revenue from walmart_sales group by city order by largest_revenue desc limit 1;

-- 8) What product line had the largest VAT?
select product_line, sum(VAT) as largest_VAT from walmart_sales group by product_line order by largest_VAT desc limit 1;

-- 9) Fetch each product line and add a column to those product line 
-- showing "Good", "Bad". Good if its greater than average sales
select product_line,quantity, 
		case when quantity > (select avg(quantity) from walmart_sales) then 'Good' else 'bad' end as product_line_review 
from walmart_sales;  

-- 10) Which branch sold more products than average product sold?
select sum(quantity)/3 from walmart_sales;
select branch, sum(quantity) as sum_qty from walmart_sales group by branch having sum_qty > (select sum(quantity)/3 from walmart_sales);

-- 11) What is the most common product line by gender?
select gender, product_line, count(gender) from walmart_sales group by gender,product_line order by count(*) desc;

-- 12)What is the average rating of each product line?
select product_line, avg(rating) from walmart_sales group by product_line;

-- Sales
-- 1) Number of sales made in each time of the day per weekday
select day_name,time_of_day,count(quantity) from walmart_sales group by day_name,time_of_day order by day_name; 

-- Which of the customer types brings the most revenue?
select customer_type, sum(gross_income) as revenue from walmart_sales group by customer_type order by revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select city, sum(VAT) as max_vat from walmart_sales group by city order by max_vat desc;

-- Which customer type pays the most in VAT?
select customer_type, sum(VAT) as most_VAT from walmart_sales group by customer_type order by most_VAT desc;

-- Customer

-- 1) How many unique customer types does the data have?
select distinct customer_type from walmart_sales;

-- 2) How many unique payment methods does the data have?
select distinct payment_method from walmart_sales;

-- 3) What is the most common customer type?
select customer_type, count(*) as count from walmart_sales group by customer_type order by count desc;

-- 4) Which customer type buys the most?
select customer_type, sum(total) as most_buy from walmart_sales group by customer_type order by most_buy desc;

-- 5) What is the gender of most of the customers?
select gender, count(*) as count_gender from walmart_sales group by gender order by count_gender desc limit 1;

-- 6) What is the gender distribution per branch?
select branch,gender, count(gender) from walmart_sales group by branch,gender order by branch;

-- 7) Which time of the day do customers give most ratings?
select time_of_day, count(rating) as count_rating from walmart_sales group by time_of_day order by count_rating desc;

-- 8) Which time of the day do customers give most ratings per branch?
select branch,time_of_day, count(rating) as count_rating from walmart_sales group by branch,time_of_day order by branch,count_rating desc;

-- 9) Which day fo the week has the best avg ratings?
select day_name, avg(rating) as avg_rating from walmart_sales group by day_name order by avg_rating desc;

-- 10) Which day of the week has the best average ratings per branch?
select branch, day_name, avg(rating) as avg_rating from walmart_sales group by branch,day_name order by branch,avg_rating desc;