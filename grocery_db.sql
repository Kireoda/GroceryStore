-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 16, 2025 at 07:57 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `grocery_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customer_id` varchar(10) NOT NULL,
  `customer_name` varchar(100) NOT NULL,
  `customer_age` int(11) NOT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `employee_id` varchar(10) NOT NULL,
  `employee_name` varchar(100) NOT NULL,
  `wage` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`employee_id`, `employee_name`, `wage`) VALUES
('3', 'Bob Brown', 17.50);

--
-- Triggers `employee`
--
DELIMITER $$
CREATE TRIGGER `employee_wage_audit_trg` AFTER UPDATE ON `employee` FOR EACH ROW BEGIN    IF NEW.wage <> OLD.wage THEN        INSERT INTO employee_wage_audit (employee_id, old_wage, new_wage)        VALUES (OLD.employee_id, OLD.wage, NEW.wage);    END IF; END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `employee_wage_audit`
--

CREATE TABLE `employee_wage_audit` (
  `audit_id` int(11) NOT NULL,
  `employee_id` varchar(10) NOT NULL,
  `old_wage` decimal(10,2) DEFAULT NULL,
  `new_wage` decimal(10,2) DEFAULT NULL,
  `changed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_wage_audit`
--

INSERT INTO `employee_wage_audit` (`audit_id`, `employee_id`, `old_wage`, `new_wage`, `changed_at`) VALUES
(1, '3', 15.00, 17.50, '2025-11-15 19:10:12');

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `product_id` varchar(10) NOT NULL,
  `name` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`product_id`, `name`, `price`, `stock`) VALUES
('P001', 'Test Product', 9.99, 10);

--
-- Triggers `product`
--
DELIMITER $$
CREATE TRIGGER `product_prevent_negative_stock_trg` BEFORE UPDATE ON `product` FOR EACH ROW BEGIN    IF NEW.stock < 0 THEN        SIGNAL SQLSTATE '45000'        SET MESSAGE_TEXT = 'Stock level cannot be negative.';    END IF; END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customer_id`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`employee_id`);

--
-- Indexes for table `employee_wage_audit`
--
ALTER TABLE `employee_wage_audit`
  ADD PRIMARY KEY (`audit_id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`product_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `employee_wage_audit`
--
ALTER TABLE `employee_wage_audit`
  MODIFY `audit_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
