-- Create a table with our filepaths

CREATE TABLE INVOICES_filepath (
	file_path VARCHAR(250),
)

INSERT INTO INVOICES_filepath (file_path) VALUES ('C:\Users\fredd\wasb_sql_test\finance\invoices_due\awesome_animals.txt');
INSERT INTO INVOICES_filepath (file_path) VALUES ('C:\Users\fredd\wasb_sql_test\finance\invoices_due\brilliant_bottles.txt');
INSERT INTO INVOICES_filepath (file_path) VALUES ('C:\Users\fredd\wasb_sql_test\finance\invoices_due\crazy_catering.txt');
INSERT INTO INVOICES_filepath (file_path) VALUES ('C:\Users\fredd\wasb_sql_test\finance\invoices_due\disco_dj.txt');
INSERT INTO INVOICES_filepath (file_path) VALUES ('C:\Users\fredd\wasb_sql_test\finance\invoices_due\excellent_entertainment.txt');
INSERT INTO INVOICES_filepath (file_path) VALUES ('C:\Users\fredd\wasb_sql_test\finance\invoices_due\fantastic_ice_sculptures.txt');

-- As the files are in a COLUMN: DATA format, add these lines to a table for initial processing
CREATE TABLE Staging_INVOICES (
    data NVARCHAR(MAX) 
);

-- Create staging table holding all the information we're importing. Assumption later that some of these columns are not required.
CREATE TABLE Staging2_INVOICES (
	company_name VARCHAR(100), 
	invoice_items VARCHAR(200),
	invoice_amount DECIMAL(8, 2), 
	due_date VARCHAR(200)
);

-- Iterate through our receipt files, inserting these into our first staging table, then split each line item on the colon ":", and insert the data after the ":" into our second staging table. CASTING as decimals where required as per instructions.
declare @mysqltext nvarchar(250)
declare @mypath nvarchar(250)
declare mycursor cursor forward_only
	for select file_path from INVOICES_filepath
open mycursor
	fetch next from mycursor into @mypath
while @@FETCH_STATUS = 0
	begin
		set @mysqltext = 
		'
		
		BULK INSERT Staging_INVOICES
			FROM ''' + @mypath + '''
			WITH
			(
				FIRSTROW = 3,
				FIELDTERMINATOR = '':'',
				ROWTERMINATOR = ''\n'',
				TABLOCK
			);'
			
		execute sp_executesql @mysqltext
		
		-- Insert data into the Staging2_INVOICES table
		INSERT INTO Staging2_INVOICES (company_name, invoice_items, invoice_amount, due_date)
		SELECT
			MAX(CASE WHEN [data] LIKE 'Company Name: %' THEN SUBSTRING([data], CHARINDEX(': ', [data]) + 2, LEN([data])) END),
			MAX(CASE WHEN [data] LIKE 'Invoice Items: %' THEN SUBSTRING([data], CHARINDEX(': ', [data]) + 2, LEN([data])) END),
			MAX(CASE WHEN [data] LIKE 'Invoice Amount: %' THEN CAST(SUBSTRING([data], CHARINDEX(': ', [data]) + 2, LEN([data])) AS DECIMAL(10, 2)) END),
			MAX(CASE WHEN [data] LIKE 'Due Date: %' THEN SUBSTRING([data], CHARINDEX(': ', [data]) + 2, LEN([data])) END)
		FROM Staging_INVOICES
		GROUP BY CHARINDEX(' ', [data]) / 20;  -- Assuming each employee's data is in 20 lines

		TRUNCATE TABLE Staging_INVOICES -- truncate to get ready for the next file

		fetch next from mycursor into @mypath

	end

close mycursor
deallocate mycursor


-- Create our actual INVOICES and SUPPLIER tables with only required information
CREATE TABLE INVOICES (
	supplier_id TINYINT,
	invoice_amount DECIMAL(8, 2),
	due_date DATE
)


CREATE TABLE SUPPLIER (
	supplier_id TINYINT,
	[name] VARCHAR(100)
)

-- Creating our supplier with an id ranked alphabetically, using distinct so we only get 1 id per company and we can easily use for joins later
INSERT INTO SUPPLIER
SELECT distinct dense_rank() OVER(ORDER BY company_name ASC) AS supplier_id,
	company_name AS [name]
FROM Staging2_INVOICES;

-- Using a couple of CTEs to pivot the data, extracting the number of months from the "due_date" column into a usable format.
WITH get_months AS (
	SELECT company_name, 
		invoice_items, 
		invoice_amount, 
		CAST(LEFT(due_date, 1) AS TINYINT) AS num_months
	FROM Staging2_INVOICES
),
get_date AS (
	SELECT company_name, 
		invoice_items, 
		invoice_amount, 
		EOMONTH(DATEADD(month, num_months, '12/01/2023')) AS due_date
	FROM get_months
)


-- Insert into our final table
INSERT INTO INVOICES
SELECT supplier_id, 
	invoice_amount, 
	due_date
FROM get_date I
LEFT JOIN SUPPLIER S
ON S.name = I.company_name

SELECT * FROM INVOICES
SELECT * FROM SUPPLIER
