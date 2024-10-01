#############################################################################################
# Created By: Milind Keer
# Created on: 01/10/2024
# Description: This script reads receipts text data from finance/receipts_from_last_night/
# folder and generates a valid SQL file containing INSERT statements for all receipts
# to be inserted into the SExI database's EXPENSE table.
#############################################################################################

import os
from datetime import datetime

# Get the current date and time
now = datetime.now()
current_date_time = now.strftime("%Y-%m-%d %H:%M:%S")
filename = os.path.basename(__file__)

# Directory where the .txt files are stored
directory = 'finance/receipts_from_last_night'

# Output SQL file
output_sql_file = 'create_expenses.sql'

# Open the output SQL file for writing
with open(output_sql_file, 'w') as sql_file:
    # Write the table creation statement
    sql_file.write(f""" -- This SQL file was generated from {filename} on {current_date_time} \n \n """)
   
    sql_file.write('-- SQL to create the EXPENSE table\n')
    sql_file.write('CREATE TABLE IF NOT EXISTS EXPENSE (\n')
    sql_file.write('    employee_id TINYINT,\n')
    sql_file.write('    unit_price DECIMAL(8, 2),\n')
    sql_file.write('    quantity TINYINT\n')
    sql_file.write(');\n\n')

    # Iterate through each .txt file in the directory
    for filename in os.listdir(directory):
        if filename.endswith('.txt'):
            file_path = os.path.join(directory, filename)
            
            # Read the content of the .txt file
            with open(file_path, 'r') as txt_file:
                data = {}
                
                # Extract relevant information from the text file
                for line in txt_file:
                    key, value = line.split(':', 1)
                    data[key.strip()] = value.strip()

                # Split employee's full name into first_name and last_name
                employee_name = data.get('Employee', '')
                first_name, last_name = employee_name.split(' ', 1)
                # print(first_name)
                # print(last_name)     

                # Extract unit price and quantity
                unit_price = float(data.get('Unit Price', 0))
                quantity = int(data.get('Quantity', 0))

                # Write the insert statement
                sql_file.write(f'-- Insert data from {filename}\n')
                sql_file.write('INSERT INTO EXPENSE (employee_id, unit_price, quantity)\n')
                sql_file.write(f"SELECT emp.employee_id, {unit_price:.2f}, {quantity}\n")
                sql_file.write("FROM EMPLOYEE emp\n")
                sql_file.write(f"WHERE emp.first_name = '{first_name}' AND emp.last_name = '{last_name}';;\n\n")

print(f"SQL insert statements written to {output_sql_file}")

