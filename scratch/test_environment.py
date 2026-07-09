import duckdb

con = duckdb.connect(database=':memory:')
con.execute("CREATE TABLE test_customers (customer_id INTEGER, name VARCHAR)")
con.execute("INSERT INTO test_customers VALUES (1, 'Alice'), (2, 'Bob'), (3, 'Charlie')")

result = con.execute("SELECT COUNT(*) AS total_customers FROM test_customers").fetchall()

print("Environment test successful!")
print("Row count:", result)