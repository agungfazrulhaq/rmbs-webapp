import sys

sys.path.append('../../')
from config.settings import DATABASE_DB, DATABASE_HOST, DATABASE_PASSWORD, DATABASE_USER, DATABASE_PORT

import psycopg2

def create_connection():
    # print("Trying to connect to database...")
    try:
        conn = psycopg2.connect(
            host=DATABASE_HOST,
            database=DATABASE_DB,
            port=DATABASE_PORT,
            user=DATABASE_USER,
            password=DATABASE_PASSWORD
        )
        print("Connection Created Successfully : ", conn)
        return conn
    except:
        print("Failed to connect to database")
        return None