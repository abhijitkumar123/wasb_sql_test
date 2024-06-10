-- CREATE THE EMPLOYEE TABLE
CREATE TABLE IF NOT EXISTS MEMORY.DEFAULT.EMPLOYEE (
    EMPLOYEE_ID TINYINT,
    FIRST_NAME VARCHAR,
    LAST_NAME VARCHAR,
    JOB_TITLE VARCHAR,
    MANAGER_ID TINYINT
);

-- INSERT EMPLOYEE DATA INTO THE EMPLOYEE TABLE
INSERT INTO MEMORY.DEFAULT.EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, JOB_TITLE, MANAGER_ID) VALUES
(1, 'Ian', 'James', 'CEO', 4),
(2, 'Umberto', 'Torrielli', 'CSO', 1),
(3, 'Alex', 'Jacobson', 'MD EMEA', 2),
(4, 'Darren', 'Poynton', 'CFO', 2),
(5, 'Tim', 'Beard', 'MD APAC', 2),
(6, 'Andrea', 'Murphy', 'CTO', 1),
(7, 'John', 'Doe', 'Head of Marketing', 3),
(8, 'Jane', 'Smith', 'Head of Sales', 3),
(9, 'Robert', 'Brown', 'Head of Development', 6);