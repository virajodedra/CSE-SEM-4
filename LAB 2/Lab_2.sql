-- Create Department Table 
CREATE TABLE Department ( 
DepartmentID INT PRIMARY KEY, 
DepartmentName VARCHAR(100) NOT NULL UNIQUE
);

delete from Department

-- Create Designation Table 
CREATE TABLE Designation ( 
DesignationID INT PRIMARY KEY, 
DesignationName VARCHAR(100) NOT NULL UNIQUE 
); 

-- Create Person Table 
CREATE TABLE Person ( 
PersonID INT PRIMARY KEY IDENTITY(101,1), 
FirstName VARCHAR(100) NOT NULL, 
LastName VARCHAR(100) NOT NULL, 
Salary DECIMAL(8, 2) NOT NULL, 
JoiningDate DATETIME NOT NULL,   
DepartmentID INT NULL, 
DesignationID INT NULL, 
FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID), 
FOREIGN KEY (DesignationID) REFERENCES Designation(DesignationID) 
);



--Part – A 
--1. Department, Designation & Person Table’s INSERT, UPDATE & DELETE Procedures. 
--For TABLE : 
	--INSERT TABLE : 1
	create or alter procedure PR_Department_insert
		@DepartmentID INT,
		@DepartmentName VARCHAR(100)
	as 
	begin
		insert into Department values(@DepartmentID, @DepartmentName);
	end

	exec PR_Department_insert 1, "Admin"
	exec PR_Department_insert 2, "IT"
	exec PR_Department_insert 3, "HR"
	exec PR_Department_insert 4, "Account"

	select * from Department
	--update :

	create or alter procedure PR_Department_update
		@DepartmentID INT,
		@DepartmentName VARCHAR(100)
	as 
	begin
		update Department
		set DepartmentName = @DepartmentName
		where DepartmentID = @DepartmentID
	end

	--DELETE : 
	 create or alter procedure PR_Department_delete
		@DepartmentID INT
	as 
	begin
		delete from Department
		where DepartmentID = @DepartmentID
	end




	--TABLE : 2
	create or alter procedure PR_Designation_insert
		@DesignationID INT,
		@DesignationName VARCHAR(100)
	as 
	begin
		insert into Designation values(@DesignationID, @DesignationName);
	end

	exec PR_Designation_insert 11, Jobber
	exec PR_Designation_insert 12, Welder
	exec PR_Designation_insert 13, Clerk
	exec PR_Designation_insert 14, Manager
	exec PR_Designation_insert 15, CEO

	select * from Designation

	--update :

	create or alter procedure PR_Designation_update
		@DesignationID INT,
		@DesignationName VARCHAR(100)
	as 
	begin
		update Designation
		set DesignationName = @DesignationName
		where DesignationID = @DesignationID
	end

	--DELETE : 
	 create or alter procedure PR_Designation_delete
		@DesignationID INT
	as 
	begin
		delete from Designation
		where DesignationID = @DesignationID
	end



	--TABLE : 3
	create or alter procedure PR_Person_insert
		@FirstName VARCHAR(100),
		@LastName VARCHAR(100),
		@Salary decimal(8, 2),
		@JoiningDate DateTime,
		@DepartmentID int,
		@DesignationID int
	as 
	begin
		insert into Person values(@FirstName, @LastName, @Salary, @JoiningDate, @DepartmentID, @DesignationID);
	end

	exec PR_Person_insert 'Rahul', 'Anshu', 56000, '1990-1-1', 1, 12
	exec PR_Person_insert 'Hardik ', 'Hinsu', 18000, '1990-09-25', 2, 11
	exec PR_Person_insert 'Bhavin', 'Kamani', 25000, '1991-05-14', null, 11
	exec PR_Person_insert 'Bhoomi', 'Patel', 39000, '2014-02-20', 1, 13	
	exec PR_Person_insert 'Rohit', 'Rajgor', 17000, '1990-07-23', 2, 15
	exec PR_Person_insert 'Priya', 'Mehta', 25000, '1990-10-18', 2, null
	exec PR_Person_insert 'Neha', 'Trivedi', 18000, '2014-02-20', 3, 15

	select * from Person

	--update

	create or alter procedure PR_Person_Update
		@FirstName VARCHAR(100),
		@LastName VARCHAR(100),
		@Salary decimal(8, 2),
		@JoiningDate DateTime,
		@DepartmentID int,
		@DesignationID int
	as 
	begin
		update Person
		set FirstName = @FirstName,
			LastName = @LastName,
			Salary = @Salary,
			JoiningDate = @JoiningDate,
			DepartmentID = @DepartmentID,
			DesignationID = @DesignationID
		end

		--delete :
		
	create or alter procedure PR_Person_Delete
		@PersonID int
	as 
	begin
		delete from Person
		where PersonID = @PersonID
	end



--2. Department, Designation & Person Table’s SELECTBYPRIMARYKEY 
	--table 1 :
	create or alter procedure PR_Department_SELECTBYPRIMARYKEY
		@DepartmentID int
	as
	begin
		select * from Department
		where DepartmentID = @DepartmentID
	end

	--table 2 :
	create or alter procedure PR_Designation_SELECTBYPRIMARYKEY
		@DesignationID int
	as
	begin
		select * from Designation
		where DesignationID = @DesignationID
	end

	--table 3 : 
	create or alter procedure PR_Person_SELECTBYPRIMARYKEY
		@PersonID int
	as
	begin
		select * from Person
		where PersonID = @PersonID
	end

--3. Department, Designation & Person Table’s (If foreign key is available then do write join and take 
--columns on select list) 
	create or alter procedure PR_ALLJOIN
	as
	begin
		select * from person
		join Department
		on Person.DepartmentID = Department.DepartmentID
		join Designation
		on Person.DesignationID = Designation.DesignationID
	end

	exec PR_ALLJOIN
--4. Create a Procedure that shows details of the first 3 persons.
	create or alter procedure PR_TOP3
	as
	begin
		select TOP 3 * from person
		join Department
		on Person.DepartmentID = Department.DepartmentID
		join Designation
		on Person.DesignationID = Designation.DesignationID
	end

	exec PR_TOP3
--Part – B 
--5. Create a Procedure that takes the department name as input and returns a table with all workers 
--working in that department. 
--6. Create Procedure that takes department name & designation name as input and returns a table with 
--worker’s first name, salary, joining date & department name. 
--7. Create a Procedure that takes the first name as an input parameter and display all the details of the 
--worker with their department & designation name. 
--8. Create Procedure which displays department wise maximum, minimum & total salaries. 
--9. Create Procedure which displays designation wise average & total salaries. 
--Part – C 
--10. Create Procedure that Accepts Department Name and Returns Person Count. 
--11. Create a procedure that takes a salary value as input and returns all workers with a salary greater than 
--input salary value along with their department and designation details. 
--12. Create a procedure to find the department(s) with the highest total salary among all departments. 
--13. Create a procedure that takes a designation name as input and returns a list of all workers under that 
--designation who joined within the last 10 years, along with their department. 
--14. Create a procedure to list the number of workers in each department who do not have a designation 
--assigned. 
--15. Create a procedure to retrieve the details of workers in departments where the average salary is above 
--12000.
