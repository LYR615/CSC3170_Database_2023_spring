SELECT EMPLOYEE_ID
FROM as3.employees
WHERE (EMPLOYEE_ID) not in
	(SELECT MANAGER_ID
    FROM as3.employees) 
and (EMPLOYEE_ID) in (SELECT MANAGER_ID
					 FROM as3.departments) 
    