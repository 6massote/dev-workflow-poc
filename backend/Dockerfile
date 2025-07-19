FROM node:18-alpine

WORKDIR /app

# Health check will use wget (built into Alpine) instead of curl

# Copy package files
COPY package*.json ./

# Install dependencies (production only)
RUN npm install --only=production

# Copy application code
COPY . .

# Expose port
EXPOSE 3001

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3001/health || exit 1

# Start application
CMD ["npm", "start"] 