-- Indexes

CREATE INDEX idx_product_category ON product(category); 

CREATE INDEX idx_product_expiry ON product(expiry_date);

CREATE INDEX idx_customer_visits_branch ON customer_visits(branch_id);

CREATE INDEX idx_delivery_details_product ON delivery_details(product_id);

CREATE INDEX idx_employee_branch ON employee(branch_id);

CREATE INDEX idx_branch_product_stock ON branch_product_stock(branch_id, product_id);

-- Verifying Indexes with EXPLAIN

EXPLAIN SELECT name, price 
FROM product 
WHERE category = 'Protein';
-- Finds all products in a specific category.

EXPLAIN SELECT name, expiry_date 
FROM product 
WHERE expiry_date < CURDATE() + INTERVAL 7 DAY;
-- Finds products expiring within 7 days.

EXPLAIN SELECT customer_id
FROM customer_visits
WHERE branch_id = '2';
-- Finds customers that visited a specific branch.

EXPLAIN SELECT delivery_id, quantity 
FROM delivery_details
WHERE product_id = '2';
-- Finds deliveries that included a certain product.

EXPLAIN SELECT shifts
FROM employee
WHERE employee_id = '4';
-- Finds shifts assigned to an employee.

EXPLAIN SELECT product_id 
FROM branch_product_stock
WHERE branch_id = '1';
-- Finds products stocked in a specific branch.


-- Views
CREATE VIEW Employee_Public AS
SELECT employee_id, employee_name, job_title
FROM employee;
-- Shows employee details without salary or personal info

CREATE VIEW Customer_Public AS
SELECT customer_id, customer_name, customer_age
FROM customer;
-- Shows customer info without contact info for privacy

CREATE VIEW Branch_Visits AS
SELECT 
    b.address AS Branch_Address,
    COUNT(cv.customer_id) AS Total_Visits
FROM store_branch b
JOIN customer_visits cv ON b.branch_id = cv.branch_id
GROUP BY b.address;
-- Shows number of visits per branch

CREATE VIEW Product_Summary AS
SELECT 
    p.name AS Product_Name,
    SUM(dd.quantity) AS Total_Amount_Delivered
FROM product p
JOIN delivery_details dd ON p.product_id = dd.product_id
GROUP BY p.name;
-- Shows total amount delivered per product

CREATE VIEW Branch_Products AS
SELECT 
    b.address AS Branch,
    p.name AS Product,
    bps.quantity AS Stock
FROM store_branch b
JOIN branch_product_stock bps ON b.branch_id = bps.branch_id
JOIN product p ON bps.product_id = p.product_id;
-- Shows the branch, the product, and the quantity in stock

CREATE VIEW Employee_Branch_Info AS
SELECT 
    e.employee_name AS Employee,
    e.job_title AS Role,
    e.shifts AS Shift_Time,
    b.address AS Branch,
    e.wage AS Hourly_Wage
FROM employee e
JOIN store_branch b ON e.branch_id = b.branch_id;
-- Shows employee name, role, shifts, branch location, and wage

