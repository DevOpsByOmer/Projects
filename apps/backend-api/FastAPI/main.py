from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from prometheus_fastapi_instrumentator import Instrumentator
import logging

app = FastAPI(
    title="FastAPI Backend",
    description="Handles API requests for fullstack app",
    version="1.0.0"
)

# ✅ Add Prometheus Instrumentation
Instrumentator().instrument(app).expose(app)

# ✅ CORS: Allow frontend to call API from any domain
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Update with actual domain in prod
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ✅ Root route
@app.get("/")
def read_root():
    return {"message": "Hello from FastAPI backend!"}

# ✅ Health check route
@app.get("/api/health")
def health_check():
    return {"status": "ok"}

# ✅ Example route
@app.get("/api/message")
def get_message():
    return {"message": "Hello from FastAPI API"}
