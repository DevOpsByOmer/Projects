# Base Python image
FROM python:3.10

ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy
ENV PATH="/app/.venv/bin:$PATH"

WORKDIR /app/

# Install uv
COPY --from=ghcr.io/astral-sh/uv:0.5.11 /uv /uvx /bin/

# Pre-install hatchling to avoid uv failure
RUN pip install --no-cache-dir hatchling

# Copy dependency files early
COPY pyproject.toml uv.lock alembic.ini /app/

# Copy the .env file into the container (KEY STEP)
COPY .env /app/.env

# Install dependencies using uv
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync || echo "⚠️ uv failed, continuing..."

# Copy source files
COPY ./app /app/app
COPY ./scripts /app/scripts

# Final sync in case of app local dependencies
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync || echo "⚠️ uv failed again, continuing..."

# Start FastAPI server
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
