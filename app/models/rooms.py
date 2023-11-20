from pydantic import Field, BaseModel
from passlib.context import CryptContext
from sqlalchemy import Column, Integer, String, Boolean
from sqlalchemy.orm import Session
from app.database.connection import Base, SessionLocal
import logging

# Initialize logger
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize password context
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


class RoomDB(Base):
    __tablename__ = "rooms"

    room_id = Column(Integer, primary_key=True, index=True)
    room_name = Column(String)
    capacity = Column(Integer)
    facility = Column(String)
    image_url = Column(String)
    description = Column(String)
    available = Column(Boolean, default=True)

    @staticmethod
    def get_by_room_id(db: Session, room_id: int):
        return db.query(RoomDB).filter(UserDB.room_id == room_id).first()

    @staticmethod
    def get_all(db: Session):
        return db.query(RoomDB).all()


class Room(BaseModel):
    room_id: int
    room_name: str
    capacity: int
    facility: str
    description: str
    available: bool
    image_url: str

    def create_room(self, db: Session = SessionLocal()):
        db_room = RoomDB(
            room_id=self.room_id,
            room_name=self.room_name,
            capacity=self.capacity,
            facility=self.facility,
            description=self.description,
            available=self.available,
            image_url=self.image_url
        )

        try:
            db.add(db_room)
            db.commit()
            db.refresh(db_room)
            logger.info("Room added")
            return {"room_name": self.room_name, "image_url": self.image_url}
        except Exception as e:
            db.rollback()
            logger.error(f"Error occurred: {e}")
            return None