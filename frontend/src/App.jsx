import React, { useState, useEffect } from 'react'
import VersionInfo from './components/VersionInfo'

function App() {
  const [backendStatus, setBackendStatus] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3001'

  useEffect(() => {
    const fetchBackendStatus = async () => {
      try {
        setLoading(true)
        setError(null)
        
        const response = await fetch(`${API_BASE_URL}/health`)
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`)
        }
        
        const data = await response.json()
        setBackendStatus(data)
      } catch (err) {
        console.error('Error fetching backend status:', err)
        setError(err.message)
      } finally {
        setLoading(false)
      }
    }

    // Initial fetch
    fetchBackendStatus()

    // Set up polling every 30 seconds
    const interval = setInterval(fetchBackendStatus, 30000)

    return () => clearInterval(interval)
  }, [API_BASE_URL])

  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center p-4">
      <div className="max-w-md w-full">
        <div className="bg-white rounded-lg shadow-lg p-6">
          <div className="text-center mb-6">
            <h1 className="text-2xl font-bold text-gray-900 mb-2">
              📦 Version Info
            </h1>
            <div className="flex items-center justify-center">
              <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                ✅ Up to Date
              </span>
            </div>
          </div>
          
          <VersionInfo 
            status={backendStatus} 
            loading={loading} 
            error={error} 
          />
        </div>
      </div>
    </div>
  )
}

export default App 