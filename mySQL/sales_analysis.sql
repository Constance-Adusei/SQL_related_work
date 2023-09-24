SELECT * FROM walmartsales.sales;

-- ------------------FEATURE ENGINEERING
/*SELECT 
     time,
     (CASE 
         WHEN 'time' BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
         WHEN 'time' BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
         ELSE 'Evening'
      END   
	  ) AS time_of_day
FROM sales;*/

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales 
SET time_of_day = (
				CASE 
         WHEN 'time' BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
         WHEN 'time' BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
         ELSE 'Evening'
      END
      );
      

-- day

/*SELECT 
     date,
     DAYNAME(date) AS day_name
FROM sales;*/

/*ALTER TABLE sales
DROP COLUMN day;*/

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);


-- month

/*SELECT 
    date,
    MONTHNAME(date)
FROM sales;*/

ALTER TABLE sales ADD COLUMN month_name VARCHAR(12);

UPDATE sales 
SET month_name = MONTHNAME(date);


-- -----------------------EDA
-- -----------------------ANSWERING BUSINESS QUESTIONS
-- -----------------------Generic
-- 1. Unique cities in the sales dataset

SELECT
     DISTINCT city
FROM sales;

-- 2. Branches in each city



-- ----------------------Product----------------
-- 1. Product lines in the dataset
SELECT 
     DISTINCT product_line
FROM sales;

-- 2. Common payment method
SELECT payment,
	COUNT(payment) AS payment_count
FROM sales
GROUP BY payment
ORDER BY payment_count DESC;

-- 3. Most sold product line

SELECT 
     product_line,
     COUNT(product_line) AS product_count
FROM sales
GROUP BY product_line
ORDER BY product_count DESC;


-- 4. Total revenue by month
SELECT 
      month_name AS month,
      SUM(total) AS total_revenue
FROM sales
GROUP BY month
ORDER BY total_revenue;

-- 5. Month that has the largest cost of goods
SELECT 
     month_name AS month,
     SUM(cogs) AS total_cost_of_goods
FROM sales
GROUP BY month
ORDER BY  total_cost_of_goods DESC;

-- 6. Product line with the most revenue
SELECT
      product_line,
      SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;


-- 7. City with the largest revenue
SELECT
      city, 
      branch,
      SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch
ORDER BY total_revenue DESC;


-- 8. Product line with the largest TAX
SELECT 
      product_line,
      AVG(tax_pct) AS avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- 9. Product line rating
SELECT 
      product_line,
      quantity,
      CASE 
      WHEN quantity >  AVG(quantity) OVER ()
      THEN 'Good'
	  ELSE 'Bad'
      END AS rating
FROM sales;




-- 10. branch that sold more products than the average product sold
SELECT 
	  branch, 
      SUM(quantity) AS quantity
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);


-- 11. Most common product line by gender
SELECT
      gender,
      product_line,
	  COUNT(gender) AS gender_count
FROM sales
GROUP BY gender, product_line
ORDER BY gender_count;


-- 12. Averege rating on each product line
SELECT 
     product_line,
     ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;





-- -----------Sales--------------------------

-- 1. Each sales made in each time of the day per week
SELECT 
      time_of_day,
      day_name,
      COUNT(*) AS total_sales
FROM sales
GROUP BY time_of_day, day_name
ORDER BY total_sales DESC;


-- 2. Customer type with the most revenue
SELECT 
     customer_type,
     SUM(total) AS total_revenue 
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- 3. city with the largest TAX
SELECT 
      city,
      ROUND(AVG(tax_pct), 2) AS VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;

-- 4. Which customer type pays the most in VAT
SELECT 
      customer_type,
      ROUND(AVG(tax_pct), 2) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;


-- -------------Customer-----------------------------
-- 1. Unique Customers in the data
SELECT
      DISTINCT customer_type,
      COUNT(customer_type) AS customer_type_count
FROM sales
GROUP BY customer_type
ORDER BY customer_type_count DESC;

-- 2. Unique payment method
SELECT
      DISTINCT payment,
      COUNT(payment) AS payment_method_count
FROM sales
GROUP BY payment
ORDER BY payment_method_count DESC;


-- 3.Customer type that buys the most
SELECT
      customer_type,
      COUNT(*) AS customer_type_count
FROM sales
GROUP BY customer_type
ORDER BY customer_type_count DESC;

-- 4.Gender of most of the customers
SELECT
      gender,
      customer_type,
      COUNT(gender) AS gender_count
FROM sales
GROUP BY gender, customer_type
ORDER BY gender_count DESC;

-- gender distribution per branch
SELECT
      gender,
      branch,
      COUNT(gender) AS gender_count
FROM sales
GROUP BY gender, branch
ORDER BY branch DESC;


-- time of the day that customers give most ratings
SELECT
      time_of_day,
      ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;


-- Which time of the day do customers give most ratings per branch?
SELECT
      time_of_day,
      branch,
      ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY time_of_day, branch
ORDER BY avg_rating DESC;

-- Which day fo the week has the best avg ratings?
SELECT
      day_name,
      ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch?
SELECT
      day_name,
      branch,
      ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY day_name, branch
ORDER BY avg_rating DESC;


 

