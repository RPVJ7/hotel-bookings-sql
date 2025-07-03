-- hotel_booking_analysis.sql
-- SQL Analysis on Hotel Bookings Dataset

-- 1. Top 5 customers booking in same city they live
WITH cte AS (
    SELECT b.customer_id, 
           SUM(CASE WHEN cc.city = hc.city THEN 1 ELSE 0 END) AS same_city_bookings,
           COUNT(booking_id) AS total_bookings
    FROM hotel_bookings b
    JOIN customers c ON c.customer_id = b.customer_id
    JOIN cities cc ON cc.id = c.city_id
    JOIN hotels h ON b.hotel_id = h.id
    JOIN cities hc ON h.city_id = hc.id
    GROUP BY b.customer_id
)
SELECT TOP 5 customer_id,
       same_city_bookings * 100.0 / total_bookings AS percent_of_bookings
FROM cte
ORDER BY same_city_bookings DESC, percent_of_bookings DESC;

-- 2. Female contribution to bookings and revenue per hotel
SELECT b.hotel_id,
       ROUND(SUM(CASE WHEN c.gender = 'F' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS female_bookings_contribution,
       ROUND(SUM(CASE WHEN c.gender = 'F' THEN b.number_of_nights * b.per_night_rate ELSE 0 END) * 100.0 /
             SUM(b.number_of_nights * b.per_night_rate), 2) AS female_revenue_contribution
FROM hotel_bookings b
JOIN customers c ON b.customer_id = c.customer_id
GROUP BY b.hotel_id;

-- 3. Bookings from customers from different state
SELECT b.hotel_id, COUNT(*) AS no_of_bookings
FROM hotel_bookings b
JOIN hotels h ON b.hotel_id = h.id
JOIN customers c ON c.customer_id = b.customer_id
JOIN cities ch ON ch.id = h.city_id
JOIN cities cc ON cc.id = c.city_id
WHERE cc.state != ch.state
GROUP BY b.hotel_id;

-- 4. Peak occupancy date per hotel
WITH date_range AS (
    SELECT MIN(stay_start_date) AS min_date, MAX(DATEADD(day, number_of_nights, stay_start_date)) AS max_date
    FROM hotel_bookings
    UNION ALL
    SELECT DATEADD(DAY, 1, min_date), max_date FROM date_range WHERE DATEADD(DAY, 1, min_date) <= max_date
),
occp AS (
    SELECT dr.min_date AS [date], hotel_id,
           SUM(CASE WHEN dr.min_date BETWEEN stay_start_date AND DATEADD(day, number_of_nights - 1, stay_start_date) THEN 1 ELSE 0 END) AS occupancy
    FROM hotel_bookings h
    CROSS JOIN date_range dr
    GROUP BY dr.min_date, hotel_id
)
SELECT hotel_id, [date], occupancy
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY hotel_id ORDER BY occupancy DESC) AS rn FROM occp
) a
WHERE rn = 1;

-- 5. Customers who booked in at least 3 states
SELECT customer_id, COUNT(DISTINCT c.state) AS distinct_state_count
FROM hotel_bookings b
JOIN hotels h ON h.id = b.hotel_id
JOIN cities c ON h.city_id = c.id
GROUP BY customer_id
HAVING COUNT(DISTINCT c.state) >= 3;

-- 6. Monthly occupancy rate
WITH cte AS (
    SELECT hotel_id, CAST(stay_date AS DATE) AS [date], MAX(h.[capacity(no of rooms)]) AS capacity,
           COUNT(*) AS occupants
    FROM hotel_bookings_flatten b
    JOIN hotels h ON b.hotel_id = h.id
    GROUP BY hotel_id, CAST(stay_date AS DATE)
)
SELECT hotel_id, MONTH([date]) AS mnth,
       SUM(occupants) AS occupants, 
       SUM(capacity) AS capacity,
       SUM(occupants) * 100.0 / SUM(capacity) AS ocr
FROM cte
GROUP BY hotel_id, MONTH([date]);

-- 7. Fully occupied dates
SELECT hotel_id, stay_date, COUNT(*) AS no_of_bookings, MAX(h.[capacity(no of rooms)]) AS capacity
FROM hotel_bookings_flatten b
JOIN hotels h ON b.hotel_id = h.id
GROUP BY hotel_id, stay_date
HAVING COUNT(*) = MAX(h.[capacity(no of rooms)]);

-- 8. Highest sales channel per hotel/month
WITH cte AS (
    SELECT hotel_id, [booking _channel] AS booking_channel, FORMAT(booking_date, 'yyyyMM') AS booking_month,
           SUM(per_night_rate * number_of_nights) AS sales
    FROM hotel_bookings
    GROUP BY hotel_id, [booking _channel], FORMAT(booking_date, 'yyyyMM')
)
SELECT hotel_id, booking_month, booking_channel
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY hotel_id, booking_month ORDER BY sales DESC) AS rn FROM cte
) a
WHERE rn = 1;

-- 9. Booking channel share
WITH cte AS (
    SELECT [booking _channel], COUNT(*) AS no_of_bookings FROM hotel_bookings GROUP BY [booking _channel]
)
SELECT *, ROUND(no_of_bookings * 100.0 / SUM(no_of_bookings) OVER (), 2) AS bookings_share
FROM cte;

-- 10. Revenue by generation
SELECT hotel_id,
       SUM(CASE WHEN YEAR(c.dob) BETWEEN 1980 AND 1996 THEN per_night_rate * number_of_nights ELSE 0 END) AS millenial_revenue,
       SUM(CASE WHEN YEAR(c.dob) > 1996 THEN per_night_rate * number_of_nights ELSE 0 END) AS genz_revenue
FROM hotel_bookings b
JOIN customers c ON b.customer_id = c.customer_id
GROUP BY hotel_id;

-- 11. Average stay duration
SELECT hotel_id, ROUND(AVG(number_of_nights), 2) AS average_stay_duration
FROM hotel_bookings
GROUP BY hotel_id;

-- 12. Advance booking duration
SELECT hotel_id, AVG(DATEDIFF(day, booking_date, stay_start_date) * 1.0) AS avg_days_in_advance
FROM hotel_bookings
GROUP BY hotel_id;

-- 13. Customers who never booked
SELECT c.customer_id FROM customers c
LEFT JOIN hotel_bookings b ON c.customer_id = b.customer_id
WHERE b.booking_id IS NULL;

-- 14. Customers staying in 3+ hotels in same month
SELECT customer_id, DATENAME(month, stay_date) AS mnth, COUNT(DISTINCT hotel_id) AS distinct_hotels
FROM hotel_bookings_flatten
GROUP BY customer_id, DATENAME(month, stay_date)
HAVING COUNT(DISTINCT hotel_id) >= 3;
