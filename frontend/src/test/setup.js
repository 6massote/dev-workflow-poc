import '@testing-library/jest-dom'

// Mock fetch for API tests
global.fetch = jest.fn()

// Mock environment variables
import.meta.env = {
  VITE_API_URL: 'http://localhost:3001'
} 