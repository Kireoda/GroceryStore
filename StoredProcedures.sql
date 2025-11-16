-- Stored Procedure to update the stock quantity of a product
CREATE PROCEDURE Update_Product_Stock (
    IN p_product_id VARCHAR(20),
    IN p_quantity_change INT
)
BEGIN
    UPDATE product
    SET stock = stock + p_quantity_change
    WHERE product_id = p_product_id;
END;

-- Stored Procedure to transfer an employee to a new branch
CREATE PROCEDURE Transfer_Employee (
    IN p_employee_id VARCHAR(10),
    IN p_new_branch_id VARCHAR(20),
    IN p_transfer_date DATE
)
BEGIN
    UPDATE employee
    SET branch_id = p_new_branch_id
    WHERE employee_id = p_employee_id;

    INSERT INTO employee_location (employee_id, branch_id, start_date, end_date)
    VALUES (p_employee_id, p_new_branch_id, p_transfer_date, NULL);
END;

-- Stored Procedure to log a new customer visit with a timestamp
CREATE PROCEDURE Log_Customer_Visit (
    IN p_customer_id VARCHAR(10),
    IN p_branch_id VARCHAR(20)
)
BEGIN
    INSERT INTO customer_visits (customer_id, branch_id)
    VALUES (p_customer_id, p_branch_id)
    ON DUPLICATE KEY UPDATE customer_id = p_customer_id;
END;

-- Stored Procedure to retrieve all products that have expired
CREATE PROCEDURE Get_Expired_Products ()
BEGIN
    SELECT
        product_id,
        name,
        expiry_date,
        stock
    FROM product
    WHERE expiry_date < CURDATE();
END;