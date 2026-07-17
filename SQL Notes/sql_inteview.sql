/*
================================================================================
 SQL INTERVIEW QUESTIONS
 Source: Ankit Bansal - https://www.youtube.com/watch?v=Iv9qBz-cyVA&t=353s
================================================================================
 Assumed schema (for context, not exhaustive):
   emp(emp_id, manager_id, department_id, salary, ...)
   emp1(emp_id, manager_id, ...)
   employee(emp_id, ...)
   dept(dep_id, dep_name, ...)
   orders(customer_name, ...)
================================================================================
*/


-- ============================================================================
-- Q1. How to find duplicates in a given table?
-- ============================================================================
-- Group by the column(s) that define a duplicate, then filter groups
-- with more than one occurrence using HAVING.

SELECT
    emp_id,
    COUNT(*) AS occurrence_count
FROM emp
GROUP BY emp_id
HAVING COUNT(*) > 1;


-- ============================================================================
-- Q2. How to delete duplicates?
-- ============================================================================
-- Use ROW_NUMBER() partitioned by the duplicate-defining column(s).
-- Rows with rn > 1 are the extra (duplicate) copies and can be deleted.
-- Note: ORDER BY inside the window function should ideally reference a
-- tiebreaker column (e.g. a primary key) rather than the same column
-- used in PARTITION BY, to make the "kept" row deterministic.

WITH cte AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY emp_id ORDER BY emp_id) AS rn
    FROM emp1
)
DELETE FROM cte
WHERE rn > 1;


-- ============================================================================
-- Q3. Difference between UNION and UNION ALL
-- ============================================================================
-- UNION ALL : returns all rows from both queries, including duplicates.
--             e.g. Table1 (9 rows) + Table2 (8 rows) = 17 rows.
-- UNION     : returns only distinct rows; duplicates across both queries
--             are removed.

SELECT manager_id FROM emp
UNION
SELECT manager_id FROM emp1;
-- Returns only unique manager_id values across both tables.


-- ============================================================================
-- Q4. Find employees who are not present in dept.
-- ============================================================================

-- Approach 1: NOT IN
SELECT emp_id
FROM employee
WHERE emp_id NOT IN (
    SELECT dept_id FROM dept
);

-- Approach 2: LEFT JOIN + NULL check (preferred — handles NULLs safely
-- and is generally more performant on large datasets)
SELECT
    emp.*,
    dept.dep_id,
    dept.dep_name
FROM emp
LEFT JOIN dept
    ON emp.department_id = dept.dep_id
WHERE dept.dep_id IS NULL;


-- ============================================================================
-- Q5. Find the second highest salary in each department.
-- ============================================================================
-- DENSE_RANK() is used so genuine salary ties share the same rank
-- (unlike ROW_NUMBER, which would arbitrarily split ties).

SELECT *
FROM (
    SELECT
        emp.*,
        DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rnk
    FROM emp
) a
WHERE rnk = 2;


-- ============================================================================
-- Q6. Find all transactions done by "Shilpa".
-- ============================================================================
-- Use UPPER()/LOWER() to make the comparison case-insensitive,
-- in case names are stored inconsistently (e.g. "shilpa", "SHILPA", "Shilpa").

SELECT *
FROM orders
WHERE UPPER(customer_name) = 'SHILPA';


-- ============================================================================
-- Q7. Self join — find managers whose salary is greater than their
--     employees' salary (or list employees who earn more than their manager).
-- ============================================================================
-- A self join treats the same table as two logical tables: one row
-- representing the employee, one representing that employee's manager.

-- Employees who earn MORE than their manager:
SELECT
    e.emp_id        AS employee_id,
    e.salary        AS employee_salary,
    m.emp_id        AS manager_id,
    m.salary        AS manager_salary
FROM emp e
JOIN emp m
    ON e.manager_id = m.emp_id
WHERE e.salary > m.salary;

-- Managers whose salary is greater than ALL of their direct reports:
SELECT
    m.emp_id   AS manager_id,
    m.salary   AS manager_salary
FROM emp m
WHERE m.salary > (
    SELECT MAX(e.salary)
    FROM emp e
    WHERE e.manager_id = m.emp_id
);


-- ============================================================================
-- Q8. Joins — LEFT JOIN vs INNER JOIN
-- ============================================================================
-- INNER JOIN : returns only rows where there is a match in BOTH tables.
-- LEFT JOIN  : returns ALL rows from the left table, plus matching rows
--              from the right table; unmatched right-side columns are NULL.

-- INNER JOIN example: only employees that have a matching department
SELECT
    emp.*,
    dept.dep_name
FROM emp
INNER JOIN dept
    ON emp.department_id = dept.dep_id;

-- LEFT JOIN example: all employees, with department info where available
SELECT
    emp.*,
    dept.dep_name
FROM emp
LEFT JOIN dept
    ON emp.department_id = dept.dep_id;

/*===========================================================
Question:
--------
You have two tables:

employee
---------
emp_id
emp_name
salary
department_id
gender

department
-----------
department_id
department_name

Write a SQL query to display:

department_name | second_highest_salary | second_lowest_salary

The result should contain one row per department.
Use DENSE_RANK() so that duplicate salaries are handled correctly.
===========================================================*/


WITH ranked_data AS (
    SELECT
        d.department_name,
        e.salary,
        DENSE_RANK() OVER (
            PARTITION BY d.department_name
            ORDER BY e.salary DESC
        ) AS salary_desc_rank,

        DENSE_RANK() OVER (
            PARTITION BY d.department_name
            ORDER BY e.salary ASC
        ) AS salary_asc_rank

    FROM employee e
    JOIN department d
        ON e.department_id = d.department_id
)

SELECT
    department_name,

    MAX(
        CASE
            WHEN salary_desc_rank = 2
            THEN salary
        END
    ) AS second_highest_salary,

    MAX(
        CASE
            WHEN salary_asc_rank = 2
            THEN salary
        END
    ) AS second_lowest_salary

FROM ranked_data

GROUP BY department_name

ORDER BY department_name;
/*
1. Join employee and department tables.
2. Use DENSE_RANK() in descending order to find the second highest salary.
3. Use DENSE_RANK() in ascending order to find the second lowest salary.
4. Use CASE expressions to filter only rank = 2.
5. Use MAX() to convert multiple rows into a single row per department.
6. GROUP BY department_name to produce one result per department.

Why DENSE_RANK()?
- Employees with the same salary receive the same rank.
- Unlike ROW_NUMBER(), duplicate salaries are not skipped.
- Unlike RANK(), there are no gaps in ranking (1,2,3 instead of 1,2,2,4). */

