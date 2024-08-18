--ex1
WITH first_orders AS (
    SELECT customer_id, MIN(order_date) AS first_order_date
    FROM Delivery
    GROUP BY customer_id
)
SELECT 
    ROUND(100.0 * SUM(CASE WHEN d.order_date = d.customer_pref_delivery_date THEN 1 ELSE 0 END) 
    / COUNT(*), 2) AS immediate_percentage
FROM Delivery d
JOIN first_orders f 
    ON d.customer_id = f.customer_id 
   AND d.order_date = f.first_order_date;

--ex2
WITH first_logins AS (
    SELECT 
        player_id, 
        MIN(event_date) AS first_date
    FROM Activity
    GROUP BY player_id
),
next_logins AS (
    SELECT 
        f.player_id
    FROM first_logins f
    JOIN Activity a
    ON f.player_id = a.player_id 
        AND a.event_date = f.first_date + INTERVAL '1 day'
)
SELECT 
    ROUND( 1.0 * COUNT(DISTINCT n.player_id) 
    / COUNT(DISTINCT f.player_id),2) AS fraction
FROM first_logins f
LEFT JOIN next_logins n 
ON f.player_id = n.player_id;

--EX3

--ex4

--ex5

--ex6
with main as(
select  
    b.name as Department ,
    a.name as Employee ,
    a.salary as Salary ,
   dense_rank() over(partition by a.departmentId order by a.salary desc) as rank
from Employee as a
left join Department as b
    on a.departmentId = b.id 
)
select 
    Department,
    Employee,
    Salary
from main 
where rank <=3
order by Department

--ex7


--ex8
SELECT 
    p.product_id, 
    COALESCE(A.new_price, 10) AS price
FROM Products p
LEFT JOIN 
    (SELECT 
         product_id, 
         new_price
     FROM Products
     WHERE change_date <= '2019-08-16'
     ORDER BY change_date DESC
    ) a 
ON p.product_id = A.product_id
GROUP BY p.product_id;
