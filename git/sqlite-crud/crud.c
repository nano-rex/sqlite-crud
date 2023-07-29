#include <iostream>
#include <sqlite3.h>

using namespace std;

void create() {
    sqlite3 *db;
    int rc = sqlite3_open("data.db", &db);
    if (rc) {
        cout << "Can't open database: " << sqlite3_errmsg(db) << endl;
        return;
    }
    cout << "Opened database successfully" << endl;
    
    const char *sql = "CREATE TABLE Users (ID INT PRIMARY KEY NOT NULL, NAME TEXT NOT NULL, AGE INT NOT NULL, GENDER TEXT, SALARY INT);";
    rc = sqlite3_exec(db, sql, 0, 0, 0);
    if (rc != SQLITE_OK) {
        cout << "SQL error: " << sqlite3_errmsg(db) << endl;
    } else {
        cout << "Table created successfully" << endl;
    }
    
    sqlite3_close(db);
}

void insert() {
    sqlite3 *db;
    int rc = sqlite3_open("data.db", &db);
    if (rc) {
        cout << "Can't open database: " << sqlite3_errmsg(db) << endl;
        return;
    }
    
    sqlite3_stmt *stmt;
    const char *sql = "INSERT INTO USERS (ID, NAME, AGE, GENDER, SALARY) VALUES (?, ?, ?, ?, ?);";
    rc = sqlite3_prepare_v2(db, sql, -1, &stmt, 0);
    if (rc != SQLITE_OK) {
        cout << "SQL error: " << sqlite3_errmsg(db) << endl;
        return;
    }
    
    while (true) {
        int idd, age, salary;
        string name, gender;
        
        cout << "Enter ID: ";
        cin >> idd;
        cout << "Enter Name: ";
        cin >> name;
        cout << "Enter Age: ";
        cin >> age;
        cout << "Enter your Gender: ";
        cin >> gender;
        cout << "Enter your Salary: ";
        cin >> salary;
        
        sqlite3_bind_int(stmt, 1, idd);
        sqlite3_bind_text(stmt, 2, name.c_str(), -1, SQLITE_STATIC);
        sqlite3_bind_int(stmt, 3, age);
        sqlite3_bind_text(stmt, 4, gender.c_str(), -1, SQLITE_STATIC);
        sqlite3_bind_int(stmt, 5, salary);
        
        rc = sqlite3_step(stmt);
        if (rc != SQLITE_DONE) {
            cout << "Data not Inserted" << endl;
        } else {
            cout << "Data Inserted Successfully" << endl;
        }
        
        sqlite3_reset(stmt);
        
        char ch;
        cout << "Do You want to Add More Records(Y/N): ";
        cin >> ch;
        if (ch == 'N' || ch == 'n') {
            break;
        }
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(db);
}

void read_one() {
    sqlite3 *db;
    int rc = sqlite3_open("data.db", &db);
    if (rc) {
        cout << "Can't open database: " << sqlite3_errmsg(db) << endl;
        return;
    }
    
    sqlite3_stmt *stmt;
    const char *sql = "SELECT * FROM USERS WHERE id = ?;";
    rc = sqlite3_prepare_v2(db, sql, -1, &stmt, 0);
    if (rc != SQLITE_OK) {
        cout << "SQL error: " << sqlite3_errmsg(db) << endl;
        return;
    }
    
    int ids;
    cout << "Enter Your ID: ";
    cin >> ids;
    
    sqlite3_bind_int(stmt, 1, ids);
    
    rc = sqlite3_step(stmt);
    if (rc == SQLITE_ROW) {
        cout << "Name is: " << sqlite3_column_text(stmt, 1) << endl;
        cout << "Age is: " << sqlite3_column_int(stmt, 2) << endl;
        cout << "Salary is: " << sqlite3_column_int(stmt, 4) << endl;
    } else {
        cout << "Record Does not Exist" << endl;
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(db);
}

void read_all() {
    sqlite3 *db;
    int rc = sqlite3_open("data.db", &db);
    if (rc) {
        cout << "Can't open database: " << sqlite3_errmsg(db) << endl;
        return;
    }
    
    sqlite3_stmt *stmt;
    const char *sql = "SELECT * FROM USERS;";
    rc = sqlite3_prepare_v2(db, sql, -1, &stmt, 0);
    if (rc != SQLITE_OK) {
        cout << "SQL error: " << sqlite3_errmsg(db) << endl;
        return;
    }
    
    rc = sqlite3_step(stmt);
    if (rc == SQLITE_ROW) {
        cout << "\n<=== Available Records ===>" << endl;
        while (rc == SQLITE_ROW) {
            cout << "Name is: " << sqlite3_column_text(stmt, 1) << endl;
            cout << "Age is: " << sqlite3_column_int(stmt, 2) << endl;
            cout << "Salary is: " << sqlite3_column_int(stmt, 4) << endl;
            cout << endl;
            rc = sqlite3_step(stmt);
        }
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(db);
}

void update() {
    sqlite3 *db;
    int rc = sqlite3_open("data.db", &db);
    if (rc) {
        cout << "Can't open database: " << sqlite3_errmsg(db) << endl;
        return;
    }
    
    sqlite3_stmt *stmt;
    const char *sql = "UPDATE USERS SET NAME = ?, AGE = ?, GENDER = ?, SALARY = ? WHERE ID = ?;";
    rc = sqlite3_prepare_v2(db, sql, -1, &stmt, 0);
    if (rc != SQLITE_OK) {
        cout << "SQL error: " << sqlite3_errmsg(db) << endl;
        return;
    }
    
    int idd, age, salary;
    string name, gender;
    
    cout << "Enter ID: ";
    cin >> idd;
    cout << "Enter Name: ";
    cin >> name;
    cout << "Enter Age: ";
    cin >> age;
    cout << "Enter Gender: ";
    cin >> gender;
    cout << "Enter Salary: ";
    cin >> salary;
    
    sqlite3_bind_text(stmt, 1, name.c_str(), -1, SQLITE_STATIC);
    sqlite3_bind_int(stmt, 2, age);
    sqlite3_bind_text(stmt, 3, gender.c_str(), -1, SQLITE_STATIC);
    sqlite3_bind_int(stmt, 4, salary);
    sqlite3_bind_int(stmt, 5, idd);
    
    rc = sqlite3_step(stmt);
    if (rc != SQLITE_DONE) {
        cout << "Something Error in Updation" << endl;
    } else {
        cout << "Records Updated" << endl;
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(db);
}

void deleteRecord() {
    sqlite3 *db;
    int rc = sqlite3_open("data.db", &db);
    if (rc) {
        cout << "Can't open database: " << sqlite3_errmsg(db) << endl;
        return;
    }
    
    sqlite3_stmt *stmt;
    const char *sql = "DELETE FROM USERS WHERE ID = ?;";
    rc = sqlite3_prepare_v2(db, sql, -1, &stmt, 0);
    if (rc != SQLITE_OK) {
        cout << "SQL error: " << sqlite3_errmsg(db) << endl;
        return;
    }
    
    int idd;
    cout << "Enter ID: ";
    cin >> idd;
    
    sqlite3_bind_int(stmt, 1, idd);
    
    rc = sqlite3_step(stmt);
    if (rc != SQLITE_DONE) {
        cout << "Something Error in Deletion" << endl;
    } else {
        cout << "One record Deleted" << endl;
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(db);
}

int main() {
    while (true) {
        cout << "1). Insert Records" << endl;
        cout << "2). Read Records" << endl;
        cout << "3). Update Records" << endl;
        cout << "4). Delete Records" << endl;
        cout << "5). Exit" << endl;
        cout << "Enter Your Choice: ";
        
        int ch;
        cin >> ch;
        
        switch (ch) {
            case 1:
                insert();
                break;
            case 2:
                cout << "1). Read Single Record" << endl;
                cout << "2). Read All Records" << endl;
                cout << "Enter Your Choice: ";
                
                int choice;
                cin >> choice;
                
                if (choice == 1) {
                    read_one();
                } else if (choice == 2) {
                    read_all();
                } else {
                    cout << "Wrong Choice Entered" << endl;
                }
                
                break;
            case 3:
                update();
                break;
            case 4:
                deleteRecord();
                break;
            case 5:
                return 0;
            default:
                cout << "Enter Correct Choice" << endl;
                break;
        }
    }
    
    return 0;
}
