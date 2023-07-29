#!/bin/bash

####################################################
create() {
    sqlite3 data.db <<EOF
    CREATE TABLE Users
    (ID      INT   PRIMARY KEY  NOT NULL,
     NAME    TEXT               NOT NULL,
     AGE     INT                NOT NULL,
     GENDER  TEXT,
     SALARY  INT);
EOF
    echo "Table created successfully"
}

####################################################
# FOR CREATING RECORDS FUNCTION DEFINITION
insert() {
    while true; do
        read -p "Enter ID: " idd
        read -p "Enter Name: " name
        read -p "Enter Age: " age
        read -p "Enter your Gender: " gender
        read -p "Enter your Salary: " salary
        sqlite3 data.db <<EOF
        INSERT into USERS(ID,NAME,AGE,GENDER,SALARY) VALUES ($idd,'$name',$age,'$gender',$salary);
EOF
        if [ $? -eq 0 ]; then
            echo "Data Inserted Successfully"
        else
            echo "Data not Inserted"
        fi
        read -p "Do You want to Add More Records(Y/N): " ch
        if [ "$ch" == "N" ] || [ "$ch" == "n" ]; then
            break
        fi
    done
}

####################################################
# FOR READING ONE RECORD FUNCTION DEFINITION
read_one() {
    read -p "Enter Your ID: " ids
    sqlite3 data.db <<EOF
    SELECT * from USERS WHERE id = $ids;
EOF
    if [ $? -eq 0 ]; then
        echo "Name is: $name"
        echo "Age is: $age"
        echo "Salary is: $salary"
    else
        echo "Roll Number Does not Exist"
    fi
}

####################################################
# FOR READING ALL RECORDS FUNCTION DEFINITION
read_all() {
    sqlite3 data.db <<EOF
    SELECT * from USERS;
EOF
    if [ $? -eq 0 ]; then
        echo "<===Available Records===>"
        echo "Name is : $name"
        echo "Age is : $age"
        echo "Salary is : $salary"
    fi
}

####################################################
# FOR UPDATING RECORDS FUNCTION DEFINITION
update() {
    read -p "Enter ID: " idd
    read -p "Enter Name: " name
    read -p "Enter Age: " age
    read -p "Enter Gender: " gender
    read -p "Enter Salary: " salary
    sqlite3 data.db <<EOF
    UPDATE USERS set name = '$name', age = $age, gender = '$gender', salary = $salary WHERE id = $idd;
EOF
    if [ $? -eq 0 ]; then
        echo "Records Updated"
    else
        echo "Something Error in Updation"
    fi
}

####################################################
# FOR DELETING RECORDS FUNCTION DEFINITION
delete() {
    read -p "Enter ID: " idd
    sqlite3 data.db <<EOF
    DELETE from USERS where ID = $idd;
EOF
    if [ $? -eq 0 ]; then
        echo "One record Deleted"
    else
        echo "Something Error in Deletion"
    fi
}

####################################################
# MAIN BLOCK
while true; do
    echo "1). Insert Records: "
    echo "2). Read Records: "
    echo "3). Update Records: "
    echo "4). Delete Records: "
    echo "5). Exit"
    read -p "Enter Your Choice: " ch
    if [ $ch -eq 1 ]; then
        insert
    elif [ $ch -eq 2 ]; then
        echo "1). Read Single Record"
        echo "2). Read All Records"
        read -p "Enter Your Choice: " choice
        if [ $choice -eq 1 ]; then
            read_one
        elif [ $choice -eq 2 ]; then
            read_all
        else
            echo "Wrong Choice Entered"
        fi
    elif [ $ch -eq 3 ]; then
        update
    elif [ $ch -eq 4 ]; then
        delete
    elif [ $ch -eq 5 ]; then
        break
    else
        echo "Enter Correct Choice"
    fi
done

####################################################
#END
