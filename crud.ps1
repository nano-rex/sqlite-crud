import-module sqlite3

####################################################
function create {
	$conn = sqlite3.connect('data.db')
	Write-Host "Opened database successfully"
	$conn.execute(@'
		CREATE TABLE Users
		(ID      INT   PRIMARY KEY  NOT NULL,
		 NAME    TEXT               NOT NULL,
		 AGE     INT                NOT NULL,
		 GENDER  TEXT,
		 SALARY  INT);
	'@)
	Write-Host "Table created successfully"
}

####################################################
# FOR CREATING RECORDS FUNCTION DEFINITION
function insert {
	$con = sqlite3.connect("data.db")
	$cursor = $con.cursor()
	do {
		$idd = [int](Read-Host "Enter ID")
		$name = Read-Host "Enter Name"
		$age = [int](Read-Host "Enter Age")
		$gender = Read-Host "Enter your Gender"
		$salary = [int](Read-Host "Enter your Salary")
		$query = "INSERT into USERS(ID,NAME,AGE,GENDER,SALARY) VALUES ($idd,'$name',$age,'$gender',$salary);"
		$cursor.execute($query)
		$con.commit()
		if ($cursor.execute($query)) {
			Write-Host "Data Inserted Successfully"
		} else {
			Write-Host "Data not Inserted"
		}
		$ch = Read-Host "Do You want to Add More Records(Y/N)"
	} while ($ch -eq "Y" -or $ch -eq "y")
	$cursor.close()
}

####################################################
# FOR READING ONE RECORD FUNCTION DEFINITION
function read_one {
	$con = sqlite3.connect("data.db")
	$cursor = $con.cursor()
	$ids = [int](Read-Host "Enter Your ID")
	$query = "SELECT * from USERS WHERE id = $ids"
	$result = $cursor.execute($query)
	if ($result) {
		foreach ($i in $result) {
			Write-Host "Name is: $($i[1])"
			Write-Host "Age is: $($i[2])"
			Write-Host "Salary is: $($i[4])"
		}
	} else {
		Write-Host "Roll Number Does not Exist"
		$cursor.close()
	}
}

####################################################
# FOR READING ALL RECORDS FUNCTION DEFINITION
function read_all {
	$con = sqlite3.connect("data.db")
	$cursor = $con.cursor()
	$query = "SELECT * from USERS"
	$result = $cursor.execute($query)
	if ($result) {
		Write-Host "<===Available Records===>"
		foreach ($i in $result) {
			Write-Host "Name is: $($i[1])"
			Write-Host "Age is: $($i[2])"
			Write-Host "Salary is: $($i[4])"
		}
	} else {
		# Do nothing
	}
}

####################################################
# FOR UPDATING RECORDS FUNCTION DEFINITION
function update {
	$con = sqlite3.connect("data.db")
	$cursor = $con.cursor()
	$idd = [int](Read-Host "Enter ID")
	$name = Read-Host "Enter Name"
	$age = [int](Read-Host "Enter Age")
	$gender = Read-Host "Enter Gender"
	$salary = [int](Read-Host "Enter Salary")
	$data = @($name, $age, $gender, $salary, $idd)
	$query = "UPDATE USERS set name = ?, age = ?, gender = ?, salary = ? WHERE id = ?"
	$result = $cursor.execute($query, $data)
	$con.commit()
	$cursor.close()
	if ($result) {
		Write-Host "Records Updated"
	} else {
		Write-Host "Something Error in Updation"
	}
}

####################################################
# FOR DELETING RECORDS FUNCTION DEFINITION
function delete {
	$con = sqlite3.connect("data.db")
	$cursor = $con.cursor()
	$idd = [int](Read-Host "Enter ID")
	$query = "DELETE from USERS where ID = $idd"
	$result = $cursor.execute($query)
	$con.commit()
	$cursor.close()
	if ($result) {
		Write-Host "One record Deleted"
	} else {
		Write-Host "Something Error in Deletion"
	}
}

####################################################
# MAIN BLOCK
try {
	do {
		Write-Host "1). Insert Records"
		Write-Host "2). Read Records"
		Write-Host "3). Update Records"
		Write-Host "4). Delete Records"
		Write-Host "5). Exit"
		$ch = [int](Read-Host "Enter Your Choice")
		switch ($ch) {
			1 {
				insert
			}
			2 {
				Write-Host "1). Read Single Record"
				Write-Host "2). Read All Records"
				$choice = [int](Read-Host "Enter Your Choice")
				switch ($choice) {
					1 {
						read_one
					}
					2 {
						read_all
					}
					default {
						Write-Host "Wrong Choice Entered"
					}
				}
			}
			3 {
				update
			}
			4 {
				delete
			}
			5 {
				break
			}
			default {
				Write-Host "Enter Correct Choice"
			}
		}
	} while ($true)
} catch {
	Write-Host "Database Error"
}

####################################################
#END
