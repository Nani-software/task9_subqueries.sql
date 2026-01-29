-- Task 9: Writing Subqueries (Nested Queries)
-- SQL Developer Internship - Elevate Labs

USE intern_training_db;

-- 1. Ensure salary data exists
SELECT emp_id, name, salary FROM employees;

------------------------------------------------
-- 2. Subquery in WHERE clause (Non-correlated)
-- Find employees earning more than average salary
------------------------------------------------
SELECT
    emp_id,
    name,
    salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);

-- Execution Flow:
-- Step 1: Inner query calculates average salary
-- Step 2: Outer query compares each employee salary


------------------------------------------------
-- 3. Subquery in SELECT clause
-- Display employee salary along with average salary
------------------------------------------------
SELECT
    emp_id,
    name,
    salary,
    (SELECT AVG(salary) FROM employees) AS avg_salary
FROM employees;

-- Use case:
-- Salary comparison reports


------------------------------------------------
-- 4. Subquery in FROM clause (Derived Table)
-- List employees earning above average
------------------------------------------------
SELECT
    e.emp_id,
    e.name,
    e.salary
FROM employees e
JOIN (
    SELECT AVG(salary) AS avg_sal
    FROM employees
) avg_table
ON e.salary > avg_table.avg_sal;


------------------------------------------------
-- 5. Correlated subquery
-- Employees earning more than their department average
------------------------------------------------
SELECT
    e.emp_id,
    e.name,
    e.salary,
    e.department_id
FROM employees e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
);

-- Execution Flow:
-- Inner query runs once for EACH row of outer query


------------------------------------------------
-- 6. Equivalent JOIN-based query
-- Same result as correlated subquery
------------------------------------------------
SELECT
    e.emp_id,
    e.name,
    e.salary
FROM employees e
JOIN (
    SELECT department_id, AVG(salary) AS dept_avg
    FROM employees
    GROUP BY department_id
) d
ON e.department_id = d.department_id
AND e.salary > d.dept_avg;


------------------------------------------------
-- 7. Subquery returning multiple rows
-- Employees working in departments located in Hyderabad
------------------------------------------------
SELECT
    emp_id,
    name
FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM departments
    WHERE location = 'Hyderabad'
);


------------------------------------------------
-- 8. Debugging common subquery error
-- ERROR example (commented):
-- Subquery returns more than one row
------------------------------------------------
-- SELECT * FROM employees
-- WHERE salary = (SELECT salary FROM employees);

-- FIX:
SELECT * FROM employees
WHERE salary IN (SELECT salary FROM employees);
