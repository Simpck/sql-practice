SELECT CONCAT(employee.first_name, ' ', employee.last_name) AS Employee, client.client_name, works_with.total_sales
FROM (
    SELECT works_with.client_id, COUNT(works_with.emp_id) AS employee_count
    FROM works_with
    GROUP BY works_with.client_id
) AS employee_count
JOIN works_with
ON employee_count.client_id = works_with.client_id
JOIN employee
ON works_with.emp_id = employee.emp_id
JOIN client
ON works_with.client_id = client.client_id
WHERE employee_count.employee_count = 1;
