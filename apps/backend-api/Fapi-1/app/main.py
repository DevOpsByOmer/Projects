from fastapi import FastAPI
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




