CREATE SCHEMA pizza_runner;
SET search_path = pizza_runner;

DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  "runner_id" INTEGER,
  "registration_date" DATE
);
INSERT INTO runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" TIMESTAMP
);

INSERT INTO customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
);

INSERT INTO runner_orders
  ("order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  "pizza_id" INTEGER,
  "pizza_name" TEXT
);
INSERT INTO pizza_names
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER,
  "toppings" TEXT
);
INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  "topping_id" INTEGER,
  "topping_name" TEXT
);
INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  
  


SELECT * FROM customer_orders;
SELECT * FROM runner_orders;
SELECT * FROM runners;
SELECT * FROM pizza_names;
SELECT * FROM pizza_recipes;
SELECT * FROM pizza_toppings;
SELECT * FROM pizza_recipes_temp;


-- DATA CLEANING
-- Data from the customer_orders table from the exclusion and 
-- The extras column have some characters that need to be clean before using.
-- exclusion column
UPDATE customer_orders
SET exclusions = CASE WHEN exclusions = '' OR exclusions = 'null' THEN NULL
                 ELSE exclusions
				 END;
				 


-- extras column
UPDATE customer_orders
SET extras = CASE WHEN extras = '' OR extras = 'null' THEN NULL
                 ELSE extras
				 END;
				 


-- creating new table for extras
-- Drop the table if it exists
DROP TABLE IF EXISTS extras;

-- Create a new table
CREATE TABLE extras AS
SELECT
    c.order_id,
    TRIM(e.value) AS topping_id
FROM customer_orders AS c
CROSS JOIN STRING_TO_ARRAY(c.extras, ',') AS e;

		
		

-- Data from the runner_orders table also need to be clean before using
-- the columns pickup_time, distance and duration cleaning
-- pickup_time cleaning
UPDATE runner_orders
SET pickup_time = CASE WHEN pickup_time = 'null' THEN NULL
                       ELSE pickup_time
				       END;

-- distance cleaning
UPDATE runner_orders
SET distance = CASE WHEN distance = 'null' THEN NULL
                    WHEN distance LIKE '%km' THEN TRIM(TRAILING 'km' from distance)
                    ELSE distance
				    END;
					
--duration cleaning
UPDATE runner_orders
SET duration = CASE WHEN duration = 'null' THEN NULL
                    WHEN duration LIKE '%mins' THEN TRIM(TRAILING 'mins' FROM duration)
					WHEN duration LIKE '%minute' THEN TRIM(TRAILING 'minute' FROM duration)
                    WHEN duration LIKE '%minutes' THEN TRIM(TRAILING 'minutes' FROM duration)
                    ELSE duration
				    END;
					
-- cancellation column cleaning
UPDATE runner_orders
SET cancellation = CASE WHEN cancellation = 'null' OR cancellation = '' THEN NULL
                        ELSE cancellation
				        END;
						
						
-- Changing the data types of some of the columns in the runner_orders table
ALTER TABLE runner_orders
ALTER COLUMN pickup_time TYPE timestamp USING pickup_time::timestamp without time zone, 
ALTER COLUMN distance TYPE numeric USING distance::numeric,
ALTER COLUMN duration TYPE integer USING duration::integer;



-- Cleaning the pizza toppings table
DROP TABLE IF EXISTS pizza_recipes_temp;
CREATE TEMP TABLE pizza_recipes_temp AS (
SELECT 
      pizza_id,
      regexp_split_to_table(toppings, ',') AS topping_id
FROM pizza_recipes);


-- modifying the datatype of the toppingd column
ALTER TABLE pizza_recipes_temp
ALTER COLUMN topping_id TYPE integer USING topping_id::integer;



-- -------- Pizza Metrics
-- 1. How many pizzas were ordered?
SELECT  
	 COUNT(order_id) AS total_pizza_ordered
FROM customer_orders;

-- 2. How many unique customer orders were made?
SELECT 
     DISTINCT order_id
FROM customer_orders;

-- 3. How many successful orders were delivered by each runner?
SELECT 
     runner_id,
	 COUNT(runner_id) AS order_delivered 
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id
ORDER BY order_delivered DESC;

-- 4. How many of each type of pizza was delivered?
SELECT 
     pizza_name,
	 COUNT(pizza_id) AS pizza_delivered
FROM runner_orders
JOIN customer_orders
USING (order_id)
JOIN pizza_names
USING (pizza_id)
WHERE cancellation IS NULL
GROUP BY pizza_name
ORDER BY pizza_delivered DESC;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT 
     customer_id,
	 pizza_name,
	 COUNT(pizza_id) AS pizza_ordered
FROM pizza_names
JOIN customer_orders
USING (pizza_id)
GROUP BY pizza_name, customer_id
ORDER BY pizza_ordered DESC;

-- 6. What was the maximum number of pizzas delivered in a single order?
SELECT 
     order_id,
	 

-- 7. For each customer, how many delivered pizzas had at least 1 change, and how many had no changes?
SELECT 
     customer_id,
	 COUNT(
	       CASE WHEN exclusions IS NOT NULL OR extras IS NOT NULL THEN 1
		                  END) AS changed_order,
						  
	 COUNT(
	       CASE WHEN exclusions IS NULL OR extras IS NULL THEN 1
	                        END) AS unchanged_order
FROM customer_orders
JOIN runner_orders
USING (order_id)
WHERE cancellation IS NULL
GROUP BY customer_id;

-- 8.  How many pizzas were delivered that had both exclusions and extras?
SELECT 
     order_id,
	 COUNT(order_id) AS both_e_e_pizza
FROM customer_orders
JOIN runner_orders
USING (order_id)
WHERE cancellation IS NULL 
      AND exclusions IS NOT NULL
	  AND extras IS NOT NULL
GROUP BY order_id
ORDER BY both_e_e_pizza;

-- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT 
     EXTRACT(HOUR FROM order_time) AS hour_of_day,
	 COUNT(order_id) AS pizza_ordered
FROM customer_orders
GROUP BY order_id, order_time
ORDER BY pizza_ordered DESC;

-- 10 What was the volume of orders for each day of the week?
SELECT
     TO_CHAR(order_time, 'Day') AS day_of_week,
	 	 COUNT(order_id) AS pizza_ordered
FROM customer_orders
GROUP BY order_id, order_time
ORDER BY pizza_ordered DESC;



-- ------B. Runner and Customer Experience-----
-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT
     runner_id,
	 EXTRACT(WEEK FROM registration_date + 3) AS week
FROM runners;

-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pick up the order?
SELECT 
      runner_id,
	  order_time,
	  pickup_time,
	  ROUND(AVG(EXTRACT(MINUTE FROM pickup_time) - EXTRACT(MINUTE FROM order_time)),1) AS average_min
FROM customer_orders
JOIN runner_orders
USING (order_id)
GROUP BY pickup_time, runner_id, order_time;

-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?


-- 4.  What was the average distance traveled for each customer?
SELECT 
     customer_id,
	 ROUND(AVG(distance),2) AS avg_distance
FROM customer_orders
JOIN runner_orders
USING (order_id)
WHERE distance IS NOT NULL
GROUP BY customer_id, distance;

-- 5. What was the difference between the longest and shortest delivery times for all orders?
SELECT 
      MAX(duration) - MIN(duration) AS delivery_time_diff
FROM runner_orders;

-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT 
	  order_id,
	  runner_id,
	  ROUND(AVG(distance / (duration :: numeric/60)), 2) AS avg_speed
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY order_id, runner_id;

-- 7. What is the successful delivery percentage for each runner?
SELECT
     






-- ------- C. Ingredient Optimization --------
-- 1. What are the standard ingredients for each pizza?
SELECT 
      pizza_id,
	   String_agg(topping_name, ',') AS standard_ingredients
FROM pizza_recipes_temp 
JOIN pizza_toppings 
USING(topping_id)
JOIN pizza_names
USING(pizza_id)
GROUP BY pizza_names, pizza_id;

-- 2. What was the most commonly added extra?
WITH extras AS (
	SELECT order_id, UNNEST(string_to_array(extras,',')) AS topping_id
    FROM customer_orders
    WHERE extras IS NOT NULL)

SELECT 
      topping_name, 
	  COUNT(topping_name) AS common_used_num
FROM extras
JOIN pizza_toppings t
ON t.topping_id = CAST(extras.topping_id AS integer)
GROUP BY topping_name 
ORDER BY common_used_num DESC;

-- 3.  What was the most commonly added exclusions?
WITH exclusions AS (
	SELECT order_id, UNNEST(string_to_array(exclusions,',')) AS topping_id
    FROM customer_orders
    WHERE exclusions IS NOT NULL)

SELECT 
      topping_name, 
	  COUNT(topping_name) AS common_used_num
FROM exclusions
JOIN pizza_toppings t
ON t.topping_id = CAST(exclusions.topping_id AS integer)
GROUP BY topping_name 
ORDER BY common_used_num DESC;


-- 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
-- Meat Lovers
-- Meat Lovers - Exclude Beef
-- Meat Lovers - Extra Bacon
-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
with extras_cte AS (
                    SELECT 
                      record_id,
                      'Extra ' + STRING_AGG(t.topping_name, ', ') as record_options
                    FROM extras e,
                         pizza_toppings t
                    WHERE e.topping_id = t.topping_id
                    GROUP BY record_id
                    ),
exclusions_cte AS
                  (
                    SELECT 
                      record_id,
                      'Exclude ' + STRING_AGG(t.topping_name, ', ') as record_options
                    FROM exclusions e,
                         pizza_toppings t
                    WHERE e.topping_id = t.topping_id
                    GROUP BY record_id
                  ),
union_cte AS
                  (
                    SELECT * FROM extras_cte
                    UNION
                    SELECT * FROM exclusions_cte
                  )

SELECT c.record_id, 
        c.order_id,
        CONCAT_WS(' - ', p.pizza_name, STRING_AGG(cte.record_options, ' - ')) as pizza_and_topping
FROM customer_orders c
JOIN pizza_names p ON c.pizza_id = p.pizza_id
LEFT JOIN union_cte cte ON c.record_id = cte.record_id
GROUP BY
	c.record_id,
	p.pizza_name,
  c.order_id
ORDER BY 1;
