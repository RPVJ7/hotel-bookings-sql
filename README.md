# hotel-bookings-sql
SQL project analyzing hotel booking data

Project Overview

This project explores a hotel bookings dataset from multiple hotels across Indian cities using SQL. The goal is to extract business insights that inform customer behavior, hotel performance, occupancy rates, and marketing effectiveness. It is part of a personal data portfolio hosted on GitHub.

**Dataset Schema**

The analysis is based on four main tables:

hotel_bookings

Booking data including stay duration, channel, and pricing.

Key columns: booking_id, customer_id, hotel_id, booking_date, stay_start_date, number_of_nights, per_night_rate, booking_channel

customers

Demographics and home city of each customer.

Key columns: customer_id, city_id, gender, dob

hotels

Metadata about each hotel, including capacity.

Key columns: id, name, city_id, capacity(no of rooms)

cities

Lookup table mapping city IDs to city names and states.

Key columns: id, city, state

Additional flattening logic is used in hotel_bookings_flatten for date-specific occupancy calculations.

**Business Questions Answered**

Who are the top customers booking in the same city they live in?(Top 5 ranked by volume and percentage)

How much do female customers contribute in bookings and revenue per hotel?

How many bookings come from customers from other states (interstate travelers)?

On which dates did each hotel see maximum occupancy?

Which customers have booked hotels in at least 3 different states?

What is the occupancy rate (percentage of rooms booked) per month per hotel?

Which dates were hotels fully occupied (at 100% capacity)?

Which booking channel generated the most sales per hotel per month?

What is the overall percentage share of bookings by channel?

How much revenue came from millennials vs Gen Z for each hotel?

What is the average stay duration at each hotel?

How far in advance do customers typically book?

Which customers never made a booking?

Which customers stayed in 3+ different hotels within the same month?

**Business Value**

Customer Segmentation: Understand behaviors of locals, travelers, females, and generations.

Revenue Analysis: Quantify monetary contribution by segment and channel.

Operational Planning: Monitor occupancy and peak demand days for resource allocation.

Marketing Strategy: Identify top-performing booking channels.

**Skills Demonstrated**

SQL for Data Exploration & Business Intelligence

Use of CTEs and nested queries

Window Functions (ROW_NUMBER())

Date Manipulation (stay windows, booking lead time)

Dimensional joins for attribute enrichment

**Project Files**

hotel_booking_analysis.sql – SQL scripts answering all 14 business questions.

hotel_booking_project_and_data.xlsx – The dataset (structure of hotel_bookings, customers, hotels, cities).

**How to Use**

Load the dataset into your SQL environment (e.g., MySQL, PostgreSQL, SQL Server).

Run each SQL block as outlined in the hotel_booking_analysis.sql file.

Modify queries as needed to support your DBMS syntax.

This project is part of my public data portfolio to showcase practical SQL skills and business analytics thinking.

