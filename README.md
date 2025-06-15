
Project - 2
```markdown
# 🚀 DevOps Full-Stack ECS Project

This project demonstrates a **containerized full-stack application** deployed on **AWS ECS Fargate** with a complete **CI/CD pipeline**, using modern DevOps tools.

---

## 📦 Tech Stack

| Layer        | Stack                            |
|--------------|----------------------------------|
| Frontend     | React + NGINX                    |
| Backend      | FastAPI + Uvicorn                |
| Infra as Code| Terraform                        |
| CI/CD        | GitHub Actions                   |
| Container    | Docker                           |
| Registry     | Amazon ECR                       |
| Hosting      | AWS ECS Fargate + ALB            |

---

## 🧭 Architecture

```

```
               👨‍💻 User Browser
                      │
                      ▼
                 🔁 AWS ALB (Public)
                /                 \
     ┌────────────┐         ┌────────────┐
     │ Frontend TG│         │ Backend TG │
     └────┬───────┘         └────┬───────┘
          ▼                        ▼
  🧠 React App (NGINX)     ⚙️ FastAPI App (Uvicorn)
          ▼                        ▼
  📦 Frontend Task          📦 Backend Task
          ▼                        ▼
       ECS Service             ECS Service
          ▼                        ▼
       ECS Cluster (Fargate, Auto-managed compute)
                      ▼
                 VPC + Subnets
```

````

---

## 🚀 Features

- ✅ CI/CD pipelines via GitHub Actions
- ✅ Automatic Docker build & push to ECR
- ✅ Infrastructure provisioning with Terraform
- ✅ Frontend + Backend deployed on ECS
- ✅ Load balanced using ALB with target groups
- ✅ Dynamic API URL via React `.env.production`

---

## 🧱 Terraform Highlights

### ALB and Target Groups

```hcl
resource "aws_lb" "main" {
  ...
}

resource "aws_lb_target_group" "frontend" {
  port = 80
  ...
}

resource "aws_lb_target_group" "backend" {
  port = 8000
  ...
}
````

### ECS Cluster & Services

```hcl
resource "aws_ecs_cluster" "main" {
  name = "devops-cluster"
}

resource "aws_ecs_service" "frontend" { ... }
resource "aws_ecs_service" "backend" { ... }
```

---

## 🐳 Docker Setup

### Backend (`Dockerfile`)

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Frontend (`Dockerfile`)

```dockerfile
FROM node:20-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

---

## 💻 Frontend Code

### `App.js`

```js
useEffect(() => {
  fetch(`${process.env.REACT_APP_API_URL}/`)
    .then((res) => res.json())
    .then((data) => setMessage(data.message))
    .catch((err) => console.error(err));
}, []);
```

### `.env.production`

```
REACT_APP_API_URL=http://<your-alb-dns-name>/api
```

---

## 🌐 Backend Code

### `main.py`

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {"message": "Hello from FastAPI backend!"}

@app.get("/api/health")
def health():
    return {"status": "ok"}
```

---

## 🔁 GitHub Actions

### `docker-build-push.yml`

```yaml
name: Build & Push Docker Images
on:
  push:
    branches: [ main ]
jobs:
  build-and-push:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: aws-actions/amazon-ecr-login@v1
      - name: Build and Push to ECR
        run: |
          docker build -t ${{ secrets.ECR_REPO }} .
          docker tag ${{ secrets.ECR_REPO }} ${{ secrets.ECR_REPO }}:${{ github.sha }}
          docker push ${{ secrets.ECR_REPO }} --all-tags
```

---

## ✅ Deployment Output

* ✅ Application accessible via ALB DNS
* ✅ `/api` requests served by FastAPI backend
* ✅ `/` requests served by React frontend
* ✅ CI/CD and infrastructure automated

---

## 🔧 Optional Enhancements

* 🌐 Route53 domain for frontend
* 🔒 ACM (HTTPS certificate) for ALB
* 🔑 Store secrets in AWS Secrets Manager
* 📈 CloudWatch monitoring
* ⚖️ ECS Autoscaling policies
* 🗃️ RDS / DynamoDB integration

---

## 📂 Project Structure

```
project/
├── frontend/
│   ├── Dockerfile
│   ├── public/
│   ├── src/
│   └── .env.production
├── backend/
│   ├── Dockerfile
│   ├── main.py
│   └── requirements.txt
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── .github/workflows/
    └── docker-build-push.yml
```

---

## 🙌 Credits

