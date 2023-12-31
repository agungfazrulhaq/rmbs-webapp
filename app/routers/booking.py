# route.py
from fastapi import APIRouter, HTTPException, Depends, Request, Response, Form, Body
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from app.utils.auth_handler import signJWT, decodeJWT, decode_jwt_token, new_active_token, reset_expiration_active_token, remove_active_token_key
from app.utils.auth_bearer import JWTBearer
from app.utils import rooms as r_utils
from app.models.user import User, UserDB
from app.models.rooms import Room, RoomDB
from app.models.role import RoleDB
from app.database.connection import SessionLocal, redis_connection
from sqlalchemy.orm import Session

router = APIRouter()
templates = Jinja2Templates(directory="templates")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/schedules")
async def root(request: Request, response: Response, current_user: dict = Depends(decode_jwt_token)):
    token = request.cookies.get("Authorization", "").replace("Bearer ", "")
    if not current_user:
        raise HTTPException(status_code=401, detail="Unauthorized")
    unique_id = request.cookies.get("UniqueID", "")
    print(unique_id)
    if not reset_expiration_active_token(unique_id):
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    request = {"user" : current_user}
    return templates.TemplateResponse("schedules.html", {"request": request})

@router.get("/form")
async def root(request: Request, response: Response, current_user: dict = Depends(decode_jwt_token)):
    token = request.cookies.get("Authorization", "").replace("Bearer ", "")
    if not current_user:
        raise HTTPException(status_code=401, detail="Unauthorized")
    unique_id = request.cookies.get("UniqueID", "")
    print(unique_id)
    if not reset_expiration_active_token(unique_id):
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    request = {"user" : current_user}
    return templates.TemplateResponse("booking.html", {"request": request})

@router.get("/rooms")
async def read_rooms(request: Request, response: Response,  db: Session = Depends(get_db), current_user: dict = Depends(decode_jwt_token)):
    token = request.cookies.get("Authorization", "").replace("Bearer ", "")
    if not current_user:
        raise HTTPException(status_code=401, detail="Unauthorized")
    unique_id = request.cookies.get("UniqueID", "")
    print(unique_id)
    if not reset_expiration_active_token(unique_id):
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    # request = {"Hello" : "World", "user" : current_user}
    rooms_list = r_utils.parsing_roomdb_to_dict(RoomDB.get_all(db))
    # print(rooms_list)
    request = {"user" : current_user, "room_list" : rooms_list}
    return templates.TemplateResponse("room-list.html", {"request": request})