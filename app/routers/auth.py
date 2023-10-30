# route.py
from fastapi import APIRouter, HTTPException, Depends, Request, Response, Form, Body
from typing import Annotated, Optional
from sqlalchemy.orm import Session
from app.models.user import User, UserDB
from app.models.role import RoleDB
from app.database.connection import SessionLocal, redis_connection
from fastapi.responses import RedirectResponse, HTMLResponse
from fastapi.templating import Jinja2Templates
from passlib.context import CryptContext
from pydantic import SecretStr
from fastapi.security import HTTPBasic, HTTPBasicCredentials
from app.utils.auth_handler import signJWT, decodeJWT, decode_jwt_token, new_active_token, reset_expiration_active_token, remove_active_token_key
from app.utils.auth_bearer import JWTBearer

router = APIRouter()
templates = Jinja2Templates(directory="templates")
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
security = HTTPBasic()

active_tokens = []

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def get_current_user(userlogin, db: Session = Depends(get_db)):
    # print(userlogin)
    user = UserDB.get_by_username(db, username=userlogin["username"])
    if user is None or not pwd_context.verify(userlogin["password"], user.password):
        raise HTTPException(status_code=401, detail="Invalid username or password")
    # token = signJWT(user.username, user.role)
    print(f"user email: {user.email}, role: {user.role_id}")
    return user

def get_role(role_id,  db: Session = Depends(get_db)):
    role = RoleDB.get_by_role_id(db, role_id)
    if role is None :
        raise HTTPException(status_code=401, detail="Invalid role")
    
    return role

@router.get("/login")
async def login(request: Request, invalidlogin: Optional[bool]= False):
    return templates.TemplateResponse("login.html", {"request": request, "invalidlogin": invalidlogin})

@router.post("/login")
def login(response: Response, username: Annotated[str, Form()], password: Annotated[str, Form()], db: Session = Depends(get_db)):
    userlogin = {"username": username, "password": password}
    user = get_current_user(userlogin, db)
    current_role = get_role(user.role_id, db)
    token = signJWT(user.username, user.name, current_role.rolename)
    active_tokens.append(token)
    response = RedirectResponse(url="/", status_code=303)
    response.set_cookie(key="Authorization", value=f"Bearer {token}")
    unique_id = new_active_token(token)
    response.set_cookie(key="UniqueID", value=unique_id)
    # print(response.headers["Authorization"])
    return response

@router.get("/protected", tags=['tests'])
def read_protected_route(request: Request, response: Response, current_user: dict = Depends(decode_jwt_token)):
    token = request.cookies.get("Authorization", "").replace("Bearer ", "")
    if not current_user:
        raise HTTPException(status_code=401, detail="Unauthorized")
    unique_id = request.cookies.get("UniqueID", "")
    print(unique_id)
    if not reset_expiration_active_token(unique_id):
        raise HTTPException(status_code=401, detail="Unauthorized")
    return {"message": "This is protected", "user profile": current_user}

@router.get("/unprotected")
def read_unprotected_route():
    return {"message": "This is an unprotected route, anyone can visit this page!"}

@router.get("/logout")
def logout(response: Response, request: Request):
    token = request.cookies.get("Authorization", "").replace("Bearer ", "")
    unique_id = request.cookies.get("UniqueID", "")
    remove_active_token_key(unique_id)
    print(token)
    try:
        active_tokens.remove(token)
    except:
        pass
    response.delete_cookie(key="Authorization", path="/")
    return RedirectResponse(url="/auth/login", status_code=302)
