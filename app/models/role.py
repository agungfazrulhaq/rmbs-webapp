from pydantic import BaseModel, EmailStr, SecretStr, Field
from passlib.context import CryptContext
from sqlalchemy import Column, Integer, String, Boolean
from sqlalchemy.orm import Session
from app.database.connection import Base, SessionLocal
import logging

# Initialize logger
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class RoleDB(Base):
    __tablename__ = "roles"

    role_id = Column(Integer, primary_key=True, index=True)
    rolename = Column(String, unique=True, index=True)
    description = Column(String)
    name = Column(String)
    
    @staticmethod
    def get_by_role_id(db: Session, role_id: int):
        return db.query(RoleDB).filter(RoleDB.role_id == role_id).first()
    
    @staticmethod
    def get_all_roles(db: Session):
        return db.query(RoleDB).all()