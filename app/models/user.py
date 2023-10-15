from fastapi import FastAPI
from pydantic import BaseModel, EmailStr, SecretStr
from passlib.context import CryptContext
from sqlalchemy import Column, Integer, String, Boolean
from sqlalchemy.orm import Session
from database.connection import Base, SessionLocal

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


class UserDB(Base):
    __tablename__ = "users"

    user_id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True)
    name = Column(String)
    role_id = Column(Integer, default=4)
    email = Column(String, unique=True, index=True)
    password = Column(String)
    enable_status = Column(Boolean, default=False)

    @staticmethod
    def get_by_username(db: Session, username: str):
        return db.query(UserDB).filter(UserDB.username == username).first()

    @staticmethod
    def get_by_email(db: Session, email: str):
        return db.query(UserDB).filter(UserDB.email == email).first()


class User(BaseModel):
    role_id: int
    name: str
    username: str
    email: EmailStr
    password: SecretStr
    enable_status: bool

    def create_user(self):
        db_user = UserDB(role_id=self.role_id, name=self.name, username=self.username, email=self.email)
        self.password = pwd_context.hash(self.password.get_secret_value())
        db_user.password = self.password
        db = SessionLocal()
        db.add(db_user)
        db.commit()
        db.refresh(db_user)
        print("added users")
        return {"email" : self.email, "password_hash":self.password}