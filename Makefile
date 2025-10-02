# Variables
PYTHON := python3
PIP := pip

# =============================================================================
# HELP
# =============================================================================

help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# =============================================================================
# INSTALLATION
# =============================================================================

install: ## Install package in production mode
	$(PYTHON) -m pip install --upgrade pip
	$(PYTHON) -m pip install -r requirements.txt

install-dev: install ## Install package with development dependencies
	$(PYTHON) -m pip install ruff mypy pytest pre-commit
	pre-commit install


clean: ## Clean up build artifacts and cache
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	find . -type d -name ".mypy_cache" -exec rm -rf {} +
	find . -type d -name ".ruff_cache" -exec rm -rf {} +
	find . -type d -name "htmlcov" -exec rm -rf {} +
	rm -rf build/ dist/

# =============================================================================
# CODE QUALITY
# =============================================================================

lint: ## Run linting tools
	ruff check src
	mypy src

format: ## Format code with ruff
	ruff format src

format-check: ## Check code formatting
	ruff format --check src

# =============================================================================
# TESTING
# =============================================================================

test: ## Run all tests (default)
	pytest -v

# =============================================================================
# AGENTCORE DEVELOPMENT
# =============================================================================

launch-local: ## Run AgentCore locally with disabled telemetry
	@echo "🧪 Running with AgentCore local runtime"
	agentcore launch --local --env OTEL_SDK_DISABLED=true

# =============================================================================
# DOCKER
# =============================================================================

docker-build: ## Build Docker image (handled by AgentCore)
	@echo "Docker build is handled by 'agentcore launch' command"
	@echo "Use 'make launch-local' instead"

docker-run: ## Run with AgentCore (replaces docker run)
	@echo "Use 'make launch-local' to run with AgentCore"

# =============================================================================
# PRE-COMMIT
# =============================================================================

pre-commit: ## Run pre-commit on all files
	pre-commit run --all-files

pre-commit-update: ## Update pre-commit hooks
	pre-commit autoupdate

# =============================================================================
# CI/CD HELPERS
# =============================================================================

ci-install: ## Install dependencies for CI
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt
	$(PIP) install pytest ruff mypy

ci-test: ## Run tests for CI
	pytest -v

ci-lint: ## Run linting for CI
	ruff check src --format=github
	mypy src
