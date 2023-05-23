SELECT FIRST_NAME, LAST_NAME
FROM as3.employees 
WHERE MANAGER_ID IN (SELECT EMPLOYEE_ID
					 FROM as3.employees 
					 WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
											FROM as3.departments
						                    WHERE LOCATION_ID in (SELECT LOCATION_ID
																FROM as3.locations 
											                    WHERE COUNTRY_ID = 'US')))
