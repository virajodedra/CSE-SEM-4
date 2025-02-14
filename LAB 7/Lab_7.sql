--------------------------------------------------------------LAB : 7 EXCEPTION HANDLING !!---------------------------------------------
--viraj odedra
--Customers-
--Column_Name DataType Constraints
--Customer_id Int Primary Key
--Customer _Name Varchar (250) Not Null
--Email Varchar (50) Unique
--Orders
--Column_Name DataType Constraints
--Order_id Int Primary Key
--Customer_id Int Foreign Key
--Order_date date Not Null

-- Create the Customers table
CREATE TABLE Customers (
 Customer_id INT PRIMARY KEY,
 Customer_Name VARCHAR(250) NOT NULL,
 Email VARCHAR(50) UNIQUE
);
-- Create the Orders table
CREATE TABLE Orders (
 Order_id INT PRIMARY KEY,
 Customer_id INT,
 Order_date DATE NOT NULL,
 FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id)
);
--viraj odedra

--From the above given tables perform the following queries:
--Part – A
--1. Handle Divide by Zero Error and Print message like: Error occurs that is - Divide by zero error.
	Begin try
		Declare @num1 int = 4, @num2 int = 0, @Div int = 0

		set @Div = @num1 / @num2

	End try
	Begin catch
		print('Error !, can not divide by ZERO')
	End catch
--2. Try to convert string to integer and handle the error using try…catch block.
	Begin try
		Declare @StrValue varchar(10) = 'Viraj', @IntValue int 

		set @IntValue = CAST(@StrValue as int)

	End try
	Begin catch
		print('Error , can not convert string to integer')
	End catch
--3. Create a procedure that prints the sum of two numbers: take both numbers as integer & handle
--exception with all error functions if any one enters string value in numbers otherwise print result.
	
	create or alter procedure PR_SUM_STR
		@Str varchar(10), @Num varchar(10)
	as begin
		Begin try
			Declare @sum int 
			set @sum = CAST(@Str as int) + CAST(@Num as int)
			print(@sum)
		End try
		Begin catch
		print('Error , can not convert string to integer')
		print 'Error Number : ' + CAST(ERROR_NUMBER() as varchar(100)) 
		print 'Error Severity : ' + CAST(ERROR_SEVERITY() as varchar(100)) 
		print 'Error State : ' + CAST(ERROR_STATE() as varchar(100)) 
		print 'Error Message : ' + CAST(ERROR_MESSAGE() as varchar(100)) 
		End catch
	end
	PR_SUM_STR '12' , '10'
	PR_SUM_STR 'Viraj' , '04'
--4. Handle a Primary Key Violation while inserting data into customers table and print the error details
--such as the error message, error number, severity, and state.

	insert into Customers values(1, 'Dhairya', 'Dhairya123@gmail.com')
	insert into Customers values(2, 'Pruthviraj', 'Pruthviraj123@gmail.com')
	insert into Customers values(3, 'Viraj', 'Viraj123@gmail.com')


	begin try 
		insert into Customers values(3, 'Viraj', 'Viraj123@gmail.com')
	end try
	begin catch
		print('Error , can not add the record because of the primary key violation')
		print 'Error Number : ' + CAST(ERROR_NUMBER() as varchar(100)) 
		print 'Error Severity : ' + CAST(ERROR_SEVERITY() as varchar(100)) 
		print 'Error State : ' + CAST(ERROR_STATE() as varchar(100)) 
		print 'Error Message : ' + CAST(ERROR_MESSAGE() as varchar(100))
	end catch

--5. Throw custom exception using stored procedure which accepts Customer_id as input & that throws
--Error like no Customer_id is available in database.
	
	create or alter procedure PR_CUSTOM_EXCEPTION
		@CustomerID int
	as begin
			if not exists (select 1 from Customers where Customer_id = @CustomerID)
			begin
				Throw 400000, 'No Custome ID available in Database', 4;
			end
			else
			begin
				print('Customer ID EXISTS !')
			end
		end

	PR_CUSTOM_EXCEPTION 2
--Part – B
--6. Handle a Foreign Key Violation while inserting data into Orders table and print appropriate error
--message.

	begin try
		
		insert into Orders values(1, 5, '2025-02-14')

	end try
	begin catch
		print('Error , can not add the record because of the Foreign key violation')
		print 'Error Number : ' + CAST(ERROR_NUMBER() as varchar(100)) 
		print 'Error Severity : ' + CAST(ERROR_SEVERITY() as varchar(100)) 
		print 'Error State : ' + CAST(ERROR_STATE() as varchar(100)) 
		print 'Error Message : ' + CAST(ERROR_MESSAGE() as varchar(100))
	end catch

--7. Throw custom exception that throws error if the data is invalid.
	
	create or alter procedure PR_INVALID
		@Value int
	as
	begin
		if @Value < 0 
		Begin
			Throw 4000001, 'Invlid data : Value can not be negative', 4;
		End
		else
		Begin
			print('Your Data IS Valid !!')
		End
	end
	PR_INVALID -2
--8. Create a Procedure to Update Customer’s Email with Error Handling
	create or alter procedure PR_EMAIL_UPDATE_EXCEPTION
		@CuID int ,@Email varchar(200)
	as
	begin
		Begin Try
			update  Customers
			set Email = @Email
			where Customer_id = @CuID
		End Try
		Begin catch
			print 'Error Number : ' + CAST(ERROR_NUMBER() as varchar(100)) 
			print 'Error Severity : ' + CAST(ERROR_SEVERITY() as varchar(100)) 
			print 'Error State : ' + CAST(ERROR_STATE() as varchar(100)) 
			print 'Error Message : ' + CAST(ERROR_MESSAGE() as varchar(100))
		End catch
	end

	PR_EMAIL_UPDATE_EXCEPTION 3, 'virajodedra@gmail.com'
	PR_EMAIL_UPDATE_EXCEPTION 400, 'virajodedra@gmail.com'
	select * from Customers

--Part – C
--9. Create a procedure which prints the error message that “The Customer_id is already taken. Try another
--one”
	
	create or alter procedure PR_EMAIL_INSERT_EXCEPTION
		@CuID int 
	as
	begin
			if  exists (select 1 from Customers where Customer_id = @CuID)
			begin
				Throw 400000, 'The Customer_id is already taken. Try another one', 4;
			end
			else
			begin
				print('Customer ID EXISTS !')
			end
		end

		PR_EMAIL_INSERT_EXCEPTION 3
				PR_EMAIL_INSERT_EXCEPTION 3000
--10. Handle Duplicate Email Insertion in Customers Table.

	create or alter procedure PR_Insertation_EXCEPTION
		@CuID int , @Name varchar(100), @Email varchar(200)
	as
	begin
		Begin Try
			insert into Customers values(@CuID, @Name, @Email)
		End Try
		Begin catch
			print 'Error Number : ' + CAST(ERROR_NUMBER() as varchar(100)) 
			print 'Error Severity : ' + CAST(ERROR_SEVERITY() as varchar(100)) 
			print 'Error State : ' + CAST(ERROR_STATE() as varchar(100)) 
			print 'Error Message : ' + CAST(ERROR_MESSAGE() as varchar(100))
		End catch
	end


	PR_Insertation_EXCEPTION 1, 'Topper Pruthvi', 'toperPruthviTop01@gmail.com'



-------------------------------------------------------------------------------------------------viraj odedra----------------------------------------------------------------------------------------
