import sys

sys.path.append('../../')
sys.path.append('../')
from config.settings import DATABASE_URL, REDIS_HOST, REDIS_PORT, MINIO_ACCESS, MINIO_SECRET, MINIO_HOST, MINIO_PORT, MINIO_BUCKET
import redis

# db.py
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

from minio import Minio
# from minio.error import ResponseError

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

redis_connection = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, db=0)

# minio_client = Minio(
#     f'{MINIO_HOST}:{MINIO_PORT}',
#     access_key=MINIO_ACCESS,
#     secret_key=MINIO_SECRET,
#     secure=False
# )

# minio_bucket = MINIO_BUCKET