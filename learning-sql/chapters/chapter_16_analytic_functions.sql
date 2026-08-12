# CHAPTER 16: Analytic Functions

## Analytic Function Concepts

### Data Windows

SELECT QUARTER(payment_date) AS quarter,
       MONTHNAME(payment_date) AS month_nm,
       SUM(amount) AS monthly_sales
FROM payment
WHERE YEAR(payment_date) = 2005
GROUP BY QUARTER(payment_date), MONTHNAME(payment_date);

SELECT QUARTER(payment_date) AS quarter,
       MONTHNAME(payment_date) AS month_nm,
       SUM(amount) AS monthly_sales,
       MAX(SUM(amount)) OVER () AS max_overal_sales, # very interesting
       MAX(SUM(amount)) OVER (PARTITION BY QUARTER(payment_date)) AS max_qrtr_sales
FROM payment
WHERE YEAR(payment_date) = 2005
GROUP BY QUARTER(payment_date), MONTHNAME(payment_date);

SELECT QUARTER(payment_date) AS quarter,
       MONTHNAME(payment_date) AS month_nm,
       SUM(amount) OVER () AS max_overral_sales,
       SUM(amount) OVER (PARTITION BY QUARTER(payment_date)) AS max_qrtr_sales
FROM payment
WHERE YEAR(payment_date) = 2005;

### Localized Sorting

SELECT QUARTER(payment_date) AS quarter,
       MONTHNAME(payment_date) AS month_nm,
       SUM(amount) AS monthly_sales,
       RANK() OVER (ORDER BY SUM(amount) DESC) AS sales_rank
FROM payment
WHERE YEAR(payment_date) = 2005
GROUP BY QUARTER(payment_date), MONTHNAME(payment_date)
ORDER BY 1, 2;

SELECT QUARTER(payment_date) AS quarter,
       MONTHNAME(payment_date) AS month_nm,
       SUM(amount) AS monthly_sales,
       RANK() OVER (PARTITION BY QUARTER(payment_date) ORDER BY SUM(amount) DESC) AS qtr_sales_rank
FROM payment
WHERE YEAR(payment_date) = 2005
GROUP BY QUARTER(payment_date), MONTHNAME(payment_date)
ORDER BY 1, 4;

## Ranking

### Ranking Functions

SELECT customer_id, COUNT(*) AS num_rentals
FROM rental
GROUP BY customer_id
ORDER BY 2 DESC;

SELECT customer_id,
       COUNT(*) AS num_rentals,
       ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS row_number_rnk,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS rank_rnk,
       DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS dense_rank_rnk
FROM rental
GROUP BY customer_id
ORDER BY 2 DESC;

### Generating Multiple Rankings

SELECT customer_id,
       MONTHNAME(rental_date) AS rental_month,
       COUNT(*) AS num_rentals
FROM rental
GROUP BY customer_id, MONTHNAME(rental_date)
ORDER BY 2, 3 DESC;

SELECT customer_id,
       MONTHNAME(rental_date) AS rental_month,
       COUNT(*) AS num_rentals,
       RANK() OVER (PARTITION BY MONTHNAME(rental_date) ORDER BY COUNT(*) DESC) AS rank_rnk
FROM rental
GROUP BY customer_id, MONTHNAME(rental_date)
ORDER BY 2, 3 DESC;

SELECT customer_id,
       MONTHNAME(rental_date) AS rental_month,
       COUNT(*) AS num_rentals,
       ROW_NUMBER() OVER (PARTITION BY MONTHNAME(rental_date) ORDER BY COUNT(*) DESC) AS row_number_rnk,
       RANK() OVER (PARTITION BY MONTHNAME(rental_date) ORDER BY COUNT(*) DESC) AS rank_rnk,
       DENSE_RANK() OVER (PARTITION BY MONTHNAME(rental_date) ORDER BY COUNT(*) DESC) AS dense_rank_rnk
FROM rental
GROUP BY customer_id, MONTHNAME(rental_date)
ORDER BY 2, 3 DESC;

SELECT customer_id,
       MONTHNAME(rental_date) AS rental_month,
       COUNT(*) AS num_rentals,
       MAX(COUNT(*)) OVER (PARTITION BY customer_id) AS max_rental_in_month
FROM rental
GROUP BY customer_id, MONTHNAME(rental_date)
ORDER BY 2, 3 DESC;

SELECT customer_id,
       MONTHNAME(rental_date) AS rental_month,
       COUNT(*) AS num_rentals
FROM rental
WHERE customer_id = 148
GROUP BY customer_id, MONTHNAME(rental_date)
ORDER BY 2, 3 DESC;

SELECT customer_id,
       MONTHNAME(rental_date) AS rental_month,
       COUNT(*) AS num_rentals,
       MAX(COUNT(*)) OVER () AS max_total_rental_in_month
FROM rental
GROUP BY customer_id, MONTHNAME(rental_date)
ORDER BY 2, 3 DESC;

SELECT customer_id,
       MONTHNAME(rental_date) AS rental_month,
       COUNT(*) AS num_rentals
FROM rental
GROUP BY customer_id, MONTHNAME(rental_date)
HAVING COUNT(*) = 22;

SELECT customer_id, rental_month, num_rentals, rank_rnk AS ranking
FROM (
    SELECT customer_id,
           MONTHNAME(rental_date) AS rental_month,
           COUNT(*) AS num_rentals,
           RANK() OVER (PARTITION BY MONTHNAME(rental_date) ORDER BY COUNT(*) DESC) AS rank_rnk
    FROM rental
    GROUP BY customer_id, MONTHNAME(rental_date)
    ORDER BY 2, 3 DESC
) AS cust_rankings
WHERE rank_rnk <= 5
ORDER BY rental_month, num_rentals DESC, rank_rnk;

## Reporting Functions

SELECT MONTHNAME(payment_date) AS payment_month,
       amount,
       SUM(amount) OVER (PARTITION BY MONTHNAME(payment_date)) AS monthly_total,
       SUM(amount) OVER () AS grand_total
FROM payment
WHERE amount >= 10
ORDER BY 1;

SELECT SUM(amount)
FROM payment
WHERE amount >= 10 AND MONTHNAME(payment_date) = 'August'
ORDER BY 1;

SELECT MONTHNAME(payment_date) AS payment_month,
       SUM(amount) AS month_total,
       ROUND(SUM(amount) / (SUM(SUM(amount)) OVER ()) * 100, 2) AS pct_of_total # interesting
FROM payment
GROUP BY MONTHNAME(payment_date);

SELECT MONTHNAME(payment_date) AS payment_month,
       SUM(amount) AS month_total,
       CASE SUM(amount)
           WHEN MAX(SUM(amount)) OVER () THEN 'Highest'
           WHEN MIN(SUM(amount)) OVER () THEN 'Lowest'
           ELSE 'Middle'
       END AS descriptor
FROM payment
GROUP BY MONTHNAME(payment_date);

### Window Frames

SELECT YEARWEEK(payment_date) AS payment_week,
       SUM(amount) AS week_total,
       SUM(SUM(amount)) OVER (ORDER BY YEARWEEK(payment_date) ROWS UNBOUNDED PRECEDING) AS rolling_sum
FROM payment
GROUP BY YEARWEEK(payment_date)
ORDER BY 1;

SELECT YEARWEEK(payment_date) AS payment_week,
       SUM(amount) AS week_total,
       AVG(SUM(amount)) OVER (ORDER BY YEARWEEK(payment_date) ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS rolling_3wk_avg
FROM payment
GROUP BY YEARWEEK(payment_date)
ORDER BY 1;


SELECT DATE(payment_date),
       SUM(amount),
       AVG(SUM(amount)) OVER (ORDER BY DATE(payment_date)
           RANGE BETWEEN INTERVAL 3 DAY PRECEDING AND INTERVAL 3 DAY FOLLOWING) AS 7_day_avg
FROM payment
WHERE payment_date BETWEEN '2005-07-01' AND '2005-09-01'
GROUP BY DATE(payment_date)
ORDER BY 1;

### Lag and Lead

SELECT YEARWEEK(payment_date) AS payment_week,
       SUM(amount) AS week_total,
       LAG(SUM(amount), 1) OVER (ORDER BY YEARWEEK(payment_date)) AS prev_wk_tot,
       LEAD(SUM(amount), 1) OVER (ORDER BY YEARWEEK(payment_date)) AS next_wk_tot
FROM payment
GROUP BY YEARWEEK(payment_date)
ORDER BY 1;

SELECT YEARWEEK(payment_date) AS payment_week,
       SUM(amount) AS week_total,
       ROUND(((SUM(amount)/(LAG(SUM(amount)) over (ORDER BY YEARWEEK(payment_date))))-1)*100,2) AS pct_diff
FROM payment
GROUP BY YEARWEEK(payment_date)
ORDER BY 1;

### Column Value Concatenation

SELECT f.title,
       GROUP_CONCAT(a.last_name ORDER BY a.last_name SEPARATOR ', ') AS actors
FROM actor AS a
    INNER JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
    INNER JOIN film AS f
    ON fa.film_id = f.film_id
GROUP BY f.title
HAVING COUNT(*) = 3;

## Test Your Knowledge

### Exercise 16-1

#### Personal

SELECT *,
       ROW_NUMBER() OVER (ORDER BY tot_sales DESC) AS ranking
FROM sales_fact;

#### Book

SELECT year_no, month_no, tot_sales,
       RANK() OVER (ORDER BY tot_sales DESC) AS sales_rank
FROM sales_fact;

### Exercise 16-2

#### Personal

SELECT *,
       ROW_NUMBER() OVER (PARTITION BY year_no ORDER BY tot_sales DESC) AS ranking
FROM sales_fact;

#### Book

SELECT year_no, month_no, tot_sales,
       RANK() OVER (PARTITION BY year_no ORDER BY tot_sales DESC) AS sales_rank
FROM sales_fact;

### Exercise 16-3

#### Personal

SELECT *,
       LAG(tot_sales) OVER (ORDER BY month_no) AS last_tot_sales
FROM sales_fact
WHERE year_no = 2020;

#### Book

SELECT year_no, month_no, tot_sales,
       LAG(tot_sales) OVER (ORDER BY month_no) AS prev_month_sales
FROM sales_fact
WHERE year_no = 2020;