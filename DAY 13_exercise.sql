--EX1
SELECT COUNT(DISTINCT company_id) AS duplicate_companies
FROM job_listings j1
WHERE EXISTS (
    SELECT company_id 
    FROM job_listings j2
    WHERE j1.company_id = j2.company_id
      AND j1.title = j2.title
      AND j1.description = j2.description
      AND j1.job_id <> j2.job_id
);

--ex2


