-- Create a table with our filepaths
CREATE TABLE Receipts_filepath (
	file_path VARCHAR(250),
)

INSERT INTO Receipts_filepath (file_path) VALUES ('C:\Users\fredd\wasb_sql_test\finance\receipts_from_last_night\drinkies.txt');
INSERT INTO Receipts_filepath (file_path) VALUES ('C:\Users\fredd\wasb_sql_test\finance\receipts_from_last_night\drinks.txt');
INSERT INTO Receipts_filepath (file_path) VALUES ('C:\Users\fredd\wasb_sql_test\finance\receipts_from_last_night\drinkss.txt');
INSERT INTO Receipts_filepath (file_path) VALUES ('C:\Users\fredd\wasb_sql_test\finance\receipts_from_last_night\duh_i_think_i_got_too_many.txt');
INSERT INTO Receipts_filepath (file_path) VALUES ('C:\Users\fredd\wasb_sql_test\finance\receipts_from_last_night\i_got_lost_on_the_way_home_and_now_im_in_mexico.txt');
INSERT INTO Receipts_filepath (file_path) VALUES ('C:\Users\fredd\wasb_sql_test\finance\receipts_from_last_night\ubers.txt');
INSERT INTO Receipts_filepath (file_path) VALUES ('C:\Users\fredd\wasb_sql_test\finance\receipts_from_last_night\we_stopped_for_a_kebabs.txt');

-- As the files are in a COLUMN: DATA format, add these lines to a table for initial processing
CREATE TABLE Staging_EXPENSE (
    data NVARCHAR(MAX) 
);


-- Create staging table holding all the information we're importing. Assumption later that some of these columns are not required.
CREATE TABLE Staging2_EXPENSE (
	employee VARCHAR(100), 
	items VARCHAR(100),
	unit_price DECIMAL(8, 2), 
	quantity TINYINT
);

-- Iterate through our receipt files, inserting these into our first staging table, then split each line item on the colon ":", and insert the data after the ":" into our second staging table. CASTING as decimals where required as per instructions.
declare @mysqltext nvarchar(250)
declare @mypath nvarchar(250)
declare mycursor cursor forward_only
	for select file_path from Receipts_filepath
open mycursor
	fetch next from mycursor into @mypath
while @@FETCH_STATUS = 0
	begin
		set @mysqltext = 
		'
		
		BULK INSERT Staging_EXPENSE
			FROM ''' + @mypath + '''
			WITH
			(
				FIELDTERMINATOR = '':'',
				ROWTERMINATOR = ''\n'',
				TABLOCK
			);'
			
		execute sp_executesql @mysqltext
		
		-- Insert data into the Staging2 table
		INSERT INTO Staging2_EXPENSE (employee, items, unit_price, quantity)
		SELECT
			MAX(CASE WHEN [data] LIKE 'Employee: %' THEN SUBSTRING([data], CHARINDEX(': ', [data]) + 2, LEN([data])) END),
			MAX(CASE WHEN [data] LIKE 'Items: %' THEN SUBSTRING([data], CHARINDEX(': ', [data]) + 2, LEN([data])) END),
			MAX(CASE WHEN [data] LIKE 'Unit Price: %' THEN CAST(SUBSTRING([data], CHARINDEX(': ', [data]) + 2, LEN([data])) AS DECIMAL(10, 2)) END),
			MAX(CASE WHEN [data] LIKE 'Quantity: %' THEN CAST(SUBSTRING([data], CHARINDEX(': ', [data]) + 2, LEN([data])) AS INT) END)
		FROM Staging_EXPENSE
		GROUP BY CHARINDEX(' ', [data]) / 20;  -- Assuming each employee's data is in 20 lines

		TRUNCATE TABLE Staging_EXPENSE -- truncate to get ready for the next file


		fetch next from mycursor into @mypath

	end

close mycursor
deallocate mycursor


-- Create our actual EXPENSE table with only required information
CREATE TABLE EXPENSE (
	employee_id TINYINT,
	unit_price DECIMAL(8, 2),
	quantity TINYINT
);

-- Using a cte to concatenate first and last name to provide a key pair, join our expense and employee table and select only the required columns to insert into our EXPENSE table
WITH cte AS (
	SELECT CONCAT(first_name, ' ', last_name) AS full_name,
		employee_id
	FROM EMPLOYEE
)

INSERT INTO EXPENSE
SELECT employee_id, 
	unit_price, 
	quantity
FROM Staging2_EXPENSE S
LEFT JOIN cte E
ON S.employee = E.full_name


-- visualisation to check our script has done what it should have
SELECT * FROM EXPENSE
