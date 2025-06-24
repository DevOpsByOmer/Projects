from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from prometheus_fastapi_instrumentator import Instrumentator
import logging
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.resources import Resource
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor

trace.set_tracer_provider(
    TracerProvider(resource=Resource.create({"service.name": "fastapi-backend"}))
)
trace.get_tracer_provider().add_span_processor(
    BatchSpanProcessor(OTLPSpanExporter(endpoint="http://otel-collector.monitoring.svc.cluster.local:4317", insecure=True))
)

app = FastAPI()
FastAPIInstrumentor().instrument_app(app)


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
