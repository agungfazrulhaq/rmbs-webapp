import time
from typing import Dict
from fastapi import Depends, HTTPException, Request
from app.database.connection import redis_connection as r
import uuid

import jwt
import json
from decouple import config
# from config.settings import JWT_ALGORITHM, JWT_SECRET


JWT_SECRET = config("JWT_SECRET")
JWT_ALGORITHM = config("JWT_ALGORITHM")


def token_response(token: str):
    return {
        "access_token": token
    }

def signJWT(user_id: str, user_name:str, role_id: str) -> Dict[str, str]:
    payload = {
        "user_id": user_id,
        "user_name": user_name,
        "role_id": role_id,
        "ttl": 3600
    }
    token = jwt.encode(payload, JWT_SECRET, algorithm=JWT_ALGORITHM)

    return token

def decodeJWT(token: str) -> dict:
    # if not token:
    #     token = request.cookies.get("Authorization", "").replace("Bearer ", "")
    try:
        decoded_token = jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGORITHM])
        return decoded_token if decoded_token["expires"] >= time.time() else None
    except:
        return {}


def decode_jwt_token(request: Request, token: str = None):
    token = request.cookies.get("Authorization", "").replace("Bearer ", "")
    # print(token)
    # dict_token = token.replace("'", '"')
    # token = json.loads(dict_token)

    try:
        decoded_token = jwt.decode(token, JWT_SECRET, algorithms=["HS256"])
        return decoded_token
    except:
        raise HTTPException(status_code=401, detail="Invalid token")

def new_active_token(token):
    unique_flag = False
    while not unique_flag :
        unique_id = uuid.uuid4()
        if r.set(f'token:{unique_id}', token, ex=3600, nx=True) :
            unique_flag = True

    return unique_id

def reset_expiration_active_token(unique_id):
    return r.expire(f'token:{unique_id}', 3600)

def remove_active_token_key(unique_id):
    return r.delete(f'token:{unique_id}')

def authenticate_user(token, request, response, current_user=None):
    if not current_user:
        # raise HTTPException(status_code=401, detail="Unauthorized")
        return False
    unique_id = request.cookies.get("UniqueID", "")
    # print(unique_id)
    if not reset_expiration_active_token(unique_id):
        # raise HTTPException(status_code=401, detail="Unauthorized")
        return False

    return True        