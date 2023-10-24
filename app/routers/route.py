# route.py
from fastapi import APIRouter
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates

router = APIRouter()
templates = Jinja2Templates(directory="templates")

@router.get("/")
async def root(request: Request, response: Response):
    
    return templates.TemplateResponse("index.html", {"request": request})