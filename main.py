# main.py
from fastapi import FastAPI, HTTPException
from app.routers import route, auth, users, booking, admin
from fastapi.staticfiles import StaticFiles
from fastapi.responses import RedirectResponse, HTMLResponse
import uvicorn

app = FastAPI()
app.mount("/static", StaticFiles(directory="static"), name="static")
app.include_router(route.router, tags=['mainmenu'])
app.include_router(auth.router, prefix='/auth', tags=['authentication'])
app.include_router(booking.router, prefix='/booking', tags=['booking_service'])
app.include_router(admin.router, prefix='/admin', tags=['administration'])


@app.exception_handler(HTTPException)
async def custom_exception_handler(request, exc):
    redirect_url = '/auth/login'
    if exc.status_code == 401 :
        if exc.detail == "Invalid username or password" :
            redirect_url = '/auth/login?invalidlogin=True'
        return RedirectResponse(url=redirect_url, status_code=303)
    return {"detail": exc.detail}

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=80, reload=True)