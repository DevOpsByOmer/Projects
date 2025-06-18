from fastapi import FastAPI
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
import os
import sys

from app.routes import api
from app.core.config import add_cors

# Create FastAPI app instance
app = FastAPI()

# Add CORS middleware
add_cors(app)

# Include application routers
app.include_router(api.router, prefix="/api")

# Root endpoint
@app.get("/")
def read_root():
    return {"message": "API is running"}

# Health check endpoint (used by ECS/ALB)
@app.get("/health")
def health():
    return {"status": "ok"}

# === Database Configuration ===

# Load credentials from environment variables
DB_HOST = os.getenv("DB_HOST")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")

if not all([DB_HOST, DB_NAME, DB_USER, DB_PASSWORD]):
    print("❌ ERROR: One or more database environment variables are missing.", file=sys.stderr)
    sys.exit(1)

# Construct DB URL
SQLALCHEMY_DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}"

# Set up SQLAlchemy
try:
    engine = create_engine(SQLALCHEMY_DATABASE_URL, echo=True)
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    Base = declarative_base()
    
    # Import models and create tables
    from app.models import all_models  # this should import your model files
    Base.metadata.create_all(bind=engine)

    print("✅ Connected to DB and initialized successfully.")

except Exception as e:
    print(f"❌ ERROR: Failed to initialize the database: {e}", file=sys.stderr)
    sys.exit(1)
