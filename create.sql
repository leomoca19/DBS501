-- Create the Locations table
CREATE TABLE Locations (
    Location_id NUMBER PRIMARY KEY,
    City VARCHAR2(50)
);

-- Insert sample data into Locations
INSERT INTO Locations (Location_id, City) VALUES (1100, 'Venice');  

-- Create the Employees table
CREATE TABLE Employees (
    Employee_id NUMBER PRIMARY KEY,
    First_name VARCHAR2(50),
    Last_name VARCHAR2(50),
    Manager_id NUMBER,
    Hire_date DATE
);

-- Insert sample data into Employees
INSERT INTO Employees (Employee_id, First_name, Last_name, Manager_id, Hire_date) VALUES (100, 'Manager', 'Smith', NULL, TO_DATE('2023-01-15', 'YYYY-MM-DD'));
INSERT INTO Employees (Employee_id, First_name, Last_name, Manager_id, Hire_date) VALUES (101, 'John', 'Doe', 100, TO_DATE('2023-02-10', 'YYYY-MM-DD'));
INSERT INTO Employees (Employee_id, First_name, Last_name, Manager_id, Hire_date) VALUES (102, 'Jane', 'Smith', 100, TO_DATE('2023-03-05', 'YYYY-MM-DD'));

-- Create the Departments table
CREATE TABLE Departments (
    Department_id NUMBER PRIMARY KEY,
    Department_name VARCHAR2(50),
    Manager_id NUMBER,
    Location_id NUMBER,
    FOREIGN KEY (Manager_id) REFERENCES Employees(Employee_id),
    FOREIGN KEY (Location_id) REFERENCES Locations(Location_id)
);

-- Insert sample data into Departments
INSERT INTO Departments (Department_id, Department_name, Manager_id, Location_id) VALUES (320, 'Testing', 100, 1100);
INSERT INTO Departments (Department_id, Department_name, Manager_id, Location_id) VALUES (321, 'Designing', 100, 1200);
INSERT INTO Departments (Department_id, Department_name, Manager_id, Location_id) VALUES (322, 'Manufacturing', 100, 1200);
INSERT INTO Departments (Department_id, Department_name, Manager_id, Location_id) VALUES (323, 'Marketing', 100, 1200);
