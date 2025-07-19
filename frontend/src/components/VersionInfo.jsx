import React from 'react'

const VersionInfo = ({ status, loading, error }) => {
  if (loading) {
    return (
      <div className="space-y-4">
        <div className="animate-pulse">
          <div className="h-4 bg-gray-200 rounded w-3/4 mb-2"></div>
          <div className="h-4 bg-gray-200 rounded w-1/2 mb-2"></div>
          <div className="h-4 bg-gray-200 rounded w-2/3 mb-2"></div>
          <div className="h-4 bg-gray-200 rounded w-1/3"></div>
        </div>
      </div>
    )
  }

  if (error) {
    return (
      <div className="space-y-4">
        <div className="bg-red-50 border border-red-200 rounded-md p-4">
          <div className="flex">
            <div className="flex-shrink-0">
              <svg className="h-5 w-5 text-red-400" viewBox="0 0 20 20" fill="currentColor">
                <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clipRule="evenodd" />
              </svg>
            </div>
            <div className="ml-3">
              <h3 className="text-sm font-medium text-red-800">Error loading version info</h3>
              <div className="mt-2 text-sm text-red-700">{error}</div>
            </div>
          </div>
        </div>
      </div>
    )
  }

  if (!status) {
    return (
      <div className="space-y-4">
        <div className="bg-yellow-50 border border-yellow-200 rounded-md p-4">
          <div className="flex">
            <div className="flex-shrink-0">
              <svg className="h-5 w-5 text-yellow-400" viewBox="0 0 20 20" fill="currentColor">
                <path fillRule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
              </svg>
            </div>
            <div className="ml-3">
              <h3 className="text-sm font-medium text-yellow-800">Version info unavailable</h3>
              <div className="mt-2 text-sm text-yellow-700">Unable to fetch version information from the backend.</div>
            </div>
          </div>
        </div>
      </div>
    )
  }

  const formatBuildTime = (timestamp) => {
    return new Date(timestamp).toLocaleString()
  }

  return (
    <div className="space-y-4">
      <div className="grid grid-cols-1 gap-4">
        <div className="flex justify-between items-center py-2 border-b border-gray-200">
          <span className="text-sm font-medium text-gray-600">Frontend Version:</span>
          <span className="text-sm text-gray-900 font-mono">{status.version || '0.1.0'}</span>
        </div>
        
        <div className="flex justify-between items-center py-2 border-b border-gray-200">
          <span className="text-sm font-medium text-gray-600">Backend Version:</span>
          <span className="text-sm text-gray-900 font-mono">{status.version || '0.1.0'}</span>
        </div>
        
        <div className="flex justify-between items-center py-2 border-b border-gray-200">
          <span className="text-sm font-medium text-gray-600">Environment:</span>
          <span className="text-sm text-gray-900 capitalize">{status.environment || 'development'}</span>
        </div>
        
        <div className="flex justify-between items-center py-2">
          <span className="text-sm font-medium text-gray-600">Build Time:</span>
          <span className="text-sm text-gray-900">{formatBuildTime(status.timestamp)}</span>
        </div>
      </div>
      
      <div className="mt-6 p-4 bg-blue-50 rounded-md">
        <p className="text-xs text-blue-700 text-center">
          Versions are managed by release-please and semantic versioning
        </p>
      </div>
    </div>
  )
}

export default VersionInfo 