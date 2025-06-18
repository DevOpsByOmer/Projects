from fastapi.middleware.cors import CORSMiddleware
import boto3
import os

def add_cors(app):
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

# 👇 SSM client (adjust region as needed)
ssm = boto3.client("ssm", region_name="ap-south-1")

def get_secret(name: str) -> str:
    return ssm.get_parameter(Name=name, WithDecryption=True)["Parameter"]["Value"]

# 👇 Pull secrets from SSM and set as environment variables
os.environ["DB_PASSWORD"] = get_secret("/devops/backend/db_password")
os.environ["DB_USER"]     = get_secret("/devops/backend/db_user")
os.environ["DB_NAME"]     = get_secret("/devops/backend/db_name")
os.environ["DB_HOST"]     = get_secret("/devops/backend/db_host")
