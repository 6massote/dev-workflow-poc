# Deployment Guide

This guide covers deploying the GitHub Safe Merge & Deploy Workflow demo to various environments.

## 🚀 Quick Deployment

### Prerequisites

- Docker and Docker Compose
- Git with proper configuration
- GitHub repository with Actions enabled

### Local Development Deployment

```bash
# Clone and setup
git clone <your-repo-url>
cd dev-workflow-poc

# Start development environment with Docker (recommended)
npm run dev

# Or build and start (first time)
npm run dev:build
```

**Access URLs**:
- Frontend: http://localhost:5173
- Backend: http://localhost:3001
- Health Check: http://localhost:3001/health

### Alternative: Local Development (without Docker)

```bash
# Install Node.js 18+ (see .nvmrc)
nvm use

# Install dependencies
npm run install:all

# Start development servers
npm run dev:backend & npm run dev:frontend
```

## 🐳 Docker Deployment

The project includes pre-configured Docker files for both development and production environments.

### Development Environment

**Files included:**
- `docker-compose.yml` - Development environment with hot reloading
- `backend/Dockerfile.dev` - Backend development container
- `frontend/Dockerfile.dev` - Frontend development container

**Start development:**
```bash
# Start development environment
npm run dev

# Or build and start (first time)
npm run dev:build

# View logs
npm run dev:logs

# Stop containers
npm run dev:down
```

### Production Environment

**Files included:**
- `docker-compose.prod.yml` - Production environment (for local testing)
- `backend/Dockerfile` - Production backend container
- `frontend/Dockerfile` - Production frontend container with serve

**Deploy to production:**
```bash
# Build and start production services (local testing)
npm run docker:prod

# Or manually:
docker-compose -f docker-compose.prod.yml up --build -d

# Check status
docker-compose -f docker-compose.prod.yml ps

# View logs
docker-compose -f docker-compose.prod.yml logs -f

# Stop services
docker-compose -f docker-compose.prod.yml down
```

### Docker Features

- **Hot reloading** in development
- **Health checks** for all services
- **Volume mounting** for live code changes
- **Network isolation** between services
- **Production optimization** with serve
- **Simple and lightweight** container configuration

## ☁️ Cloud Platform Deployment

### AWS Deployment

#### Using AWS ECS

1. **Create ECR Repository**:
```bash
aws ecr create-repository --repository-name merge-guard-demo
```

2. **Build and Push Images**:
```bash
# Backend
docker build -t merge-guard-backend ./backend
docker tag merge-guard-backend:latest <account>.dkr.ecr.<region>.amazonaws.com/merge-guard-demo:latest
docker push <account>.dkr.ecr.<region>.amazonaws.com/merge-guard-demo:latest

# Frontend
docker build -t merge-guard-frontend ./frontend
docker tag merge-guard-frontend:latest <account>.dkr.ecr.<region>.amazonaws.com/merge-guard-frontend:latest
docker push <account>.dkr.ecr.<region>.amazonaws.com/merge-guard-frontend:latest
```

3. **Create ECS Task Definition**:
```json
{
  "family": "merge-guard-demo",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "256",
  "memory": "512",
  "executionRoleArn": "arn:aws:iam::<account>:role/ecsTaskExecutionRole",
  "containerDefinitions": [
    {
      "name": "backend",
      "image": "<account>.dkr.ecr.<region>.amazonaws.com/merge-guard-demo:latest",
      "portMappings": [
        {
          "containerPort": 3001,
          "protocol": "tcp"
        }
      ],
      "healthCheck": {
        "command": ["CMD-SHELL", "curl -f http://localhost:3001/health || exit 1"],
        "interval": 30,
        "timeout": 5,
        "retries": 3
      }
    }
  ]
}
```

#### Using AWS Lambda (Serverless)

1. **Create Lambda Function**:
```bash
# Package backend for Lambda
cd backend
zip -r function.zip . -x "node_modules/*"
aws lambda create-function \
  --function-name merge-guard-backend \
  --runtime nodejs18.x \
  --handler server.handler \
  --zip-file fileb://function.zip
```

2. **Configure API Gateway**:
```bash
# Create API Gateway
aws apigateway create-rest-api --name "Merge Guard API"

# Create resources and methods for health endpoint
aws apigateway create-resource --rest-api-id <api-id> --parent-id <parent-id> --path-part "health"
aws apigateway put-method --rest-api-id <api-id> --resource-id <resource-id> --http-method GET
```

### Google Cloud Platform

#### Using Cloud Run

1. **Deploy Backend**:
```bash
# Build and deploy
gcloud builds submit --tag gcr.io/<project-id>/merge-guard-backend ./backend
gcloud run deploy merge-guard-backend \
  --image gcr.io/<project-id>/merge-guard-backend \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --port 3001
```

2. **Deploy Frontend**:
```bash
# Build and deploy
gcloud builds submit --tag gcr.io/<project-id>/merge-guard-frontend ./frontend
gcloud run deploy merge-guard-frontend \
  --image gcr.io/<project-id>/merge-guard-frontend \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --port 80
```

### Azure

#### Using Azure Container Instances

1. **Deploy Backend**:
```bash
# Build and push to Azure Container Registry
az acr build --registry <registry-name> --image merge-guard-backend ./backend

# Deploy to Container Instances
az container create \
  --resource-group <resource-group> \
  --name merge-guard-backend \
  --image <registry-name>.azurecr.io/merge-guard-backend:latest \
  --ports 3001 \
  --dns-name-label merge-guard-backend
```

## 🔧 Environment Configuration

### Environment Variables

#### Backend Environment Variables

```bash
# Production
NODE_ENV=production
PORT=3001
FRONTEND_URL=https://your-frontend-domain.com

# Development
NODE_ENV=development
PORT=3001
FRONTEND_URL=http://localhost:5173
```

#### Frontend Environment Variables

```bash
# Production
VITE_API_URL=https://your-backend-domain.com

# Development
VITE_API_URL=http://localhost:3001
```

### Configuration Files

#### Nginx Configuration (`nginx.conf`)

```nginx
events {
    worker_connections 1024;
}

http {
    upstream backend {
        server backend:3001;
    }

    server {
        listen 80;
        server_name localhost;

        # Frontend
        location / {
            root /usr/share/nginx/html;
            try_files $uri $uri/ /index.html;
        }

        # Backend API
        location /api/ {
            proxy_pass http://backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        # Health check
        location /health {
            proxy_pass http://backend;
            proxy_set_header Host $host;
        }
    }
}
```

## 📊 Monitoring & Health Checks

### Health Check Endpoints

- **Backend Health**: `GET /health`
- **Application Status**: `GET /api/status`
- **Application Info**: `GET /api/info`

### Monitoring Setup

#### Prometheus Metrics

Add to `backend/server.js`:

```javascript
const prometheus = require('prom-client');

// Create metrics
const httpRequestDurationMicroseconds = new prometheus.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code']
});

// Expose metrics endpoint
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', prometheus.register.contentType);
  res.end(await prometheus.register.metrics());
});
```

#### Grafana Dashboard

Create dashboard configuration for:
- Request rate and latency
- Error rates
- System metrics (CPU, memory)
- Custom business metrics

## 🔒 Security Considerations

### Production Security

1. **HTTPS Only**:
```nginx
# Redirect HTTP to HTTPS
server {
    listen 80;
    return 301 https://$server_name$request_uri;
}
```

2. **Security Headers**:
```javascript
// Backend security headers
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      scriptSrc: ["'self'"],
      imgSrc: ["'self'", "data:", "https:"],
    },
  },
}));
```

3. **Rate Limiting**:
```javascript
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});

app.use(limiter);
```

### Secrets Management

#### Using Environment Variables

```bash
# Production secrets
DATABASE_URL=postgresql://user:pass@host:port/db
JWT_SECRET=your-super-secret-key
API_KEYS=key1,key2,key3
```

#### Using Cloud Secret Managers

**AWS Secrets Manager**:
```javascript
const AWS = require('aws-sdk');
const secretsManager = new AWS.SecretsManager();

async function getSecret(secretName) {
  const data = await secretsManager.getSecretValue({ SecretId: secretName }).promise();
  return JSON.parse(data.SecretString);
}
```

## 🚀 CI/CD Pipeline Deployment

### GitHub Actions Deployment

#### Backend Deployment Workflow

Create `.github/workflows/deploy-backend.yml`:

```yaml
name: Deploy Backend

on:
  push:
    branches: [ master ]
    paths: [ 'backend/**' ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          
      - name: Install dependencies
        run: cd backend && npm ci
        
      - name: Run tests
        run: cd backend && npm test
        
      - name: Build Docker image
        run: docker build -t merge-guard-backend ./backend
        
      - name: Deploy to cloud
        run: |
          # Deploy to your cloud platform
          echo "Deploying backend..."
```

#### Frontend Deployment Workflow

Create `.github/workflows/deploy-frontend.yml`:

```yaml
name: Deploy Frontend

on:
  push:
    branches: [ master ]
    paths: [ 'frontend/**' ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          
      - name: Install dependencies
        run: cd frontend && npm ci
        
      - name: Run tests
        run: cd frontend && npm test
        
      - name: Build application
        run: cd frontend && npm run build
        
      - name: Deploy to cloud
        run: |
          # Deploy to your cloud platform
          echo "Deploying frontend..."
```

## 🔄 Rolling Updates & Rollbacks

### Blue-Green Deployment

1. **Deploy to Blue Environment**:
```bash
# Deploy new version to blue
kubectl apply -f blue-deployment.yaml
kubectl rollout status deployment/merge-guard-blue
```

2. **Switch Traffic**:
```bash
# Update service to point to blue
kubectl patch service merge-guard-service -p '{"spec":{"selector":{"version":"blue"}}}'
```

3. **Rollback if Needed**:
```bash
# Switch back to green
kubectl patch service merge-guard-service -p '{"spec":{"selector":{"version":"green"}}}'
```

### Canary Deployment

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: merge-guard-ingress
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: merge-guard-service
            port:
              number: 80
    annotations:
      nginx.ingress.kubernetes.io/canary: "true"
      nginx.ingress.kubernetes.io/canary-weight: "10"
```

## 📈 Scaling Strategies

### Horizontal Pod Autoscaling

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: merge-guard-backend-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: merge-guard-backend
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

### Load Balancing

```yaml
apiVersion: v1
kind: Service
metadata:
  name: merge-guard-service
spec:
  selector:
    app: merge-guard-backend
  ports:
  - protocol: TCP
    port: 80
    targetPort: 3001
  type: LoadBalancer
```

## 🛠️ Troubleshooting

### Common Issues

1. **Port Already in Use**:
```bash
# Find process using port
lsof -i :3001
# Kill process
kill -9 <PID>
```

2. **Docker Build Failures**:
```bash
# Clean Docker cache
docker system prune -a
# Rebuild without cache
docker build --no-cache -t merge-guard-backend ./backend
```

3. **Health Check Failures**:
```bash
# Check application logs
docker logs <container-id>
# Test health endpoint manually
curl -f http://localhost:3001/health
```

### Debug Mode

Enable debug output:

```bash
# Backend debug
DEBUG=* npm start

# Frontend debug
DEBUG=vite:* npm run dev

# Validation script debug
DEBUG=1 ./scripts/validate-merge-state.sh
```

This deployment guide provides comprehensive instructions for deploying the GitHub Safe Merge & Deploy Workflow demo to various environments while maintaining security, scalability, and observability best practices. 