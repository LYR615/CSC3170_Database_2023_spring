SELECT EMPLOYEE_ID, JOB_ID, as3.departments.DEPARTMENT_ID, DEPARTMENT_NAME
FROM as3.employees JOIN as3.departments   
WHERE as3.employees.DEPARTMENT_ID = as3.departments.DEPARTMENT_ID     
HAVING DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
					    FROM as3.departments
                        WHERE LOCATION_ID IN (SELECT LOCATION_ID
											  FROM as3.locations
                                              WHERE CITY = "Seattle"))                            
