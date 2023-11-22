# rooms.py
from fastapi import APIRouter, HTTPException, Depends, Request, Response, Form, Body, UploadFile, File
from typing import Annotated, Optional
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from app.utils.auth_handler import signJWT, decodeJWT, decode_jwt_token, new_active_token, reset_expiration_active_token, remove_active_token_key
from app.utils.auth_bearer import JWTBearer
from app.models.user import User, UserDB
from app.models.rooms import Room, RoomDB
from app.utils import rooms as r_utils
from app.models.role import RoleDB
from app.database.connection import SessionLocal, redis_connection
from sqlalchemy.orm import Session
from fastapi import APIRouter

router = APIRouter()
templates = Jinja2Templates(directory="templates")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/")
async def read_rooms(request: Request, response: Response, db: Session = Depends(get_db), current_user: dict = Depends(decode_jwt_token)):
    token = request.cookies.get("Authorization", "").replace("Bearer ", "")
    if not current_user:
        raise HTTPException(status_code=401, detail="Unauthorized")
    unique_id = request.cookies.get("UniqueID", "")
    print(unique_id)
    if not reset_expiration_active_token(unique_id):
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    # request = {"Hello" : "World", "user" : current_user}
    rooms_list = r_utils.parsing_roomdb_to_dict(RoomDB.get_all(db))

    request = {"user" : current_user, "room_list" : rooms_list}
    return templates.TemplateResponse("rooms-admin.html", {"request": request})

@router.post('/add')
def add_room(
    room_name: Annotated[str, Form()],
    capacity: Annotated[int, Form()],
    facility: Annotated[str, Form()],
    description: Annotated[str, Form()],
    image: Annotated[UploadFile, File()],
    available: Annotated[bool, Form()]
):
    filename = image.filename
    metadata = {"room_name": room_name, "capacity": capacity, "facility": facility
               ,"description": description, "image":image, "available":available}
    
    return metadata

