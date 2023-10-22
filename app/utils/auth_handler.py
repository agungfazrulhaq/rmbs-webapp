import time
from typing import Dict
from fastapi import Depends, HTTPException, Request

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

def signJWT(user_id: str, role_id: str) -> Dict[str, str]:
    payload = {
        "user_id": user_id,
        "role_id": role_id,
        "expires": time.time() + 600
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
        