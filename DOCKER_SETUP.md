# Docker Setup & Usage

This document provides a comprehensive guide for using Docker with the GitHub Safe Merge & Deploy Workflow project.

## 🐳 Docker-First Development

The project is now configured to use Docker as the primary development environment, providing a consistent and isolated development experience.

## 📁 Docker Files Structure

```
dev-workflow-poc/
├── docker-compose.yml              # Development environment
├── docker-compose.prod.yml         # Production environment (local testing)
├── .dockerignore                   # Root Docker ignore
├── Makefile                        # Convenient commands
├── backend/
│   ├── Dockerfile                  # Production backend
│   ├── Dockerfile.dev              # Development backend
│   └── .dockerignore               # Backend Docker ignore
└── frontend/
    ├── Dockerfile                  # Production frontend (with serve)
    ├── Dockerfile.dev              # Development frontend
    └── .dockerignore               # Frontend Docker ignore
```

## 🚀 Quick Start with Docker

### Prerequisites
- Docker and Docker Compose installed
- Git with proper configuration

### Development Environment

```bash
# Clone the repository
git clone <your-repo-url>
cd dev-workflow-poc

# Start development environment
npm run dev

# Or build and start (first time)
npm run dev:build
```

**Access URLs:**
- Frontend: http://localhost:5173
- Backend: http://localhost:3001
- Health Check: http://localhost:3001/health

### Available Commands

```bash
# Development
npm run dev              # Start development environment
npm run dev:build        # Build and start (first time)
npm run dev:down         # Stop containers
npm run dev:logs         # View logs

# Production
npm run docker:prod      # Build and start production
npm run docker:clean     # Clean up Docker resources

# Alternative: Use Makefile
make help                # Show all available commands
make dev                 # Start development
make prod                # Start production
make clean               # Clean up resources
```

## 🔧 Docker Configuration Details

### Development Environment (`docker-compose.yml`)

**Features:**
- Hot reloading for both frontend and backend
- Volume mounting for live code changes
- Health checks for all services
- Network isolation between services
- Environment-specific configurations

**Services:**
- `backend`: Node.js Express server with nodemon
- `frontend`: React + Vite development server
- `merge-guard-network`: Isolated network for services

### Production Environment (`docker-compose.prod.yml`)

**Features:**
- Optimized production builds
- Simple and lightweight container configuration
- Health checks and monitoring
- Production-ready configurations
- Local testing environment

**Services:**
- `backend`: Production Node.js server
- `frontend`: Serve static React app

## 🛠️ Dockerfile Details

### Backend Dockerfiles

**Development (`backend/Dockerfile.dev`):**
- Includes all dependencies (dev + prod)
- Uses nodemon for hot reloading
- Includes curl for health checks
- Volume mounting for live changes

**Production (`backend/Dockerfile`):**
- Production dependencies only
- Optimized for size and security
- Health checks included
- Graceful shutdown handling

### Frontend Dockerfiles

**Development (`frontend/Dockerfile.dev`):**
- Vite development server
- Hot module replacement
- Host binding for container access
- Volume mounting for live changes

**Production (`frontend/Dockerfile`):**
- Multi-stage build for optimization
- Serve static files with Node.js serve
- Lightweight and simple configuration
- No external dependencies

## 🔒 Security Features

### Container Security

**Security Features:**
- Non-root containers
- Minimal attack surface
- Isolated network communication
- Health checks for monitoring

## 📊 Monitoring & Health Checks

### Health Check Endpoints

- **Backend**: `http://localhost:3001/health`
- **Frontend**: `http://localhost:3000/health`
- **Production**: `http://localhost:3000/health`

### Docker Health Checks

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:3001/health"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

## 🔄 Development Workflow

### 1. Start Development
```bash
npm run dev
```

### 2. Make Changes
- Edit code in your IDE
- Changes are automatically reflected due to volume mounting
- Hot reloading works for both frontend and backend

### 3. View Logs
```bash
npm run dev:logs
# or
make dev-logs
```

### 4. Stop Environment
```bash
npm run dev:down
# or
make dev-down
```

## 🚀 Production Deployment

### Local Production Testing
```bash
npm run docker:prod
```

### Production Features
- Optimized builds
- Simple and lightweight containers
- Health monitoring
- Minimal dependencies

## 🧹 Maintenance

### Clean Up Resources
```bash
npm run docker:clean
# or
make clean
```

### Rebuild Images
```bash
npm run dev:build
# or
make dev-build
```

### View Resource Usage
```bash
docker stats
```

## 🔧 Troubleshooting

### Common Issues

**Port Already in Use:**
```bash
# Find process using port
lsof -i :3001
# Kill process
kill -9 <PID>
```

**Docker Build Failures:**
```bash
# Clean Docker cache
docker system prune -a
# Rebuild without cache
docker-compose build --no-cache
```

**Container Won't Start:**
```bash
# Check logs
docker-compose logs <service-name>
# Check health status
docker-compose ps
```

### Debug Mode

**Backend Debug:**
```bash
docker-compose exec backend npm run dev
```

**Frontend Debug:**
```bash
docker-compose exec frontend npm run dev
```

## 📈 Performance Optimization

### Development Optimizations
- Volume mounting for instant changes
- Hot reloading for both services
- Network isolation for security
- Health checks for reliability

### Production Optimizations
- Multi-stage builds for smaller images
- Lightweight serve for static files
- Minimal container footprint
- Simple and maintainable configuration

## 🎯 Benefits of Docker-First Approach

1. **Consistency**: Same environment across all developers
2. **Isolation**: No conflicts with local Node.js versions
3. **Simplicity**: One command to start everything
4. **Production Parity**: Development matches production
5. **Scalability**: Easy to add more services
6. **Security**: Isolated network and minimal attack surface
7. **Performance**: Optimized builds and lightweight containers

This Docker setup provides a robust, scalable, and secure development environment that closely mirrors production deployment. 