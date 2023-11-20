# route.py
from fastapi import APIRouter, HTTPException, Depends, Request, Response, Form, Body
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from app.utils.auth_handler import signJWT, decodeJWT, decode_jwt_token, 
                                    new_active_token, reset_expiration_active_token, 
                                    remove_active_token_key, authenticate_user
from app.utils.auth_bearer import JWTBearer
from app.models.user import User, UserDB
from app.models.role import RoleDB
from app.routers.admin.users import router as users_router
from app.routers.admin.rooms import router as rooms_router
from app.database.connection import SessionLocal, redis_connection
from sqlalchemy.orm import Session

router = APIRouter()

router.include_router(rooms_router, prefix="/rooms", tags=["rooms"])
# router.include_router(users_router, prefix="/users", tags=["users"])

templates = Jinja2Templates(directory="templates")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/")
async def root(request: Request, response: Response, current_user: dict = Depends(decode_jwt_token)):
    token = request.cookies.get("Authorization", "").replace("Bearer ", "")
    
    if not authenticate_user:
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    # request = {"Hello" : "World", "user" : current_user}
    redirect_url = '/admin/rooms'
    return RedirectResponse(url=redirect_url, status_code=303)