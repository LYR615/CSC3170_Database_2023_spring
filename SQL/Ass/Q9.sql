-- SELECT JOB_ID, count(EMPLOYEE_ID)
SELECT JOB_ID, COUNT(*)
FROM as3.employees
GROUP BY JOB_ID