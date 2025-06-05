SELECT branch.branch_name, CONCAT(employee.first_name, ' ', employee.last_name) AS manager_name, employee_count.employee_count, total_branch.total_branch, rank_pos.employee_name
FROM branch
JOIN employee
ON branch.mgr_id = employee.emp_id
JOIN (
    SELECT employee.super_id, COUNT(employee.emp_id) AS employee_count
    FROM employee
    GROUP BY employee.super_id
) AS employee_count
ON branch.mgr_id = employee_count.super_id
JOIN (
    SELECT employee.branch_id, SUM(total_sales.total_sales) AS total_branch
    FROM (
        SELECT works_with.emp_id, SUM(works_with.total_sales) AS total_sales
        FROM works_with
        GROUP BY works_with.emp_id
    ) AS total_sales
    JOIN employee
    ON total_sales.emp_id = employee.emp_id
    GROUP BY employee.branch_id
) AS total_branch
ON branch.branch_id = total_branch.branch_id
JOIN (
    SELECT total_sales_rank.branch_id, total_sales_rank.emp_id, total_sales_rank.employee_name, total_sales_rank.total_sales, RANK()
        OVER (PARTITION BY branch_id ORDER BY total_sales DESC) AS rank_pos
    FROM (
        SELECT CONCAT(employee.first_name, ' ', employee.last_name) AS employee_name, employee.branch_id, total_sales.emp_id, total_sales.total_sales
        FROM (
            SELECT works_with.emp_id, SUM(works_with.total_sales) AS total_sales
            FROM works_with
            GROUP BY works_with.emp_id
        ) AS total_sales
        JOIN employee
        ON total_sales.emp_id = employee.emp_id
    ) AS total_sales_rank
) AS rank_pos
ON branch.branch_id = rank_pos.branch_id
WHERE rank_pos.rank_pos = 1;