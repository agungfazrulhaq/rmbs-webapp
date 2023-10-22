# main.py
from fastapi import FastAPI, HTTPException
from app.routers import route, auth, users
from fastapi.staticfiles import StaticFiles
from fastapi.responses import RedirectResponse, HTMLResponse
import uvicorn

app = FastAPI()
app.mount("/static", StaticFiles(directory="static"), name="static")
app.include_router(route.router)
app.include_router(auth.router, prefix='/auth', tags=['authentication'])


# @app.exception_handler(HTTPException)
# async def custom_exception_handler(request, exc):
#     if exc.status_code == 401 :
#         return RedirectResponse(url='/auth/login', status_code=303)
#     return {"detail": exc.detail}

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=80, reload=True)