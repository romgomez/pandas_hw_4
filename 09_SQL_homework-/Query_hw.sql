USE sakila;

-- 1a
SELECT first_name,last_name FROM actor;

-- 1b
SELECT concat(first_name, " ", last_name) FROM actor;

-- 2a
SELECT actor_id, first_name, last_name
FROM actor 
WHERE first_name = "JOE";

-- 2b
SELECT actor_id, first_name, last_name
FROM actor 
WHERE last_name LIKE "%GEN%";

-- 2c
SELECT actor_id, first_name, last_name
FROM actor 
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name ASC;

-- 2d 
SELECT country_id, country
FROM country
WHERE country IN ("Afghanistan","Bangladesh", "China");

-- 3a
ALTER TABLE actor
ADD description BLOB;

-- 3b
ALTER TABLE actor
DROP description;

-- 4a
SELECT COUNT(last_name), last_name
FROM actor 
GROUP BY last_name;

-- 4b
SELECT COUNT(last_name), last_name
FROM actor 
GROUP BY last_name
HAVING COUNT(last_name) >= 2;

-- 4c
UPDATE actor 
SET first_name = "GROUCHO"
WHERE first_name = "HARPO" AND last_name = "WILLIAMS";

-- 4d
SET SQL_SAFE_UPDATES = 0;
UPDATE actor 
SET first_name = "GROUCHO"
WHERE first_name = "HARPO";

-- 5a 
-- SHOW CREATE TABLE address;  

-- 6a
SELECT s.first_name, s.last_name, a.address_id, a.address
FROM staff as s
INNER JOIN address as a ON
s.address_id = a.address_id;

-- 6b
SELECT s.first_name, s.last_name, p.staff_id, SUM(p.amount)
FROM staff as s
INNER JOIN payment as p ON s.staff_id = p.staff_id
WHERE p.payment_date LIKE "2005-08%" GROUP BY p.staff_id;

-- 6c 
SELECT f.film_id, f.title, COUNT(fa.actor_id) as "Number_of_Actors"
FROM film as f
INNER JOIN film_actor as fa ON fa.film_id = f.film_id
GROUP BY f.film_id;

-- 6d
SELECT f.film_id, f.title, COUNT(f.film_id) as "Number_of_Copies"
FROM film as f
INNER JOIN inventory as i ON i.film_id = f.film_id
WHERE f.title = "Hunchback Impossible"
GROUP BY f.film_id;

-- 6e
SELECT c.first_name, c.last_name, SUM(p.amount) as "Total_Amount_Paid"
FROM payment as p
INNER JOIN customer as c ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name ASC;

-- 7a 
SELECT title 
FROM film
WHERE language_id IN 
(	SELECT language_id 
    FROM language
    WHERE language_id=1 
    AND title LIKE "K%" OR title LIKE "Q%"
);
    
-- 7b
SELECT last_name, first_name 
FROM actor 
WHERE actor_id IN 
(	
	SELECT actor_id 
	FROM film_actor 
	WHERE film_id IN 
    (	
		SELECT film_id 
		FROM film 
		WHERE title = "Alone Trip"
	)
);


-- 7c
SELECT c.last_name, c.first_name, c.email 
FROM customer as c
INNER JOIN customer_list as cl ON c.customer_id = cl.ID 
WHERE cl.country = 'Canada';

-- 7d
SELECT title 
FROM film 
WHERE film_id 
IN 
(	
	SELECT film_id 
	FROM film_category 
    WHERE category_id IN 
    (
		SELECT category_id 
        FROM category 
        WHERE name = "Family"
	)
);

-- 7e 
SELECT f.title, COUNT(f.film_id) AS "Rent_Count"
FROM film as f, inventory as i, rental as r 
WHERE f.film_id = i.film_id AND r.inventory_id = i.inventory_id 
GROUP BY i.film_id 
ORDER BY COUNT(f.film_id) DESC
LIMIT 5;

-- 7f
SELECT s.store_id, SUM(p.amount) AS "Total_Revenue"
FROM store as s
INNER JOIN staff as st ON s.store_id = st.store_id 
INNER JOIN payment as p ON p.staff_id = st.staff_id 
GROUP BY s.store_id;

-- 7g
SELECT s.store_id, ci.city, co.country 
FROM store as s
INNER JOIN address as a ON s.address_id = a.address_id 
INNER JOIN city as ci ON a.city_id = ci.city_id 
INNER JOIN country ON ci.country_id = co.country_id;

-- 7h
SELECT name, SUM(p.amount) AS "Gross_Revenue" 
FROM category as c 
INNER JOIN film_category as fc ON fc.category_id = c.category_id 
INNER JOIN inventory as i ON i.film_id = fc.film_id 
INNER JOIN rental as r ON r.inventory_id = i.inventory_id 
INNER JOIN payment p ON p.rental_id = r.rental_id 
GROUP BY c.name 
ORDER BY "Gross_Revenue" DESC 
LIMIT 5;

-- 8a 
DROP VIEW IF EXISTS top_five_genres; 
CREATE VIEW top_five_genres AS SELECT c.name as "Genre", SUM(p.amount) AS "Gross_Revenue" 
FROM category c 
INNER JOIN film_category fc ON fc.category_id = c.category_id 
INNER JOIN inventory i ON i.film_id = fc.film_id 
INNER JOIN rental r ON r.inventory_id = i.inventory_id 
INNER JOIN payment p ON p.rental_id = r.rental_id 
GROUP BY c.name 
ORDER BY "Gross_Revenue" DESC 
LIMIT 5;

-- 8b
SELECT * FROM top_five_genres;

-- 8c
DROP VIEW top_five_genres;

