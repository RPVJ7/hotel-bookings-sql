# Hotel Bookings SQL Analysis Project

## Project Overview
This project explores a hotel bookings dataset from multiple hotels across Indian cities using SQL. The goal is to extract business insights that inform customer behavior, hotel performance, occupancy rates, and marketing effectiveness. It is part of a personal data portfolio hosted on GitHub.

## Dataset Schema

The analysis is based on four main tables:

1. **hotel_bookings**  
   - Booking data including stay duration, channel, and pricing.  
   - Key columns: `booking_id`, `customer_id`, `hotel_id`, `booking_date`, `stay_start_date`, `number_of_nights`, `per_night_rate`, `booking_channel`

2. **customers**  
   - Demographics and home city of each customer.  
   - Key columns: `customer_id`, `city_id`, `gender`, `dob`

3. **hotels**  
   - Metadata about each hotel, including capacity.  
   - Key columns: `id`, `name`, `city_id`, `capacity(no of rooms)`

4. **cities**  
   - Lookup table mapping city IDs to city names and states.  
   - Key columns: `id`, `city`, `state`

Additional flattening logic is used in `hotel_bookings_flatten` for date-specific occupancy calculations.

## Business Questions Answered

1. Top customers booking in the same city they live in  
2. Female contribution to bookings and revenue per hotel  
3. Bookings from customers from different states  
4. Peak occupancy date per hotel  
5. Customers who booked in at least 3 states  
6. Monthly occupancy rate by hotel  
7. Fully occupied dates per hotel  
8. Highest revenue-generating booking channel per hotel/month  
9. Booking channel share (percentage of total bookings)  
10. Revenue from Millennials and Gen Z  
11. Average stay duration  
12. Average lead time before booking  
13. Inactive customers (never booked)  
14. Customers with 3+ hotel stays in the same month

---

## Skills Demonstrated

- SQL Aggregations, Joins, and Filtering
- CTEs and Window Functions (`ROW_NUMBER`, `FIRST_VALUE`)
- Date Arithmetic and Time-based Grouping
- Business Insight Extraction from Raw Data

---

## Business Value

- Identify high-value and local customer behaviors
- Revenue segmentation by gender, generation, and geography
- Optimize marketing spend by booking channel
- Improve hotel resource planning using occupancy patterns

---

## Project Files

- `hotel_booking_analysis.sql` – SQL scripts answering all 14 business questions  
- `hotel_booking_project_and_data.xlsx` – Dataset containing all hotel booking data

---

## How to Use

1. Load the dataset into your SQL engine (e.g., MySQL, PostgreSQL, SQL Server)
2. Open and run `hotel_booking_analysis.sql`
3. Use query results for visualization, insight reporting, or further modeling

---

> This project is part of my public data portfolio to showcase practical SQL skills and business analytics thinking.
