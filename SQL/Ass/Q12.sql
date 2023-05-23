SELECT EMPLOYEE_ID, SALARY 
FROM as3.employees
WHERE SALARY > (SELECT max(avg_salary) 
			    FROM (SELECT avg(SALARY) avg_salary
				FROM as3.employees
				GROUP BY DEPARTMENT_ID) as a)

