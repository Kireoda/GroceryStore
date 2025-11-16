-- Grocery Store Database SQL Script

-- Table: store_branch
CREATE TABLE store_branch (
    branch_id VARCHAR(20) PRIMARY KEY,
    address VARCHAR(255),
    website VARCHAR(100),
    phone_number VARCHAR(20),
    email VARCHAR(100),
    opening_hours VARCHAR(50)
);

INSERT INTO store_branch VALUES
('1', 'Upper Marshes', 'www.tesco.com', '0421345233', 'tesco@gmail.com', '9am-9pm'),
('2', 'Greenhill Street', 'www.aldi.ie', '0427771234', 'aldi@gmail.com', '8am-10pm'),
('3', 'Riverbank Road', 'www.lidl.ie', '0415556789', 'lidl@gmail.com', '9am-8pm'),
('4', 'Main Street', 'www.supervalu.ie', '0462229988', 'supervalu@gmail.com', '8am-9pm'),
('5', 'Oakwood Park', 'www.dunnesstores.ie', '0441123456', 'dunnes@gmail.com', '9am-9pm');


-- Table: customer
CREATE TABLE customer (
    customer_id VARCHAR(10) NOT NULL,
    customer_name VARCHAR(20),
    customer_age INT,
    phone_number VARCHAR(20),
    email VARCHAR(50),
    PRIMARY KEY (customer_id)
);

INSERT INTO customer VALUES
('1', 'billy bob joe', 40, '0853651766', 'billybobjoe@gmail.com'),
('2', 'zangetsu', 16, '0858791115', 'zangetsu@gmail.com'),
('3', 'ben', 69, '0850117384', 'ben@gmail.com'),
('4', 'sven', 74, '0856919574', 'sven@gmail.com'),
('5', 'tom', 37, '0855812311', 'tom@gmail.com');


-- Table: employee
CREATE TABLE employee (
    employee_id VARCHAR(10),
    employee_name VARCHAR(20),
    date_of_birth DATE,
    address VARCHAR(50),
    phone_number VARCHAR(20),
    job_title VARCHAR(30),
    wage DECIMAL(4,2),
    shifts VARCHAR(30),
    branch_id VARCHAR(20),
    PRIMARY KEY (employee_id),
    FOREIGN KEY (branch_id) REFERENCES store_branch (branch_id)
);

INSERT INTO employee VALUES
('1','james','2002-02-10','100 Beachmount Drive','0851846527','Till',12.50,'7am-5pm','1'),
('2','billy','2000-01-03','20 Beachmount Belmore','0851864713','Manager',14.28,'7am-6pm','2'),
('3','bob','1999-08-28','12 Bay Estate','0851846527','Supervisor',16.12,'7am-6pm','3'),
('4','max','1997-09-14','33 Bay Estate','0851852657','Manager',11.65,'7am-6pm','4'),
('5','asta','1996-12-17','45 Bay Estate','0858991355','Floor Staff',11.20,'7am-4pm','5');


-- Table: product
CREATE TABLE product (
    product_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2),
    expiry_date DATE,
    stock INT,
    category VARCHAR(50),
    branch_id VARCHAR(20),
    FOREIGN KEY (branch_id) REFERENCES store_branch(branch_id)
);

INSERT INTO product VALUES
('1', 'Eggs', 3.50, '2025-06-12', 100, 'Protein', '1'),
('2', 'Milk', 1.20, '2025-05-20', 200, 'Dairy', '2'),
('3', 'Bread', 2.00, '2025-05-15', 150, 'Bakery', '3'),
('4', 'Chicken', 7.99, '2025-04-30', 80, 'Meat', '4'),
('5', 'Apples', 2.50, '2025-06-01', 300, 'Fruit', '5');


-- Table: delivery
CREATE TABLE delivery (
    delivery_id VARCHAR(20) PRIMARY KEY,
    cost DECIMAL(10,2),
    delivery_date DATE,
    amount DECIMAL(10,2)
);

INSERT INTO delivery VALUES
('1', 200.00, '2025-09-12', 500.00),
('2', 150.00, '2025-09-15', 300.00),
('3', 180.00, '2025-09-20', 400.00),
('4', 220.00, '2025-10-01', 600.00),
('5', 100.00, '2025-10-10', 250.00);


-- Table: customer_visits
CREATE TABLE customer_visits (
    customer_id VARCHAR(20),
    branch_id VARCHAR(20),
    PRIMARY KEY (customer_id, branch_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (branch_id) REFERENCES store_branch(branch_id)
);

INSERT INTO customer_visits VALUES
('1', '1'),
('2', '2'),
('3', '3'),
('4', '4'),
('5', '5');


-- Table: employee_location
CREATE TABLE employee_location (
    employee_id VARCHAR(20),
    branch_id VARCHAR(20),
    start_date DATE,
    end_date DATE,
    PRIMARY KEY (employee_id, branch_id, start_date),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    FOREIGN KEY (branch_id) REFERENCES store_branch(branch_id)
);

INSERT INTO employee_location VALUES
('1','1','2024-01-01','2025-01-01'),
('2','2','2024-02-01','2025-02-01'),
('3','3','2024-03-01','2025-03-01'),
('4','4','2024-04-01','2025-04-01'),
('5','5','2024-05-01','2025-05-01');


-- Table: branch_product_stock
CREATE TABLE branch_product_stock (
    branch_id VARCHAR(20),
    product_id VARCHAR(20),
    quantity INT,
    PRIMARY KEY (branch_id, product_id),
    FOREIGN KEY (branch_id) REFERENCES store_branch (branch_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

INSERT INTO branch_product_stock VALUES
('1','1',100),
('2','2',200),
('3','3',150),
('4','4',80),
('5','5',300);


-- Table: delivery_details
CREATE TABLE delivery_details (
    delivery_id VARCHAR(20),
    product_id VARCHAR(20),
    quantity INT,
    PRIMARY KEY (delivery_id, product_id),
    FOREIGN KEY (delivery_id) REFERENCES delivery(delivery_id),
    FOREIGN KEY (product_id) REFERENCES product (product_id)
);

INSERT INTO delivery_details VALUES
('1','1',50),
('2','2',40),
('3','3',60),
('4','4',70),
('5','5',30);
