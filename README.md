# Create-Retrieve-Update-Delete
**with sqlite**

### Diagram
```mermaid
classDiagram
class Main
Main <-- Insert
Main <-- Read
Main <-- Update
Main <-- Delete
Main: +int id
class Insert{
  +int id
  +String name
  +int age
  +char gender
  +int salary
}
class Read{
  +print()
}
class Update{
  +String name
  +int age
  +char gender
  +int salary
}
class Delete{
  -int id
}
```

### Prerequisite

#### Python
``pip install --user sqlite``
``python3 crud.py``

#### Java
``java -classpath crud.java``

#### C++
``g++ crud.cpp -o out.crud.cpp``
``./out.crud.cpp``

#### C
``gcc crud.c -o out.crud.c``
``./out.crud.cpp``

