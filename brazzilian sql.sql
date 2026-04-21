create database brazillianEcommerce;
use  brazillianEcommerce;

CREATE TABLE olist_master (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,
    delivery_days INT,
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10),
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g DECIMAL(10,2),
    product_length_cm DECIMAL(10,2),
    product_height_cm DECIMAL(10,2),
    product_width_cm DECIMAL(10,2),
    payment_sequential INT,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value DECIMAL(10,2),
    product_category_name_english VARCHAR(100),
    month VARCHAR(10),
    year INT,
    review_score DECIMAL(3,2),
    month_name VARCHAR(20),
    estimated_days INT,
    is_late TINYINT(1)
);
SET GLOBAL local_infile = 1;
LOAD DATA LOCAL INFILE 'C:/Users/Gaurav/olist_master.csv'
INTO TABLE olist_master
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS total_rows FROM olist_master;
describe olist_master;


-- Q1: Overall Business Summary
SELECT 
    COUNT(DISTINCT order_id)     AS total_orders,
    SUM(price)                   AS total_revenue,
    AVG(price)                   AS avg_order_value,
    AVG(delivery_days)           AS avg_delivery_days,
    AVG(review_score)            AS avg_review_score
FROM olist_master;

-- MONTHLY REVENUE TREND
-- How revenue changed month by month
SELECT month,COUNT(DISTINCT order_id)  AS total_orders,
SUM(price)AS revenue
FROM olist_master
GROUP BY month
ORDER BY month;

-- TOP 10 PRODUCT CATEGORIES BY REVENUE
-- Which categories made the most money
SELECT product_category_name_english   AS category,
COUNT(DISTINCT order_id)        AS total_orders,
SUM(price)                      AS revenue
FROM olist_master
WHERE product_category_name_english != 'Unknown'
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;


-- AVERAGE DELIVERY DAYS BY STATE
-- Which states get fastest and slowest delivery
SELECT customer_state,
AVG(delivery_days)            AS avg_delivery_days,
COUNT(DISTINCT order_id)      AS total_orders
FROM olist_master
GROUP BY customer_state
ORDER BY avg_delivery_days ASC;


-- Payment Method Distribution
-- Which payment methods customers prefer
SELECT payment_type, COUNT(*)   AS total_orders,
COUNT(*) * 100.0 / (SELECT COUNT(*) 
 FROM olist_master)          AS percentage,
SUM(payment_value)       AS total_value
FROM olist_master
GROUP BY payment_type
ORDER BY total_orders DESC;


-- Review Score Distribution
-- How satisfied were customers
SELECT review_score,
COUNT(*)  AS total_reviews,
COUNT(*) * 100.0 / (SELECT COUNT(*) 
 FROM olist_master)          AS percentage
FROM olist_master
GROUP BY review_score
ORDER BY review_score;


-- Top 10 Cities by Orders
-- Which cities ordered the most
SELECT  customer_city,customer_state,
 COUNT(DISTINCT order_id)    AS total_orders,
SUM(price)      AS revenue
FROM olist_master
GROUP BY customer_city, customer_state
ORDER BY total_orders DESC
LIMIT 10;


-- How many orders were delivered late
SELECT COUNT(*)        AS total_orders,
SUM(is_late)     AS late_orders,
SUM(is_late) * 100.0 / COUNT(*)     AS late_percentage
FROM olist_master;


-- Peak Sales Month
-- Which single month had highest revenue
SELECT month,SUM(price)   AS revenue,
COUNT(DISTINCT order_id)    AS total_orders
FROM olist_master
GROUP BY month
ORDER BY revenue DESC
LIMIT 1;


-- Review Score vs Delivery Time
-- Do late deliveries cause bad reviews?
SELECT 
    CAST(review_score AS UNSIGNED)  AS review_score,
    AVG(delivery_days)              AS avg_delivery_days,
    COUNT(DISTINCT order_id)        AS total_orders
FROM olist_master
GROUP BY review_score
ORDER BY review_score;