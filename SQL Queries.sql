/************************** Orders Table Creation *************************/
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

SELECT COUNT(*) FROM orders;
SELECT * FROM orders LIMIT 5;

SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id_nulls,
    SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) AS order_status_nulls,
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS purchase_time_nulls,

    SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS approved_at_nulls,
    SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS carrier_date_nulls,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS customer_delivery_nulls,
    SUM(CASE WHEN order_estimated_delivery_date IS NULL THEN 1 ELSE 0 END) AS estimated_delivery_nulls
FROM orders;

SELECT order_id,COUNT(*) AS count_rows FROM orders GROUP BY order_id HAVING COUNT(*) > 1;


/************************* Order Items Table Creation **********************/
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);

SELECT COUNT(*) FROM order_items;
SELECT * FROM order_items LIMIT 5;

SELECT
    COUNT(*) AS total_rows, SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
    SUM(CASE WHEN order_item_id IS NULL THEN 1 ELSE 0 END) AS order_item_id_nulls,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS product_id_nulls,
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS seller_id_nulls,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS price_nulls,
    SUM(CASE WHEN freight_value IS NULL THEN 1 ELSE 0 END) AS freight_nulls 
FROM order_items;

SELECT
    order_id,
    order_item_id,
    COUNT(*) AS count_rows
FROM order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;


/************************** Payments Table Creation *************************/
CREATE TABLE payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);

SELECT COUNT(*) FROM payments;
SELECT * FROM payments LIMIT 5;

SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
    SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END) AS payment_type_nulls,
    SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END) AS payment_value_nulls
FROM payments;


/************************* Products Table Creation ************************/
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(50),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

SELECT COUNT(*) FROM products;
SELECT * FROM products LIMIT 5;

SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS category_nulls,
    SUM(CASE WHEN product_name_length IS NULL THEN 1 ELSE 0 END) AS name_length_nulls,
    SUM(CASE WHEN product_description_length IS NULL THEN 1 ELSE 0 END) AS desc_length_nulls,
    SUM(CASE WHEN product_photos_qty IS NULL THEN 1 ELSE 0 END) AS photos_nulls,

    SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END) AS weight_nulls,
    SUM(CASE WHEN product_length_cm IS NULL THEN 1 ELSE 0 END) AS length_nulls,
    SUM(CASE WHEN product_height_cm IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN product_width_cm IS NULL THEN 1 ELSE 0 END) AS width_nulls
FROM products;

/**************************** Create View ******************************/
CREATE VIEW products_clean AS
SELECT
    product_id,
    COALESCE(product_category_name, 'unknown') AS product_category_name,
    COALESCE(product_name_length, 0) AS product_name_length,
    COALESCE(product_description_length, 0) AS product_description_length,
    COALESCE(product_photos_qty, 0) AS product_photos_qty,

    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM products;

select * from products_clean;
drop view products_clean;

/****************************** Create View ******************************/
CREATE VIEW products_final AS
WITH medians AS (
    SELECT
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_weight_g) AS median_weight,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_length_cm) AS median_length,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_height_cm) AS median_height,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_width_cm) AS median_width FROM products)
SELECT
    p.product_id,
    COALESCE(p.product_category_name, 'unknown') AS product_category_name,
    COALESCE(p.product_name_length, 0) AS product_name_length,
    COALESCE(p.product_description_length, 0) AS product_description_length,
    COALESCE(p.product_photos_qty, 0) AS product_photos_qty,

    COALESCE(p.product_weight_g, m.median_weight) AS product_weight_g,
    COALESCE(p.product_length_cm, m.median_length) AS product_length_cm,
    COALESCE(p.product_height_cm, m.median_height) AS product_height_cm,
    COALESCE(p.product_width_cm, m.median_width) AS product_width_cm
FROM products p
CROSS JOIN medians m;

SELECT COUNT(*) FROM products_final;
SELECT * FROM products_final WHERE product_category_name = 'unknown' LIMIT 5;


/*********************** Customers Table Creation **********************/
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(50),
    customer_state VARCHAR(5)
);

SELECT COUNT(*) FROM customers;
SELECT * FROM customers LIMIT 5;

SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id_nulls,
    SUM(CASE WHEN customer_unique_id IS NULL THEN 1 ELSE 0 END) AS customer_unique_id_nulls,
    SUM(CASE WHEN customer_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS zip_nulls,
    SUM(CASE WHEN customer_city IS NULL THEN 1 ELSE 0 END) AS city_nulls,
    SUM(CASE WHEN customer_state IS NULL THEN 1 ELSE 0 END) AS state_nulls
FROM customers;

SELECT
    customer_id,
    COUNT(*) AS cnt
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


/*************************** Sellers Table Creation ***********************/
CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(50),
    seller_state VARCHAR(5)
);

SELECT COUNT(*) FROM sellers;
SELECT * FROM sellers LIMIT 5;

SELECT
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS seller_id_nulls,
    SUM(CASE WHEN seller_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS zip_nulls,
    SUM(CASE WHEN seller_city IS NULL THEN 1 ELSE 0 END) AS city_nulls,
    SUM(CASE WHEN seller_state IS NULL THEN 1 ELSE 0 END) AS state_nulls
FROM sellers;

SELECT seller_id, COUNT(*)
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;


/*************************** Reviews Table Creation ***********************/
CREATE TABLE reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

SELECT COUNT(*) FROM reviews;
SELECT * FROM reviews LIMIT 5;
	
SELECT
    SUM(CASE WHEN review_id IS NULL THEN 1 ELSE 0 END) AS review_id_nulls,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
    SUM(CASE WHEN review_score IS NULL THEN 1 ELSE 0 END) AS score_nulls,
    SUM(CASE WHEN review_comment_title IS NULL THEN 1 ELSE 0 END) AS title_nulls,
    SUM(CASE WHEN review_comment_message IS NULL THEN 1 ELSE 0 END) AS message_nulls,
    SUM(CASE WHEN review_creation_date IS NULL THEN 1 ELSE 0 END) AS creation_nulls,
    SUM(CASE WHEN review_answer_timestamp IS NULL THEN 1 ELSE 0 END) AS answer_nulls
FROM reviews;

SELECT review_id, COUNT(*)
FROM reviews
GROUP BY review_id
HAVING COUNT(*) > 1;

SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp,
    COUNT(*) AS cnt
FROM reviews
GROUP BY
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
HAVING COUNT(*) > 1;

ALTER TABLE reviews
ADD COLUMN review_row_id SERIAL PRIMARY KEY;


/*************************** Geolocation Table Creation *********************/
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat DOUBLE PRECISION,
    geolocation_lng DOUBLE PRECISION,
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(10)
);

SELECT COUNT(*) FROM geolocation;
SELECT * FROM geolocation LIMIT 5;

SELECT
    SUM(CASE WHEN geolocation_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS zip_nulls,
    SUM(CASE WHEN geolocation_lat IS NULL THEN 1 ELSE 0 END) AS lat_nulls,
    SUM(CASE WHEN geolocation_lng IS NULL THEN 1 ELSE 0 END) AS lng_nulls,
    SUM(CASE WHEN geolocation_city IS NULL THEN 1 ELSE 0 END) AS city_nulls,
    SUM(CASE WHEN geolocation_state IS NULL THEN 1 ELSE 0 END) AS state_nulls
FROM geolocation;


/********************** Category Name Translation Table ********************/
CREATE TABLE product_category_name_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);

SELECT COUNT(*) FROM product_category_name_translation;

SELECT
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS cat_nulls,
    SUM(CASE WHEN product_category_name_english IS NULL THEN 1 ELSE 0 END) AS eng_nulls
FROM product_category_name_translation;

SELECT product_category_name, COUNT(*)
FROM product_category_name_translation
GROUP BY product_category_name
HAVING COUNT(*) > 1;

ALTER TABLE product_category_name_translation
ADD PRIMARY KEY (product_category_name);


/**************************** Delivey Analysis ***************************/
/*************************** Total Orders By Status **********************/
SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

/********************* Delivered vs Undelivered Orders *********************/
SELECT
    CASE 
        WHEN order_status = 'delivered' THEN 'Delivered'
        ELSE 'Not Delivered'
    END AS delivery_group,
    COUNT(*) AS total_orders
FROM orders
GROUP BY delivery_group;

/************************ Delivery Delay Analysis ***********************/
SELECT
    COUNT(*) AS delivered_orders,
    SUM(
        CASE
            WHEN order_delivered_customer_date > order_estimated_delivery_date
            THEN 1 ELSE 0
        END
    ) AS late_orders,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN order_delivered_customer_date > order_estimated_delivery_date
                THEN 1 ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS late_delivery_percentage
FROM orders
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NOT NULL;

/************************ deliveries review scores ***********************/
SELECT
    CASE
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
        THEN 'Late'
        ELSE 'On Time'
    END AS delivery_status,
    COUNT(*) AS total_reviews,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM orders o
JOIN reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY delivery_status;

/************************* Sellers deliveriy Analysis *********************/
SELECT
    oi.seller_id,
    COUNT(*) AS total_orders,
    SUM(
        CASE
            WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
            THEN 1 ELSE 0
        END
    ) AS late_orders,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
                THEN 1 ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS late_percentage
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id
HAVING COUNT(*) > 50
ORDER BY late_percentage DESC
LIMIT 10;

/********************* Delivery Analysis By Customer State ******************/
SELECT
    c.customer_state,
    COUNT(*) AS total_orders,
    SUM(
        CASE
            WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
            THEN 1 ELSE 0
        END
    ) AS late_orders,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
                THEN 1 ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS late_percentage
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
HAVING COUNT(*) > 100
ORDER BY late_percentage DESC;

/********************************* Analysis *******************************/
SELECT COUNT(*) FROM orders;

SELECT *FROM orders LIMIT 5;

SELECT COUNT(DISTINCT order_id) FROM orders;

SELECT order_id,
    order_purchase_timestamp,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM orders WHERE order_delivered_customer_date IS NOT NULL LIMIT 5;

SELECT order_id,
    order_status,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    CASE
        WHEN order_status != 'delivered' THEN 'not_delivered'
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'on_time'
        ELSE 'late'
    END AS delivery_status FROM orders LIMIT 10;

/******************************* create View ****************************/
CREATE OR REPLACE VIEW order_delivery_performance AS
SELECT order_id, customer_id, order_status,
    order_purchase_timestamp,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    CASE
        WHEN order_status != 'delivered' THEN 'not_delivered'
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'on_time'
        ELSE 'late'END AS delivery_status FROM orders;

SELECT * FROM order_delivery_performance LIMIT 10;

SELECT * FROM customers LIMIT 5;

/************************************ Joins *********************************/
SELECT
    o.order_id,
    o.delivery_status,
    c.customer_state
FROM order_delivery_performance o
JOIN customers c
ON o.customer_id = c.customer_id LIMIT 10;

SELECT
    c.customer_state,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN o.delivery_status = 'late' THEN 1 ELSE 0 END) AS late_orders,
    ROUND(
        100.0 * SUM(CASE WHEN o.delivery_status = 'late' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS late_percentage
FROM order_delivery_performance o
JOIN customers c
ON o.customer_id = c.customer_id
WHERE o.delivery_status != 'not_delivered'
GROUP BY c.customer_state
ORDER BY late_percentage DESC;


/****************************** Order Analysis **************************/
/***************************** Total Orders ***************************/
SELECT COUNT(*) AS total_orders FROM orders;

/**************************** Total Orders by Status **************************/
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

/**************************** Orders in a month ************************/
SELECT
    DATE_TRUNC('month', order_purchase_timestamp) AS month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;


/**************************** Payments Analysis *************************/
/********************** Total Payment Type Transactions *******************/
SELECT
    payment_type,
    COUNT(*) AS total_transactions
FROM payments
GROUP BY payment_type
ORDER BY total_transactions DESC;

/*************************** Payment Type Revenue ************************/
SELECT
    payment_type,
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM payments
GROUP BY payment_type
ORDER BY total_revenue DESC;


/*************************** Customer Analysis***************************/
/***************************** Total Customers ************************/
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM customers;

/************************* Total Customers by State ***********************/
SELECT
    customer_state,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;

/*********************** Total customers per type ************************/
SELECT
    customer_type,
    COUNT(*) AS total_customers
FROM (
    SELECT
        customer_id,
        CASE
            WHEN COUNT(order_id) > 1 THEN 'Repeat Customer'
            ELSE 'One-time Customer'
        END AS customer_type
    FROM orders
    GROUP BY customer_id
) sub
GROUP BY customer_type;


/****************************** Product Analysis ***************************/
/************************** Total items by product ID **********************/
SELECT
    product_id,
    COUNT(*) AS total_items_sold
FROM order_items
GROUP BY product_id
ORDER BY total_items_sold DESC
LIMIT 10;

/************************ Total items by Category **************************/
SELECT
    ct.product_category_name_english AS category,
    COUNT(*) AS total_items_sold
FROM order_items oi
JOIN products_final p
    ON oi.product_id = p.product_id
JOIN product_category_name_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY category
ORDER BY total_items_sold DESC;

/*********************** product total revenue *************************/
SELECT
    product_id,
    ROUND(SUM(price), 2) AS total_revenue
FROM order_items
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 10;


/**************************** Sellers Analysis **************************/
/************************* Sellers Total Orders *************************/
SELECT
    seller_id,
    COUNT(DISTINCT order_id) AS total_orders
FROM order_items
GROUP BY seller_id
ORDER BY total_orders DESC
LIMIT 10;

/************************ Seller Revenue Contribution ********************/
SELECT
    seller_id,
    ROUND(SUM(price), 2) AS total_revenue
FROM order_items
GROUP BY seller_id
ORDER BY total_revenue DESC
LIMIT 10;

/************************ Seller Delivery Performance *********************/
SELECT
    oi.seller_id,
    COUNT(*) AS total_orders,
    SUM(
        CASE
            WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
            THEN 1 ELSE 0
        END
    ) AS late_orders,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
                THEN 1 ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS late_percentage
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id
HAVING COUNT(*) > 50
ORDER BY late_percentage DESC
LIMIT 10;


/************************ Overall Delivery Performance ***********************/
SELECT
    CASE
        WHEN order_delivered_customer_date > order_estimated_delivery_date
        THEN 'Late'
        ELSE 'On Time'
    END AS delivery_status,
    COUNT(*) AS total_orders
FROM orders
WHERE order_status = 'delivered'
GROUP BY delivery_status;


/**************************** Review Analysis *****************************/
/*********************** Total Reviews By Review Score ********************/
SELECT
    review_score,
    COUNT(*) AS total_reviews
FROM reviews
GROUP BY review_score
ORDER BY review_score;

/*************************** delivery Review Score **********************/
SELECT ROUND(AVG(review_score), 2) AS avg_review_score FROM reviews;

SELECT
    CASE
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
        THEN 'Late Delivery'
        ELSE 'On Time Delivery'
    END AS delivery_status,
    COUNT(r.review_id) AS total_reviews,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM orders o
JOIN reviews r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY delivery_status;

/*************************** Review Score Count ***************************/
SELECT
    r.review_score,
    COUNT(*) AS review_count
FROM orders o
JOIN reviews r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date > o.order_estimated_delivery_date
GROUP BY r.review_score
ORDER BY review_score;

/************************* Total reviews by Category ***********************/
SELECT
    ct.product_category_name_english AS category,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    COUNT(*) AS total_reviews
FROM reviews r
JOIN order_items oi
    ON r.order_id = oi.order_id
JOIN products_final p
    ON oi.product_id = p.product_id
JOIN product_category_name_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY category
HAVING COUNT(*) > 100
ORDER BY avg_review_score ASC
LIMIT 10;

/**************************Total Reviews By Seller ****************************/
SELECT
    oi.seller_id,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    COUNT(*) AS total_reviews
FROM reviews r
JOIN order_items oi
    ON r.order_id = oi.order_id
GROUP BY oi.seller_id
HAVING COUNT(*) > 50
ORDER BY avg_review_score ASC
LIMIT 10;


/****************************  location analysis *****************************/
/******************************** Creat View ******************************/
CREATE OR REPLACE VIEW orders_customers AS
SELECT
    o.order_id,
    o.order_status,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    c.customer_id,
    c.customer_state
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id;

/**************************** Ctreate View *******************************/
CREATE OR REPLACE VIEW payments_per_order AS
SELECT
    order_id,
    SUM(payment_value) AS order_revenue
FROM payments
GROUP BY order_id;

/*************************** Total orders by State ************************/
SELECT
    customer_state,
    COUNT(*) AS total_orders
FROM orders_customers
GROUP BY customer_state
ORDER BY total_orders DESC;

/************************** Total Revenue by State ************************/
SELECT
    oc.customer_state,
    ROUND(SUM(p.order_revenue), 2) AS total_revenue
FROM orders_customers oc
JOIN payments_per_order p
    ON oc.order_id = p.order_id
GROUP BY oc.customer_state
ORDER BY total_revenue DESC;

/************************** Avg Orders by State *************************/
SELECT
    oc.customer_state,
    ROUND(SUM(p.order_revenue) / COUNT(DISTINCT oc.order_id), 2) AS avg_order_value
FROM orders_customers oc
JOIN payments_per_order p
    ON oc.order_id = p.order_id
GROUP BY oc.customer_state
ORDER BY avg_order_value DESC;

/************************* State delivey performance ********************/
SELECT
    customer_state,
    COUNT(*) AS total_delivered_orders,
    SUM(
        CASE
            WHEN order_delivered_customer_date > order_estimated_delivery_date
            THEN 1 ELSE 0
        END
    ) AS late_orders,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN order_delivered_customer_date > order_estimated_delivery_date
                THEN 1 ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS late_delivery_percentage
FROM orders_customers
WHERE order_status = 'delivered'
GROUP BY customer_state
HAVING COUNT(*) > 100
ORDER BY late_delivery_percentage DESC;


/****************************** Create View *******************************/
CREATE OR REPLACE VIEW customers_per_state AS
SELECT
    customer_state,
    COUNT(DISTINCT customer_id) AS total_customers
FROM customers
GROUP BY customer_state;

/*************************** Create view *****************************/
CREATE OR REPLACE VIEW sellers_per_state AS
SELECT
    seller_state,
    COUNT(DISTINCT seller_id) AS total_sellers
FROM sellers
GROUP BY seller_state;

/******************* Total Customers & Sellers by State ******************/
SELECT
    c.customer_state,
    c.total_customers,
    COALESCE(s.total_sellers, 0) AS total_sellers
FROM customers_per_state c
LEFT JOIN sellers_per_state s
    ON c.customer_state = s.seller_state
ORDER BY c.total_customers DESC;

