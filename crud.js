const sqlite3 = require('sqlite3').verbose();
const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

const db = new sqlite3.Database('data.db');

function create() {
  db.serialize(() => {
    db.run(`
      CREATE TABLE IF NOT EXISTS Users (
        ID INTEGER PRIMARY KEY NOT NULL,
        NAME TEXT NOT NULL,
        AGE INTEGER NOT NULL,
        GENDER TEXT,
        SALARY INTEGER
      )
    `, (err) => {
      if (err) {
        console.error('Table creation error:', err);
      } else {
        console.log('Table created successfully');
      }
    });
  });
}

function insert() {
  rl.question('Enter ID: ', (idd) => {
    rl.question('Enter Name: ', (name) => {
      rl.question('Enter Age: ', (age) => {
        rl.question('Enter your Gender: ', (gender) => {
          rl.question('Enter your Salary: ', (salary) => {
            const query = 'INSERT INTO Users (ID, NAME, AGE, GENDER, SALARY) VALUES (?, ?, ?, ?, ?)';
            const data = [idd, name, age, gender, salary];
            db.run(query, data, (err) => {
              if (err) {
                console.error('Data insertion error:', err);
              } else {
                console.log('Data inserted successfully');
              }
              rl.close();
            });
          });
        });
      });
    });
  });
}

function readOne() {
  rl.question('Enter Your ID: ', (ids) => {
    const query = 'SELECT * FROM Users WHERE ID = ?';
    db.get(query, [ids], (err, row) => {
      if (err) {
        console.error('Read one record error:', err);
      } else if (row) {
        console.log(`Name is: ${row.NAME}`);
        console.log(`Age is: ${row.AGE}`);
        console.log(`Salary is: ${row.SALARY}`);
      } else {
        console.log('Record does not exist');
      }
      rl.close();
    });
  });
}

function readAll() {
  const query = 'SELECT * FROM Users';
  db.all(query, (err, rows) => {
    if (err) {
      console.error('Read all records error:', err);
    } else if (rows.length > 0) {
      console.log('\n<=== Available Records ===>');
      rows.forEach((row) => {
        console.log(`Name is: ${row.NAME}`);
        console.log(`Age is: ${row.AGE}`);
        console.log(`Salary is: ${row.SALARY}\n`);
      });
    } else {
      console.log('No records found');
    }
    rl.close();
  });
}

function update() {
  rl.question('Enter ID: ', (idd) => {
    rl.question('Enter Name: ', (name) => {
      rl.question('Enter Age: ', (age) => {
        rl.question('Enter Gender: ', (gender) => {
          rl.question('Enter Salary: ', (salary) => {
            const query = 'UPDATE Users SET NAME = ?, AGE = ?, GENDER = ?, SALARY = ? WHERE ID = ?';
            const data = [name, age, gender, salary, idd];
            db.run(query, data, (err) => {
              if (err) {
                console.error('Record update error:', err);
              } else {
                console.log('Record updated successfully');
              }
              rl.close();
            });
          });
        });
      });
    });
  });
}

function remove() {
  rl.question('Enter ID: ', (idd) => {
    const query = 'DELETE FROM Users WHERE ID = ?';
    db.run(query, [idd], (err) => {
      if (err) {
        console.error('Record deletion error:', err);
      } else {
        console.log('Record deleted successfully');
      }
      rl.close();
    });
  });
}

function main() {
  rl.question('1) Insert Records\n2) Read Records\n3) Update Records\n4) Delete Records\n5) Exit\nEnter Your Choice: ', (ch) => {
    switch (ch) {
      case '1':
        insert();
        break;
      case '2':
        rl.question('1) Read Single Record\n2) Read All Records\nEnter Your Choice: ', (choice) => {
          if (choice === '1') {
            readOne();
          } else if (choice === '2') {
            readAll();
          } else {
            console.log('Wrong choice entered');
            rl.close();
          }
        });
        break;
      case '3':
        update();
        break;
      case '4':
        remove();
        break;
      case '5':
        rl.close();
        break;
      default:
        console.log('Enter correct choice');
        rl.close();
        break;
    }
  });
}

create();
main();

process.on('exit', () => {
  db.close();
});
