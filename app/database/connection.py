import sys

sys.path.append('../../')
sys.path.append('../')
from config.settings import DATABASE_URL, REDIS_HOST, REDIS_PORT
import redis

# db.py
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

redis_connection = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, db=0)