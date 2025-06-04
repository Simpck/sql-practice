SELECT after_ranking.branch_name, after_ranking.employee_name, after_ranking.total_sales, after_ranking.total_client
FROM (
    SELECT counting.branch_name, counting.employee_name, counting.total_sales, counting.total_client, RANK() 
        OVER (PARTITION BY branch_name ORDER BY total_sales DESC) AS rank_pos
    FROM (
        SELECT branch.branch_name, CONCAT(employee.first_name, ' ', employee.last_name) AS employee_name, 
            SUM(works_with.total_sales) AS total_sales, COUNT(works_with.client_id) AS total_client
        FROM works_with
        JOIN employee
        ON works_with.emp_id = employee.emp_id
        JOIN branch
        ON employee.branch_id = branch.branch_id
        GROUP BY works_with.emp_id
    ) AS counting
) AS after_ranking
WHERE rank_pos = 1;