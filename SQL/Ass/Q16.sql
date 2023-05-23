SELECT as3.departments.DEPARTMENT_ID, DEPARTMENT_NAME, FIRST_NAME
#SELECT *
FROM as3.departments JOIN as3.employees 
WHERE as3.employees.EMPLOYEE_ID = as3.departments.MANAGER_ID  