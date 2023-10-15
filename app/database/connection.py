import sys

sys.path.append('../../')
sys.path.append('../')
from config.settings import DATABASE_URL

# db.py
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# def create_connection():
#     # print("Trying to connect to database...")
#     try:
#         conn = psycopg2.connect(
#             host=DATABASE_HOST,
#             database=DATABASE_DB,
#             port=DATABASE_PORT,
#             user=DATABASE_USER,
#             password=DATABASE_PASSWORD
#         )
#         print("Connection Created Successfully : ", conn)
#         return conn
#     except:
#         print("Failed to connect to database")
#         return None