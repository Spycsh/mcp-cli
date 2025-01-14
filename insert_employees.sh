#!/bin/bash

# Define the SQLite database file
DB_FILE="employees.db"

# Create the database and table if it doesn't exist
sqlite3 "$DB_FILE" <<EOF
CREATE TABLE IF NOT EXISTS employees (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    age INTEGER,
    department TEXT,
    salary REAL,
    hire_date TEXT
);
EOF

# Generate random employee data and insert it into the table
insert_random_employees() {
    local num_employees=$1
    for ((i=1; i<=num_employees; i++)); do
        # Generate random values
        NAME=$(shuf -n 1 /usr/share/dict/words)$(shuf -n 1 /usr/share/dict/words)
        AGE=$((RANDOM % 48 + 18))  # Random age between 18 and 65
        DEPARTMENT=$(shuf -e "HR" "Engineering" "Sales" "Marketing" "Finance" -n 1)
        SALARY=$(awk "BEGIN {print ($RANDOM%90000+30000)/100}")
        HIRE_DATE=$(date -d "$((RANDOM % 3650)) days ago" +%Y-%m-%d)

        # Insert into the database
        sqlite3 "$DB_FILE" <<EOF
INSERT INTO employees (name, age, department, salary, hire_date) 
VALUES ('$NAME', $AGE, '$DEPARTMENT', $SALARY, '$HIRE_DATE');
EOF
    done
}

# Insert 10 random employees
insert_random_employees 10

# Display the inserted data
echo "Inserted Employees:"
sqlite3 "$DB_FILE" "SELECT * FROM employees;"
