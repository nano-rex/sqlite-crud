#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sqlite3.h>

// gcc crud.c -o out.crud.c -lsqlite3

void create() {
    sqlite3 *db;
    int rc = sqlite3_open("data.db", &db);
    if (rc) {
        printf("Can't open database: %s\n", sqlite3_errmsg(db));
        return;
    }
    printf("Opened database successfully\n");
    
    const char *sql = "CREATE TABLE Users (ID INT PRIMARY KEY NOT NULL, NAME TEXT NOT NULL, AGE INT NOT NULL, GENDER TEXT, SALARY INT);";
    rc = sqlite3_exec(db, sql, 0, 0, 0);
    if (rc != SQLITE_OK) {
        printf("SQL error: %s\n", sqlite3_errmsg(db));
    } else {
        printf("Table created successfully\n");
    }
    
    sqlite3_close(db);
}

void insert() {
    sqlite3 *db;
    int rc = sqlite3_open("data.db", &db);
    if (rc) {
        printf("Can't open database: %s\n", sqlite3_errmsg(db));
        return;
    }
    
    sqlite3_stmt *stmt;
    const char *sql = "INSERT INTO USERS (ID, NAME, AGE, GENDER, SALARY) VALUES (?, ?, ?, ?, ?);";
    rc = sqlite3_prepare_v2(db, sql, -1, &stmt, 0);
    if (rc != SQLITE_OK) {
        printf("SQL error: %s\n", sqlite3_errmsg(db));
        return;
    }
    
    while (1) {
        int idd, age, salary;
        char name[100], gender[10];
        
        printf("Enter ID: ");
        scanf("%d", &idd);
        printf("Enter Name: ");
        scanf("%s", name);
        printf("Enter Age: ");
        scanf("%d", &age);
        printf("Enter your Gender: ");
        scanf("%s", gender);
        printf("Enter your Salary: ");
        scanf("%d", &salary);
        
        sqlite3_bind_int(stmt, 1, idd);
        sqlite3_bind_text(stmt, 2, name, -1, SQLITE_STATIC);
        sqlite3_bind_int(stmt, 3, age);
        sqlite3_bind_text(stmt, 4, gender, -1, SQLITE_STATIC);
        sqlite3_bind_int(stmt, 5, salary);
        
        rc = sqlite3_step(stmt);
        if (rc != SQLITE_DONE) {
            printf("Data not Inserted\n");
        } else {
            printf("Data Inserted Successfully\n");
        }
        
        sqlite3_reset(stmt);
        
        char ch;
        printf("Do You want to Add More Records(Y/N): ");
        scanf(" %c", &ch);
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
        printf("Can't open database: %s\n", sqlite3_errmsg(db));
        return;
    }
    
    sqlite3_stmt *stmt;
    const char *sql = "SELECT * FROM USERS WHERE id = ?;";
    rc = sqlite3_prepare_v2(db, sql, -1, &stmt, 0);
    if (rc != SQLITE_OK) {
        printf("SQL error: %s\n", sqlite3_errmsg(db));
        return;
    }
    
    int ids;
    printf("Enter Your ID: ");
    scanf("%d", &ids);
    
    sqlite3_bind_int(stmt, 1, ids);
    
    rc = sqlite3_step(stmt);
    if (rc == SQLITE_ROW) {
        printf("Name is: %s\n", sqlite3_column_text(stmt, 1));
        printf("Age is: %d\n", sqlite3_column_int(stmt, 2));
        printf("Salary is: %d\n", sqlite3_column_int(stmt, 4));
    } else {
        printf("Record Does not Exist\n");
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(db);
}

void read_all() {
    sqlite3 *db;
    int rc = sqlite3_open("data.db", &db);
    if (rc) {
        printf("Can't open database: %s\n", sqlite3_errmsg(db));
        return;
    }
    
    sqlite3_stmt *stmt;
    const char *sql = "SELECT * FROM USERS;";
    rc = sqlite3_prepare_v2(db, sql, -1, &stmt, 0);
    if (rc != SQLITE_OK) {
        printf("SQL error: %s\n", sqlite3_errmsg(db));
        return;
    }
    
    rc = sqlite3_step(stmt);
    if (rc == SQLITE_ROW) {
        printf("\n<=== Available Records ===>\n");
        while (rc == SQLITE_ROW) {
            printf("Name is: %s\n", sqlite3_column_text(stmt, 1));
            printf("Age is: %d\n", sqlite3_column_int(stmt, 2));
            printf("Salary is: %d\n", sqlite3_column_int(stmt, 4));
            printf("\n");
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
        printf("Can't open database: %s\n", sqlite3_errmsg(db));
        return;
    }
    
    sqlite3_stmt *stmt;
    const char *sql = "UPDATE USERS SET NAME = ?, AGE = ?, GENDER = ?, SALARY = ? WHERE ID = ?;";
    rc = sqlite3_prepare_v2(db, sql, -1, &stmt, 0);
    if (rc != SQLITE_OK) {
        printf("SQL error: %s\n", sqlite3_errmsg(db));
        return;
    }
    
    int idd, age, salary;
    char name[100], gender[10];
    
    printf("Enter ID: ");
    scanf("%d", &idd);
    printf("Enter Name: ");
    scanf("%s", name);
    printf("Enter Age: ");
    scanf("%d", &age);
    printf("Enter Gender: ");
    scanf("%s", gender);
    printf("Enter Salary: ");
    scanf("%d", &salary);
    
    sqlite3_bind_text(stmt, 1, name, -1, SQLITE_STATIC);
    sqlite3_bind_int(stmt, 2, age);
    sqlite3_bind_text(stmt, 3, gender, -1, SQLITE_STATIC);
    sqlite3_bind_int(stmt, 4, salary);
    sqlite3_bind_int(stmt, 5, idd);
    
    rc = sqlite3_step(stmt);
    if (rc != SQLITE_DONE) {
        printf("Something Error in Updation\n");
    } else {
        printf("Records Updated\n");
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(db);
}

void deleteRecord() {
    sqlite3 *db;
    int rc = sqlite3_open("data.db", &db);
    if (rc) {
        printf("Can't open database: %s\n", sqlite3_errmsg(db));
        return;
    }
    
    sqlite3_stmt *stmt;
    const char *sql = "DELETE FROM USERS WHERE ID = ?;";
    rc = sqlite3_prepare_v2(db, sql, -1, &stmt, 0);
    if (rc != SQLITE_OK) {
        printf("SQL error: %s\n", sqlite3_errmsg(db));
        return;
    }
    
    int idd;
    printf("Enter ID: ");
    scanf("%d", &idd);
    
    sqlite3_bind_int(stmt, 1, idd);
    
    rc = sqlite3_step(stmt);
    if (rc != SQLITE_DONE) {
        printf("Something Error in Deletion\n");
    } else {
        printf("One record Deleted\n");
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(db);
}

int main() {
    while (1) {
        printf("1). Insert Records\n");
        printf("2). Read Records\n");
        printf("3). Update Records\n");
        printf("4). Delete Records\n");
        printf("5). Exit\n");
        printf("Enter Your Choice: ");
        
        int ch;
        scanf("%d", &ch);
        
        switch (ch) {
            case 1:
                insert();
                break;
            case 2:
                printf("1). Read Single Record\n");
                printf("2). Read All Records\n");
                printf("Enter Your Choice: ");
                
                int choice;
                scanf("%d", &choice);
                
                if (choice == 1) {
                    read_one();
                } else if (choice == 2) {
                    read_all();
                } else {
                    printf("Wrong Choice Entered\n");
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
                printf("Enter Correct Choice\n");
                break;
        }
    }
    
    return 0;
}
