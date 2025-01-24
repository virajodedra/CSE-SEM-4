--LAB - 5 CURSOR .....
-- Creating PersonInfo Table
CREATE TABLE PersonInfo (
 PersonID INT PRIMARY KEY,
 PersonName VARCHAR(100) NOT NULL,
 Salary DECIMAL(8,2) NOT NULL,
 JoiningDate DATETIME NULL,
 City VARCHAR(100) NOT NULL,
 Age INT NULL,
 BirthDate DATETIME NOT NULL
);
-- Creating PersonLog Table
CREATE TABLE PersonLog (
 PLogID INT PRIMARY KEY IDENTITY(1,1),
 PersonID INT NOT NULL,
 PersonName VARCHAR(250) NOT NULL,
 Operation VARCHAR(50) NOT NULL,
 UpdateDate DATETIME NOT NULL,
 --FOREIGN KEY (PersonID) REFERENCES PersonInfo(PersonID) ON DELETE CASCADE
);

drop table PersonLog
drop table PersonInfo
--Part – A
--1. Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table to display
--a message “Record is Affected.”
	create trigger tr_Insert_Update_Delete
	on PersonInfo
	after insert, update, delete
	as
	begin
		print 'The record is affected'
	end
--2. Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table. For that,
--log all operations performed on the person table into PersonLog.
		--for insert
	create trigger tr_Insert_log
	on PersonInfo
	after insert
	as
	begin
		declare @PID int, @PName varchar(200), @Operation varchar(200), @Time datetime

		select @PID = PersonID from inserted
		select @PName = PersonName from inserted
		
		insert into PersonLog values(@PID, @PName, 'Insert', GETDATE())
	end

		--for update

	create trigger tr_Update_log
	on PersonInfo
	after update
	as
	begin
		declare @PID int, @PName varchar(200), @Operation varchar(200), @Time datetime

		select @PID = PersonID from inserted
		select @PName = PersonName from inserted
		
		insert into PersonLog values(@PID, @PName, 'Update', GETDATE())
	end

	--for delete
	create trigger tr_Delete_log
	on PersonInfo
	after delete
	as
	begin
		declare @PID int, @PName varchar(200), @Operation varchar(200), @Time datetime

		select @PID = PersonID from deleted
		select @PName = PersonName from deleted
		
		insert into PersonLog values(@PID, @PName, 'Delete', GETDATE())
	end

--3. Create an INSTEAD OF trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo
--table. For that, log all operations performed on the person table into PersonLog.
	create trigger tr_Insert_log_instead
	on PersonInfo
	instead of insert
	as
	begin
		declare @PID int, @PName varchar(200), @Operation varchar(200), @Time datetime

		select @PID = PersonID from inserted
		select @PName = PersonName from inserted
		
		insert into PersonLog values(@PID, @PName, 'Insert', GETDATE())
	end

		--for update

	create trigger tr_Update_log_instead
	on PersonInfo
	instead of update
	as
	begin
		declare @PID int, @PName varchar(200), @Operation varchar(200), @Time datetime

		select @PID = PersonID from inserted
		select @PName = PersonName from inserted
		
		insert into PersonLog values(@PID, @PName, 'Update', GETDATE())
	end

	--for delete
	create trigger tr_Delete_log_instead
	on PersonInfo
	instead of delete
	as
	begin
		declare @PID int, @PName varchar(200), @Operation varchar(200), @Time datetime

		select @PID = PersonID from deleted
		select @PName = PersonName from deleted
		
		insert into PersonLog values(@PID, @PName, 'Delete', GETDATE())
	end
	
--4. Create a trigger that fires on INSERT operation on the PersonInfo table to convert person name into
--uppercase whenever the record is inserted.
	create trigger tr_Insert_log_upper
	on PersonInfo
	after insert
	as
	begin
		declare @PID int, @PName varchar(200), @Operation varchar(200), @Time datetime

		select @PID = PersonID from inserted
		select @PName = PersonName from inserted
		
		update PersonInfo 
		set PersonName = upper(@PName)
		where PersonID = @PID
	end
	drop trigger tr_Insert_log_upper
	insert into PersonInfo values(2, 'Pruthvi', 120000, '1999-12-2', 'WAKANER', 99, '2005-12-24')
	select * from PersonInfo
--5. Create trigger that prevent duplicate entries of person name on PersonInfo table.
	create trigger tr_stop_duplicate
	on  PersonInfo
	instead of insert
	as
	begin
		insert into PersonInfo (PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate)
		select 
			PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate
			from inserted
			where PersonName not in	(
				select PersonName from PersonInfo
			)
	end

	drop trigger tr_stop_duplicate
	
--6. Create trigger that prevent Age below 18 years.
	create trigger tr_Insert_age_below18
	on PersonInfo
	instead of insert
	as
	begin

		insert into PersonInfo (PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate)
		select 
			PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate
			from inserted
			where  Age >= 18	
	end
	insert into PersonInfo values(5, 'Pruthvi', 120000, '1999-12-2', 'WAKANER', 99, '2005-12-24')
	select * from PersonInfo

	drop trigger tr_Insert_age_below18
--Part – B
--7. Create a trigger that fires on INSERT operation on person table, which calculates the age and update
--that age in Person table.
	create trigger tr_Insert_age_update
	on PersonInfo
	instead of insert
	as
	begin

		declare @PID int, @Age int, @Bdate datetime

		select @PID = PersonID from inserted
		select @Bdate = BirthDate from inserted
		
		set @Age = abs(DATEDIFF(YEAR, @Bdate, GETDATE()))

		update PersonInfo 
		set BirthDate = @Bdate
		where PersonID = @PID	
	end
	insert into PersonInfo values(5, 'Pruthvi', 120000, '1999-12-2', 'WAKANER', 99, '2005-12-24')
	select * from PersonInfo
--8. Create a Trigger to Limit Salary Decrease by a 10%.
	create trigger tr_Insert_age_update
	on PersonInfo
	AFTER update
	as
	begin
		declare @OldSalary decimal(8, 2), @NewSalary decimal(8, 2), @Pid int

		select  @OldSalary = Salary from deleted;
		select @Pid = PersonID from inserted;
		select @NewSalary = Salary

		if(@NewSalary < @OldSalary * 0.1)
			begin 
				update PersonInfo
				set Salary = @OldSalary
				where PersonID = @Pid
			end
	end
--Part – C
--9. Create Trigger to Automatically Update JoiningDate to Current Date on INSERT if JoiningDate is NULL
--during an INSERT.
	create trigger tr_Update_joiningDate
	on PersonInfo
	after insert
	as
	begin
		declare @jDate datetime, @PID int

		set @JDate = select JoiningDate from inserted
		set @PID   = select PersonId from inserted
		
		if(@JDate is null)
			update PersonInfo
			set JoinningDate = GETDATE()
			where PersonID = @PID
	end
--10. Create DELETE trigger on PersonLog table, when we delete any record of PersonLog table it prints
--‘Record deleted successfully from PersonLog'
create trigger tr_Delete_log
	on PersonLog
	after delete
	as
	begin
		print('Record deleted successfully from PersonLog')
	end



