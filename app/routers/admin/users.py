# users.py
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def read_users():
    return {"message": "Listing all users"}

# Add more user-related endpoints here
