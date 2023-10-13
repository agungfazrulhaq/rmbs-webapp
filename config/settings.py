import os

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:secret@localhost:5432/rmbsdatabase")
DATABASE_HOST = os.getenv("DATABASE_HOST", "172.25.164.49")
DATABASE_DB = os.getenv("DATABASE_DB", "rmbsdatabase")
DATABASE_PORT = os.getenv("DATABASE_PORT", "5432")
DATABASE_USER = os.getenv("DATABASE_USER")
DATABASE_PASSWORD = os.getenv("DATABASE_PASSWORD")