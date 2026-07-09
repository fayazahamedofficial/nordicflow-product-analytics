import duckdb

# This creates (or connects to) a real file on disk, not memory
con = duckdb.connect(database='nordicflow.duckdb')

con.execute("CREATE TABLE IF NOT EXISTS test_customers (customer_id INTEGER, name VARCHAR)")
con.execute("DELETE FROM test_customers")  # clear out old test rows if re-run
con.execute("INSERT INTO test_customers VALUES (1, 'Alice'), (2, 'Bob'), (3, 'Charlie')")

result = con.execute("SELECT COUNT(*) AS total_customers FROM test_customers").fetchall()
print("Database file created successfully!")
print("Row count:", result)

con.close()