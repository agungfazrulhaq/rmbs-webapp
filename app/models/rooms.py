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

    room_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
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
    room_name: str
    capacity: int
    facility: str
    description: str
    available: bool
    image_url: str

    def create_room(self, db: Session = SessionLocal()):
        db_room = RoomDB(
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
    
    @staticmethod
    def delete_room(room_id: int, db: Session = SessionLocal()):
        room_to_delete = db.query(RoomDB).filter(RoomDB.room_id == room_id).first()
        if room_to_delete:
            try:
                db.delete(room_to_delete)
                db.commit()
                logger.info(f"Room with ID {room_id} deleted")
                return {"message": "Room deleted successfully"}
            except Exception as e:
                db.rollback()
                logger.error(f"Error occurred: {e}")
                return None
        else:
            logger.error(f"Room with ID {room_id} not found")
            return None
            
    @staticmethod
    def update_room(room_id: int, updated_room: dict, db: Session = SessionLocal()):
        room_to_update = db.query(RoomDB).filter(RoomDB.room_id == room_id).first()
        if room_to_update:
            try:
                for key, value in updated_room.items():
                    setattr(room_to_update, key, value)

                db.commit()
                db.refresh(room_to_update)
                logger.info(f"Room with ID {room_id} updated")
                return {"message": "Room updated successfully"}
            except Exception as e:
                db.rollback()
                logger.error(f"Error occurred: {e}")
                return None
        else:
            logger.error(f"Room with ID {room_id} not found")
            return None