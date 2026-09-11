const request = require('supertest');
const { app } = require('./server');

describe('CORS configuration', () => {
  it('should include CORS headers on a simple request', async () => {
    const response = await request(app)
      .get('/health')
      .set('Origin', 'http://localhost:54529');

    expect(response.headers['access-control-allow-origin']).toBe('*');
    expect(response.status).toBe(200);
  });
});
