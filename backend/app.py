from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import os
import logging

load_dotenv()

logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler("kuza.log"),
        logging.StreamHandler()
    ]
)

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow frontend origins in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

from routes.scan import router as scan_router
from routes.educate import router as educate_router
from routes.payment import router as payment_router

app.include_router(scan_router, prefix="/api")
app.include_router(educate_router, prefix="/api")
app.include_router(payment_router, prefix="/api")

from models.db_models import Base
from services.db_service import engine
Base.metadata.create_all(bind=engine)