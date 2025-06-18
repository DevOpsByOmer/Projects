from fastapi import APIRouter

router = APIRouter()

@router.get("/message")
def get_message():
    return {"message": "Hello from the upgraded FastAPI backend!"}

@router.get("/health")
def health_check():
    return {"status": "ok"}
