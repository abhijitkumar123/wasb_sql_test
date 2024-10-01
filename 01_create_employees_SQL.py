#############################################################################################
# Created By: Milind Keer
# Created on: 01/10/2024
# Description: This script reads employee data from the hr/employee_index.csv file 
# and generates a valid SQL file containing INSERT statements for all employee records 
# to be inserted into the SExI database's EMPLOYEE table.
#############################################################################################

from datetime import datetime
import pandas as pd
import os

# Get the current date and time
now = datetime.now()
current_date_time = now.strftime("%Y-%m-%d %H:%M:%S")
filename = os.path.basename(__file__)

# Read the CSV file into a DataFrame
csv_file_path = 'hr/employee_index.csv'
df = pd.read_csv(csv_file_path)
output_sql_file = 'create_employees.sql'

# Open the SQL file to write
with open(output_sql_file, 'w') as sql_file:
    # Write the CREATE TABLE statement
    sql_file.write(f""" -- This SQL file was generated from {filename} on {current_date_time} \n \n -- Create Employee Table: """)
    
    sql_file.write("""
CREATE TABLE IF NOT EXISTS EMPLOYEE (
    employee_id TINYINT,
    first_name VARCHAR,
    last_name VARCHAR,
    job_title VARCHAR,
    manager_id TINYINT
);
\n
""")
    
    # Generate INSERT INTO statements for each row in the DataFrame
    for index, row in df.iterrows():
        employee_id = row['employee_id']
        first_name = row['first_name']
        last_name = row['last_name']
        job_title = row['job_title']
        manager_id = row['manager_id']
                
        # Create the INSERT statement
        insert_statement = f"INSERT INTO EMPLOYEE (employee_id, first_name, last_name,job_title, manager_id) VALUES ({employee_id}, '{first_name}', '{last_name}', '{job_title}', {manager_id});\n"
        
        # Write the INSERT statement to the SQL file
        sql_file.write(f"""-- Insert {index+1} record from CSV \n""")
        sql_file.write(insert_statement)

print(f"SQL file '{output_sql_file}' has been created with employee data.")
