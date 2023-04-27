import psycopg2

conn = psycopg2.connect(database="malariadb_dev",
                        host="localhost",
                        user="postgres",
                        password="postgrespw",
                        port="5432")

cursor = conn.cursor()

cursor.execute("select * from cases_reported")
print(cursor.fetchone())