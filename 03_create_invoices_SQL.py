#############################################################################################
# Created By: Milind Keer
# Created on: 01/10/2024
# Description: This script reads invoices text data from finance/invoices_due/
# folder and generates a valid SQL file containing INSERT statements for all invoices
# to be inserted into the SExI database's INVOICE and SUPPLIER tables
#############################################################################################

import os
import re
from datetime import datetime, timedelta
import calendar

# Get the current date and time
now = datetime.now()
current_date_time = now.strftime("%Y-%m-%d %H:%M:%S")
filename1 = os.path.basename(__file__)

# Directory containing invoice text files
directory = 'finance/invoices_due'
output_sql_file = 'create_invoices.sql'


# Set to hold unique company names
company_names = set()

# Function to get the last day of the month for a given date
def get_last_day_of_month(year, month):
    last_day = calendar.monthrange(year, month)[1]
    return datetime(year, month, last_day)

# Function to calculate the due date from natural language input
def calculate_due_date(due_date_description):
    # Extract the number of months
    months_match = re.search(r'(\d+)\s*months?', due_date_description)
    # print(months_match)
    if months_match:
        months = int(months_match.group(1))
        # Calculate the due date by adding the months to the current date
        due_date = datetime.now() + timedelta(days=months*30)  # Approximate by using 30 days per month
        last_day_of_due_date = get_last_day_of_month(due_date.year, due_date.month)
        return last_day_of_due_date.strftime('%Y-%m-%d')  # Format as 'YYYY-MM-DD'
    else:
        raise ValueError(f"Unrecognized due date format: {due_date_description}")

# Function to generate SQL INSERT statements
def generate_invoice_sql():
    with open(output_sql_file, 'w') as sql_file:
        sql_file.write(f""" -- This SQL file was generated from {filename1} on {current_date_time} \n \n """)
        # Create the INVOICE, STAGING_SUPPLIER and SUPPLIER tables
        sql_file.write("""
CREATE TABLE IF NOT EXISTS INVOICE (
    supplier_id TINYINT,
    invoice_amount DECIMAL(8, 2),
    due_date DATE
);

CREATE TABLE IF NOT EXISTS STAGING_SUPPLIER (
    supplier_id TINYINT,
    name VARCHAR
);

CREATE TABLE IF NOT EXISTS SUPPLIER (
    supplier_id TINYINT,
    name VARCHAR
);

\n""")

        # Let's first gather company names
        for filename in os.listdir(directory):
            if filename.endswith('.txt'):
                file_path = os.path.join(directory, filename)
                with open(file_path, 'r') as f:
                    content = f.read()
                    company_name_match = re.search(r'Company Name:\s*(.*)', content)
                    if company_name_match:
                        company_name = company_name_match.group(1).strip()
                        company_names.add(company_name)

        # Sort company names alphabetically and create supplier IDs
        sorted_company_names = sorted(company_names)
        supplier_ids = {name: index + 1 for index, name in enumerate(sorted_company_names)}

        # Generate SQL inserts
        for filename in os.listdir(directory):
            if filename.endswith('.txt'):
                file_path = os.path.join(directory, filename)
                with open(file_path, 'r') as f:
                    content = f.read()
                    
                    # Extracting the required fields using regex
                    invoice_amount_match = re.search(r'Invoice Amount:\s*(\d+)', content)
                    due_date_match = re.search(r'Due Date:\s*(.*)', content)

                    # print(invoice_amount_match)
                    # print(due_date_match)

                    if invoice_amount_match and due_date_match:
                        invoice_amount = float(invoice_amount_match.group(1).strip())
                        
                        # print(invoice_amount)
                        due_date_description = due_date_match.group(1).strip()
                        # print(due_date_description)
                        # Calculate the due date from the description
                        try:
                            formatted_due_date = calculate_due_date(due_date_description)
                        except ValueError as e:
                            print(f"Error in {filename}: {e}")
                            continue

                        # Get the company name
                        company_name = re.search(r'Company Name:\s*(.*)', content).group(1).strip()
                        supplier_id = supplier_ids[company_name]

                        # Escape single quotes in the company name
                        escaped_company_name = company_name.replace("'", "''")    

                        # Write the SQL insert statements
                        sql_file.write(f"""
/* Insert data from: {filename} */
INSERT INTO INVOICE (supplier_id, invoice_amount, due_date)
VALUES ({supplier_id}, {invoice_amount:.2f}, DATE '{formatted_due_date}');
\n""")
                        sql_file.write(f"""
/* Insert supplier: {escaped_company_name} */
INSERT INTO STAGING_SUPPLIER (supplier_id, name)
VALUES ({supplier_id}, '{escaped_company_name}');
\n""")

        # Write SQL to de-duplicate and insert into the final SUPPLIER table
        sql_file.write(f"""
-- Insert distinct suppliers into the final SUPPLIER table
INSERT INTO SUPPLIER (supplier_id, name)
SELECT DISTINCT supplier_id, name
FROM staging_supplier;

-- Drop staging_supplier table to clean up
DROP TABLE IF EXISTS staging_supplier;
\n""")

    print(f"SQL insert statements written to {output_sql_file}")

# Run the function to generate SQL
generate_invoice_sql()


