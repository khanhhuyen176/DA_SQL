--EX1
WITH job_count_dup AS (
  SELECT 
    company_id, 
    title, 
    description, 
    COUNT(job_id) AS job_count
  FROM job_listings
  GROUP BY company_id, title, description )
SELECT count(*) as duplicate_companies
FROM job_count_dup
WHERE job_count >=2

--EX2
SELECT 
    t1.category, 
    t1.product, 
    t1.total
FROM 
    (SELECT category, product, SUM(spend) AS total
     FROM product_spend
     WHERE EXTRACT(YEAR FROM transaction_date) = 2022
     GROUP BY category, product) t1
WHERE 
    2 > (SELECT COUNT(*)
         FROM product_spend t2
         WHERE t2.category = t1.category 
           AND EXTRACT(YEAR FROM t2.transaction_date) = 2022
           AND SUM(t2.spend) > t1.total
         GROUP BY t2.product)
ORDER BY 
    t1.category, t1.total DESC;

--EX3
WITH total_call as (
SELECT 
policy_holder_id, COUNT(case_id) as total
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id) >= 3 )
SELECT COUNT(policy_holder_id) as policy_holder_count
FROM total_call

--EX4
SELECT DISTINCT
p.page_id
FROM pages as p
LEFT JOIN page_likes as k
ON p.page_id = k.page_id
WHERE liked_date is null
ORDER BY p.page_id

--EX5
with june AS(
    SELECT DISTINCT user_id
    FROM user_actions
    WHERE EXTRACT(YEAR FROM event_date) = 2022
      AND EXTRACT(MONTH FROM event_date) = 6
      AND event_type is not null
),
july AS(
    SELECT DISTINCT user_id
    FROM user_actions
    WHERE EXTRACT(YEAR FROM event_date) = 2022
      AND EXTRACT(MONTH FROM event_date) = 7
      AND event_type is not null
)
SELECT
    7 AS month,
    COUNT(july.user_id) AS monthly_active_users
FROM july
JOIN june
ON july.user_id = june.user_id;

--ex6
SELECT 
    TO_CHAR(trans_date, 'YYYY-MM') AS month,
    country,
    COUNT(*) AS trans_count,
    SUM(amount) AS trans_total_amount,
    COUNT(CASE WHEN state = 'approved' THEN 1 END) AS approved_count,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM 
    Transactions
GROUP BY 
    TO_CHAR(trans_date, 'YYYY-MM'), country;

--ex7
SELECT
    s.product_id,
    s.year AS first_year,
    s.quantity,
    s.price
FROM Sales s
JOIN (
    SELECT product_id, MIN(year) AS first_year
    FROM Sales
    GROUP BY product_id
) AS f
ON s.product_id = f.product_id
AND s.year = f.first_year;

--ex8
-- Count the total number of unique products
WITH TotalProducts AS (
    SELECT COUNT(DISTINCT product_key) AS num_products
    FROM Product),
CustomerProductCount AS (
    SELECT customer_id, COUNT(DISTINCT product_key) AS num_bought
    FROM Customer
    GROUP BY customer_id)
SELECT c.customer_id
FROM CustomerProductCount c
JOIN TotalProducts t
ON c.num_bought = t.num_products;

--ex9
WITH MissingManagers AS (
    SELECT DISTINCT e1.manager_id
    FROM Employees e1
    LEFT JOIN Employees e2
    ON e1.manager_id = e2.employee_id
    WHERE e2.employee_id IS NULL),
LowSalary AS (
    SELECT e.employee_id
    FROM Employees e
    JOIN MissingManagers mm
    ON e.manager_id = mm.manager_id
    WHERE e.salary < 30000)
SELECT employee_id
FROM LowSalary
ORDER BY employee_id;

--ex10
WITH job_count_dup AS (
  SELECT 
    company_id, 
    title, 
    description, 
    COUNT(job_id) AS job_count
  FROM job_listings
  GROUP BY company_id, title, description )
SELECT count(*) as duplicate_companies
FROM job_count_dup
WHERE job_count >=2

--ex11
WITH UserMovieCounts AS (
    SELECT u.name, COUNT(DISTINCT mr.movie_id) AS movie_count
    FROM Users u
    JOIN MovieRating mr ON u.user_id = mr.user_id
    GROUP BY u.user_id, u.name),
TopUser AS (
    SELECT name
    FROM UserMovieCounts
    ORDER BY movie_count DESC, name
    LIMIT 1),
MovieAverageRatings AS (
    SELECT m.title, AVG(mr.rating) AS avg_rating
    FROM Movies m
    JOIN MovieRating mr ON m.movie_id = mr.movie_id
    WHERE mr.created_at BETWEEN '2020-02-01' AND '2020-02-29'
    GROUP BY m.movie_id, m.title),
TopMovie AS (
    SELECT title
    FROM MovieAverageRatings
    ORDER BY avg_rating DESC, title
    LIMIT 1)
SELECT name AS results
FROM TopUser
UNION ALL
SELECT title AS results
FROM TopMovie;

--ex12
SELECT
    id,
    COUNT(*) AS num
FROM (
    SELECT requester_id AS id FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS id FROM RequestAccepted ) AS AllFriends
GROUP BY id
ORDER BY num DESC
LIMIT 1;

