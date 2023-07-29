import java.sql.*;

/*
https://github.com/xerial/sqlite-jdbc/releases
java -classpath ".:sqlite-jdbc-3.42.0.0.jar" Sample.java
*/

public class CRUD {
    public static void main(String[] args) {
        try {
            Connection conn = DriverManager.getConnection("jdbc:sqlite:data.db");
            System.out.println("Opened database successfully");

            Statement stmt = conn.createStatement();
            String createTableQuery = "CREATE TABLE IF NOT EXISTS Users " +
                    "(ID INT PRIMARY KEY NOT NULL, " +
                    "NAME TEXT NOT NULL, " +
                    "AGE INT NOT NULL, " +
                    "GENDER TEXT, " +
                    "SALARY INT)";
            stmt.executeUpdate(createTableQuery);
            System.out.println("Table created successfully");

            while (true) {
                System.out.println("1). Insert Records");
                System.out.println("2). Read Records");
                System.out.println("3). Update Records");
                System.out.println("4). Delete Records");
                System.out.println("5). Exit");
                int choice = Integer.parseInt(System.console().readLine("Enter Your Choice: "));

                if (choice == 1) {
                    insert(conn);
                } else if (choice == 2) {
                    System.out.println("1). Read Single Record");
                    System.out.println("2). Read All Records");
                    int readChoice = Integer.parseInt(System.console().readLine("Enter Your Choice: "));
                    if (readChoice == 1) {
                        readOne(conn);
                    } else if (readChoice == 2) {
                        readAll(conn);
                    } else {
                        System.out.println("Wrong Choice Entered");
                    }
                } else if (choice == 3) {
                    update(conn);
                } else if (choice == 4) {
                    delete(conn);
                } else if (choice == 5) {
                    break;
                } else {
                    System.out.println("Enter Correct Choice");
                }
            }

            conn.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
        }
    }

    public static void insert(Connection conn) {
        try {
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO Users (ID, NAME, AGE, GENDER, SALARY) VALUES (?, ?, ?, ?, ?)");

            int id = Integer.parseInt(System.console().readLine("Enter ID: "));
            String name = System.console().readLine("Enter Name: ");
            int age = Integer.parseInt(System.console().readLine("Enter Age: "));
            String gender = System.console().readLine("Enter Gender: ");
            int salary = Integer.parseInt(System.console().readLine("Enter Salary: "));

            pstmt.setInt(1, id);
            pstmt.setString(2, name);
            pstmt.setInt(3, age);
            pstmt.setString(4, gender);
            pstmt.setInt(5, salary);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Data Inserted Successfully");
            } else {
                System.out.println("Data not Inserted");
            }

            pstmt.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
        }
    }

    public static void readOne(Connection conn) {
        try {
            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM Users WHERE ID = ?");
            int id = Integer.parseInt(System.console().readLine("Enter Your ID: "));
            pstmt.setInt(1, id);

            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                System.out.println("Name is: " + rs.getString("NAME"));
                System.out.println("Age is: " + rs.getInt("AGE"));
                System.out.println("Salary is: " + rs.getInt("SALARY"));
            } else {
                System.out.println("ID Does not Exist");
            }

            rs.close();
            pstmt.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
        }
    }

    public static void readAll(Connection conn) {
        try {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM Users");

            System.out.println("\n<=== Available Records ===>");
            while (rs.next()) {
                System.out.println("Name is: " + rs.getString("NAME"));
                System.out.println("Age is: " + rs.getInt("AGE"));
                System.out.println("Salary is: " + rs.getInt("SALARY") + "\n");
            }

            rs.close();
            stmt.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
        }
    }

    public static void update(Connection conn) {
        try {
            PreparedStatement pstmt = conn.prepareStatement("UPDATE Users SET NAME = ?, AGE = ?, GENDER = ?, SALARY = ? WHERE ID = ?");

            int id = Integer.parseInt(System.console().readLine("Enter ID: "));
            String name = System.console().readLine("Enter Name: ");
            int age = Integer.parseInt(System.console().readLine("Enter Age: "));
            String gender = System.console().readLine("Enter Gender: ");
            int salary = Integer.parseInt(System.console().readLine("Enter Salary: "));

            pstmt.setString(1, name);
            pstmt.setInt(2, age);
            pstmt.setString(3, gender);
            pstmt.setInt(4, salary);
            pstmt.setInt(5, id);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Records Updated");
            } else {
                System.out.println("Something Error in Updation");
            }

            pstmt.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
        }
    }

    public static void delete(Connection conn) {
        try {
            PreparedStatement pstmt = conn.prepareStatement("DELETE FROM Users WHERE ID = ?");

            int id = Integer.parseInt(System.console().readLine("Enter ID: "));
            pstmt.setInt(1, id);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("One record Deleted");
            } else {
                System.out.println("Something Error in Deletion");
            }

            pstmt.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
        }
    }
}
