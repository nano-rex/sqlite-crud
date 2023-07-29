using System;
using System.Data.SQLite;

namespace CRUD
{
    class Program
    {
        static void Main(string[] args)
        {
            string connectionString = "Data Source=data.db;Version=3;";
            SQLiteConnection connection = new SQLiteConnection(connectionString);
            connection.Open();

            string createTableQuery = @"
                CREATE TABLE IF NOT EXISTS Users
                (ID INTEGER PRIMARY KEY NOT NULL,
                 NAME TEXT NOT NULL,
                 AGE INTEGER NOT NULL,
                 GENDER TEXT,
                 SALARY INTEGER);
            ";
            SQLiteCommand createTableCommand = new SQLiteCommand(createTableQuery, connection);
            createTableCommand.ExecuteNonQuery();

            while (true)
            {
                Console.WriteLine("1). Insert Records");
                Console.WriteLine("2). Read Records");
                Console.WriteLine("3). Update Records");
                Console.WriteLine("4). Delete Records");
                Console.WriteLine("5). Exit");
                Console.Write("Enter Your Choice: ");
                int choice = Convert.ToInt32(Console.ReadLine());

                switch (choice)
                {
                    case 1:
                        InsertRecord(connection);
                        break;
                    case 2:
                        Console.WriteLine("1). Read Single Record");
                        Console.WriteLine("2). Read All Records");
                        Console.Write("Enter Your Choice: ");
                        int readChoice = Convert.ToInt32(Console.ReadLine());
                        if (readChoice == 1)
                        {
                            Console.Write("Enter ID: ");
                            int id = Convert.ToInt32(Console.ReadLine());
                            ReadSingleRecord(connection, id);
                        }
                        else if (readChoice == 2)
                        {
                            ReadAllRecords(connection);
                        }
                        else
                        {
                            Console.WriteLine("Wrong Choice Entered");
                        }
                        break;
                    case 3:
                        UpdateRecord(connection);
                        break;
                    case 4:
                        DeleteRecord(connection);
                        break;
                    case 5:
                        connection.Close();
                        return;
                    default:
                        Console.WriteLine("Enter Correct Choice");
                        break;
                }
            }
        }

        static void InsertRecord(SQLiteConnection connection)
        {
            Console.Write("Enter ID: ");
            int id = Convert.ToInt32(Console.ReadLine());
            Console.Write("Enter Name: ");
            string name = Console.ReadLine();
            Console.Write("Enter Age: ");
            int age = Convert.ToInt32(Console.ReadLine());
            Console.Write("Enter Gender: ");
            string gender = Console.ReadLine();
            Console.Write("Enter Salary: ");
            int salary = Convert.ToInt32(Console.ReadLine());

            string insertQuery = "INSERT INTO Users (ID, NAME, AGE, GENDER, SALARY) VALUES (@id, @name, @age, @gender, @salary)";
            SQLiteCommand insertCommand = new SQLiteCommand(insertQuery, connection);
            insertCommand.Parameters.AddWithValue("@id", id);
            insertCommand.Parameters.AddWithValue("@name", name);
            insertCommand.Parameters.AddWithValue("@age", age);
            insertCommand.Parameters.AddWithValue("@gender", gender);
            insertCommand.Parameters.AddWithValue("@salary", salary);
            insertCommand.ExecuteNonQuery();

            Console.WriteLine("Data Inserted Successfully");
        }

        static void ReadSingleRecord(SQLiteConnection connection, int id)
        {
            string selectQuery = "SELECT * FROM Users WHERE ID = @id";
            SQLiteCommand selectCommand = new SQLiteCommand(selectQuery, connection);
            selectCommand.Parameters.AddWithValue("@id", id);
            SQLiteDataReader reader = selectCommand.ExecuteReader();

            if (reader.HasRows)
            {
                while (reader.Read())
                {
                    Console.WriteLine($"Name is: {reader["NAME"]}");
                    Console.WriteLine($"Age is: {reader["AGE"]}");
                    Console.WriteLine($"Salary is: {reader["SALARY"]}");
                }
            }
            else
            {
                Console.WriteLine("Record Does not Exist");
            }

            reader.Close();
        }

        static void ReadAllRecords(SQLiteConnection connection)
        {
            string selectQuery = "SELECT * FROM Users";
            SQLiteCommand selectCommand = new SQLiteCommand(selectQuery, connection);
            SQLiteDataReader reader = selectCommand.ExecuteReader();

            if (reader.HasRows)
            {
                Console.WriteLine("<=== Available Records ===>");
                while (reader.Read())
                {
                    Console.WriteLine($"Name is: {reader["NAME"]}");
                    Console.WriteLine($"Age is: {reader["AGE"]}");
                    Console.WriteLine($"Salary is: {reader["SALARY"]}");
                }
            }

            reader.Close();
        }

        static void UpdateRecord(SQLiteConnection connection)
        {
            Console.Write("Enter ID: ");
            int id = Convert.ToInt32(Console.ReadLine());
            Console.Write("Enter Name: ");
            string name = Console.ReadLine();
            Console.Write("Enter Age: ");
            int age = Convert.ToInt32(Console.ReadLine());
            Console.Write("Enter Gender: ");
            string gender = Console.ReadLine();
            Console.Write("Enter Salary: ");
            int salary = Convert.ToInt32(Console.ReadLine());

            string updateQuery = "UPDATE Users SET NAME = @name, AGE = @age, GENDER = @gender, SALARY = @salary WHERE ID = @id";
            SQLiteCommand updateCommand = new SQLiteCommand(updateQuery, connection);
            updateCommand.Parameters.AddWithValue("@name", name);
            updateCommand.Parameters.AddWithValue("@age", age);
            updateCommand.Parameters.AddWithValue("@gender", gender);
            updateCommand.Parameters.AddWithValue("@salary", salary);
            updateCommand.Parameters.AddWithValue("@id", id);
            updateCommand.ExecuteNonQuery();

            Console.WriteLine("Record Updated Successfully");
        }

        static void DeleteRecord(SQLiteConnection connection)
        {
            Console.Write("Enter ID: ");
            int id = Convert.ToInt32(Console.ReadLine());

            string deleteQuery = "DELETE FROM Users WHERE ID = @id";
            SQLiteCommand deleteCommand = new SQLiteCommand(deleteQuery, connection);
            deleteCommand.Parameters.AddWithValue("@id", id);
            deleteCommand.ExecuteNonQuery();

            Console.WriteLine("Record Deleted Successfully");
        }
    }
}
