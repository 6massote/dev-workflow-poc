import { render, screen } from '@testing-library/react'
import { describe, it, expect, vi } from 'vitest'
import App from './App'

// Mock the components
vi.mock('./components/HealthStatus', () => ({
  default: ({ status, loading, error }) => (
    <div data-testid="health-status">
      {loading && 'Loading...'}
      {error && `Error: ${error}`}
      {status && 'Status OK'}
    </div>
  )
}))

vi.mock('./components/ConnectionStatus', () => ({
  default: ({ status, loading, error }) => (
    <div data-testid="connection-status">
      {loading && 'Loading...'}
      {error && `Error: ${error}`}
      {status && 'Connected'}
    </div>
  )
}))

vi.mock('./components/VersionInfo', () => ({
  default: ({ status, loading, error }) => (
    <div data-testid="version-info">
      {loading && 'Loading...'}
      {error && `Error: ${error}`}
      {status && 'Version OK'}
    </div>
  )
}))

describe('App', () => {
  it('renders the main heading', () => {
    render(<App />)
    expect(screen.getByText(/GitHub Safe Merge & Deploy Workflow/i)).toBeInTheDocument()
  })

  it('renders the description', () => {
    render(<App />)
    expect(screen.getByText(/production-ready GitHub project/i)).toBeInTheDocument()
  })

  it('renders status components', () => {
    render(<App />)
    expect(screen.getByTestId('health-status')).toBeInTheDocument()
    expect(screen.getByTestId('connection-status')).toBeInTheDocument()
    expect(screen.getByTestId('version-info')).toBeInTheDocument()
  })

  it('renders features section', () => {
    render(<App />)
    expect(screen.getByText(/Features/i)).toBeInTheDocument()
    expect(screen.getByText(/Merge & Tag Validation/i)).toBeInTheDocument()
    expect(screen.getByText(/Automated Releases/i)).toBeInTheDocument()
  })

  it('renders endpoints section', () => {
    render(<App />)
    expect(screen.getByText(/Available Endpoints/i)).toBeInTheDocument()
    expect(screen.getByText(/GET \/health/i)).toBeInTheDocument()
  })
}) 