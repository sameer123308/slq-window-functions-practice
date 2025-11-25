CREATE DATABASE window_functions;
USE window_functions;
 -- Create table

CREATE TABLE Students3 (
    id INT,
    name VARCHAR(50),
    class CHAR(1),
    marks INT
);

-- Insert sample data
INSERT INTO Students3 (id, name, class, marks) VALUES
(1, 'Ayan', 'A', 92),
(2, 'Bella', 'A', 92),
(3, 'Chet', 'A', 88),
(4, 'Diya', 'A', 80);

select * from students3;

-- Q1 "Write an SQL query to assign ranks to students within each class based on their marks in descending order." RANK()

SELECT 
      name,
      class,
      marks,
      RANK() OVER(PARTITION BY class ORDER BY marks DESC) AS class_rank
      FROM students3;
      

-- Q2 "Write an SQL query to assign ranks to students within each class based on their marks in descending order, 
 -- but without skipping rank numbers in case of ties." DENSE_RANK()
 
SELECT
      name, 
      class,
      marks,
      DENSE_RANK() OVER(PARTITION BY class ORDER BY marks DESC) AS class_dense_rank
      FROM students3;
      
-- RANK_NUMBER() inserting new table
-- Create table
CREATE TABLE Students4 (
    id INT,
    name VARCHAR(50),
    class CHAR(1),
    marks INT
);

-- Insert sample data
INSERT INTO Students4 (id, name, class, marks) VALUES
(1, 'Ali', 'A', 88),
(2, 'Bina', 'A', 92),
(3, 'Carl', 'B', 85),
(4, 'Dia', 'A', 92),
(5, 'Evan', 'B', 90);    

SELECT * FROM students4;

-- Q3 
-- "How would you use SQL to give every student in a class a unique sequential rank based on their marks, 
-- even if some students have the same marks?"  ROW_NUMBER()

SELECT
      name, 
      class,
      marks,
      ROW_NUMBER() OVER(PARTITION BY class ORDER BY marks DESC) AS class_dense_rank
      FROM students4;


-- Create table
CREATE TABLE Players (
    id INT,
    name VARCHAR(50),
    score INT
);

-- Insert sample data
INSERT INTO Players (id, name, score) VALUES
(1, 'Ayan', 99),
(2, 'Bella', 95),
(3, 'Carl', 93),
(4, 'Diya', 90),
(5, 'Ethan', 85),
(6, 'Faria', 83),
(7, 'Gita', 80),
(8, 'Harry', 78),
(9, 'Ishan', 76),
(10, 'Jia', 70); 

SELECT * FROM players;

-- Q4 
-- "Write an SQL query to divide players into 4 performance quartiles based on their scores, 
-- with the highest scores in the first quartile." NTILE()


SELECT
  name,
  score,
  NTILE(4) OVER(ORDER BY score DESC) AS performance_quartile
  FROM players;
  
  
 -- Q5  & Q6 LEAD() AND LAG()
-- Create table
CREATE TABLE Sales (
    id INT,
    month VARCHAR(10),
    sales INT
);

-- Insert sample data
INSERT INTO Sales (id, month, sales) VALUES
(1, 'Jan', 1000),
(2, 'Feb', 1200),
(3, 'Mar', 1100),
(4, 'Apr', 1300);

SELECT * FROM sales;
 
-- Q5 How would you use a window function to compare each month’s sales with the previous month’s sales?" 

SELECT 
     month,
     sales,
     LAG(sales) OVER(ORDER BY id) AS previous_month_sales
     FROM sales;
     
     
-- Q6 "How would you use SQL to compare each month’s sales with the following month’s sales?" 

SELECT 
     month,
     sales,
     LEAD(sales) OVER(ORDER BY id) AS following_month_sales
     FROM sales;  
     
  
-- AGGREGATE WINDOW FUNCTIONS SUM(), AVG(), COUNT(), MIN(), MAX()
-- Create sales table
CREATE TABLE sales1 (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    region VARCHAR(50),
    sale_date DATE,
    amount DECIMAL(10,2)
);

-- Insert sample data
INSERT INTO sales1 (sale_id, customer_id, product_id, region, sale_date, amount) VALUES
(1, 101, 201, 'North', '2023-01-05', 500),
(2, 102, 202, 'North', '2023-01-10', 300),
(3, 103, 203, 'South', '2023-01-15', 700),
(4, 101, 204, 'South', '2023-01-20', 400),
(5, 104, 201, 'East',  '2023-02-01', 200),
(6, 105, 202, 'East',  '2023-02-05', 900),
(7, 101, 203, 'North', '2023-02-10', 600),
(8, 102, 201, 'South', '2023-02-15', 800),
(9, 103, 204, 'East',  '2023-02-20', 1000),
(10, 104, 202, 'North', '2023-03-01', 750),
(11, 105, 203, 'South', '2023-03-05', 650),
(12, 101, 201, 'East',  '2023-03-10', 300);  

SELECT * FROM sales1;

-- Q7 FIND EACH SALE AMOUNT ALONG WITH THE TOTAL SALES OF THAT REGION.

SELECT 
      sale_id,
      region,
      amount,
      SUM(amount) OVER(PARTITION BY region) AS totsl_sale_region
      FROM sales1;
      
    
-- Q8 SHOW EACH CUSTOMERS SALE AND THEIR TOTAL SALE ACROSS ALL PRODUCTS.

SELECT 
    customer_id,
    sale_id,
    amount,
    SUM(amount) OVER (PARTITION BY customer_id) AS total_customer_sales
FROM sales1;


-- Q9  FOR EACH SALE, SHOW THE AVERAGE SALES AMOUNT IN THAT REGION.
SELECT
      sale_id,
      region,
      amount,
      AVG(amount) OVER(PARTITION BY region) as avg_region_sales
      FROM sales1;
      
-- Q10 Find each sale amount and the highest sale in the same region.

SELECT 
    sale_id,
    region,
    amount,
    MAX(amount) OVER (PARTITION BY region) AS max_sale_in_region
FROM sales1;      

--  Q11 Find each sale amount and the lowest sale in the same region.

SELECT 
    sale_id,
    region,
    amount,
    MIN(amount) OVER (PARTITION BY region) AS min_sale_in_region
FROM sales1;

-- Q12 Show each sale with the count of sales done by that customer.

SELECT 
    customer_id,
    sale_id,
    amount,
    COUNT(*) OVER (PARTITION BY customer_id) AS sales_count_by_customer
FROM sales1;

-- Q13 Show running total of sales by region (ordered by date).

SELECT 
    region,
    sale_date,
    amount,
    SUM(amount) OVER (PARTITION BY region ORDER BY sale_date) AS running_total
FROM sales1;

-- Q14 Show each sale with the overall average sale amount (no partition).

SELECT 
    sale_id,
    amount,
    AVG(amount) OVER () AS overall_avg_sale
FROM sales1;

-- Q15 Show each sale amount and the first sale made in that region.

SELECT
    sale_id,
    region,
    sale_date,
    amount,
    FIRST_VALUE(amount) OVER (PARTITION BY region ORDER BY sale_date) AS first_sale_in_region
FROM sales1;

-- Q16 Show each sale amount and the last sale made in that region.

SELECT
    sale_id,
    region,
    sale_date,
    amount,
    LAST_VALUE(amount) OVER (
        PARTITION BY region 
        ORDER BY sale_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_sale_in_region
FROM sales1;

-- Note: Without ROWS BETWEEN … the LAST_VALUE often gives current row value, so we always fix it with this frame.


-- Q17. Show each sale amount and the 2nd sale made in that region.


SELECT
    sale_id,
    region,
    sale_date,
    amount,
    NTH_VALUE(amount, 2) OVER (
        PARTITION BY region ORDER BY sale_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS second_sale_in_region
FROM sales1;


-- 1. Drop table if it already exists (safety)
DROP TABLE IF EXISTS sales;

-- 2. Create the Sales table
CREATE TABLE sales3 (
    order_id INT PRIMARY KEY,
    order_date DATE,
    product_code VARCHAR(10),
    quantity INT,
    sale_price DECIMAL(10,2)
);

-- 3. Insert sample data
INSERT INTO sales3 (order_id, order_date, product_code, quantity, sale_price) VALUES
(1, '2024-08-01', 'P001', 10, 100),
(2, '2024-08-01', 'P002',  5, 200),
(3, '2024-08-02', 'P001',  8, 100),
(4, '2024-08-02', 'P003', 12, 150),
(5, '2024-08-03', 'P002',  7, 200);

SELECT * FROM sales3;

-- Q.18 For each product, find the first sale price when the product was sold.
--  That means: Look at each product’s sales history (ordered by date) and return the earliest price.

SELECT
product_code,
order_date,
sale_price,
FIRST_VALUE(sale_price) OVER (
PARTITION BY product_code
ORDER BY order_date
) AS first_sale_price
FROM sales3;

-- Explanation:
-- For P001 → Sales happened on 2024-08-01 (100) and 2024-08-02 (100). First sale = 100.
-- For P002 → First sale was on 2024-08-01 (200). So first_sale_price = 200.
-- For P003 → Only one sale (150). So first_sale_price = 150.



-- Q.19 For each product, find the last sale price from its most recent order.
--  That means: Look at each product’s sales (ordered by date) and return the latest price.


SELECT
product_code,
order_date,
sale_price,
LAST_VALUE(sale_price) OVER (
PARTITION BY product_code
ORDER BY order_date
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) AS last_sale_price
FROM sales3;

-- Explanation:
-- For P001 → Last sale on 2024-08-02 (100). So last_sale_price = 100.
-- For P002 → Last sale on 2024-08-03 (200). So last_sale_price = 200.
-- For P003 → Only sale on 2024-08-02 (150). So last_sale_price = 150.


-- Q20 For each product, find the 2nd sale price (if it exists).
-- That means: Arrange each product’s sales by date and pick the 2nd entry.

SELECT
product_code,
order_date,
sale_price,
NTH_VALUE(sale_price, 2) OVER (
PARTITION BY product_code
ORDER BY order_date
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) AS second_sale_price
FROM sales3;

-- Explanation:
-- For P001 → Sales = [100, 100]. 2nd sale = 100.
-- For P002 → Sales = [200, 200]. 2nd sale = 200.
-- For P003 → Sales = [150]. No 2nd sale → NULL.