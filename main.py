import os
import trino
import pandas as pd
from datetime import datetime
from dateutil.relativedelta import relativedelta
from trino import exceptions

class TrinoManager:
    def __init__(self, host, port, user, catalog, schema):
        self.host = host
        self.port = port
        self.user = user
        self.catalog = catalog
        self.schema = schema
        self.conn = None
        self.cur = None

    def connect(self):
        """Establish a connection to Trino."""
        try:
            self.conn = trino.dbapi.connect(
                host=self.host,
                port=self.port,
                user=self.user,
                catalog=self.catalog,
                schema=self.schema
            )
            self.cur = self.conn.cursor()
            print("Connection successful!")
            self.cur.execute(f"USE {self.catalog}.{self.schema}")
        except exceptions.TrinoConnectionError as e:
            print(f"Connection failed: {e}")
            raise

    def execute_sql_from_file(self, file_path):
        """Read SQL commands from a file and execute them."""
        try:
            with open(file_path, 'r') as file:
                sql_commands = file.read()
                self.cur.execute(sql_commands)
                print(f"Executed {file_path} successfully!")
        except exceptions.TrinoQueryError as e:
            print(f"Failed to execute {file_path}: {e}")

    def run_sql_files(self, directory):
        """Execute all SQL files in the specified directory. This will create all the tables that is required"""
        try:
            for file_name in os.listdir(directory):
                if file_name.startswith('create_') and file_name.endswith('.sql'):
                    file_path = os.path.join(directory, file_name)
                    print(f"Executing {file_path}...")
                    self.execute_sql_from_file(file_path)
            print("All tables created successfully!")
        except Exception as e:
            print(f"An error occurred: {e}")

    def load_csv_to_table(self, csv_file, table_name, columns):
        """Load data from a CSV file into a Trino table."""
        try:
            df = pd.read_csv(csv_file)
            insert_query = f"""
            INSERT INTO {self.catalog}.{self.schema}.{table_name} ({', '.join(columns)})
            VALUES ({', '.join(['?' for _ in columns])})
            """
            for _, row in df.iterrows():
                self.cur.execute(insert_query, tuple(row))
            print(f"Data loaded successfully into {table_name}!")
        except Exception as e:
            print(f"Failed to load data from {csv_file}: {e}")

    def get_employee_id(self, first_name, last_name):
        """Retrieve employee_id based on first_name and last_name."""
        query = """
        SELECT employee_id FROM memory.default.employee
        WHERE first_name = ? AND last_name = ?
        """
        self.cur.execute(query, (first_name, last_name))
        result = self.cur.fetchone()
        if result:
            return result[0]
        return None

    def insert_expense_data(self, txt_directory):
        """Process TXT files for expenses and insert data into Trino."""
        insert_query = """
        INSERT INTO memory.default.expenses (employee_id, unit_price, quantity)
        VALUES (?, ?, ?)
        """

        def extract_data_from_file(file_path):
            with open(file_path, 'r') as file:
                lines = file.readlines()

                # Extract information from the file
                employee_line = next(line for line in lines if line.startswith('Employee:'))
                unit_price_line = next(line for line in lines if line.startswith('Unit Price:'))
                quantity_line = next(line for line in lines if line.startswith('Quantity:'))

                employee_name = employee_line.replace('Employee:', '').strip()
                unit_price = float(unit_price_line.replace('Unit Price:', '').strip())
                quantity = int(quantity_line.replace('Quantity:', '').strip())

                # Split employee name into first and last names
                first_name, last_name = employee_name.split(maxsplit=1)

                # Get employee_id from the employee table
                employee_id = self.get_employee_id(first_name, last_name)

                if employee_id is not None:
                    return employee_id, unit_price, quantity
                return None

        # Process each TXT file in the directory
        for file_name in os.listdir(txt_directory):
            if file_name.endswith('.txt'):
                file_path = os.path.join(txt_directory, file_name)
                data = extract_data_from_file(file_path)
                if data:
                    try:
                        self.cur.execute(insert_query, data)
                        print(f"Inserted data from {file_path}: {data}")
                    except Exception as e:
                        print(f"Failed to insert data from {file_path}: {e}")

    def get_supplier_id(self, name):
        """Retrieve supplier_id based on supplier name or create a new one."""
        query = """
        SELECT supplier_id FROM memory.default.suppliers
        WHERE name = ?
        """
        self.cur.execute(query, (name,))
        result = self.cur.fetchone()
        if result:
            return result[0]

        query = """
        SELECT COUNT(*) FROM memory.default.suppliers
        """
        self.cur.execute(query)
        supplier_count = self.cur.fetchone()[0]
        new_supplier_id = supplier_count + 1

        insert_query = """
        INSERT INTO memory.default.suppliers (supplier_id, name)
        VALUES (?, ?)
        """
        self.cur.execute(insert_query, (new_supplier_id, name))
        return new_supplier_id

    def get_due_date(self, due_date_str):
        """Calculate the due date based on a relative or absolute date string."""
        due_date_str = due_date_str.lower().strip()

        # Handle relative dates like "3 months from now" or "1 month from now"
        if 'month' in due_date_str:
            num_months = int(due_date_str.split()[0])
            due_date = datetime.now() + relativedelta(months=num_months)

        # Handle absolute date format like "2024-12-31"
        elif '-' in due_date_str:
            due_date = datetime.strptime(due_date_str, '%Y-%m-%d')

        # Handle other relative date formats
        elif 'days from now' in due_date_str:
            num_days = int(due_date_str.split()[0])
            due_date = datetime.now() + pd.DateOffset(days=num_days)

        else:
            raise ValueError(f"Unrecognized due date format: {due_date_str}")

        return pd.Timestamp(year=due_date.year, month=due_date.month, day=1) + pd.DateOffset(months=1) - pd.DateOffset(days=1)

    def insert_invoice_data(self, txt_directory):
        """Process TXT files for invoices and insert data into Trino."""

        insert_invoice_query = """
        INSERT INTO memory.default.invoices (supplier_id, invoice_amount, due_date)
        VALUES (?, ?, ?)
        """

        def extract_data_from_file(file_path):
            with open(file_path, 'r') as file:
                lines = file.readlines()

                company_name_line = next(line for line in lines if line.startswith('Company Name:'))
                invoice_amount_line = next(line for line in lines if line.startswith('Invoice Amount:'))
                due_date_line = next(line for line in lines if line.startswith('Due Date:'))

                company_name = company_name_line.replace('Company Name:', '').strip()
                invoice_amount = float(invoice_amount_line.replace('Invoice Amount:', '').strip())
                due_date_str = due_date_line.replace('Due Date:', '').strip()
                due_date = self.get_due_date(due_date_str)

                supplier_id = self.get_supplier_id(company_name)

                if supplier_id is not None:
                    return supplier_id, invoice_amount, due_date
                return None

        for file_name in os.listdir(txt_directory):
            if file_name.endswith('.txt'):
                file_path = os.path.join(txt_directory, file_name)
                data = extract_data_from_file(file_path)
                if data:
                    try:
                        self.cur.execute(insert_invoice_query, data)
                        print(f"Inserted data from {file_path}: {data}")
                    except Exception as e:
                        print(f"Failed to insert data from {file_path}: {e}")

    def close(self):
        """Close the cursor and connection."""
        if self.cur:
            self.cur.close()
        if self.conn:
            self.conn.close()
        print("Connection closed!")

# Usage
if __name__ == "__main__":
    # Trino connection settings
    host = 'localhost'
    port = 8080
    user = 'admin'
    catalog = 'memory'
    schema = 'default'

    # Directories
    sql_directory = 'sql_scripts/'
    csv_file = 'hr/employee_index.csv'
    table_name = 'employee'
    columns = ['employee_id', 'first_name', 'last_name', 'job_title', 'manager_id']
    txt_expense_directory = 'finance/receipts_from_last_night'
    txt_invoice_directory = 'finance/invoices_due'

    # Initialize TrinoManager
    manager = TrinoManager(host, port, user, catalog, schema)
    
    # Connect to Trino
    manager.connect()

    # Run SQL files to create tables
    manager.run_sql_files(sql_directory)

    # Load data into table
    manager.load_csv_to_table(csv_file, table_name, columns)

    # Process TXT files for expenses
    manager.insert_expense_data(txt_expense_directory)

    # Process TXT files for invoices
    manager.insert_invoice_data(txt_invoice_directory)

    # Close connection
    manager.close()
