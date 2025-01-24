----------------------------------------------------------------AFTER Trigger----------------------------------------------------	

CREATE TABLE EMPLOYEEDETAILS
(
	EmployeeID Int Primary Key,
	EmployeeName Varchar(100) Not Null,
	ContactNo Varchar(100) Not Null,
	Department Varchar(100) Not Null,
	Salary Decimal(10,2) Not Null,
	JoiningDate DateTime Null
)

CREATE TABLE EmployeeLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT NOT NULL,
    EmployeeName VARCHAR(100) NOT NULL,
    ActionPerformed VARCHAR(100) NOT NULL,
    ActionDate DATETIME NOT NULL
);


--1)	Create a trigger that fires AFTER INSERT, UPDATE, and DELETE operations on the EmployeeDetails table to 
--      display the message "Employee record inserted", "Employee record updated", "Employee record deleted"
	--AFTER INSERT
	create or alter trigger tr_After_Insert
	on EMPLOYEEDETAILS
	after insert
	as
	begin
		print('"Employee record inserted"')
	end

	--AFTER UPDATE
	create or alter trigger tr_After_Update
	on EMPLOYEEDETAILS
	after update
	as
	begin
		print('"Employee record Updated"')
	end

	--AFTER DELETE
	create or alter trigger tr_After_Delete
	on EMPLOYEEDETAILS
	after delete
	as
	begin
		print('"Employee record Deleted"')
	end

--2)	Create a trigger that fires AFTER INSERT, UPDATE, and DELETE operations on the EmployeeDetails table  
--		to log all operations into the EmployeeLog table.
	--AFTER INSERTED
	create trigger tr_log_after_insert
	on EMPLOYEEDETAILS
	after insert
	as
	begin
		Declare @Id int, @Name varchar(200)
		select @Id = EmployeeID from inserted
		select @Name = EmployeeName from inserted

		insert into EmployeeLogs values(@Id, @Name, 'Inserted', GETDATE())
	end

	--AFTER Updated
	create trigger tr_log_after_update
	on EMPLOYEEDETAILS
	after update
	as
	begin
		Declare @Id int, @Name varchar(200)
		select @Id = EmployeeID from inserted
		select @Name = EmployeeName from inserted

		insert into EmployeeLogs values(@Id, @Name, 'Updated', GETDATE())
	end

	--AFTER DELETED
	create trigger tr_log_after_delete
	on EMPLOYEEDETAILS
	after delete
	as
	begin
		Declare @Id int, @Name varchar(200)
		select @Id = EmployeeID from deleted
		select @Name = EmployeeName from deleted

		insert into EmployeeLogs values(@Id, @Name, 'Deleted', GETDATE())
	end

--3)	Create a trigger that fires AFTER INSERT to automatically calculate the joining bonus (10% of the salary)
--		for new employees and update a bonus column in the EmployeeDetails table.
		create or alter trigger tr_JoiningBonus
		on EMPLOYEEDETAILS
		after insert
		as
		begin
			DECLARE @BonusSalary decimal(8, 2) = 0, @Salary decimal(8, 2), @EMPID int

			select 
					@Salary = Salary, @EMPID = EmployeeID
			from inserted

			set @BonusSalary += @Salary * 0.1

			update EMPLOYEEDETAILS
			set Salary = @BonusSalary
			where EmployeeID = @EMPID
									
		end
--4)	Create a trigger to ensure that the JoiningDate is automatically set to the current date if it is NULL during an INSERT operation.
	create trigger tr_Update_joiningDate
	on EMPLOYEEDETAILS
	after insert
	as
	begin
		declare @jDate DateTime, @EID int

		select @JDate =  JoiningDate, @EID = EmployeeID 
		from inserted
		
		if(@JDate is null)
		begin
			update EMPLOYEEDETAILS
			set JoiningDate = GETDATE()
			where EmployeeID = @EID
		end
	end

--5)	Create a trigger that ensure that ContactNo is valid during insert  (Like ContactNo length is 10)
		create trigger tr_ContactNo
		on EMPLOYEEDETAILS
		after insert
		as 
		begin
			declare @numberLength varchar(100), @EID int
			
			select @numberLength =  ContactNo, @EID = EmployeeID 
		from inserted

		if(LEN(@numberLength) != 10)
			begin
			print('Invalid Contact no.')
				delete 
				from EMPLOYEEDETAILS
				where EmployeeID = @EID
			end	
		end

-----	-------------------------------------Instead of Trigger--------------------------------------

CREATE TABLE Movies (
    MovieID INT PRIMARY KEY,
    MovieTitle VARCHAR(255) NOT NULL,
    ReleaseYear INT NOT NULL,
    Genre VARCHAR(100) NOT NULL,
    Rating DECIMAL(3, 1) NOT NULL,
    Duration INT NOT NULL
);

CREATE TABLE MoviesLog
(
	LogID INT PRIMARY KEY IDENTITY(1,1),
	MovieID INT NOT NULL,
	MovieTitle VARCHAR(255) NOT NULL,
	ActionPerformed VARCHAR(100) NOT NULL,
	ActionDate	DATETIME  NOT NULL
);


--1.	Create an INSTEAD OF trigger that fires on INSERT, UPDATE and DELETE operation on the Movies table. 
--		For that, log all operations performed on the Movies table into MoviesLog.

		--INSTEAD OF INSERT
		create trigger tr_insteadOFInsert
		on Movies
		instead of insert
		as
		begin
			Declare @MovieID int, @MovieTitle varchar(200)
			select @MovieID = MovieID from inserted
			select @MovieTitle = MovieTitle from inserted

			insert into MoviesLog values(@MovieID, @MovieTitle, 'Not - Inserted', GETDATE())
		end

		drop trigger tr_insteadOFInsert
		--INSTEAD OF UPDATE
		create trigger tr_insteadOFUpdate
		on Movies
		instead of update
		as
		begin
			Declare @MovieID int, @MovieTitle varchar(200)
			select @MovieID = MovieID from inserted
			select @MovieTitle = MovieTitle from inserted

			insert into MoviesLog values(@MovieID, @MovieTitle, 'Not - Updated', GETDATE())
		end

		--INSTEAD OF DELETE
		create trigger tr_insteadOFDelete
		on Movies
		instead of delete
		as
		begin
			Declare @MovieID int, @MovieTitle varchar(200)
			select @MovieID = MovieID from deleted
			select @MovieTitle = MovieTitle from deleted

			insert into MoviesLog values(@MovieID, @MovieTitle, 'Not - Inserted', GETDATE())
		end

--2.	Create a trigger that only allows to insert movies for which Rating is greater than 5.5 .
		create trigger tr_insteadOfRating
		on Movies
		instead of insert
		as
		begin
			Declare @MovieID int, @MovieTitle varchar(200), @ReleaseYear int, @Genre varchar(200), @Rating decimal(3, 2), @Duration int
			select @MovieID = MovieID from inserted
			select @MovieTitle = MovieTitle from inserted
			select @ReleaseYear = ReleaseYear from inserted
			select @Genre = Genre from inserted
			select @Rating = Rating from inserted
			select @Duration = Duration from inserted

			if(@Rating > 5.5)
			begin
				insert into Movies values(@MovieID, @MovieTitle, @ReleaseYear, @Genre, @Rating, @Duration)
			end

		end

--3.	Create trigger that prevent duplicate 'MovieTitle' of Movies table and log details of it in MoviesLog table.
		create or alter trigger tr_duplicate_allow
		on Movies 
		instead of  insert
		as
		begin
			
		end

--4.	Create trigger that prevents to insert pre-release movies.

--5.	Develop a trigger to ensure that the Duration of a movie cannot be updated to a value greater than 120 minutes 
--		(2 hours) to prevent unrealistic entries.
