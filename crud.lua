local sqlite3 = require("lsqlite3")

-- FOR CREATING TABLE
function create()
    local db = sqlite3.open("data.db")
    print("Opened database successfully")
    db:exec([[
        CREATE TABLE Users
        (ID      INT   PRIMARY KEY  NOT NULL,
         NAME    TEXT               NOT NULL,
         AGE     INT                NOT NULL,
         GENDER  TEXT,
         SALARY  INT);
    ]])
    print("Table created successfully")
    db:close()
end

-- FOR INSERTING RECORDS
function insert()
    local db = sqlite3.open("data.db")
    local stmt = db:prepare("INSERT INTO Users(ID, NAME, AGE, GENDER, SALARY) VALUES (?, ?, ?, ?, ?)")
    while true do
        print("Enter ID: ")
        local id = io.read()
        print("Enter Name: ")
        local name = io.read()
        print("Enter Age: ")
        local age = io.read()
        print("Enter Gender: ")
        local gender = io.read()
        print("Enter Salary: ")
        local salary = io.read()
        stmt:bind_values(id, name, age, gender, salary)
        stmt:step()
        stmt:reset()
        print("Data Inserted Successfully")
        print("Do You want to Add More Records(Y/N): ")
        local choice = io.read()
        if choice == "N" or choice == "n" then
            break
        end
    end
    stmt:finalize()
    db:close()
end

-- FOR READING ONE RECORD
function read_one()
    local db = sqlite3.open("data.db")
    print("Enter Your ID: ")
    local id = io.read()
    local stmt = db:prepare("SELECT * FROM Users WHERE ID = ?")
    stmt:bind_values(id)
    while stmt:step() == sqlite3.ROW do
        print("Name is: " .. stmt:get_value(1))
        print("Age is: " .. stmt:get_value(2))
        print("Salary is: " .. stmt:get_value(4))
    end
    stmt:finalize()
    db:close()
end

-- FOR READING ALL RECORDS
function read_all()
    local db = sqlite3.open("data.db")
    local stmt = db:prepare("SELECT * FROM Users")
    while stmt:step() == sqlite3.ROW do
        print("Name is: " .. stmt:get_value(1))
        print("Age is: " .. stmt:get_value(2))
        print("Salary is: " .. stmt:get_value(4))
    end
    stmt:finalize()
    db:close()
end

-- FOR UPDATING RECORDS
function update()
    local db = sqlite3.open("data.db")
    print("Enter ID: ")
    local id = io.read()
    print("Enter Name: ")
    local name = io.read()
    print("Enter Age: ")
    local age = io.read()
    print("Enter Gender: ")
    local gender = io.read()
    print("Enter Salary: ")
    local salary = io.read()
    local stmt = db:prepare("UPDATE Users SET NAME = ?, AGE = ?, GENDER = ?, SALARY = ? WHERE ID = ?")
    stmt:bind_values(name, age, gender, salary, id)
    stmt:step()
    stmt:finalize()
    print("Records Updated")
    db:close()
end

-- FOR DELETING RECORDS
function delete()
    local db = sqlite3.open("data.db")
    print("Enter ID: ")
    local id = io.read()
    local stmt = db:prepare("DELETE FROM Users WHERE ID = ?")
    stmt:bind_values(id)
    stmt:step()
    stmt:finalize()
    print("One record Deleted")
    db:close()
end

-- MAIN FUNCTION
function main()
    while true do
        print("1). Insert Records")
        print("2). Read Records")
        print("3). Update Records")
        print("4). Delete Records")
        print("5). Exit")
        print("Enter Your Choice: ")
        local choice = io.read()
        if choice == "1" then
            insert()
        elseif choice == "2" then
            print("1). Read Single Record")
            print("2). Read All Records")
            print("Enter Your Choice: ")
            local subChoice = io.read()
            if subChoice == "1" then
                read_one()
            elseif subChoice == "2" then
                read_all()
            else
                print("Wrong Choice Entered")
            end
        elseif choice == "3" then
            update()
        elseif choice == "4" then
            delete()
        elseif choice == "5" then
            break
        else
            print("Enter Correct Choice")
        end
    end
end

-- CALLING MAIN FUNCTION
main()
