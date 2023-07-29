#!/bin/python3

import sqlite3

####################################################
def create():
	conn = sqlite3.connect('data.db')
	print("Opened database successfully");
	conn.execute('''
		CREATE TABLE Users
		(ID      INT   PRIMARY KEY  NOT NULL,
		 NAME    TEXT               NOT NULL,
		 AGE     INT                NOT NULL,
		 GENDER  TEXT,
		 SALARY  INT);
	''')
	print("Table created successfully");

####################################################
# FOR CREATING RECORDS FUNCTION DEFINITION
def insert():
#	try:
		con = sqlite3.connect("data.db")
		cursor = con.cursor()
		while (True):
			idd = int(input("Enter ID: "))
			name = input("Enter Name: ")
			age = int(input("Enter Age: "))
			gender = input("Enter your Gender: ")
			salary = int(input("Enter your Salary: "))
			query = "INSERT into USERS(ID,NAME,AGE,GENDER,SALARY) VALUES (?,?,?,?,?);"
			data = (idd,name,age,gender,salary)
			cursor.execute(query, data)
			con.commit()
			if(cursor.execute(query,data)):
				print("Data Inserted Successfully")
			else:
				print("Data not Inserted")
#			ch = input("Do You want to Add More Records(Y/N): ")
#			if ch == "N" or ch == "n":
#				cursor.close()
#				break
#			else:
#				pass
#	except:
#		print("Error in Record Creation\n")

####################################################
# FOR READING ONE RECORD FUNCTION DEFINITION
def read_one():
    con = sqlite3.connect("data.db")
    cursor = con.cursor()
    ids = int(input("Enter Your ID: "))
    query = "SELECT * from USERS WHERE id = ?"
    result = cursor.execute(query, (ids,))
    if (result):
        for i in result:
            print(f"Name is: {i[1]}")
            print(f"Age is: {i[2]}")
            print(f"Salary is: {i[4]}")
    else:
        print("Roll Number Does not Exist")
        cursor.close()

####################################################
# FOR READING ALL RECORDS FUNCTION DEFINITION
def read_all():
    con = sqlite3.connect("data.db")
    cursor = con.cursor()
    query = "SELECT * from USERS"
    result = cursor.execute(query)
    if (result):
        print("\n&lt;===Available Records===&gt;")
        for i in result:
            print(f"Name is : {i[1]}")
            print(f"Age is : {i[2]}")
            print(f"Salary is : {i[4]}\n")
    else:
        pass
    
####################################################
# FOR UPDATING RECORDS FUNCTION DEFINITION
def update():
    con = sqlite3.connect("data.db")
    cursor = con.cursor()
    idd = int(input("Enter ID: "))
    name = input("Enter Name: ")
    age = int(input("Enter Age: "))
    gender = input("Enter Gender: ")
    salary = int(input("Enter Salary: "))
    data = (name, age, gender, salary, idd,)
    query = "UPDATE USERS set name = ?, age = ?, gender = ?, salary = ? WHERE id = ?"
    result = cursor.execute(query, data)
    con.commit()
    cursor.close()
    if (result):
        print("Records Updated")
    else:
        print("Something Error in Updation")

####################################################
# FOR DELETING RECORDS FUNCTION DEFINITION
def delete():
    con = sqlite3.connect("data.db")
    cursor = con.cursor()
    idd = int(input("Enter ID: "))
    query = "DELETE from USERS where ID = ?"
    result = cursor.execute(query, (idd,))
    con.commit()
    cursor.close()
    if (result):
        print("One record Deleted")
    else:
        print("Something Error in Deletion")

####################################################
# MAIN BLOCK
try:
    while (True):
        print("1). Insert Records: ")
        print("2). Read Records: ")
        print("3). Update Records: ")
        print("4). Delete Records: ")
        print("5). Exit")
        ch = int(input("Enter Your Choice: "))
        if (ch == 1):
            insert()
        elif (ch == 2):
            print("1). Read Single Record")
            print("2). Read All Records")
            choice = int(input("Enter Your Choice: "))
            if (choice == 1):
                read_one()
            elif (choice == 2):
                read_all()
            else:
                print("Wrong Choice Entered")
        elif (ch == 3):
            update()
        elif (ch == 4):
            delete()
        elif (ch == 5):
            break
        else:
            print("Enter Correct Choice")
except:
    print("Database Error")

####################################################
#END
