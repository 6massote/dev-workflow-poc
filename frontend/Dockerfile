FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build application
RUN npm run build

# Production stage
FROM node:18-alpine

# Install serve for static file serving
RUN npm install -g serve

# Copy built files
COPY --from=builder /app/dist /app/dist

# Expose port
EXPOSE 3000

# Start serve
CMD ["serve", "-s", "/app/dist", "-l", "3000"] 