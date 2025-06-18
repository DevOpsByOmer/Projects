from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from fastapi import FastAPI
from app.routes import api
from app.core.config import add_cors
import os

app = FastAPI()
add_cors(app)

app.include_router(api.router, prefix="/api")

# Load DB credentials from env
DB_HOST = os.getenv("DB_HOST")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")

SQLALCHEMY_DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}"

# 👇 Create engine using secret-loaded URL
engine = create_engine(SQLALCHEMY_DATABASE_URL)
Base = declarative_base()

Base.metadata.create_all(bind=engine)
