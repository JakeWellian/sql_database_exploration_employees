--  Data exploration of the employees database

-- Revewing the employees table.
SELECT 
    *
FROM
    employees;

-- Revewing the departments table.      
SELECT
	dept_no
FROM
	departments;

--  Male employees whose first name is Denis.     
SELECT 
    *
FROM
    employees
WHERE
	first_name = "Denis" and gender = "M";

--  Employees whose first name is Denis or Elvis.      
SELECT 
    *
FROM
    employees
WHERE
	first_name = "Denis" or first_name = "Elvis";
 
--  Female employees whose first name is Kellie or Aruna.  
SELECT 
    *
FROM
    employees
WHERE
	first_name = "Kellie" and gender = "F" or (first_name = "Aruna" and gender = "F");

--  Employees whose first name is either Cathie, Mark or Nathan.       
SELECT 
    *
FROM
    employees
WHERE
	first_name IN ("Cathie","Mark","Nathan");
 
--  Employees with a first name starting with "Mar".   
SELECT 
    *
FROM
    employees
WHERE
	first_name LIKE("Mar%");

--  Employees with a first name of 4 letters and with the letters starting with "Mar".         
SELECT 
    *
FROM
    employees
WHERE
	first_name LIKE("Mar_");

--  Employees who were hired between 1990-01-01 and 2000-01-01.     
SELECT 
    *
FROM
    employees
WHERE
	hire_date BETWEEN "1990-01-01" and "2000-01-01";


--  Employees who were not hired between 1990-01-01 and 2000-01-01.     
SELECT 
    *
FROM
    employees
WHERE
	hire_date NOT BETWEEN "1990-01-01" and "2000-01-01";

--  Checking for null values in the first name column.     
SELECT 
    *
FROM
    employees
WHERE
	first_name IS NULL;


--  Employees with a salary of $150,000 who were hired after Janaury 1st 2000.  
SELECT 
    *
FROM
    salaries
WHERE
	salary > 150000 and from_date > "2000-01-01";

--  Count of distinct first names.    
SELECT
	COUNT(emp_no)
FROM
	employees;


--  Number of distinct first name.
SELECT
	COUNT(DISTINCT first_name)
FROM
	employees;

 --  Number of employees with a salary of more than $100,000.
SELECT
    COUNT(*)
FROM
    salaries
WHERE
    salary >= 100000;
 
 --  Different first names in the "employees" table.
SELECT
	first_name, count(first_name) as name_count
FROM
	employees
GROUP BY first_name;

--  All first names that appear more than 250 times in the "employees" table.
SELECT 
    first_name, COUNT(first_name) AS names_count
FROM
    employees
GROUP BY first_name
HAVING COUNT(first_name) > 250
ORDER BY first_name;

--  Employees whose average salary is higher than $120,000 per annum.
SELECT
    *, AVG(salary)
FROM
    salaries
GROUP BY emp_no
HAVING AVG(salary) > 120000;


--  List of all names that are encountered less than 200 times and refer to people hired after the 1999-01-01.
select first_name, count(first_name) as names_count
from employees
where hire_date > "1999-01-01"
group by first_name
having count(first_name) < 200
order by first_name DESC;

-- Employee numbers of all individuals who have signed more than 1 contract after 2000-01-01.
SELECT
    emp_no
FROM
    dept_emp
WHERE
    from_date > '2000-01-01'
GROUP BY emp_no
HAVING COUNT(from_date) > 1
ORDER BY emp_no;

-- Employee with the lowest salary
SELECT
    MIN(salary)
FROM
    salaries;

-- Employee with the highest salary
SELECT
    MAX(salary)
FROM
    salaries;

-- Creating duplicate table for "departments" and adding new values
DROP TABLE IF EXISTS departments_dup;
CREATE TABLE departments_dup
(
    dept_no CHAR(4) NULL,
    dept_name VARCHAR(40) NULL
);

INSERT INTO departments_dup
(
    dept_no,
    dept_name
)SELECT
                *
FROM
                departments;

INSERT INTO departments_dup (dept_name)
VALUES                ('Public Relations');
DELETE FROM departments_dup
WHERE
    dept_no = 'd002'; 
INSERT INTO departments_dup(dept_no) VALUES ('d010'), ('d011');


-- Creating duplicate table for "dept_manager" and adding new values
DROP TABLE IF EXISTS dept_manager_dup;
CREATE TABLE dept_manager_dup (
  emp_no int(11) NOT NULL,
  dept_no char(4) NULL,
  from_date date NOT NULL,
  to_date date NULL
  );

INSERT INTO dept_manager_dup
select * from dept_manager;

INSERT INTO dept_manager_dup (emp_no, from_date)
VALUES                (999904, '2017-01-01'),
                                (999905, '2017-01-01'),
                               (999906, '2017-01-01'),
                               (999907, '2017-01-01');

SET SQL_SAFE_UPDATES = 0;

DELETE FROM dept_manager_dup
WHERE
    dept_no = 'd001';
INSERT INTO departments_dup (dept_name)
VALUES                ('Public Relations');
DELETE FROM departments_dup
WHERE
    dept_no = 'd002'; 
 
-- Managers per department
SELECT 
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m
        JOIN
    departments_dup d ON m.dept_no = d.dept_no
ORDER BY m.dept_no;
 
-- List containing information about all managers’ employee number, first and last name, department number, and hire date. 
SELECT
    e.emp_no,
    e.first_name,
    e.last_name,
    dm.dept_no,
    e.hire_date
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no;
    
-- All the employees whose last name is Markovitch. Joining the "employees" and "dept_manager" tables together. 

SELECT
    e.emp_no,  
    e.first_name,  
    e.last_name,  
    dm.dept_no,  
    dm.from_date  
FROM  
    employees e  
        LEFT JOIN   
dept_manager dm ON e.emp_no = dm.emp_no  
WHERE  
    e.last_name = 'Markovitch'  
ORDER BY dm.dept_no DESC, e.emp_no;

-- Employees whose first name is “Margareta” and have the last name “Markovitch”. Using joins
SELECT
    e.first_name, e.last_name, e.hire_date, t.title
FROM
    employees e
        JOIN
    titles t ON e.emp_no = t.emp_no
WHERE
    first_name = 'Margareta'
        AND last_name = 'Markovitch'
ORDER BY e.emp_no;   

-- A list with all possible combinations between managers from the dept_manager table and department number 9.
SELECT
    dm.*, d.*  
FROM  
    departments d  
        CROSS JOIN  
    dept_manager dm  
WHERE  
    d.dept_no = 'd009'  
ORDER BY d.dept_no;

-- List with the first 10 employees with all the departments they can be assigned to.
SELECT
    e.*, d.*
FROM
    employees e
        CROSS JOIN
    departments d
WHERE
    e.emp_no < 10011
ORDER BY e.emp_no, d.dept_name;