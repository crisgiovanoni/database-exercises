use employees;

-- How much do the current managers of each department get paid, relative to the average salary for the department? Is there any department where the department manager gets paid less than the average salary?

use bayes_819;

CREATE TEMPORARY TABLE comp_sal as
SELECT de.emp_no, s.salary, m.dept_no, m.to_date 
FROM employees.dept_emp as de
JOIN employees.salaries as s
	ON de.emp_no = s.emp_no
JOIN employees.dept_manager as m
	ON de.dept_no = m.dept_no
WHERE de.to_date = '9999-01-01';

select * from comp_sal
limit 10;

select dept_no,avg(salary)
from comp_sal
group by dept_no
limit 5;

use world;

-- What languages are spoken in Santa Monica?
select language, percentage
from city as c
join countrylanguage as cl
on c.countrycode = cl.countrycode
where c.name = 'Santa Monica';

-- How many different countries are in each region?

select region, count(name)
from country
group by region
order by count(name);

-- What is the population for each region?

select region, sum(population)
from country
group by region
order by sum(population) desc;

-- What is the population for each continent?

select continent, sum(population)
from country
group by continent
order by sum(population) desc;

-- What is the average life expectancy globally?

select avg(lifeexpectancy)
from country;

-- What is the average life expectancy for each region, each continent? Sort the results from shortest to longest

select region, avg(lifeexpectancy)
from country
group by region
order by avg(lifeexpectancy);

select continent, avg(lifeexpectancy)
from country
group by continent
order by avg(lifeexpectancy);

/*
BONUS
Find all the countries whose local name is different from the official name
How many countries have a life expectancy less than x?
What state is city x located in?
What region of the world is city x located in?
What country (use the human readable name) city x located in?
What is the life expectancy in city x? */

select name, localname
from country
where name != localname;

select name, lifeexpectancy
from country
where lifeexpectancy < 70;

select ct.name as City, cn.name as Country, region as Region
from city as ct
join country as cn
on ct.countrycode = cn.code
where ct.name = "Escobar";

select ct.name as City, cn.name as Country
from city as ct
join country as cn
on ct.countrycode = cn.code
where ct.name = "Baku";

select ct.name as City, cn.lifeexpectancy as Life_Expectancy, cn.name as Country
from city as ct
join country as cn
on ct.countrycode = cn.code
where ct.name = "Itu";

-- #### SAKILA ####

use sakila;
/* Display the first and last names in all lowercase of all the actors. */

select
concat(
upper(substring(first_name,1,1)),
lower(substring(first_name,2))
) as First_Name,
concat(
upper(substring(last_name,1,1)),
lower(substring(last_name,2))
) as Last_Name
from actor;

-- You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you could use to obtain this information?

select actor_id, first_name, last_name
from actor
where first_name = 'Joe';

-- Find all actors whose last name contain the letters "gen":

select concat(first_name, ' ', last_name) as Actor_Name
from actor
where last_name like '%gen%';

-- Find all actors whose last names contain the letters "li". This time, order the rows by last name and first name, in that order.

select concat(first_name, ' ', last_name) as Actor_Name
from actor
where last_name like '%li%'
order by last_name, first_name;

-- Using IN, display the country_id and country columns for the following countries: Afghanistan, Bangladesh, and China:

select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- List the last names of all the actors, as well as how many actors have that last name.

select last_name, count(*) as no_of_actors
from actor
group by last_name;

-- 7. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

select last_name, count(*) as no_of_actors
from actor
group by last_name
having count(last_name) > 1;

-- 8. You cannot locate the schema of the address table. Which query would you use to re-create it?

describe address;

-- 9. Use JOIN to display the first and last names, as well as the address, of each staff member.

select s.first_name, s.last_name, a.address
from staff as s
join address as a
on s.address_id = a.address_id;

-- 10. Use JOIN to display the total amount rung up by each staff member in August of 2005.

select r.staff_id, sum(p.amount)
from rental as r
join payment as p
	on r.rental_id = p.rental_id
where r.rental_date between '2005-08-01' and '2005-08-31'
group by r.staff_id;

-- 11. List each film and the number of actors who are listed for that film.

select f.title, count(a.actor_id) as no_of_actors
from film as f
join film_actor as a
	on f.film_id = a.film_id
group by f.title;

-- 12. How many copies of the film Hunchback Impossible exist in the inventory system?

select f.title, count(*)
from inventory as i
join film as f
	on i.film_id = f.film_id
	and f.title = 'Hunchback Impossible';

-- 13. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

select f.title
from film as f
where substring(f.title,1,1) in ('K','Q')
	and language_id = 
	(select l.language_id
	from language as l
	where l.name = 'English');
	
-- 14. Use subqueries to display all actors who appear in the film Alone Trip.

select concat(a.first_name, ' ', a.last_name) as Actors_in_Alone_Trip
from actor as a
join film_actor as fa
	on a.actor_id = fa.actor_id
where film_id = 
	(select f.film_id
	from film as f
	where f.title = 'Alone Trip');

-- 15. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers.

select concat(cu.first_name, ' ', cu.last_name) as name, cu.email, mp.city, mp.country
from customer as cu
join address as ad
	on cu.address_id = ad.address_id
join (
	select ci.city, cn.country
	from city as ci
	join country as cn
		on ci.country_id = cn.country_id
	where cn.country = 'Canada') as mp;

-- 16. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.

select distinct f.title
from film as f
join film_category as fc
where fc.category_id =
	(select c.category_id
	from category as c
	where c.name = 'Family');
	
-- 17. Write a query to display how much business, in dollars, each store brought in.

select s.store_id, sum(p.amount)
from store as s
join customer as c
	on s.store_id = c.store_id
join payment as p
	on c.customer_id = p.customer_id
group by s.store_id;

-- 18. Write a query to display for each store its store ID, city, and country.

select s.store_id, ci.city, cn.country
from store as s
join address as a
	on s.address_id = a.address_id
join city as ci
	on a.city_id = ci.city_id
join country as cn
	on ci.country_id = cn.country_id;

-- 19. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

select ge.name as Genre, sum(p.amount) as Gross_Revenue
from payment as p
join rental as r
	on p.rental_id = r.rental_id
join inventory as i
	on i.inventory_id = r.inventory_id
join
	(select fc.film_id, c.name
	from category as c
	join film_category as fc
		on c.category_id = fc.category_id) as ge
group by ge.name
order by sum(p.amount) desc
limit 5;

/* SELECT statements
1. Select all columns from the actor table.
2. Select only the last_name column from the actor table.
3. Select only the following columns from the film table. **Nothing specified */

select *
from actor;

select last_name
from actor;

/* DISTINCT operator
1. Select all distinct (different) last names from the actor table.
2. Select all distinct (different) postal codes from the address table.
Select all distinct (different) ratings from the film table. */

select distinct last_name
from actor;

select distinct postal_code
from address;

select distinct rating
from film;

/* WHERE clause
1. Select the title, description, rating, movie length columns from the films table that last 3 hours or longer.
2. Select the payment id, amount, and payment date columns from the payments table for payments made on or after 05/27/2005.
3. Select the primary key, amount, and payment date columns from the payment table for payments made on 05/27/2005.
4. Select all columns from the customer table for rows that have a last names beginning with S and a first names ending with N.
5. Select all columns from the customer table for rows where the customer is inactive or has a last name beginning with "M".
6. Select all columns from the category table for rows where the primary key is greater than 4 and the name field begins with either C, S or T.
7. Select all columns minus the password column from the staff table for rows that contain a password.
8. Select all columns minus the password column from the staff table for rows that do not contain a password. */

select title, description, rating, length
from film
where length > 180;

select payment_id, amount, payment_date
from payment
where payment_date >= '2005-05-27';

select payment_id, amount, payment_date
from payment
where payment_date = '2005-05-27';

select *
from customer
where last_name like 's%' and first_name like '%n';

select *
from customer
where active = 0 or last_name like 'm%';

select *
from category
where category_id > 4 and category.name in ('C%', 'S%', 'T%');

select staff_id, address_id, store_id, first_name, last_name, address_id, picture, email, store_id, active, username, last_update
from staff
where password IS NOT NULL;

select staff_id, address_id, store_id, first_name, last_name, address_id, picture, email, store_id, active, username, last_update
from staff
where password IS NULL;

/* IN operator
1. Select the phone and district columns from the address table for addresses in California, England, Taipei, or West Java.
2. Select the payment id, amount, and payment date columns from the payment table for payments made on 05/25/2005, 05/27/2005, and 05/29/2005. (Use the IN operator and the DATE function, instead of the AND operator as in previous exercises.)
3. Select all columns from the film table for films rated G, PG-13 or NC-17.

BETWEEN operator
1. Select all columns from the payment table for payments made between midnight 05/25/2005 and 1 second before midnight 05/26/2005.
2. Select the following columns from the film table for films where the length of the description is between 100 and 120.
Hint: total_rental_cost = rental_duration * rental_rate

LIKE operator
1. Select the following columns from the film table for rows where the description begins with "A Thoughtful".
2. Select the following columns from the film table for rows where the description ends with the word "Boat".
3. Select the following columns from the film table where the description contains the word "Database" and the length of the film is greater than 3 hours. */

select phone, district
from address
where district in ('California', 'England', 'Taipei', 'West Java');

select payment_id, amount, payment_date
from payment
where date(payment_date) in ('2005-05-25','2005-05-27','2005-05-29');

select *
from payment
where payment_date between '2005-05-25 24:00:00' and '2005-05-26 23:59:59';

select *
from film
where length(description) between 100 and 200;

select *
from film
where description like 'A Thoughtful%';

select *
from film
where description like '%Boat';

select *
from film
where description like '%Database%' and length > 180;

/* LIMIT Operator
1. Select all columns from the payment table and only include the first 20 rows.
2. Select the payment date and amount columns from the payment table for rows where the payment amount is greater than 5, and only select rows whose zero-based index in the result set is between 1000-2000.
3. Select all columns from the customer table, limiting results to those where the zero-based index is between 101-200. */

select *
from payment
limit 20;

select payment_date, amount
from payment
where amount > 5
limit 1000
offset 999;

select *
from customer
limit 200
offset 100;

/*ORDER BY statement
1. Select all columns from the film table and order rows by the length field in ascending order.
2. Select all distinct ratings from the film table ordered by rating in descending order.
3. Select the payment date and amount columns from the payment table for the first 20 payments ordered by payment amount in descending order.
4. Select the title, description, special features, length, and rental duration columns from the film table for the first 10 films with behind the scenes footage under 2 hours in length and a rental duration between 5 and 7 days, ordered by length in descending order. */

select *
from film
order by length;

select distinct rating
from film
order by rating desc;

select payment_date, amount
from payment
order by amount desc
limit 20;

select title, description, special_features, length, rental_duration
from film
where length < 120 and special_features like '%Behind The Scenes%' and rental_duration between 5 and 7
order by length desc
limit 10;

/* 
JOINS
1. Select customer first_name/last_name and actor first_name/last_name columns from performing a left join between the customer and actor column on the last_name column in each table. (i.e. customer.last_name = actor.last_name)
• Label customer first_name/last_name columns as customer_first_name/customer_last_name
• Label actor first_name/last_name columns in a similar fashion.
• returns correct number of records: 599*/

select c.first_name as customer_first_name, c.last_name as customer_last_name, a.first_name as actor_first_name, a.last_name as actor_last_name
from customer as c
left join actor as a
on c.last_name = a.last_name;

/*2. Select the customer first_name/last_name and actor first_name/last_name columns from performing a /right join between the customer and actor column on the last_name column in each table. (i.e. customer.last_name = actor.last_name)
• returns correct number of records: 200 */

select c.first_name as customer_first_name, c.last_name as customer_last_name
from customer as c
right join actor as a
on c.last_name = a.last_name;

/*3. Select the customer first_name/last_name and actor first_name/last_name columns from performing an inner join between the customer and actor column on the last_name column in each table. (i.e. customer.last_name = actor.last_name)
• returns correct number of records: 43*/

select c.first_name as customer_first_name, c.last_name as customer_last_name, a.first_name as actor_first_name, a.last_name as actor_last_name
from customer as c
join actor as a
on c.last_name = a.last_name;

/*48. Select the city name and country name columns from the city table, performing a left join with the country table to get the country name column.
• Returns correct records: 600*/

select ci.city, cn.country
from city as ci
left join country as cn using(country_id);

/*5. Select the title, description, release year, and language name columns from the film table, performing a left join with the language table to get the "language" column.
• Label the language.name column as "language"
• Returns 1000 rows*/

select f.title, f.description, f.release_year, l.name
from film as f
left join language as l
using(language_id);

/*6. Select the first_name, last_name, address, address2, city name, district, and postal code columns from the staff table, performing 2 left joins with the address table then the city table to get the address and city related columns.
• returns correct number of rows: 2 */

select s.first_name, s.last_name, a.address, a.address2, ci.city, a.district, a.postal_code
from staff as s
left join address as a
using(address_id)
left join city as ci
using(city_id)




