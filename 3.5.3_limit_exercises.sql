-- List the first 10 distinct last name sorted in descending order.

select distinct last_name from employees
order by last_name desc limit 10;

-- Find your query for employees born on Christmas and hired in the 90s from order_by_exercises.sql. Update it to find just the first 5 employees. 

select * from employees
where (hire_date between '1990-01-01' and '1999-12-31') and (birth_date like '%-12-25')
order by birth_date, hire_date DESC limit 5;

-- Try to think of your results as batches, sets, or pages. The first five results are your first page. The five after that would be your second page, etc. Update the query to find the tenth page of results. 

select * from employees
where (hire_date between '1990-01-01' and '1999-12-31') and (birth_date like '%-12-25')
order by birth_date, hire_date DESC limit 5 offset 45;

-- LIMIT and OFFSET can be used to create multiple pages of data. What is the relationship between OFFSET (number of results to skip), LIMIT (number of results per page), and the page number?
-- Offset denotes the starting point. Limit defines the no. of results we want on the "page", which in this case is 5. Page number is the set/group/bucket at which your results are on. In the previous example, we want the page with the 50th result and the preceding 4 results before it. Therefore, offset = (limit * page no) - limit.