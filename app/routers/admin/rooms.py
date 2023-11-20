# rooms.py
from fastapi import APIRouter, HTTPException, Depends, Request, Response, Form, Body
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from app.utils.auth_handler import signJWT, decodeJWT, decode_jwt_token, new_active_token, reset_expiration_active_token, remove_active_token_key
from app.utils.auth_bearer import JWTBearer
from app.models.user import User, UserDB
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
async def read_rooms(request: Request, response: Response, current_user: dict = Depends(decode_jwt_token)):
    return {"message": "Listing all rooms"}

# Add more room-related endpoints here