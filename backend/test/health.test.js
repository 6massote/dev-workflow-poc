const request = require('supertest');
const app = require('../server');

describe('Health Check Endpoint', () => {
  test('GET /health should return 200 and health data', async () => {
    const response = await request(app).get('/health');
    
    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('status', 'ok');
    expect(response.body).toHaveProperty('timestamp');
    expect(response.body).toHaveProperty('version');
    expect(response.body).toHaveProperty('environment');
    expect(response.body).toHaveProperty('uptime');
    expect(response.body).toHaveProperty('memory');
    expect(response.body).toHaveProperty('pid');
    
    // Check data types
    expect(typeof response.body.timestamp).toBe('number');
    expect(typeof response.body.uptime).toBe('number');
    expect(typeof response.body.pid).toBe('number');
    expect(typeof response.body.memory).toBe('object');
  });

  test('GET /api/status should return 200 and status data', async () => {
    const response = await request(app).get('/api/status');
    
    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('name', 'merge-guard-demo-backend');
    expect(response.body).toHaveProperty('version');
    expect(response.body).toHaveProperty('environment');
    expect(response.body).toHaveProperty('timestamp');
    expect(response.body).toHaveProperty('endpoints');
    expect(response.body).toHaveProperty('features');
    
    // Check endpoints structure
    expect(response.body.endpoints).toHaveProperty('health');
    expect(response.body.endpoints).toHaveProperty('status');
    expect(response.body.endpoints).toHaveProperty('info');
    
    // Check features array
    expect(Array.isArray(response.body.features)).toBe(true);
    expect(response.body.features.length).toBeGreaterThan(0);
  });

  test('GET /api/info should return 200 and info data', async () => {
    const response = await request(app).get('/api/info');
    
    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('application');
    expect(response.body).toHaveProperty('description');
    expect(response.body).toHaveProperty('repository');
    expect(response.body).toHaveProperty('version');
    expect(response.body).toHaveProperty('nodeVersion');
    expect(response.body).toHaveProperty('platform');
    expect(response.body).toHaveProperty('architecture');
  });

  test('GET / should return 200 and root data', async () => {
    const response = await request(app).get('/');
    
    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('message');
    expect(response.body).toHaveProperty('version');
    expect(response.body).toHaveProperty('endpoints');
  });

  test('GET /nonexistent should return 404', async () => {
    const response = await request(app).get('/nonexistent');
    
    expect(response.status).toBe(404);
    expect(response.body).toHaveProperty('error', 'Not Found');
    expect(response.body).toHaveProperty('message');
    expect(response.body).toHaveProperty('availableEndpoints');
  });
}); 