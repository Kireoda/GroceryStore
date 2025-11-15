import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement; // added for trigger creation

//Setup Instructions
//1. Database Setup - Ensure you have a database instance running (e.g., MySQL or MariaDB) and you have:
//Created a database named grocery_db (or updated the DB_URL).
//Run your Grocery Store Database.sql script against this database to create the tables and populate the initial data.
//Updated the USER and PASS variables in the Java file with your correct database credentials.
//2. Add the JDBC Connector - You need the MySQL Connector/J JAR file in your project's classpath:
//Maven/Gradle: If you are using a build tool, add the dependency for mysql-connector-java.
//Plain Java (CLI/IDE): Download the JAR file and ensure it is included when you compile and run your Java file.
//Why Prepared Statements? Prepared Statements are a critical security feature because they automatically handle SQL injection prevention. They also offer better performance when executing the same statement multiple times, as the database only needs to compile the query once.

public class GroceryStoreDBConnectorNOTFINISHED {

    // 1. Database Connection Parameters
    // NOTE: You must change these details to match your actual database setup.
    private static final String DB_URL = "jdbc:mysql://localhost:3306/grocery_db";
    private static final String USER = "your_db_username"; // e.g., "root"
    private static final String PASS = "your_db_password"; // e.g., "password123"

    public static void main(String[] args) {
        // Load the JDBC Driver (optional for modern Java, but good practice)
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found. Make sure the JAR is in your classpath.");
            e.printStackTrace();
            return;
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS)) {
            System.out.println("Connection successful to: " + DB_URL);

            // --- 1. Create / refresh triggers for auditing and constraints ---
            createTriggers(conn);

            // --- 2. Demonstrating a Basic Query (Row-by-Row Processing) ---
            System.out.println("\n--- 🛒 Product Inventory Check ---");
            fetchProductData(conn);

            // --- 3. Demonstrating a Prepared Statement (Update) ---
            System.out.println("\n--- 🧑‍💻 Employee Update using PreparedStatement ---");
            updateEmployeeWage(conn, "3", 17.50); // Update employee '3' (bob) to 17.50

            // Re-verify the update (optional)
            fetchEmployeeData(conn, "3");

            // --- 4. Demonstrating a Prepared Statement (Insert) ---
            System.out.println("\n--- 📝 Inserting a New Customer using PreparedStatement ---");
            insertNewCustomer(conn, "6", "Lisa Smith", 28, "0891234567", "lisa.smith@example.com");

        } catch (SQLException e) {
            System.err.println("Database error occurred.");
            e.printStackTrace();
        }
    }

    /**
     * Executes a simple SELECT query and processes the results row by row.
     */
    public static void fetchProductData(Connection conn) throws SQLException {
        String sql = "SELECT product_id, name, price, stock FROM product";

        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                String id = rs.getString("product_id");
                String name = rs.getString("name");
                double price = rs.getDouble("price");
                int stock = rs.getInt("stock");

                System.out.printf("ID: %s | Name: %s | Price: €%.2f | Stock: %d%n", id, name, price, stock);
            }
        }
    }

    /**
     * Uses a PreparedStatement to update an employee's wage.
     */
    public static void updateEmployeeWage(Connection conn, String employeeId, double newWage) throws SQLException {
        String sql = "UPDATE employee SET wage = ? WHERE employee_id = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            // Set parameters safely
            pstmt.setDouble(1, newWage);     // The first '?' is the wage
            pstmt.setString(2, employeeId);  // The second '?' is the employee_id

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Successfully updated employee " + employeeId + " wage to €" + newWage);
            } else {
                System.out.println("Employee " + employeeId + " not found or wage unchanged.");
            }
        }
    }

    /**
     * Helper function to show employee data after an update.
     */
    public static void fetchEmployeeData(Connection conn, String employeeId) throws SQLException {
        String sql = "SELECT employee_name, wage FROM employee WHERE employee_id = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, employeeId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String name = rs.getString("employee_name");
                    double wage = rs.getDouble("wage");
                    System.out.printf("Verification: %s's new wage is €%.2f%n", name, wage);
                }
            }
        }
    }

    /**
     * Uses a PreparedStatement to insert a new customer record.
     */
    public static void insertNewCustomer(Connection conn, String id, String name, int age, String phone, String email) throws SQLException {
        String sql = "INSERT INTO customer (customer_id, customer_name, customer_age, phone_number, email) VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            // Set all 5 parameters
            pstmt.setString(1, id);
            pstmt.setString(2, name);
            pstmt.setInt(3, age);
            pstmt.setString(4, phone);
            pstmt.setString(5, email);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Successfully inserted new customer: " + name);
            }
        }
    }

    /**
     * Creates at least two triggers:
     * 1) Auditing trigger for employee wage changes.
     * 2) Constraint trigger to prevent negative product stock.
     **/
    public static void createTriggers(Connection conn) throws SQLException {
        try (Statement stmt = conn.createStatement()) {

            // Table for auditing wage changes (if it doesn't already exist)
            String createAuditTable =
                    "CREATE TABLE IF NOT EXISTS employee_wage_audit (" +
                            "  audit_id INT AUTO_INCREMENT PRIMARY KEY," +
                            "  employee_id VARCHAR(10) NOT NULL," +
                            "  old_wage DECIMAL(10,2)," +
                            "  new_wage DECIMAL(10,2)," +
                            "  changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                            ")";

            // Trigger 1: auditing wage changes on employee
            String dropWageTrigger = "DROP TRIGGER IF EXISTS employee_wage_audit_trg";

            String createWageTrigger =
                    "CREATE TRIGGER employee_wage_audit_trg " +
                            "AFTER UPDATE ON employee " +
                            "FOR EACH ROW " +
                            "BEGIN " +
                            "   IF NEW.wage <> OLD.wage THEN " +
                            "       INSERT INTO employee_wage_audit (employee_id, old_wage, new_wage) " +
                            "       VALUES (OLD.employee_id, OLD.wage, NEW.wage); " +
                            "   END IF; " +
                            "END";

            // Trigger 2: prevent negative stock on product
            String dropStockTrigger = "DROP TRIGGER IF EXISTS product_prevent_negative_stock_trg";

            String createStockTrigger =
                    "CREATE TRIGGER product_prevent_negative_stock_trg " +
                            "BEFORE UPDATE ON product " +
                            "FOR EACH ROW " +
                            "BEGIN " +
                            "   IF NEW.stock < 0 THEN " +
                            "       SIGNAL SQLSTATE '45000' " +
                            "       SET MESSAGE_TEXT = 'Stock level cannot be negative.'; " +
                            "   END IF; " +
                            "END";

            // Execute in order
            stmt.executeUpdate(createAuditTable);
            stmt.executeUpdate(dropWageTrigger);
            stmt.executeUpdate(dropStockTrigger);
            stmt.executeUpdate(createWageTrigger);
            stmt.executeUpdate(createStockTrigger);

            System.out.println("Triggers created: employee_wage_audit_trg, product_prevent_negative_stock_trg");
        }
    }
}
