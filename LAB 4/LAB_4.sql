--Note: for Table valued function use tables of Lab-2
---------------------------------------------Part – A---------------------------------------------
--1. Write a function to print "hello world".
create or alter function FN_HelloWorld()
	returns varchar(50)
as
begin

	return 'Hello World'
end;

select dbo.FN_HelloWorld() as 'Hello!'
--2. Write a function which returns addition of two numbers.
	create or alter function FN_Addition(
		@num1 int,
		@num2 int
		)
		returns int
	as
	begin
		declare @sum int
		set @sum = @num1 + @num2

		return @sum
	end

	select dbo.FN_Addition(4, 4) as 'sum' 
	
--3. Write a function to check whether the given number is ODD or EVEN.
	CREATE OR ALTER FUNCTION FN_ODDorEven(
    @num1 INT
	)
	RETURNS VARCHAR(100)
	AS
	BEGIN
		DECLARE @res VARCHAR(100);

		IF (@num1 % 2 = 0)
			SET @res = 'EVEN';
		ELSE
			SET @res = 'ODD';

		RETURN @res;
	END;

-- Test the function
SELECT dbo.FN_ODDorEven(4) AS 'result';

--4. Write a function which returns a table with details of a person whose first name starts with B.

	create or alter function FN_GetPersonsStartingWithB()

	returns table
	as
		return(
			select *
			from Person
			where FirstName like 'B%'
		)
	
	
--5. Write a function which returns a table with unique first names from the person table.
	create or alter function FN_UniqueNames()
		returns table
	as
		return(
			select distinct FirstName
			from Person
		)
--6. Write a function to print number from 1 to N. (Using while loop)
CREATE OR ALTER FUNCTION FN_Print1ToN(@num INT)
RETURNS @Numbers TABLE (Number INT)
AS
BEGIN
    DECLARE @i INT = 1;
    WHILE @i <= @num
    BEGIN
        INSERT INTO @Numbers (Number) VALUES (@i)
        SET @i = @i + 1; 
    END
    RETURN;
END;

SELECT * FROM dbo.FN_Print1ToN(12);
--7. Write a function to find the factorial of a given integer.
	create or alter function FN_Factorial(
		@No int
	)
		returns int
	as
	begin
		declare @sum int = 1,
				@temp int = 1

		while @temp <= @No
		begin
			set @sum = @sum * @temp
			set @temp += 1
		end
		return @sum
	end
	select dbo.FN_Factorial(4) as factorialas 
--Part – B
--8. Write a function to compare two integers and return the comparison result. (Using Case statement)
	create or alter function Fn_comapreTwoNumbers(
		@num1 int, @num2 int
	)
		returns varchar(400)
	as
	begin
		declare @result varchar(400) = ''

		set @result  =  case
							when @num1 > @num2 then CAST(@num1 AS VARCHAR) + ' is greater than ' + CAST(@num2 AS VARCHAR)
							when @num1 < @num2 then CAST(@num2 AS VARCHAR) + ' is greater than ' + CAST(@num1 AS VARCHAR)
							ELSE CAST(@num1 AS VARCHAR) + ' and ' + CAST(@num2 AS VARCHAR) + ' both are the same!'
						end
		return @result
		end

		select dbo.Fn_comapreTwoNumbers(2,4) as comaprisonResult
		

--9. Write a function to print the sum of even numbers between 1 to 20.
	create or alter function FN_Even()
	returns int
	as
	begin
		declare @Sum int = 0,
		@No int = 2

		while @No < 20
		begin
			if(@No % 2 = 0) 
				set @Sum += @No
		set @No += 1
		end
	return @No
	end

	select dbo.FN_Even() as EvenSum


--10. Write a function that checks if a given string is a palindrome
	CREATE OR ALTER FUNCTION FN_PALINDROM(
    @str VARCHAR(100)
	)
	RETURNS VARCHAR(100)
	AS
	BEGIN
		DECLARE @demo VARCHAR(100) = @str,
				@temp VARCHAR(100),
				@result VARCHAR(100);

		SET @temp = REVERSE(@str)

		IF (@temp = @demo)
			SET @result = 'The Given String is Palindrom';
		ELSE
			SET @result = 'The Given String is not Palindrom'
		RETURN @result;
	END;

SELECT dbo.FN_PALINDROM('viraj odedra') AS result;

--Part – C
--11. Write a function to check whether a given number is prime or not.
--12. Write a function which accepts two parameters start date & end date, and returns a difference in days.
--13. Write a function which accepts two parameters year & month in integer and returns total days each
--year.
--14. Write a function which accepts departmentID as a parameter & returns a detail of the persons.
--15. Write a function that returns a table with details of all persons who joined after 1-1-1991.
