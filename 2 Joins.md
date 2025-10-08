-- Day 2: MySQL JOINS - Theory and Concepts (GitHub Version)

/*
Concepts Covered:
1. INNER JOIN
   - Returns rows that have matching keys in both tables.
   - Used to combine related data.
   - Example Use Case: Fetch only customers who have placed orders.

2. LEFT JOIN
   - Returns all rows from the left table, and matched rows from the right table.
   - NULL for unmatched rows in right table.
   - Example Use Case: List all customers including those with no orders.

3. RIGHT JOIN
   - Returns all rows from the right table, and matched rows from the left table.
   - NULL for unmatched rows in left table.
   - Example Use Case: List all orders including those without a valid customer.

4. FULL OUTER JOIN (if supported, or simulated using UNION)
   - Returns all rows when there is a match in one of the tables.
   - Example Use Case: Combine all customers and orders, even if unmatched.

5. SELF JOIN
   - Join a table with itself.
   - Useful for hierarchical or relational data analysis.
   - Example Use Case: Find pairs of customers from the same city.

Key Points for Data Engineers:
- JOINs are critical for ETL pipelines, data warehouse transformations, and analytics.
- Use LEFT/RIGHT JOIN to identify missing or unmatched data.
- SELF JOIN helps in similarity analysis and hierarchical relationships.
- Always filter early in JOINs to improve performance.
*/
