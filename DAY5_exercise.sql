--EX1
SELECT DISTINCT CITY FROM STATION
WHERE ID%2=0
--EX2
SELECT 
    COUNT(CITY) -  COUNT(DISTINCT CITY) AS difference
FROM STATION;
--EX3