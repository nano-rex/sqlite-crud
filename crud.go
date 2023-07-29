package main

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/mattn/go-sqlite3"
)

func create() {
	db, err := sql.Open("sqlite3", "data.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	createTable := `
		CREATE TABLE IF NOT EXISTS Users (
			ID      INTEGER PRIMARY KEY,
			NAME    TEXT NOT NULL,
			AGE     INTEGER NOT NULL,
			GENDER  TEXT,
			SALARY  INTEGER
		);
	`
	_, err = db.Exec(createTable)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("Table created successfully")
}

func insert() {
	db, err := sql.Open("sqlite3", "data.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	stmt, err := db.Prepare("INSERT INTO Users(ID, NAME, AGE, GENDER, SALARY) VALUES (?, ?, ?, ?, ?)")
	if err != nil {
		log.Fatal(err)
	}

	var id, age, salary int
	var name, gender string

	fmt.Print("Enter ID: ")
	fmt.Scan(&id)
	fmt.Print("Enter Name: ")
	fmt.Scan(&name)
	fmt.Print("Enter Age: ")
	fmt.Scan(&age)
	fmt.Print("Enter Gender: ")
	fmt.Scan(&gender)
	fmt.Print("Enter Salary: ")
	fmt.Scan(&salary)

	_, err = stmt.Exec(id, name, age, gender, salary)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("Data Inserted Successfully")
}

func readOne() {
	db, err := sql.Open("sqlite3", "data.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	var id int
	fmt.Print("Enter Your ID: ")
	fmt.Scan(&id)

	row := db.QueryRow("SELECT * FROM Users WHERE ID = ?", id)

	var name, gender string
	var age, salary int

	err = row.Scan(&id, &name, &age, &gender, &salary)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("Name is: %s\n", name)
	fmt.Printf("Age is: %d\n", age)
	fmt.Printf("Salary is: %d\n", salary)
}

func readAll() {
	db, err := sql.Open("sqlite3", "data.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	rows, err := db.Query("SELECT * FROM Users")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	fmt.Println("\n<=== Available Records ===>")
	for rows.Next() {
		var id, age, salary int
		var name, gender string

		err = rows.Scan(&id, &name, &age, &gender, &salary)
		if err != nil {
			log.Fatal(err)
		}

		fmt.Printf("Name is: %s\n", name)
		fmt.Printf("Age is: %d\n", age)
		fmt.Printf("Salary is: %d\n", salary)
	}
}

func update() {
	db, err := sql.Open("sqlite3", "data.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	stmt, err := db.Prepare("UPDATE Users SET NAME = ?, AGE = ?, GENDER = ?, SALARY = ? WHERE ID = ?")
	if err != nil {
		log.Fatal(err)
	}

	var id, age, salary int
	var name, gender string

	fmt.Print("Enter ID: ")
	fmt.Scan(&id)
	fmt.Print("Enter Name: ")
	fmt.Scan(&name)
	fmt.Print("Enter Age: ")
	fmt.Scan(&age)
	fmt.Print("Enter Gender: ")
	fmt.Scan(&gender)
	fmt.Print("Enter Salary: ")
	fmt.Scan(&salary)

	_, err = stmt.Exec(name, age, gender, salary, id)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("Records Updated")
}

func delete() {
	db, err := sql.Open("sqlite3", "data.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	stmt, err := db.Prepare("DELETE FROM Users WHERE ID = ?")
	if err != nil {
		log.Fatal(err)
	}

	var id int
	fmt.Print("Enter ID: ")
	fmt.Scan(&id)

	_, err = stmt.Exec(id)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("One record Deleted")
}

func main() {
	create()

	for {
		fmt.Println("1). Insert Records")
		fmt.Println("2). Read Records")
		fmt.Println("3). Update Records")
		fmt.Println("4). Delete Records")
		fmt.Println("5). Exit")

		var ch int
		fmt.Print("Enter Your Choice: ")
		fmt.Scan(&ch)

		switch ch {
		case 1:
			insert()
		case 2:
			fmt.Println("1). Read Single Record")
			fmt.Println("2). Read All Records")

			var choice int
			fmt.Print("Enter Your Choice: ")
			fmt.Scan(&choice)

			switch choice {
			case 1:
				readOne()
			case 2:
				readAll()
			default:
				fmt.Println("Wrong Choice Entered")
			}
		case 3:
			update()
		case 4:
			delete()
		case 5:
			return
		default:
			fmt.Println("Enter Correct Choice")
		}
	}
}
