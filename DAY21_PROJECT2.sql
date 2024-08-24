--task1: Số lượng đơn hàng và số lượng khách hàng mỗi tháng
select
    FORMAT_TIMESTAMP('%Y-%m', created_at) AS month_year, 
    COUNT(DISTINCT user_id) AS total_user, 
    COUNT(order_id) AS total_order
from bigquery-public-data.thelook_ecommerce.orders
where status = 'Complete'
      and
      created_at BETWEEN '2019-01-01' AND '2022-04-30'
group by month_year
order by month_year
--INSIGHT: 
/*2019 đến đầu 2020: Số lượng người mua và đơn hàng tăng nhẹ, ổn định.
Giữa 2020 đến 2021: Số lượng người mua và đơn hàng tăng mạnh, đặc biệt vào cuối 2021.
Cuối 2021 đến 2022: Có dấu hiệu giảm nhẹ nhưng vẫn tăng trở lại và duy trì ở mức cao.*/

--task2: Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
select
    FORMAT_TIMESTAMP('%Y-%m', created_at) AS month_year, 
    COUNT(DISTINCT user_id) AS distinct_users, 
    AVG(sale_price) AS average_order_value,
from bigquery-public-data.thelook_ecommerce.order_items
where 
      status = 'Complete'
      and
      created_at BETWEEN '2019-01-01' AND '2022-04-30'
group by month_year
order by month_year
--INSIGHT: 
/*2019 đến đầu 2020: Số lượng người mua đơn hàng tăng đều, duy trì; và avg đơn hàng tăng nhẹ, ổn định.
Giữa 2020 đến 2021: Số lượng người mua vẫn tăng, có dấu hiệu giảm nhẹ ở 1 vài tháng; avg đơn hàng mua tăng nhẹ, ổn định.
Cuối 2021 đến 2022: Số lượng người mua vẫn tăng và duy trì ở mức cao; avg đơn hàng mua giảm nhẹ, ổn định.*/

--task3: Nhóm khách hàng theo độ tuổi
WITH min_max AS (
    SELECT 
        gender,
        MIN(age) AS min_age,
        MAX(age) AS max_age
    FROM bigquery-public-data.thelook_ecommerce.users
    WHERE created_at BETWEEN '2019-01-01' AND '2022-04-30'
    GROUP BY gender
), All_Customers AS (
    SELECT 
        u.first_name, 
        u.last_name, 
        u.gender, 
        u.age,
        CASE 
            WHEN u.age = a.min_age THEN 'youngest'
            WHEN u.age = a.max_age THEN 'oldest'
            ELSE ''
        END AS tag
    FROM bigquery-public-data.thelook_ecommerce.users u
    JOIN min_max a
        ON u.gender = a.gender
    WHERE u.created_at BETWEEN '2019-01-01' AND '2022-04-30'
)
select age, count(*) as so_lg , tag from All_Customers
where gender in ('M', 'F')
      and tag in ('youngest', 'oldest')
GROUP BY age, tag
order BY age, tag
--INSIGHT: 
/*Trẻ nhất là 12 tuổi ở cả F VÀ M, số lượng 966, trong đó: F = 512, M = 454 
Lớn nhất là 70 tuổi ở cả F VÀ M, số lượng 981, trong đó: F = 477, M = 504 */

--task4: top 5 sản phẩm có lợi nhuận cao nhất từng tháng (xếp hạng cho từng sản phẩm)
WITH SALE_TABLE AS (
    SELECT 
        FORMAT_TIMESTAMP('%Y-%m', b.created_at) AS month_year,
        b.product_id, 
        a.name AS product_name, 
        b.sale_price, 
        a.cost, 
        COUNT(b.product_id) AS quantity_sold
    FROM 
        bigquery-public-data.thelook_ecommerce.products a
    JOIN 
        bigquery-public-data.thelook_ecommerce.order_items b
        ON a.id = b.product_id
    WHERE 
        b.status = 'Complete'
        AND b.created_at BETWEEN '2019-01-01' AND '2022-04-30'
    GROUP BY 
        month_year, 
        b.product_id, 
        a.name, 
        b.sale_price, 
        a.cost
), PROFIT_TABLE AS (
    SELECT 
        month_year,
        product_id,
        product_name,
        (sale_price * quantity_sold) AS sales,
        (cost * quantity_sold) AS cost,
        (sale_price - cost) * quantity_sold AS profit
    FROM SALE_TABLE 
)
SELECT * FROM (
  SELECT 
      DENSE_RANK() OVER(PARTITION BY month_year ORDER BY profit DESC) AS rank_per_month,
      *
  FROM PROFIT_TABLE
  ORDER BY month_year 
)
WHERE rank_per_month IN (1,2,3,4,5)

--task5:  tổng doanh thu theo ngày của từng danh mục sản phẩm (category) trong 3 tháng qua ( giả sử ngày hiện tại là 15/4/2022)
WITH SALE_DATA AS (
    SELECT 
        FORMAT_TIMESTAMP('%Y-%m-%d', b.created_at) AS dates,
        a.category AS product_categories,
        b.sale_price,
        COUNT(b.product_id) AS slg_order
    FROM bigquery-public-data.thelook_ecommerce.products a
    JOIN bigquery-public-data.thelook_ecommerce.order_items b
        ON a.id = b.product_id
    WHERE 
        b.status = 'Complete'
        AND b.created_at BETWEEN '2022-01-15' AND '2022-04-15'
    GROUP BY 
        dates, 
        product_categories, 
        sale_price
), DAILY_REVENUE AS (
    SELECT 
        dates,
        product_categories,
        SUM(sale_price * slg_order) AS revenue
    FROM SALE_DATA
    GROUP BY 
        dates, 
        product_categories
)
SELECT 
    dates,
    product_categories,
    revenue
FROM DAILY_REVENUE
ORDER BY 
    dates, 
    product_categories;

--III.1
WITH x AS (
SELECT 
        FORMAT_TIMESTAMP('%Y-%m', c.created_at) AS Month,
        FORMAT_TIMESTAMP('%Y', c.created_at) AS Year,
        a.category AS Product_category,
        COUNT(b.product_id) AS TPO -- Tổng số đơn hàng mỗi category ở từng tháng
    FROM 
        bigquery-public-data.thelook_ecommerce.products a
    JOIN 
        bigquery-public-data.thelook_ecommerce.order_items b
        ON a.id = b.product_id
    JOIN 
        bigquery-public-data.thelook_ecommerce.orders c
        ON b.order_id = c.order_id
    WHERE 
        b.status = 'Complete'
    GROUP BY 1, 2, 3
    ORDER BY Month, Year,Product_category 
), xx AS(
SELECT
    Month,
    Year,
    Product_category,
    ROUND(sum(TPO * b.sale_price),2) AS TPV, -- Tổng doanh thu mỗi category ở từng tháng
    TPO,
    ROUND(SUM(TPO * a.cost),2) AS Total_cost -- Tổng chi phí mỗi category ở từng tháng,
FROM x
    JOIN bigquery-public-data.thelook_ecommerce.products a
        ON x.Product_category = a.category
    JOIN 
        bigquery-public-data.thelook_ecommerce.order_items b
        ON a.id = b.product_id
    WHERE 
        b.status = 'Complete'
GROUP BY 1,2,3,5
ORDER BY Month, Year,Product_category 
)
SELECT  
    Month,
    Year,
    Product_category,
    TPV,
    TPO,
    -- Tăng trưởng doanh thu 
    round((TPV - LAG(TPV) OVER (ORDER BY Year, Month, Product_category)) / LAG(TPV) OVER (ORDER BY Year, Month, Product_category) * 100.00,2) || '%' AS Revenue_growth, 
    -- Tăng trưởng số đơn hàng
    round((TPO - LAG(TPO) OVER (ORDER BY Year, Month, Product_category)) / LAG(TPO) OVER (ORDER BY Year, Month, Product_category) * 100.00,2) || '%' AS Order_growth, 
    Total_cost,
    ROUND((TPV - Total_cost),2) AS Total_profit, -- Tổng lợi nhuận mỗi tháng
    ROUND(((TPV - Total_cost) / Total_cost * 100.00),2) AS Profit_to_cost_ratio  -- Tỷ lệ lợi nhuận trên chi phí mỗi tháng
FROM xx
ORDER BY Year, Month, Product_category

--III.2


