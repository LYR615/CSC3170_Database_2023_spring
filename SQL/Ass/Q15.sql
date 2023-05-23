SELECT DEPARTMENT_ID AS 'Department Name', count(EMPLOYEE_ID) as 'Number of Employees'
FROM as3.employees
group by DEPARTMENT_ID