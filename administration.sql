--created the users
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'Admin';
CREATE USER 'manager_user'@'localhost' IDENTIFIED BY 'Manager';
CREATE USER 'clerk_user'@'localhost' IDENTIFIED BY 'Clerk';
--
RANT ALL PRIVILEGES ON sample TO 'admin_user'@'localhost' WITH GRANT OPTION;

--managment
GRANT SELECT, INSERT, UPDATE, DELETE ON grocerydb.product TO 'manager_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON grocerydb.employee TO 'manager_user'@'localhost';
GRANT SELECT, INSERT ON grocerydb.customer_visits TO 'manager_user'@'localhost';
GRANT EXECUTE ON grocerydb.* TO 'manager_user'@'localhost';

--clerk 
GRANT SELECT ON grocerydb.product TO 'clerk_user'@'localhost';
GRANT SELECT ON grocerydb.customer_visits TO 'clerk_user'@'localhost';

--taking away privalges
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'manager_user'@'localhost';
FLUSH PRIVILEGES;

--deleteing users example
DROP USER 'manager_user'@'localhost';
FLUSH PRIVILEGES;
