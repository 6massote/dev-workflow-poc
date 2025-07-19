.PHONY: help dev dev-build dev-down dev-logs prod prod-down clean test lint format

# Default target
help:
	@echo "GitHub Safe Merge & Deploy Workflow - Available Commands:"
	@echo ""
	@echo "Development (Docker):"
	@echo "  dev        - Start development environment"
	@echo "  dev-build  - Build and start development environment"
	@echo "  dev-down   - Stop development containers"
	@echo "  dev-logs   - View development logs"
	@echo ""
	@echo "Production (Docker):"
@echo "  prod       - Build and start production environment"
@echo "  prod-down  - Stop production containers"
@echo ""
	@echo "Utilities:"
	@echo "  clean      - Clean up Docker resources"
	@echo "  test       - Run all tests"
	@echo "  lint       - Run linting"
	@echo "  format     - Format code"

# Development commands
dev:
	docker-compose up

dev-build:
	docker-compose up --build

dev-down:
	docker-compose down

dev-logs:
	docker-compose logs -f

# Production commands
prod:
	docker-compose -f docker-compose.prod.yml up --build -d

prod-down:
	docker-compose -f docker-compose.prod.yml down



# Utility commands
clean:
	docker-compose down -v
	docker system prune -f

test:
	npm test

lint:
	npm run lint

format:
	npm run format 