use std::io;

fn create() {
    let conn = sqlite::open("data.db").unwrap();
    conn.execute(
        "
        CREATE TABLE Users (
            ID      INTEGER PRIMARY KEY NOT NULL,
            NAME    TEXT NOT NULL,
            AGE     INTEGER NOT NULL,
            GENDER  TEXT,
            SALARY  INTEGER
        )
        "
    ).unwrap();
    println!("Table created successfully");
}

fn insert() {
    let conn = sqlite::open("data.db").unwrap();
    let mut stmt = conn.prepare(
        "
        INSERT INTO USERS (ID, NAME, AGE, GENDER, SALARY)
        VALUES (?, ?, ?, ?, ?)
        "
    ).unwrap();
    loop {
        let id: i32 = input("Enter ID: ");
        let name: String = input("Enter Name: ");
        let age: i32 = input("Enter Age: ");
        let gender: String = input("Enter your Gender: ");
        let salary: i32 = input("Enter your Salary: ");
        stmt.execute(params![id, name, age, gender, salary]).unwrap();
        println!("Data Inserted Successfully");
        let ch: String = input("Do You want to Add More Records(Y/N): ");
        if ch == "N" || ch == "n" {
            break;
        }
    }
}

fn read_one() {
    let conn = sqlite::open("data.db").unwrap();
    let mut stmt = conn.prepare(
        "
        SELECT * FROM USERS WHERE id = ?
        "
    ).unwrap();
    let id: i32 = input("Enter Your ID: ");
    let mut rows = stmt.query(params![id]).unwrap();
    if let Some(row) = rows.next().unwrap() {
        let name: String = row.get(1).unwrap();
        let age: i32 = row.get(2).unwrap();
        let salary: i32 = row.get(4).unwrap();
        println!("Name is: {}", name);
        println!("Age is: {}", age);
        println!("Salary is: {}", salary);
    } else {
        println!("Roll Number Does not Exist");
    }
}

fn read_all() {
    let conn = sqlite::open("data.db").unwrap();
    let mut stmt = conn.prepare(
        "
        SELECT * FROM USERS
        "
    ).unwrap();
    let rows = stmt.query_map(params![], |row| {
        let name: String = row.get(1).unwrap();
        let age: i32 = row.get(2).unwrap();
        let salary: i32 = row.get(4).unwrap();
        println!("Name is: {}", name);
        println!("Age is: {}", age);
        println!("Salary is: {}", salary);
    }).unwrap();
    if rows.count() == 0 {
        println!("No Records Found");
    }
}

fn update() {
    let conn = sqlite::open("data.db").unwrap();
    let mut stmt = conn.prepare(
        "
        UPDATE USERS SET name = ?, age = ?, gender = ?, salary = ? WHERE id = ?
        "
    ).unwrap();
    let id: i32 = input("Enter ID: ");
    let name: String = input("Enter Name: ");
    let age: i32 = input("Enter Age: ");
    let gender: String = input("Enter Gender: ");
    let salary: i32 = input("Enter Salary: ");
    stmt.execute(params![name, age, gender, salary, id]).unwrap();
    println!("Records Updated");
}

fn delete() {
    let conn = sqlite::open("data.db").unwrap();
    let mut stmt = conn.prepare(
        "
        DELETE FROM USERS WHERE ID = ?
        "
    ).unwrap();
    let id: i32 = input("Enter ID: ");
    stmt.execute(params![id]).unwrap();
    println!("One record Deleted");
}

fn main() {
    loop {
        println!("1). Insert Records");
        println!("2). Read Records");
        println!("3). Update Records");
        println!("4). Delete Records");
        println!("5). Exit");
        let ch: i32 = input("Enter Your Choice: ");
        match ch {
            1 => insert(),
            2 => {
                println!("1). Read Single Record");
                println!("2). Read All Records");
                let choice: i32 = input("Enter Your Choice: ");
                match choice {
                    1 => read_one(),
                    2 => read_all(),
                    _ => println!("Wrong Choice Entered"),
                }
            },
            3 => update(),
            4 => delete(),
            5 => break,
            _ => println!("Enter Correct Choice"),
        }
    }
}

fn input<T: std::str::FromStr>(prompt: &str) -> T {
    loop {
        println!("{}", prompt);
        let mut input = String::new();
        io::stdin().read_line(&mut input).unwrap();
        match input.trim().parse() {
            Ok(value) => return value,
            Err(_) => println!("Invalid input. Please try again."),
        }
    }
}
