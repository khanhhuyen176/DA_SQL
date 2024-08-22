-- 1) Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER)
--select * from public.sales_dataset_rfm_prj
	
ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE int USING ordernumber::int,
ALTER COLUMN quantityordered TYPE int USING quantityordered::int,
ALTER COLUMN priceeach TYPE NUMERIC(10, 2) USING priceeach::NUMERIC,
ALTER COLUMN orderlinenumber TYPE int USING orderlinenumber::int,
ALTER COLUMN sales TYPE NUMERIC(10, 2) USING sales::NUMERIC,
ALTER COLUMN orderdate TYPE DATE USING to_date(orderdate, 'MM/DD/YYYY'),
ALTER COLUMN status TYPE VARCHAR(50),
ALTER COLUMN productline TYPE VARCHAR(50),
ALTER COLUMN msrp TYPE int USING msrp::int,
ALTER COLUMN productcode TYPE VARCHAR(50),
ALTER COLUMN customername TYPE VARCHAR(50),
ALTER COLUMN phone TYPE VARCHAR(20),
ALTER COLUMN addressline1 TYPE VARCHAR(50),
ALTER COLUMN addressline2 TYPE VARCHAR(20),
ALTER COLUMN city TYPE VARCHAR(30),
ALTER COLUMN state TYPE VARCHAR(20),
ALTER COLUMN postalcode TYPE VARCHAR(20),
ALTER COLUMN country TYPE VARCHAR(20),
ALTER COLUMN territory TYPE VARCHAR(20),
ALTER COLUMN contactfullname TYPE VARCHAR(30),
ALTER COLUMN dealsize TYPE VARCHAR(20);
-- ??tại sao phải có thêm using ở dạng number, datetime??

-- 2) Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.
SELECT *
FROM public.sales_dataset_rfm_prj
WHERE 
    ORDERNUMBER IS NULL OR
    QUANTITYORDERED IS NULL OR
    PRICEEACH IS NULL OR
    ORDERLINENUMBER IS NULL OR
    SALES IS NULL OR
    ORDERDATE IS NULL;
-- ??chuyển data type sang dạng int/numeric rồi thì làm sao để tìm blank??

-- 3) Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . 
--Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. 
--Gợi ý: ( ADD column sau đó UPDATE)
ADD TABLE sales_dataset_rfm_prj
  ADD COLUMN CONTACTFIRSTNAME varchar(20),
  ADD COLUMN CONTACTLASTNAME varchar(20);

UPDATE public.sales_dataset_rfm_prj
SET 
    CONTACTFIRSTNAME = initcap(substring(contactfullname FROM 1 FOR POSITION('-' IN contactfullname) - 1)),
    CONTACTLASTNAME = initcap(substring(contactfullname FROM POSITION('-' IN contactfullname) + 1));

-- 4) Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 
ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN QTR_ID INT, 
ADD COLUMN MONTH_ID INT, 
ADD COLUMN YEAR_ID INT;

UPDATE public.sales_dataset_rfm_prj
SET 
    YEAR_ID = TO_CHAR(orderdate, 'YYYY')::INT,
    MONTH_ID = TO_CHAR(orderdate, 'MM')::INT,
    QTR_ID = CASE
        WHEN EXTRACT(MONTH FROM orderdate) BETWEEN 1 AND 3 THEN 1
        WHEN EXTRACT(MONTH FROM orderdate) BETWEEN 4 AND 6 THEN 2
        WHEN EXTRACT(MONTH FROM orderdate) BETWEEN 7 AND 9 THEN 3
        WHEN EXTRACT(MONTH FROM orderdate) BETWEEN 10 AND 12 THEN 4
    END;

-- 5) Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó (2 cách) ( Không chạy câu lệnh trước khi bài được review)
WITH Z AS (
    SELECT
        *,
        (SELECT AVG(quantityordered) FROM public.sales_dataset_rfm_prj) AS avg,
        (SELECT STDDEV(quantityordered) FROM public.sales_dataset_rfm_prj) AS stddev
    FROM public.sales_dataset_rfm_prj
),
OUTERLIER AS (
    SELECT 
        (quantityordered - avg) / stddev AS z_score,
		*
    FROM Z
    WHERE ABS((quantityordered - avg) / stddev) > 3
)
	
-- cách xử lý 1: update các bản ghi thành giá trị mới = avg
UPDATE public.sales_dataset_rfm_prj
SET quantityordered = OUTERLIER.avg
FROM OUTERLIER
WHERE public.sales_dataset_rfm_prj.ordernumber = OUTERLIER.ordernumber;
-- cách xử lý 2: xóa khỏi bảng
DELETE FROM public.sales_dataset_rfm_prj
WHERE ordernumber IN (
    SELECT ordernumber
    FROM OUTERLIER)





