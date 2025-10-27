.PHONY: help build up down restart logs logs-follow install clean setup test run

HOST_UID := $(shell id -u)
HOST_GID := $(shell id -g)

# Dynamically extract service names from docker-compose.yml
SERVICES := $(shell docker compose config --services 2>/dev/null)
SERVICES_LIST := $(shell echo $(SERVICES) | tr ' ' '|')

# Project type detection
HAS_PACKAGE_JSON := $(shell test -f package.json && echo "true" || echo "false")
HAS_REQUIREMENTS_TXT := $(shell test -f requirements.txt && echo "true" || echo "false")
HAS_PYPROJECT_TOML := $(shell test -f pyproject.toml && echo "true" || echo "false")
HAS_PIPFILE := $(shell test -f Pipfile && echo "true" || echo "false")
HAS_GO_MOD := $(shell test -f go.mod && echo "true" || echo "false")
HAS_CARGO_TOML := $(shell test -f Cargo.toml && echo "true" || echo "false")

# Determine project type
PROJECT_TYPE := $(shell \
	if [ "$(HAS_PACKAGE_JSON)" = "true" ]; then echo "node"; \
	elif [ "$(HAS_REQUIREMENTS_TXT)" = "true" ] || [ "$(HAS_PYPROJECT_TOML)" = "true" ] || [ "$(HAS_PIPFILE)" = "true" ]; then echo "python"; \
	elif [ "$(HAS_GO_MOD)" = "true" ]; then echo "go"; \
	elif [ "$(HAS_CARGO_TOML)" = "true" ]; then echo "rust"; \
	else echo "unknown"; \
	fi)

# Default target
help:
	@echo "🔍 Detected project type: $(PROJECT_TYPE)"
	@echo ""
	@echo "🐳 Docker commands:"
	@echo "  make up              - Start all services"
	@echo "  make down            - Stop all services"
	@echo "  make restart         - Restart all services"
	@echo "  make build           - Build all services"
	@echo "  make logs [service]     - Show last 100 log lines (service: $(SERVICES_LIST))"
	@echo "  make logs-follow [service] - Follow logs in real-time (service: $(SERVICES_LIST))"
	@echo "  make status          - Show container status"
	@echo ""
	@echo "🛠️  Development commands:"
	@echo "  make install [service] - Install dependencies (service: $(SERVICES_LIST))"
	@echo "  make run [service]   - Open shell (service: $(SERVICES_LIST))"
	@echo "  make test [service]    - Run tests (service: $(SERVICES_LIST)|all) [--watch|--coverage]"
	@echo ""
	@echo "🧹 Utility commands:"
	@echo "  make clean           - Remove all containers and volumes"
	@echo "  make setup           - Complete development environment setup"
	@echo "  make detect          - Show project type detection details"
	@echo ""
	@echo "📝 Examples:"
	@echo "  make setup           - Complete setup"
	@echo "  make install $(word 1,$(SERVICES))"
	@echo "  make run $(word 1,$(SERVICES)) sh"
	@echo "  make test all        - Run all tests"
	@echo "  make test $(word 1,$(SERVICES)) --coverage"

# Docker Compose commands
up:
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose up -d

down:
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose down

restart:
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose restart

build:
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose build

logs:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose logs --tail=100; \
	else \
		HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose logs --tail=100 $(filter-out $@,$(MAKECMDGOALS)); \
	fi

logs-follow:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose logs -f; \
	else \
		HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose logs -f $(filter-out $@,$(MAKECMDGOALS)); \
	fi

status:
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose ps

install:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Please specify a service: make install [$(SERVICES_LIST)]"; \
	else \
		case "$(PROJECT_TYPE)" in \
		"node") \
			echo "📦 Installing Node.js dependencies..."; \
			HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose run --rm --user $(HOST_UID):$(HOST_GID) $(filter-out $@,$(MAKECMDGOALS)) sh -c "cd /app && npm install"; \
			;; \
		"python") \
			echo "🐍 Installing Python dependencies..."; \
			HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose run --rm --user $(HOST_UID):$(HOST_GID) $(filter-out $@,$(MAKECMDGOALS)) sh -c "cd /app && pip install -r requirements.txt"; \
			;; \
		"go") \
			echo "🐹 Installing Go dependencies..."; \
			HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose run --rm --user $(HOST_UID):$(HOST_GID) $(filter-out $@,$(MAKECMDGOALS)) sh -c "cd /app && go mod download"; \
			;; \
		"rust") \
			echo "🦀 Installing Rust dependencies..."; \
			HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose run --rm --user $(HOST_UID):$(HOST_GID) $(filter-out $@,$(MAKECMDGOALS)) sh -c "cd /app && cargo fetch"; \
			;; \
		*) \
			echo "❌ Unknown project type: $(PROJECT_TYPE)"; \
			echo "Available project types: node, python, go, rust"; \
			exit 1; \
			;; \
		esac; \
	fi

run:
	@if [ "$(words $(MAKECMDGOALS))" -lt 2 ]; then \
		echo "Usage: make run [service] [command ...]" && exit 1; \
	fi; \
	SERVICE=$(word 2,$(MAKECMDGOALS)); \
	CMD=$$(echo $(MAKECMDGOALS) | cut -d' ' -f3-); \
	[ -z "$$CMD" ] && CMD="sh"; \
	HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) \
	docker compose run -it --rm --user $(HOST_UID):$(HOST_GID) $$SERVICE bash -c "$$CMD"

test:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Please specify a service: make test [$(SERVICES_LIST)|all] [--watch|--coverage]"; \
	elif [ "$(filter-out $@,$(MAKECMDGOALS))" = "all" ]; then \
		echo "🧪 Running all tests..."; \
		for service in $(SERVICES); do \
			echo "📋 $$service tests:"; \
			case "$(PROJECT_TYPE)" in \
				"node") \
					HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose run --rm --user $(HOST_UID):$(HOST_GID) $$service sh -c "cd /app && npm test"; \
					;; \
				"python") \
					HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose run --rm --user $(HOST_UID):$(HOST_GID) $$service sh -c "cd /app && python -m pytest"; \
					;; \
				"go") \
					HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose run --rm --user $(HOST_UID):$(HOST_GID) $$service sh -c "cd /app && go test ./..."; \
					;; \
				"rust") \
					HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose run --rm --user $(HOST_UID):$(HOST_GID) $$service sh -c "cd /app && cargo test"; \
					;; \
			esac; \
		done; \
	else \
		service=$(word 1,$(filter-out $@,$(MAKECMDGOALS))); \
		option=$(word 2,$(filter-out $@,$(MAKECMDGOALS))); \
		case "$(PROJECT_TYPE)" in \
			"node") \
				if [ "$$option" = "--watch" ]; then \
					echo "👀 Running Node.js tests in watch mode..."; \
					HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose run --rm --user $(HOST_UID):$(HOST_GID) $$service sh -c "cd /app && npm run test:watch"; \
				elif [ "$$option" = "--coverage" ]; then \
					echo "📊 Running Node.js tests with coverage..."; \
					HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose run --rm --user $(HOST_UID):$(HOST_GID) $$service sh -c "cd /app && npm run test:coverage"; \
				else \
					echo "🧪 Running Node.js tests..."; \
					HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose run --rm --user $(HOST_UID):$(HOST_GID) $$service sh -c "cd /app && npm test"; \
				fi; \
				;; \
			"python") \
				if [ "$$option" = "--watch" ]; then \
					echo "👀 Running Python tests in watch mode..."; \
					HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose run --rm --user $(HOST_UID):$(HOST_GID) $$service sh -c "cd /app && python -m pytest --watch"; \
				elif [ "$$option" = "--coverage" ]; then \
					echo "📊 Running Python tests with coverage..."; \
					HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose run --rm --user $(HOST_UID):$(HOST_GID) $$service sh -c "cd /app && python -m pytest --cov"; \
				else \
					echo "🧪 Running Python tests..."; \
					HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose run --rm --user $(HOST_UID):$(HOST_GID) $$service sh -c "cd /app && python -m pytest"; \
				fi; \
				;; \
			"go") \
				if [ "$$option" = "--watch" ]; then \
					echo "👀 Running Go tests in watch mode..."; \
					HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose run --rm --user $(HOST_UID):$(HOST_GID) $$service sh -c "cd /app && go test ./... --watch"; \
				elif [ "$$option" = "--coverage" ]; then \
					echo "📊 Running Go tests with coverage..."; \
					HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose run --rm --user $(HOST_UID):$(HOST_GID) $$service sh -c "cd /app && go test ./... -cover"; \
				else \
					echo "🧪 Running Go tests..."; \
					HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose run --rm --user $(HOST_UID):$(HOST_GID) $$service sh -c "cd /app && go test ./..."; \
				fi; \
				;; \
			"rust") \
				if [ "$$option" = "--watch" ]; then \
					echo "👀 Running Rust tests in watch mode..."; \
					HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose run --rm --user $(HOST_UID):$(HOST_GID) $$service sh -c "cd /app && cargo watch -x test"; \
				elif [ "$$option" = "--coverage" ]; then \
					echo "📊 Running Rust tests with coverage..."; \
					HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose run --rm --user $(HOST_UID):$(HOST_GID) $$service sh -c "cd /app && cargo test --coverage"; \
				else \
					echo "🧪 Running Rust tests..."; \
					HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose run --rm --user $(HOST_UID):$(HOST_GID) $$service sh -c "cd /app && cargo test"; \
				fi; \
				;; \
			*) \
				echo "❌ Unknown project type: $(PROJECT_TYPE)"; \
				exit 1; \
				;; \
		esac; \
	fi

# Utility commands
clean:
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker compose down -v
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker system prune -f

# Project detection command
detect:
	@echo "🔍 Project Type Detection Results:"
	@echo "=================================="
	@echo "📦 package.json: $(HAS_PACKAGE_JSON)"
	@echo "🐍 requirements.txt: $(HAS_REQUIREMENTS_TXT)"
	@echo "🐍 pyproject.toml: $(HAS_PYPROJECT_TOML)"
	@echo "🐍 Pipfile: $(HAS_PIPFILE)"
	@echo "🐹 go.mod: $(HAS_GO_MOD)"
	@echo "🦀 Cargo.toml: $(HAS_CARGO_TOML)"
	@echo ""
	@echo "🎯 Detected project type: $(PROJECT_TYPE)"
	@echo ""
	@case "$(PROJECT_TYPE)" in \
	"node") \
		echo "📦 Node.js project detected"; \
		echo "   Commands: npm install, npm test, npm run test:watch, npm run test:coverage"; \
		;; \
	"python") \
		echo "🐍 Python project detected"; \
		echo "   Commands: pip install -r requirements.txt, python -m pytest, python -m pytest --cov"; \
		;; \
	"go") \
		echo "🐹 Go project detected"; \
		echo "   Commands: go mod download, go test ./..., go test ./... -cover"; \
		;; \
	"rust") \
		echo "🦀 Rust project detected"; \
		echo "   Commands: cargo fetch, cargo test, cargo watch -x test"; \
		;; \
	*) \
		echo "❓ Unknown project type"; \
		echo "   Supported: Node.js, Python, Go, Rust"; \
		;; \
	esac

# Complete development environment setup
setup:
	@echo "🔨 Building Docker images..."
	@make build
	@echo "📦 Installing dependencies for $(PROJECT_TYPE) project..."
	$(foreach service,$(SERVICES), \
		@echo "Installing dependencies for $(service)..."; \
		@make install $(service); \
	)
	@echo "🚀 Starting services..."
	@make up
	@echo "⏳ Waiting for services to start..."
	@sleep 5
	@echo "📊 Checking service status..."
	@make status
	@echo ""
	@echo "✅ Development environment ready!"
	@echo "🌐 Services available:"
	$(foreach service,$(SERVICES), \
		@echo "  - $(service)"; \
	)
	@echo ""
	@echo "💡 Use 'make logs [service]' to view logs"
	@echo "💡 Use 'make shell [service]' to open a shell"
	@echo "💡 Use 'make test [service]' to run tests"

# Catch-all targets
%:
	@: