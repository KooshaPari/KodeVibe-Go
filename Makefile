.PHONY: build clean test lint install run-cli run-server deps format

# Build variables
APP_NAME = kodevibe
VERSION = 1.0.0
BUILD_DIR = build
GO_FILES = $(shell find . -name '*.go' -not -path './vendor/*')

# Build the CLI binary
build-cli:
	@echo "Building KodeVibe CLI..."
	@mkdir -p $(BUILD_DIR)
	go build -ldflags "-X main.version=$(VERSION)" -o $(BUILD_DIR)/$(APP_NAME) ./cmd/cli

# Build the server binary
build-server:
	@echo "Building KodeVibe Server..."
	@mkdir -p $(BUILD_DIR)
	go build -ldflags "-X main.version=$(VERSION)" -o $(BUILD_DIR)/$(APP_NAME)-server ./cmd/server

# Build both binaries
build: build-cli build-server

# Build for multiple platforms
build-all:
	@echo "Building for multiple platforms..."
	@mkdir -p $(BUILD_DIR)
	# Linux AMD64
	GOOS=linux GOARCH=amd64 go build -ldflags "-X main.version=$(VERSION)" -o $(BUILD_DIR)/$(APP_NAME)-linux-amd64 ./cmd/cli
	# Linux ARM64
	GOOS=linux GOARCH=arm64 go build -ldflags "-X main.version=$(VERSION)" -o $(BUILD_DIR)/$(APP_NAME)-linux-arm64 ./cmd/cli
	# macOS AMD64
	GOOS=darwin GOARCH=amd64 go build -ldflags "-X main.version=$(VERSION)" -o $(BUILD_DIR)/$(APP_NAME)-darwin-amd64 ./cmd/cli
	# macOS ARM64 (Apple Silicon)
	GOOS=darwin GOARCH=arm64 go build -ldflags "-X main.version=$(VERSION)" -o $(BUILD_DIR)/$(APP_NAME)-darwin-arm64 ./cmd/cli
	# Windows AMD64
	GOOS=windows GOARCH=amd64 go build -ldflags "-X main.version=$(VERSION)" -o $(BUILD_DIR)/$(APP_NAME)-windows-amd64.exe ./cmd/cli

# Install dependencies
deps:
	@echo "Installing dependencies..."
	go mod tidy
	go mod download

# Run tests
test:
	@echo "Running tests..."
	go test -v ./...

# Run tests with coverage
test-coverage:
	@echo "Running tests with coverage..."
	go test -v -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out -o coverage.html

# Run benchmarks
benchmark:
	@echo "Running benchmarks..."
	go test -bench=. -benchmem ./...

# Lint code
lint:
	@echo "Running linters..."
	@if command -v golangci-lint >/dev/null 2>&1; then \
		golangci-lint run; \
	else \
		echo "golangci-lint not found, install with: go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest"; \
		go vet ./...; \
	fi

# Format code
format:
	@echo "Formatting code..."
	go fmt ./...
	@if command -v goimports >/dev/null 2>&1; then \
		goimports -w $(GO_FILES); \
	else \
		echo "goimports not found, install with: go install golang.org/x/tools/cmd/goimports@latest"; \
	fi

# Security scan
security:
	@echo "Running security scan..."
	@if command -v gosec >/dev/null 2>&1; then \
		gosec ./...; \
	else \
		echo "gosec not found, install with: go install github.com/securecodewarrior/gosec/v2/cmd/gosec@latest"; \
	fi

# Install the CLI binary
install: build-cli
	@echo "Installing KodeVibe CLI..."
	sudo cp $(BUILD_DIR)/$(APP_NAME) /usr/local/bin/

# Install locally (without sudo)
install-local: build-cli
	@echo "Installing KodeVibe CLI locally..."
	mkdir -p $$HOME/.local/bin
	cp $(BUILD_DIR)/$(APP_NAME) $$HOME/.local/bin/

# Run the CLI
run-cli: build-cli
	@echo "Running KodeVibe CLI..."
	./$(BUILD_DIR)/$(APP_NAME) $(ARGS)

# Run the server
run-server: build-server
	@echo "Running KodeVibe Server..."
	./$(BUILD_DIR)/$(APP_NAME)-server $(ARGS)

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(BUILD_DIR)
	rm -f coverage.out coverage.html

# Docker build
docker-build:
	@echo "Building Docker image..."
	docker build -t kodevibe:$(VERSION) .
	docker tag kodevibe:$(VERSION) kodevibe:latest

# Docker run
docker-run:
	@echo "Running KodeVibe in Docker..."
	docker run --rm -v $$(pwd):/workspace kodevibe:latest scan /workspace

# Create release
release: clean lint test build-all
	@echo "Creating release $(VERSION)..."
	mkdir -p release/$(VERSION)
	cp $(BUILD_DIR)/* release/$(VERSION)/
	tar -czf release/kodevibe-$(VERSION).tar.gz -C release/$(VERSION) .

# Development setup
dev-setup:
	@echo "Setting up development environment..."
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	go install golang.org/x/tools/cmd/goimports@latest
	go install github.com/securecodewarrior/gosec/v2/cmd/gosec@latest
	go install github.com/air-verse/air@latest

# Live reload for development
dev:
	@echo "Starting development server with live reload..."
	@if command -v air >/dev/null 2>&1; then \
		air; \
	else \
		echo "air not found, install with: make dev-setup"; \
		go run ./cmd/cli; \
	fi

# Generate documentation
docs:
	@echo "Generating documentation..."
	@if command -v godoc >/dev/null 2>&1; then \
		echo "Starting godoc server at http://localhost:6060"; \
		godoc -http=:6060; \
	else \
		echo "godoc not found, install with: go install golang.org/x/tools/cmd/godoc@latest"; \
	fi

# Check for vulnerabilities in dependencies
vuln-check:
	@echo "Checking for vulnerabilities..."
	@if command -v govulncheck >/dev/null 2>&1; then \
		govulncheck ./...; \
	else \
		echo "govulncheck not found, install with: go install golang.org/x/vuln/cmd/govulncheck@latest"; \
	fi

# Pre-commit checks
pre-commit: format lint test

# CI pipeline
ci: deps lint test security vuln-check build

# Show help
help:
	@echo "KodeVibe Build System"
	@echo ""
	@echo "Available targets:"
	@echo "  build          - Build CLI and server binaries"
	@echo "  build-cli      - Build CLI binary only"
	@echo "  build-server   - Build server binary only"
	@echo "  build-all      - Build for multiple platforms"
	@echo "  deps           - Install dependencies"
	@echo "  test           - Run tests"
	@echo "  test-coverage  - Run tests with coverage"
	@echo "  benchmark      - Run benchmarks"
	@echo "  lint           - Run linters"
	@echo "  format         - Format code"
	@echo "  security       - Run security scan"
	@echo "  install        - Install CLI binary system-wide"
	@echo "  install-local  - Install CLI binary locally"
	@echo "  run-cli        - Run CLI (ARGS=arguments)"
	@echo "  run-server     - Run server (ARGS=arguments)"
	@echo "  clean          - Clean build artifacts"
	@echo "  docker-build   - Build Docker image"
	@echo "  docker-run     - Run in Docker"
	@echo "  release        - Create release package"
	@echo "  dev-setup      - Setup development environment"
	@echo "  dev            - Start development server with live reload"
	@echo "  docs           - Generate documentation"
	@echo "  vuln-check     - Check for vulnerabilities"
	@echo "  pre-commit     - Run pre-commit checks"
	@echo "  ci             - Run CI pipeline"
	@echo "  help           - Show this help"

# Default target
.DEFAULT_GOAL := help