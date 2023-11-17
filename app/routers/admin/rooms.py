# rooms.py
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def read_rooms():
    return {"message": "Listing all rooms"}

# Add more room-related endpoints here