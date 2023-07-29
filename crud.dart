import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'data.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE Users(ID INTEGER PRIMARY KEY, NAME TEXT NOT NULL, AGE INTEGER NOT NULL, GENDER TEXT, SALARY INTEGER)',
      );
    },
    version: 1,
  );

  await database.then((db) async {
    while (true) {
      print("1). Insert Records: ");
      print("2). Read Records: ");
      print("3). Update Records: ");
      print("4). Delete Records: ");
      print("5). Exit");
      int ch = int.parse(stdin.readLineSync()!);
      if (ch == 1) {
        await insert(db);
      } else if (ch == 2) {
        print("1). Read Single Record");
        print("2). Read All Records");
        int choice = int.parse(stdin.readLineSync()!);
        if (choice == 1) {
          await readOne(db);
        } else if (choice == 2) {
          await readAll(db);
        } else {
          print("Wrong Choice Entered");
        }
      } else if (ch == 3) {
        await update(db);
      } else if (ch == 4) {
        await delete(db);
      } else if (ch == 5) {
        break;
      } else {
        print("Enter Correct Choice");
      }
    }
  });
}

Future<void> insert(Database db) async {
  try {
    print("Enter ID: ");
    int idd = int.parse(stdin.readLineSync()!);
    print("Enter Name: ");
    String name = stdin.readLineSync()!;
    print("Enter Age: ");
    int age = int.parse(stdin.readLineSync()!);
    print("Enter your Gender: ");
    String gender = stdin.readLineSync()!;
    print("Enter your Salary: ");
    int salary = int.parse(stdin.readLineSync()!);

    await db.insert(
      'Users',
      {
        'ID': idd,
        'NAME': name,
        'AGE': age,
        'GENDER': gender,
        'SALARY': salary,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print("Data Inserted Successfully");
  } catch (e) {
    print("Error in Record Creation");
  }
}

Future<void> readOne(Database db) async {
  try {
    print("Enter Your ID: ");
    int ids = int.parse(stdin.readLineSync()!);

    List<Map<String, dynamic>> result = await db.query(
      'Users',
      where: 'ID = ?',
      whereArgs: [ids],
    );

    if (result.isNotEmpty) {
      for (var row in result) {
        print("Name is: ${row['NAME']}");
        print("Age is: ${row['AGE']}");
        print("Salary is: ${row['SALARY']}");
      }
    } else {
      print("Record Does not Exist");
    }
  } catch (e) {
    print("Error in Reading Record");
  }
}

Future<void> readAll(Database db) async {
  try {
    List<Map<String, dynamic>> result = await db.query('Users');

    if (result.isNotEmpty) {
      print("\n<=== Available Records ===>");
      for (var row in result) {
        print("Name is: ${row['NAME']}");
        print("Age is: ${row['AGE']}");
        print("Salary is: ${row['SALARY']}\n");
      }
    } else {
      print("No Records Found");
    }
  } catch (e) {
    print("Error in Reading Records");
  }
}

Future<void> update(Database db) async {
  try {
    print("Enter ID: ");
    int idd = int.parse(stdin.readLineSync()!);
    print("Enter Name: ");
    String name = stdin.readLineSync()!;
    print("Enter Age: ");
    int age = int.parse(stdin.readLineSync()!);
    print("Enter Gender: ");
    String gender = stdin.readLineSync()!;
    print("Enter Salary: ");
    int salary = int.parse(stdin.readLineSync()!);

    await db.update(
      'Users',
      {
        'NAME': name,
        'AGE': age,
        'GENDER': gender,
        'SALARY': salary,
      },
      where: 'ID = ?',
      whereArgs: [idd],
    );

    print("Record Updated Successfully");
  } catch (e) {
    print("Error in Updating Record");
  }
}

Future<void> delete(Database db) async {
  try {
    print("Enter ID: ");
    int idd = int.parse(stdin.readLineSync()!);

    await db.delete(
      'Users',
      where: 'ID = ?',
      whereArgs: [idd],
    );

    print("Record Deleted Successfully");
  } catch (e) {
    print("Error in Deleting Record");
  }
}
