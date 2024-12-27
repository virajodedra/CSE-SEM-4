CREATE TABLE Departments ( 
	DepartmentID INT PRIMARY KEY, 
	DepartmentName VARCHAR(100) NOT NULL UNIQUE, 
	ManagerID INT NOT NULL, 
	Location VARCHAR(100) NOT NULL 
); 
CREATE TABLE Employee ( 
	EmployeeID INT PRIMARY KEY, 
	FirstName VARCHAR(100) NOT NULL, 
	LastName VARCHAR(100) NOT NULL, 
	DoB DATETIME NOT NULL, 
	Gender VARCHAR(50) NOT NULL, 
	HireDate DATETIME NOT NULL, 
	DepartmentID INT NOT NULL, 
	Salary DECIMAL(10, 2) NOT NULL, 
	FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) 
);
-- Create Projects Table 
CREATE TABLE Projects ( 
	ProjectID INT PRIMARY KEY, 
	ProjectName VARCHAR(100) NOT NULL, 
	StartDate DATETIME NOT NULL, 
	EndDate DATETIME NOT NULL, 
	DepartmentID INT NOT NULL, 
	FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) 
);

INSERT INTO Departments (DepartmentID, DepartmentName, ManagerID, Location) 
VALUES  
(1, 'IT', 101, 'New York'), 
(2, 'HR', 102, 'San Francisco'), 
(3, 'Finance', 103, 'Los Angeles'), 
(4, 'Admin', 104, 'Chicago'), 
(5, 'Marketing', 105, 'Miami');

INSERT INTO Employee (EmployeeID, FirstName, LastName, DoB, Gender, HireDate, DepartmentID, Salary) 
VALUES  
(101, 'John', 'Doe', '1985-04-12', 'Male', '2010-06-15', 1, 75000.00), 
(102, 'Jane', 'Smith', '1990-08-24', 'Female', '2015-03-10', 2, 60000.00), 
(103, 'Robert', 'Brown', '1982-12-05', 'Male', '2008-09-25', 3, 82000.00), 
(104, 'Emily', 'Davis', '1988-11-11', 'Female', '2012-07-18', 4, 58000.00), 
(105, 'Michael', 'Wilson', '1992-02-02', 'Male', '2018-11-30', 5, 67000.00);

INSERT INTO Projects (ProjectID, ProjectName, StartDate, EndDate, DepartmentID) 
VALUES  
(201, 'Project Alpha', '2022-01-01', '2022-12-31', 1), 
(202, 'Project Beta', '2023-03-15', '2024-03-14', 2), 
(203, 'Project Gamma', '2021-06-01', '2022-05-31', 3), 
(204, 'Project Delta', '2020-10-10', '2021-10-09', 4), 
(205, 'Project Epsilon', '2024-04-01', '2025-03-31', 5);


-------------------------------------------------------------------Part – A------------------------------------------
--1. Create Stored Procedure for Employee table As User enters either First Name or Last Name and based
--on this you must give EmployeeID, DOB, Gender & Hiredate.

	create or alter procedure PR_A1
		@Fname varchar(100) = null,
		@Lname varchar(100) = null
	as
	begin
		select *
		from Employee
		where (FirstName = @Fname or
				LastName = @Lname)
	end


	exec PR_A1 null, Wilson


--2. Create a Procedure that will accept Department Name and based on that gives employees list who
--belongs to that department. 

	create or alter procedure PR_A2
		@DepartmentName varchar(100) 
		
	as
	begin
		select *
		from Employee
		join Department
		on Employee.DepartmentID = Department.DepartmentID
		where Department.DepartmentName = @DepartmentName
	end
	
	exec PR_A2 HR
--3. Create a Procedure that accepts Project Name & Department Name and based on that you must give
--all the project related details.
	create or alter procedure PR_A3
		@PName varchar(100),
		@DName varchar(100)	
	as
	begin
		select *
		from Projects
		join Department
		on Projects.DepartmentID = Department.DepartmentID
		where Department.DepartmentName = @DName and
			Projects.ProjectName = @PName
	end

	exec PR_A3 'Project Alpha', 'Admin'
--4. Create a procedure that will accepts any integer and if salary is between provided integer, then those
--employee list comes in output.
	create or alter procedure PR_A4
		@Salary decimal(8,2),
		@Salary2 decimal(8,2)		
	as
	begin
		select *
		from Employee
		where Salary between @Salary and @Salary2
	end
--5. Create a Procedure that will accepts a date and gives all the employees who all are hired on that date.
	create or alter procedure PR_A5
		@Date datetime	
	as
	begin
		select *
		from Employee
		where HireDate = @Date
	end
	exec PR_A5 '2010-06-15'
--Part – B
--6. Create a Procedure that accepts Gender’s first letter only and based on that employee details will be
--served.
	create or alter procedure PR_B6
		@First varchar(100)
	as
	begin
		select *
		from Employee
		where Gender like @First + '%'
	end
--7. Create a Procedure that accepts First Name or Department Name as input and based on that employee
--data will come.
	create or alter procedure PR_B6
		@FName varchar(100) = null,
		@Dname varchar(100) = null
	as
	begin
		select *
		from Employee
		join Departments
		on Employee.DepartmentID = Departments.DepartmentID
		where  (Employee.FirstName = @Fname or
				Departments.DepartmentName = @Dname)
	end
--8. Create a procedure that will accepts location, if user enters a location any characters, then he/she will
--get all the departments with all data.
	create or alter procedure PR_B8
		@Location varchar(100)
	as
	begin
		select *
		from Employee
		join Departments
		on Employee.DepartmentID = Departments.DepartmentID
		join Projects
		on Projects.DepartmentID = Departments.DepartmentID
		where  Departments.Location like '%' + @Location +'%'
	end
	exec PR_B8 Ch
--Part – C
--9. Create a procedure that will accepts From Date & To Date and based on that he/she will retrieve Project
--related data.
	create or alter procedure PR_C1
		@Sdate datetime,
		@Edate datetime
	as
	begin
		select * 
		from Projects
		where StartDate = @Sdate and EndDate = @Edate
	end
		
--10. Create a procedure in which user will enter project name & location and based on that you must
--provide all data with Department Name, Manager Name with Project Name & Starting Ending Dates.

	create or alter procedure PR_C2
		@Pname varchar(100),
		@Lname varchar(100)
	as
	begin
		select Departments.DepartmentName, Departments.ManagerID, Projects.ProjectName, Projects.StartDate, Projects.EndDate
		from Departments
		join Projects
		on Projects.DepartmentID = Departments.DepartmentID
		where Projects.ProjectName = @Pname and Departments.Location = @Lname
	end
		
------------------------------------VIRAJ------------------------SCE_4A_123---------------------------------------------------------------
