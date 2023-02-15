import math
import psycopg2
from config import host, user, password, dbname

def count_sin():
    limit = math.pi*6
    step = limit/1000
    index = 0
    while index < limit:
        yield index, math.sin(index)
        index += step
connection = None

try:
    connection = psycopg2.connect(host="my-postgres", user="postgres", password="mysecretpassword",
                                  dbname=dbname)
    with connection.cursor() as cursor:
        cursor.execute(
            "SELECT VERSION();"
        )
        print(cursor.fetchall())
    with connection.cursor() as cursor:
        cursor.execute(
            "DROP TABLE if exists XY;"
        )
        connection.commit()
    with connection.cursor() as cursor:
        cursor.execute(
            "CREATE TABLE if not exists XY(x float8 NOT NULL, y float8 NOT NULL);"
        )
        connection.commit()
    with connection.cursor() as cursor:
        for i in count_sin():
            cursor.execute(
                "INSERT INTO XY(x,y) VALUES({},{})".format(i[0],i[1])
            )
            connection.commit()
except Exception as e:
    print("{} Error!".format(e))
finally:
    if connection:
        connection.close()



