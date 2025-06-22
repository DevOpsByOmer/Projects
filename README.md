
---

# 🚀 Project 1: Enterprise DevOps Project – CI/CD with Terraform, Ansible, Docker & GitHub Actions

A fullstack infrastructure automation and CI/CD deployment pipeline for containerized applications on AWS EC2 — leveraging GitHub Actions, Docker, Terraform, and Ansible.

---

## ✅ Project Overview

This project demonstrates a complete DevOps workflow that:

* ✅ Builds and pushes Docker images to Docker Hub
* ✅ Provisions AWS EC2 infrastructure using Terraform
* ✅ Deploys Dockerized apps using Ansible
* ✅ Orchestrates all steps with GitHub Actions (CI/CD workflows)

---

## 🚧 Tech Stack

| Layer                | Tools Used     |
| -------------------- | -------------- |
| Version Control      | Git + GitHub   |
| CI/CD Pipelines      | GitHub Actions |
| Containerization     | Docker         |
| IaC (Infrastructure) | Terraform      |
| Configuration Mgmt.  | Ansible        |
| Cloud Provider       | AWS EC2 + S3   |
| App Framework        | Flask (Python) |

---

## 📁 Project Structure

```bash
project-root/
├── .github/
│   └── workflows/
│       ├── order-service.yml          # Docker CI
│       ├── deploy-infra-dev.yml       # Terraform
│       └── deploy-via-ansible.yml     # Ansible
│
├── apps/
│   └── backend-api/
│       └── order-service/
│           ├── Dockerfile
│           └── app/
│
├── terraform/
│   ├── envs/
│   │   └── dev/
│   │       ├── main.tf
│   │       ├── variable.tf
│   │       ├── terraform.tfvars
│   │       └── backend.tf
│   └── modules/
│       └── ec2/
│           ├── main.tf
│           ├── variable.tf
│           └── output.tf
│
├── ansible/
│   ├── playbook.yml
│   └── hosts
│
└── scripts/
    └── setup_ec2.py (optional)
```

---

## 🔄 CI/CD Pipeline Breakdown

### 🔨 CI: Docker Image Build & Push

**Workflow:** `.github/workflows/order-service.yml`

```plaintext
on: push or dispatch
  ↓
Checkout Code → Build Docker Image → Trivy Scan (optional) → Push to DockerHub
```

---

### ☁️ Terraform: Provision EC2

**Workflow:** `.github/workflows/deploy-infra-dev.yml`

```plaintext
on: workflow_dispatch
  ↓
Terraform Init → Validate → Plan → Apply EC2 infra
```

---

### 🤖 Ansible: Configure EC2 & Deploy

**Workflow:** `.github/workflows/deploy-via-ansible.yml`

```plaintext
on: workflow_dispatch
  ↓
SSH into EC2 → Install Docker → Pull & Run App Container
```

---

## ⚙️ Infrastructure with Terraform

* EC2 with specified AMI, instance type, and key pair
* Security Group for HTTP (Port 5000 or 80)
* Optional: Remote S3 backend for state storage

**Terraform Paths:**

* `terraform/envs/dev/main.tf` – actual resources
* `terraform/modules/ec2/` – reusable module
* `backend.tf` – remote backend config (optional)

---

## 🛠️ Deployment with Ansible

**Ansible Playbook (`ansible/playbook.yml`):**

```yaml
- name: Deploy Order Service to EC2
  hosts: ec2
  become: true

  tasks:
    - name: Install Docker
      apt:
        name: docker.io
        state: present
        update_cache: true

    - name: Pull Docker image
      shell: docker pull your-dockerhub/order-service:latest

    - name: Run Docker container
      shell: docker run -d -p 5000:5000 --name order-service your-dockerhub/order-service:latest
```

---

## 📌 Secrets Used (GitHub Repo)

| Secret Name             | Purpose                          |
| ----------------------- | -------------------------------- |
| `DOCKERHUB_USERNAME`    | Docker login                     |
| `DOCKERHUB_TOKEN`       | Docker login                     |
| `AWS_ACCESS_KEY_ID`     | Terraform AWS provisioning       |
| `AWS_SECRET_ACCESS_KEY` | Terraform AWS provisioning       |
| `EC2_SSH_PRIVATE_KEY`   | Ansible deployment               |
| `EC2_HOST`              | IP of EC2 instance               |
| `EC2_USER`              | Typically `ubuntu` or `ec2-user` |

---

## 📊 Architecture Diagram

```plaintext
GitHub Repo
    │
    ├── GitHub Actions CI (Build & Push Docker)
    │
    ├── GitHub Actions CD (Terraform)
    │           ↓
    │       AWS EC2 Instance
    │           ↓
    └── GitHub Actions CD (Ansible)
                ↓
       SSH into EC2 → Pull Docker Image → Run App Container
```

---

## ✅ What We Achieved

* ✅ CI/CD fully automated via GitHub Actions
* ✅ IaC with Terraform (reusable module)
* ✅ Post-provision automation with Ansible
* ✅ Dockerized backend app deployment
* ✅ Used secrets management (secure practice)

---

## 📌 Future Enhancements

* Add Nginx reverse proxy or ALB
* Register domain with Route53 + SSL
* Add CloudWatch monitoring or UptimeRobot
* Setup staging/production environments
* Implement Blue/Green deployment

---

This project shows **DevOps engineering skills** in:

* Infrastructure provisioning (Terraform)
* Automated deployment (Ansible)
* Docker and containerization
* GitHub Actions CI/CD
* Secure and modular production workflows

---




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

Absolutely! Here's your plan for **🚀 Project 3: Fullstack App with RDS, HTTPS, Auto-scaling & Secrets** — **converted into a clean GitHub `README.md` format**, perfect for portfolio or repository documentation.

---

# 🚀 Project 3: Fullstack App with RDS, HTTPS, Auto-scaling & Secrets

A production-ready **FastAPI + React** application, fully containerized, secured with HTTPS, backed by managed services like RDS and AWS Secrets Manager, and deployed on **ECS with auto-scaling**, using **Terraform modules** and **GitHub Actions** for CI/CD.

---

## 🎯 Objective

* ✅ Frontend: React (served via ECS or S3 + CloudFront)
* ✅ Backend: FastAPI with Gunicorn & UvicornWorker
* ✅ Database: PostgreSQL (AWS RDS)
* ✅ HTTPS: Managed via ACM + ALB
* ✅ Secrets: Stored in AWS Secrets Manager
* ✅ CI/CD: GitHub Actions for multi-environment workflows
* ✅ Infra as Code: Terraform with modules
* ✅ Runtime: Docker + ECS + Auto-scaling

---

## 🧱 Architecture Diagram

```plaintext
           Internet
               │
         ┌─────▼─────┐
         │   HTTPS   │  <- ACM + ALB
         └─────┬─────┘
               │
      ┌────────┴────────┐
      │                 │
┌─────▼────┐     ┌──────▼─────┐
│ Frontend │     │  Backend   │ <- FastAPI + Gunicorn
└─────┬────┘     └──────┬─────┘
      │                 │
┌─────▼────┐     ┌──────▼─────┐
│React App │     │ PostgreSQL │ <- RDS
└──────────┘     └────────────┘
```

---

## 🔧 Infrastructure with Terraform

### 📁 Project Structure

```bash
infra/
├── modules/
│   ├── alb/                  # HTTPS + Target groups
│   ├── ecs_service/          # ECS task + service
│   ├── rds/                  # PostgreSQL instance
│   ├── vpc/                  # Custom VPC + subnets
├── envs/
│   ├── dev/
│   └── prod/
```

---

### 🔐 Secrets Manager Example

```hcl
resource "aws_secretsmanager_secret" "db" {
  name = "app/db_credentials"
}

resource "aws_secretsmanager_secret_version" "db_creds" {
  secret_id     = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    username = "fastapiuser",
    password = "strongpass"
  })
}
```

---

### 📦 RDS (PostgreSQL)

```hcl
resource "aws_db_instance" "main" {
  identifier = "app-postgres"
  engine = "postgres"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  username = var.db_username
  password = var.db_password
  ...
}
```

---

### 🌐 ALB + ACM (HTTPS)

```hcl
resource "aws_lb_listener" "https" {
  port            = 443
  protocol        = "HTTPS"
  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.acm_cert_arn
  ...
}
```

---

### ⚖️ ECS Auto-scaling

```hcl
resource "aws_appautoscaling_target" "ecs" {
  service_namespace  = "ecs"
  resource_id        = "service/cluster-name/service-name"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 2
  max_capacity       = 10
}
```

---

## 🐳 Backend Dockerfile (Improved)

```Dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

CMD ["gunicorn", "main:app", "-w", "4", "-k", "uvicorn.workers.UvicornWorker", "-b", "0.0.0.0:8000"]
```

---

## 🧠 Backend App Code Highlights

* ✅ Uses `boto3` to fetch secrets from Secrets Manager
* ✅ Connects to RDS PostgreSQL using `asyncpg`
* ✅ Handles DB migrations with Alembic
* ✅ Logs errors and exceptions in production-friendly format

---

## 🔁 GitHub Actions CI/CD

### 📄 `ci-cd.yml` (Multi-env deployment)

```yaml
on:
  push:
    branches:
      - main
    paths:
      - backend/**
      - frontend/**

jobs:
  deploy:
    strategy:
      matrix:
        environment: [dev, prod]
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Build & Push Docker Image
        run: docker build ...

      - name: Deploy with Terraform
        run: terraform apply ...
```

---

## ✅ Project Outcomes

| Feature                  | Status       |
| ------------------------ | ------------ |
| HTTPS via ALB + ACM      | ✅ Enabled    |
| Backend on ECS Fargate   | ✅ Done       |
| PostgreSQL (RDS)         | ✅ Done       |
| Secrets Manager          | ✅ Used       |
| GitHub Actions CI/CD     | ✅ Done       |
| Dockerized Microservices | ✅ Done       |
| Auto-scaling             | ✅ Configured |

---

## 📌 Next Steps

* 🌐 Register domain with Route53 + TLS
* 🔔 Add Slack alerts with GitHub Actions or CloudWatch
* 📈 Add Grafana + Prometheus or CloudWatch metrics
* 🔁 Enable Blue/Green deployment in ECS

---

## 📝 Summary for Portfolio

This project showcases an **end-to-end DevOps pipeline** with:

* ✅ FastAPI + React fullstack application
* ✅ Dockerized microservices
* ✅ RDS & Secrets Manager integration
* ✅ ECS + ALB + HTTPS (ACM)
* ✅ GitHub Actions for CI/CD
* ✅ Auto-scaling infrastructure via Terraform

---

Here’s your **GitHub README** version of **🚀 Project 4: Enterprise-Grade Fullstack K8s CI/CD with Monitoring**. It's clean, structured, and perfect for your portfolio or repo documentation.

---

# 🚀 Project 4: Enterprise-Grade Fullstack K8s CI/CD with Monitoring

**React (Frontend)** + **FastAPI (Backend)** deployed using **Kubernetes**, **Helm**, and **ArgoCD**, with **CI/CD powered by GitHub Actions**. Real-time **monitoring via Prometheus and Grafana** makes it production-ready and self-healing.

---

## 🔧 Tech Stack

| Layer         | Technology                        |
| ------------- | --------------------------------- |
| Frontend      | React                             |
| Backend       | FastAPI                           |
| CI/CD         | GitHub Actions + ArgoCD           |
| Orchestration | Kubernetes                        |
| Packaging     | Docker + Helm Charts              |
| Monitoring    | Prometheus + Grafana              |
| Ingress       | Ingress-NGINX                     |
| Metrics       | Prometheus FastAPI Instrumentator |

---

## 📊 Architecture Diagram

```
+-------------------------+
|       GitHub Repo       |
|-------------------------|
| - Frontend (React)      |
| - Backend (FastAPI)     |
| - Helm Charts (FE+BE)   |
| - GitHub Actions        |
+-----------+-------------+
            |
            | Git Push (main)
            v
+-----------------------------+
|     GitHub Actions CI       |
|-----------------------------|
| - Build Docker images       |
| - Push to DockerHub         |
| - Update Helm values.yaml   |
| - Commit back to repo       |
+-----------+-----------------+
            |
            v
+-----------------------------+
|        ArgoCD CD           |
|-----------------------------|
| - Watches GitHub Repo       |
| - Deploys Helm Charts       |
| - Keeps K8s in sync         |
+-----------+-----------------+
            |
            v
+-----------------------------+
|     Kubernetes Cluster      |
|-----------------------------|
| - Frontend & Backend Apps   |
| - Ingress (domain routes)   |
| - Services & Deployments    |
| - Monitored via Prometheus  |
| - Dashboards via Grafana    |
+-----------------------------+
```

---

## 📦 Step-by-Step Implementation

### 1️⃣ Application Setup

* 📁 `apps/frontend-dashboard/react`
* 📁 `apps/backend-api/FastAPI`
* ✔️ Health Check: `/api/health`
* 📈 Metrics: `/metrics` (for Prometheus)

---

### 2️⃣ Helm Charts

* 📁 `helm-charts/frontend/`
* 📁 `helm-charts/backend/`
* Includes:

  * `values.yaml`
  * `deployment.yaml`
  * `service.yaml`
  * `ingress.yaml`

---

### 3️⃣ Dockerization

* ✅ Dockerfile for both Frontend and Backend
* Built and pushed using GitHub Actions

---

### 4️⃣ GitHub Actions CI

* **Trigger**: Push to `main`
* **Jobs**:

  * Build Docker images
  * Push to DockerHub
  * Update Helm `values.yaml` with image tag
  * Git commit changes back (with `git pull --rebase`)

---

### 5️⃣ ArgoCD Setup

* Installed ArgoCD in Kubernetes
* Created:

  * `argocd/frontend-application.yaml`
  * `argocd/backend-application.yaml`
* ArgoCD syncs Helm charts from GitHub repo

---

### 6️⃣ Kubernetes Ingress

* Routes:

  * `frontend.local`
  * `backend.local`
* Tested via `minikube tunnel` or `kubectl port-forward`

---

### 7️⃣ Monitoring Stack

* Installed `kube-prometheus-stack` via Helm
* Namespace: `monitoring`
* Tools:

  * Prometheus
  * Grafana
  * Node Exporter
* Dashboards from:

  * `monitoring/dashboards/node-exporter.json`
* Custom values: `monitoring/prometheus-stack/values.yaml`

---

### 8️⃣ Grafana Access

```bash
minikube service -n monitoring monitoring-grafana --url
```

* Default login: `admin / prom-operator`

---

### 9️⃣ FastAPI Metrics Integration

* Integrated `prometheus-fastapi-instrumentator`
* `/metrics` endpoint automatically scraped by Prometheus

---

## ✅ Project Status

| Component          | Status                 |
| ------------------ | ---------------------- |
| Frontend + Backend | ✅ Deployed             |
| Docker Images      | ✅ Built & pushed       |
| Helm Charts        | ✅ Synced via ArgoCD    |
| CI/CD Pipeline     | ✅ Working              |
| Ingress Routes     | ✅ Configured           |
| Monitoring         | ✅ Prometheus + Grafana |
| Metrics            | ✅ Instrumented         |

---

## 🎯 Key Benefits

* 🔁 **Full GitOps workflow** with GitHub Actions + ArgoCD
* 🔍 **Monitoring built-in** with dashboards
* 🔐 **Metrics for observability**
* 📦 **Reusable Helm charts**
* 📥 **Declarative deployments**

---

## 📌 What's Next

* Add alerting (via Alertmanager or Slack)
* Add certificate management (TLS with cert-manager)
* Expose externally with NGINX Ingress + DNS
* Expand Helm values for multi-env setup
* Add end-to-end tests in CI pipeline

---

Here's a polished and structured `README.md` section for **Project 5** you can directly use in your GitHub repo:

---

# 🌟 Project 5: Fullstack DevOps Application Deployment 🚀

This project demonstrates a **production-grade DevOps workflow** by deploying a fullstack application using **React (frontend)** and **FastAPI (backend)**, with **PostgreSQL** and **Redis** for database and caching. All components are containerized using **Docker**, orchestrated with **Kubernetes**, and deployed via **Helm** and **ArgoCD (GitOps)**.

---

## 🔧 Tech Stack

| Layer            | Technology            |
| ---------------- | --------------------- |
| Frontend         | React (Node.js)       |
| Backend          | FastAPI (Python)      |
| Database         | PostgreSQL            |
| Caching          | Redis                 |
| Containerization | Docker                |
| Orchestration    | Kubernetes (Minikube) |
| CI/CD            | Helm + ArgoCD         |

---

## 📦 Architecture Overview

```
┌────────────┐        ┌────────────┐
│   React    │──────▶│   FastAPI   │─────┐
│ Frontend   │       │   Backend   │     │
└────────────┘       └────────────┘     ▼
                           ┌──────────────┐
                           │ PostgreSQL   │
                           └──────────────┘
                           ┌──────────────┐
                           │    Redis     │
                           └──────────────┘
```

All components are deployed as containers managed by Kubernetes. Services are packaged via Helm Charts and deployed using GitOps (ArgoCD).

---

## 📁 Project Structure

```
.
├── docker/
│   ├── backend/               # FastAPI Dockerfile
│   └── frontend/              # React Dockerfile
│
├── helm-charts/
│   ├── f-backend/             # Helm chart for backend
│   ├── f-frontend/            # Helm chart for frontend
│   ├── f-postgres/            # Helm chart for PostgreSQL
│   └── f-redis/               # Helm chart for Redis
│
├── argocd/
│   ├── f-backend/             # ArgoCD Application YAML
│   ├── f-frontend/
│   ├── f-postgres/
│   └── f-redis/
│
└── k8s-values/
    ├── values-backend.yaml
    ├── values-frontend.yaml
    ├── values-postgres.yaml
    └── values-redis.yaml
```

---

## ⚙️ Workflow Summary

1. **Build Docker Images**:

   * Backend: `saotech/k8s_backend_api:<tag>`
   * Frontend: `saotech/k8s_frontend:<tag>`

2. **Push to DockerHub**

3. **Write Helm Charts** for all services under `helm-charts/`

4. **Define ArgoCD Application Manifests** under `argocd/`

5. **Deploy with ArgoCD UI or CLI**

6. **Test the fullstack app** using Ingress URLs or NodePort

---

## ✅ What We Accomplished

* 🌐 Built and containerized a fullstack web application
* 📦 Pushed Docker images to DockerHub
* 📊 Defined Helm charts for each service (frontend, backend, db, cache)
* 🚀 Automated deployment with ArgoCD GitOps model
* 🔒 Managed PostgreSQL & Redis via secrets and values
* ⚙️ Verified full system via health checks and UI tests

---

