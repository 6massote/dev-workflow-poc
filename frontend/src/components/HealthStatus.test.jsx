import { render, screen } from '@testing-library/react'
import { describe, it, expect } from 'vitest'
import HealthStatus from './HealthStatus'

describe('HealthStatus', () => {
  it('renders loading state', () => {
    render(<HealthStatus loading={true} />)
    expect(screen.getByText('Loading...')).toBeInTheDocument()
  })

  it('renders error state', () => {
    const error = 'Connection failed'
    render(<HealthStatus error={error} />)
    expect(screen.getByText('❌ Error')).toBeInTheDocument()
    expect(screen.getByText(error)).toBeInTheDocument()
  })

  it('renders unknown state', () => {
    render(<HealthStatus />)
    expect(screen.getByText('❓ Unknown')).toBeInTheDocument()
  })

  it('renders success state with health data', () => {
    const mockStatus = {
      status: 'ok',
      timestamp: Date.now(),
      version: '0.1.0',
      environment: 'development',
      uptime: 3600,
      memory: { heapUsed: 52428800 },
      pid: 12345
    }

    render(<HealthStatus status={mockStatus} />)
    expect(screen.getByText('✅ ok')).toBeInTheDocument()
    expect(screen.getByText('Environment:')).toBeInTheDocument()
    expect(screen.getByText('development')).toBeInTheDocument()
    expect(screen.getByText('Uptime:')).toBeInTheDocument()
    expect(screen.getByText('PID:')).toBeInTheDocument()
    expect(screen.getByText('12345')).toBeInTheDocument()
  })
}) 