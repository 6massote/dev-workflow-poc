const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3001;
const NODE_ENV = process.env.NODE_ENV || 'development';

// Security middleware
app.use(helmet());

// CORS configuration
app.use(cors({
  origin: process.env.FRONTEND_URL || 'http://localhost:5173',
  credentials: true
}));

// Logging middleware
if (NODE_ENV === 'development') {
  app.use(morgan('dev'));
} else {
  app.use(morgan('combined'));
}

// Body parsing middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Performance timing middleware
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    console.log(`${req.method} ${req.path} - ${res.statusCode} - ${duration}ms`);
  });
  next();
});

// Health check endpoint
app.get('/health', (req, res) => {
  const healthData = {
    status: 'ok',
    timestamp: Date.now(),
    version: process.env.npm_package_version || '0.1.0',
    environment: NODE_ENV,
    uptime: process.uptime(),
    memory: process.memoryUsage(),
    pid: process.pid
  };
  
  res.status(200).json(healthData);
});

// Application status endpoint
app.get('/api/status', (req, res) => {
  const statusData = {
    name: 'merge-guard-demo-backend',
    version: process.env.npm_package_version || '0.1.0',
    environment: NODE_ENV,
    timestamp: new Date().toISOString(),
    endpoints: {
      health: '/health',
      status: '/api/status',
      info: '/api/info'
    },
    features: [
      'GitHub Safe Merge & Deploy Workflow',
      'Merge state validation',
      'Automated releases',
      'Health monitoring'
    ]
  };
  
  res.status(200).json(statusData);
});

// Application info endpoint
app.get('/api/info', (req, res) => {
  const infoData = {
    application: 'GitHub Safe Merge & Deploy Workflow Demo',
    description: 'A production-ready GitHub project demonstrating secure PR merge and deployment workflows',
    repository: 'https://github.com/your-org/dev-workflow-poc',
    documentation: '/docs',
    version: process.env.npm_package_version || '0.1.0',
    nodeVersion: process.version,
    platform: process.platform,
    architecture: process.arch
  };
  
  res.status(200).json(infoData);
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'GitHub Safe Merge & Deploy Workflow - Backend API',
    version: process.env.npm_package_version || '0.1.0',
    endpoints: {
      health: '/health',
      status: '/api/status',
      info: '/api/info'
    }
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    error: 'Not Found',
    message: `Endpoint ${req.method} ${req.path} not found`,
    availableEndpoints: [
      'GET /',
      'GET /health',
      'GET /api/status',
      'GET /api/info'
    ]
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Error:', err);
  
  const errorResponse = {
    error: 'Internal Server Error',
    message: NODE_ENV === 'development' ? err.message : 'Something went wrong',
    timestamp: new Date().toISOString()
  };
  
  if (NODE_ENV === 'development') {
    errorResponse.stack = err.stack;
  }
  
  res.status(err.status || 500).json(errorResponse);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully');
  server.close(() => {
    console.log('Process terminated');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  console.log('SIGINT received, shutting down gracefully');
  server.close(() => {
    console.log('Process terminated');
    process.exit(0);
  });
});

// Start server
const server = app.listen(PORT, () => {
  console.log(`🚀 Backend server running on port ${PORT}`);
  console.log(`📊 Health check available at http://localhost:${PORT}/health`);
  console.log(`🔧 Environment: ${NODE_ENV}`);
  console.log(`📦 Version: ${process.env.npm_package_version || '0.1.0'}`);
});

module.exports = app; 