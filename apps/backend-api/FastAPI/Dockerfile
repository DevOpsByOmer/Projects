FROM python:3.11-slim

WORKDIR /app

# Copy dependencies
COPY requirements.txt .

RUN pip install -r requirements.txt

# Copy app code
COPY . .

# Run the FastAPI server
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
