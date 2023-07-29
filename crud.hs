import Database.SQLite.Simple

create :: IO ()
create = do
  conn <- open "data.db"
  execute_ conn "CREATE TABLE IF NOT EXISTS Users (ID INTEGER PRIMARY KEY NOT NULL, NAME TEXT NOT NULL, AGE INTEGER NOT NULL, GENDER TEXT, SALARY INTEGER)"
  putStrLn "Table created successfully"

insert :: IO ()
insert = do
  conn <- open "data.db"
  putStrLn "Enter ID: "
  idd <- readLn
  putStrLn "Enter Name: "
  name <- getLine
  putStrLn "Enter Age: "
  age <- readLn
  putStrLn "Enter your Gender: "
  gender <- getLine
  putStrLn "Enter your Salary: "
  salary <- readLn
  execute conn "INSERT INTO Users (ID, NAME, AGE, GENDER, SALARY) VALUES (?, ?, ?, ?, ?)" (idd, name, age, gender, salary)
  putStrLn "Data Inserted Successfully"

readOne :: IO ()
readOne = do
  conn <- open "data.db"
  putStrLn "Enter Your ID: "
  ids <- readLn
  results <- query conn "SELECT * FROM Users WHERE ID = ?" (Only ids) :: IO [(Int, String, Int, Maybe String, Maybe Int)]
  case results of
    [] -> putStrLn "ID does not exist"
    [(id, name, age, _, salary)] -> do
      putStrLn $ "Name is: " ++ name
      putStrLn $ "Age is: " ++ show age
      putStrLn $ "Salary is: " ++ show salary

readAll :: IO ()
readAll = do
  conn <- open "data.db"
  results <- query_ conn "SELECT * FROM Users" :: IO [(Int, String, Int, Maybe String, Maybe Int)]
  putStrLn "<=== Available Records ===>"
  mapM_ (\(id, name, age, _, salary) -> do
    putStrLn $ "Name is: " ++ name
    putStrLn $ "Age is: " ++ show age
    putStrLn $ "Salary is: " ++ show salary
    putStrLn "") results

update :: IO ()
update = do
  conn <- open "data.db"
  putStrLn "Enter ID: "
  idd <- readLn
  putStrLn "Enter Name: "
  name <- getLine
  putStrLn "Enter Age: "
  age <- readLn
  putStrLn "Enter Gender: "
  gender <- getLine
  putStrLn "Enter Salary: "
  salary <- readLn
  execute conn "UPDATE Users SET NAME = ?, AGE = ?, GENDER = ?, SALARY = ? WHERE ID = ?" (name, age, gender, salary, idd)
  putStrLn "Records Updated"

delete :: IO ()
delete = do
  conn <- open "data.db"
  putStrLn "Enter ID: "
  idd <- readLn
  execute conn "DELETE FROM Users WHERE ID = ?" (Only idd)
  putStrLn "One record Deleted"

main :: IO ()
main = do
  putStrLn "1). Insert Records: "
  putStrLn "2). Read Records: "
  putStrLn "3). Update Records: "
  putStrLn "4). Delete Records: "
  putStrLn "5). Exit"
  putStrLn "Enter Your Choice: "
  ch <- readLn
  case ch of
    1 -> insert
    2 -> do
      putStrLn "1). Read Single Record"
      putStrLn "2). Read All Records"
      putStrLn "Enter Your Choice: "
      choice <- readLn
      case choice of
        1 -> readOne
        2 -> readAll
        _ -> putStrLn "Wrong Choice Entered"
    3 -> update
    4 -> delete
    5 -> return ()
    _ -> putStrLn "Enter Correct Choice"
