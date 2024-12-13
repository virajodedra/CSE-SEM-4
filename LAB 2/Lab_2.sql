
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

	create or alter procedure PR_B5
		@DepartmentName varchar(100)
	as 
	begin
			select * 
			from Department
			join Person
			on Person.DepartmentID = Department.DepartmentID
			where DepartmentName = @DepartmentName
	end

	exec PR_B5 HR
		

--6. Create Procedure that takes department name & designation name as input and returns a table with 
--worker’s first name, salary, joining date & department name. 
	create or alter procedure PR_B6
		@DepartmentName varchar(100),
		@DesignationName varchar(100)
	as
	begin
			select	Person.FirstName, Person.Salary, Person.JoiningDate, Department.DepartmentName
			from Person
			join Department
			on Person.DepartmentID = Department.DepartmentID
			join Designation
			on Person.DesignationID = Designation.DesignationID
			where DepartmentName = @DepartmentName and DesignationName = @DesignationName
	end

	exec PR_B6 'IT', 'Jobber'
				
--7. Create a Procedure that takes the first name as an input parameter and display all the details of the 
--worker with their department & designation name.
	create or alter procedure PR_B7
		@FirstName varchar(100)
	as
	begin
			select	*
			from Person
			join Department
			on Person.DepartmentID = Department.DepartmentID
			join Designation
			on Person.DesignationID = Designation.DesignationID
			where Person.FirstName = @FirstName
	end
			
exec PR_B7 'Hardik'
--8. Create Procedure which displays department wise maximum, minimum & total salaries.
	create or alter procedure PR_B8
	as
	begin
			select	Department.DepartmentName, max(Person.Salary) as MaxSalary, 
			min(Person.Salary) as MinSalary,
			sum(Person.Salary) as TotalSalary
			from Person
			join Department
			on Person.DepartmentID = Department.DepartmentID
			group by Department.DepartmentName
			
	end
	exec PR_B8
--9. Create Procedure which displays designation wise average & total salaries.
	create or alter procedure PR_B9
	as
	begin
			select	Designation.DesignationName, avg(Person.Salary) as AVGSalary, 
			sum(Person.Salary) as TotalSalary
			from Person
			join Designation
			on Person.DesignationID = Designation.DesignationID
			group by Designation.DesignationName	
	end

	exec PR_B9
	
--Part – C 
--10. Create Procedure that Accepts Department Name and Returns Person Count. 
	create or alter Procedure PR_B10
		@DepartmentName varchar(100)
	as
	begin
		select count(Person.PersonID) as TotalCount
		from Person
		join Department
		on Person.DepartmentID = Department.DepartmentID
		where Department.DepartmentName = @DepartmentName
	end
	exec PR_B10 'IT'

--11. Create a procedure that takes a salary value as input and returns all workers with a salary greater than 
--input salary value along with their department and designation details. 
	create or alter procedure PR_C11
		@Salary int
	as
	begin
		select *
		from person
		join Designation on Person.DepartmentID = Designation.DesignationID
		join Department on Department.DepartmentID = Person.DepartmentID
		where Person.Salary > @Salary
	end


--12. Create a procedure to find the department(s) with the highest total salary among all departments. 
	create or alter procedure PR_C12
	as
	begin
		select Top 1 Department.DepartmentName, sum(Person.Salary)
		from Person
		join Department
		on Person.DepartmentID = Department.DepartmentID
		group by Department.DepartmentName
		order by Person.Salary desc
	end
--13. Create a procedure that takes a designation name as input and returns a list of all workers under that 
--designation who joined within the last 10 years, along with their department. 
	create or alter procedure PR_C13
		@DesName varchar(100)
	as
	begin
		select * 
		from Person 
		join Designation on Person.DepartmentID = Designation.DesignationID
		join Department on Department.DepartmentID = Person.DepartmentID
		where DATEDIFF(MONTH, Person.JoiningDate, GETDATE()) <= 120 
		and Designation.DesignationName = @DesName
	end	

--14. Create a procedure to list the number of workers in each department who do not have a designation 
--assigned.
	create or alter procedure PR_C14
	as
	begin
		select Department.DepartmentName,
		count(Person.PersonID) as PersonCount
		from Person
		join Department
		on Person.DepartmentID = Department.DepartmentID
		left join Designation
		on Person.DesignationID = Designation.DesignationID
		where Person.DepartmentID is null
		group by Department.DepartmentName
	end

	exec PR_C14
			
--15. Create a procedure to retrieve the details of workers in departments where the average salary is above 
--12000.
	create or alter procedure PR_ABOVE_AVG_SAL
	as
	begin
		select p.*, d.DepartmentName
		from Person p
		join Department d
		on p.DepartmentID = d.DepartmentID
		where d.DepartmentID in (
			
			select d.DepartmentID
			from  Person P
            join Department d 
			ON P.DepartmentID = d.DepartmentID
			group by d.DepartmentID
			having avg(p.salary) > 12000
		)
	end

	exec PR_ABOVE_AVG_SAL

------------------viraj---------------------------------------------------
