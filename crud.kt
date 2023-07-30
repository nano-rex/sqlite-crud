import java.sql.DriverManager

fun create() {
    val conn = DriverManager.getConnection("jdbc:sqlite:data.db")
    println("Opened database successfully")
    conn.createStatement().use { stmt ->
        stmt.execute(
            """
            CREATE TABLE Users (
                ID      INT   PRIMARY KEY  NOT NULL,
                NAME    TEXT               NOT NULL,
                AGE     INT                NOT NULL,
                GENDER  TEXT,
                SALARY  INT
            )
            """.trimIndent()
        )
    }
    println("Table created successfully")
}

fun insert() {
    val con = DriverManager.getConnection("jdbc:sqlite:data.db")
    con.createStatement().use { stmt ->
        while (true) {
            print("Enter ID: ")
            val idd = readLine()?.toIntOrNull() ?: continue
            print("Enter Name: ")
            val name = readLine() ?: continue
            print("Enter Age: ")
            val age = readLine()?.toIntOrNull() ?: continue
            print("Enter your Gender: ")
            val gender = readLine() ?: continue
            print("Enter your Salary: ")
            val salary = readLine()?.toIntOrNull() ?: continue
            val query = "INSERT into USERS(ID,NAME,AGE,GENDER,SALARY) VALUES (?,?,?,?,?);"
            stmt.prepareStatement(query).use { pstmt ->
                pstmt.setInt(1, idd)
                pstmt.setString(2, name)
                pstmt.setInt(3, age)
                pstmt.setString(4, gender)
                pstmt.setInt(5, salary)
                pstmt.executeUpdate()
            }
            println("Data Inserted Successfully")
            print("Do You want to Add More Records(Y/N): ")
            val ch = readLine()?.uppercase()
            if (ch == "N") {
                break
            }
        }
    }
}

fun readOne() {
    val con = DriverManager.getConnection("jdbc:sqlite:data.db")
    con.createStatement().use { stmt ->
        print("Enter Your ID: ")
        val ids = readLine()?.toIntOrNull() ?: return
        val query = "SELECT * from USERS WHERE id = ?"
        stmt.prepareStatement(query).use { pstmt ->
            pstmt.setInt(1, ids)
            val result = pstmt.executeQuery()
            if (result.next()) {
                println("Name is: ${result.getString("NAME")}")
                println("Age is: ${result.getInt("AGE")}")
                println("Salary is: ${result.getInt("SALARY")}")
            } else {
                println("ID Does not Exist")
            }
        }
    }
}

fun readAll() {
    val con = DriverManager.getConnection("jdbc:sqlite:data.db")
    con.createStatement().use { stmt ->
        val query = "SELECT * from USERS"
        val result = stmt.executeQuery(query)
        println("\n<=== Available Records ===>")
        while (result.next()) {
            println("Name is: ${result.getString("NAME")}")
            println("Age is: ${result.getInt("AGE")}")
            println("Salary is: ${result.getInt("SALARY")}")
        }
    }
}

fun update() {
    val con = DriverManager.getConnection("jdbc:sqlite:data.db")
    con.createStatement().use { stmt ->
        print("Enter ID: ")
        val idd = readLine()?.toIntOrNull() ?: return
        print("Enter Name: ")
        val name = readLine() ?: return
        print("Enter Age: ")
        val age = readLine()?.toIntOrNull() ?: return
        print("Enter Gender: ")
        val gender = readLine() ?: return
        print("Enter Salary: ")
        val salary = readLine()?.toIntOrNull() ?: return
        val query = "UPDATE USERS set NAME = ?, AGE = ?, GENDER = ?, SALARY = ? WHERE ID = ?"
        stmt.prepareStatement(query).use { pstmt ->
            pstmt.setString(1, name)
            pstmt.setInt(2, age)
            pstmt.setString(3, gender)
            pstmt.setInt(4, salary)
            pstmt.setInt(5, idd)
            pstmt.executeUpdate()
        }
        println("Records Updated")
    }
}

fun delete() {
    val con = DriverManager.getConnection("jdbc:sqlite:data.db")
    con.createStatement().use { stmt ->
        print("Enter ID: ")
        val idd = readLine()?.toIntOrNull() ?: return
        val query = "DELETE from USERS where ID = ?"
        stmt.prepareStatement(query).use { pstmt ->
            pstmt.setInt(1, idd)
            pstmt.executeUpdate()
        }
        println("One record Deleted")
    }
}

fun main() {
    try {
        while (true) {
            println("1). Insert Records")
            println("2). Read Records")
            println("3). Update Records")
            println("4). Delete Records")
            println("5). Exit")
            print("Enter Your Choice: ")
            val ch = readLine()?.toIntOrNull() ?: continue
            when (ch) {
                1 -> insert()
                2 -> {
                    println("1). Read Single Record")
                    println("2). Read All Records")
                    print("Enter Your Choice: ")
                    val choice = readLine()?.toIntOrNull() ?: continue
                    when (choice) {
                        1 -> readOne()
                        2 -> readAll()
                        else -> println("Wrong Choice Entered")
                    }
                }
                3 -> update()
                4 -> delete()
                5 -> break
                else -> println("Enter Correct Choice")
            }
        }
    } catch (e: Exception) {
        println("Database Error")
    }
}
