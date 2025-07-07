# 🌊 KodeVibe (Go Implementation)

**The Ultimate Code Quality Guardian** - A high-performance, comprehensive code quality tool built in Go that prevents bad vibes from entering your codebase.

## 🚀 Features

### 🎯 Complete Vibe Coverage
- **🔒 SecurityVibe**: 18+ secret patterns, vulnerability detection, entropy analysis
- **💎 CodeVibe**: Code smells, anti-patterns, complexity analysis, language-specific rules
- **⚡ PerformanceVibe**: N+1 queries, memory leaks, inefficient algorithms, bundle analysis
- **📁 FileVibe**: Junk files, large files, organization issues
- **🔀 GitVibe**: Commit quality, branch naming, merge conflict detection
- **📦 DependencyVibe**: Outdated packages, vulnerabilities, license compliance
- **📚 DocumentationVibe**: Missing docs, outdated documentation

### 🛠️ Complete Toolchain
- **CLI Interface**: Full-featured command line tool
- **HTTP REST API**: Comprehensive API with all endpoints
- **WebSocket Support**: Real-time scanning and updates
- **File Watching**: Live scanning with auto-fix
- **Auto-Fix Engine**: Intelligent code fixing
- **Multiple Report Formats**: Text, JSON, HTML, XML, JUnit, CSV
- **Git Hooks**: Pre-commit and pre-push validation
- **Performance Profiling**: Lighthouse, bundle analysis integration
- **Webhook Integration**: Slack, GitHub, Teams notifications

## 📦 Installation

### Quick Install (Binary)
```bash
# Download latest release
curl -sSL https://github.com/KooshaPari/KodeVibe/releases/latest/download/kodevibe-$(uname -s)-$(uname -m) -o kodevibe
chmod +x kodevibe
sudo mv kodevibe /usr/local/bin/
```

### Build from Source
```bash
git clone https://github.com/KooshaPari/KodeVibe-Go.git
cd KodeVibe-Go
make build
sudo make install
```

### Install Locally
```bash
make install-local  # Installs to ~/.local/bin/
```

## 🎯 Quick Start

### Basic Scanning
```bash
# Scan current directory
kodevibe scan

# Scan with specific vibes
kodevibe scan --vibes security,code,performance

# Scan specific paths
kodevibe scan src/ tests/ --exclude node_modules/

# CI/CD mode
kodevibe scan --ci --strict --format junit --output results.xml
```

### Git Hooks Setup
```bash
# Install configuration and git hooks
kodevibe install

# Install hooks only
kodevibe hooks install

# Test hooks
kodevibe hooks test
```

### File Watching
```bash
# Watch for changes and scan automatically
kodevibe watch src/ --auto-fix --vibes security,code

# Watch with specific configuration
kodevibe watch . --vibes all
```

### Auto-Fix
```bash
# Fix issues automatically
kodevibe fix --auto --backup

# Fix specific rules
kodevibe fix --rules no-console-log,strict-equality

# Interactive fixing
kodevibe fix src/
```

### HTTP Server
```bash
# Start server
kodevibe server --port 8080

# Start with TLS
kodevibe server --tls --cert cert.pem --key key.pem

# Start server in background
nohup kodevibe server &
```

## ⚙️ Configuration

### Basic Configuration (`.kodevibe.yaml`)
```yaml
# Project settings
project:
  type: web
  language: javascript
  framework: react

# Vibe configuration
vibes:
  security:
    enabled: true
    level: strict
  code:
    enabled: true
    level: moderate
    max_function_length: 50
    max_nesting_depth: 4
  performance:
    enabled: true
    level: moderate
    max_bundle_size: "2MB"

# File exclusions
exclude:
  files:
    - "node_modules/**/*"
    - ".git/**/*"
    - "coverage/**/*"
    - "*.min.js"
  patterns:
    - "*.test.*"
    - "*.spec.*"

# Custom rules
custom_rules:
  - name: "no-console-log"
    pattern: "console\\.log\\("
    message: "Remove console.log statements"
    severity: warning
```

### Advanced Configuration
```yaml
# Advanced settings
advanced:
  entropy_analysis: true
  entropy_threshold: 4.5
  cache_enabled: true
  cache_ttl: "1h"
  max_concurrency: 10
  timeout: "5m"

# Server configuration
server:
  host: "0.0.0.0"
  port: 8080
  tls: false
  auth:
    enabled: false
  rate_limit:
    enabled: true
    rps: 100

# Integrations
integrations:
  slack:
    enabled: true
    webhook_url: "${SLACK_WEBHOOK}"
  github:
    enabled: true
    token: "${GITHUB_TOKEN}"
```

## 🔧 CLI Commands

### Core Commands
```bash
kodevibe scan [paths...]              # Scan files for issues
kodevibe install                      # Install configuration and hooks
kodevibe hooks [install|uninstall|test] # Manage git hooks
kodevibe config [show|validate|init] # Manage configuration
kodevibe fix [paths...]               # Auto-fix issues
kodevibe watch [paths...]             # Watch files for changes
kodevibe server                       # Start HTTP server
```

### Scan Options
```bash
--vibes string[]        # Vibes to run (security,code,performance,file,git,dependency,documentation)
--exclude string[]      # File patterns to exclude
--min-severity string   # Minimum severity (error,warning,info)
--format string         # Output format (text,json,html,xml,junit,csv)
--output string         # Output file path
--ci                    # CI mode - exit with error code on issues
--strict                # Strict mode - fail on any issues
--staged                # Only scan staged files
--diff string           # Scan changes compared to commit/branch
--timeout int           # Timeout in seconds
--report                # Generate detailed HTML report
--cache                 # Enable caching (default: true)
```

### Fix Options
```bash
--auto                  # Auto-fix without prompting
--backup                # Create backup before fixing (default: true)
--rules string[]        # Specific rules to fix
```

### Watch Options
```bash
--auto-fix              # Automatically fix issues when detected
--vibes string[]        # Vibes to run on file changes
```

### Server Options
```bash
--host string           # Server host (default: localhost)
--port int              # Server port (default: 8080)
--tls                   # Enable TLS
--cert string           # TLS certificate file
--key string            # TLS private key file
--config string         # Configuration file path
```

## 🌐 HTTP API

### Scan Endpoints
```http
POST /api/v1/scan                    # Create new scan
GET  /api/v1/scan/:id                # Get scan result
GET  /api/v1/scans                   # List all scans
DELETE /api/v1/scan/:id              # Delete scan
```

### Configuration Endpoints
```http
GET  /api/v1/config                  # Get current configuration
PUT  /api/v1/config                  # Update configuration
POST /api/v1/config/validate         # Validate configuration
```

### Report Endpoints
```http
GET  /api/v1/reports                 # List reports
GET  /api/v1/report/:id              # Get specific report
POST /api/v1/report/:id/download     # Download report
```

### Vibe Endpoints
```http
GET  /api/v1/vibes                   # List available vibes
GET  /api/v1/vibe/:type              # Get vibe information
```

### Fix Endpoints
```http
POST /api/v1/fix                     # Start auto-fix operation
GET  /api/v1/fix/:id                 # Get fix result
```

### Watch Endpoints
```http
POST /api/v1/watch/start             # Start file watching
POST /api/v1/watch/stop              # Stop file watching
GET  /api/v1/watch/status            # Get watch status
```

### WebSocket
```http
GET  /ws                             # WebSocket connection for real-time updates
```

## 🏗️ Architecture

### Project Structure
```
kodevibe-go/
├── cmd/
│   ├── cli/main.go           # CLI application entry point
│   └── server/main.go        # Server application entry point
├── pkg/
│   ├── config/               # Configuration management
│   ├── scanner/              # Core scanning engine
│   ├── vibes/                # Individual vibe checkers
│   │   ├── security.go       # Security checks
│   │   ├── code.go           # Code quality checks
│   │   ├── performance.go    # Performance checks
│   │   └── ...
│   ├── report/               # Report generation
│   ├── fix/                  # Auto-fix engine
│   ├── watch/                # File watching
│   └── server/               # HTTP server
├── internal/
│   ├── models/               # Data structures
│   └── utils/                # Utility functions
├── go.mod                    # Go module definition
├── Makefile                  # Build automation
└── README.md                 # This file
```

### Core Components

#### Scanner Engine
- Concurrent vibe execution with semaphore control
- Caching system for performance
- Context-aware cancellation
- Metrics collection

#### Vibe Checkers
- **SecurityVibe**: Pattern-based secret detection, entropy analysis
- **CodeVibe**: AST-like analysis, complexity metrics, language-specific rules
- **PerformanceVibe**: Anti-pattern detection, bundle size analysis
- **FileVibe**: File organization, size checks, junk file detection

#### Auto-Fix Engine
- Rule-based fixing with confidence scoring
- Backup creation before modifications
- Validation of fixes to prevent breaking code
- Interactive and automatic modes

#### File Watcher
- Real-time file system monitoring
- Debouncing for performance
- Automatic scanning and fixing
- Integration with all vibes

## 🔧 Development

### Prerequisites
- Go 1.21 or later
- Make (for build automation)

### Development Setup
```bash
# Clone repository
git clone https://github.com/KooshaPari/KodeVibe-Go.git
cd KodeVibe-Go

# Install development tools
make dev-setup

# Install dependencies
make deps

# Run tests
make test

# Run with live reload
make dev
```

### Building
```bash
# Build all binaries
make build

# Build for multiple platforms
make build-all

# Build CLI only
make build-cli

# Build server only
make build-server
```

### Testing
```bash
# Run tests
make test

# Run tests with coverage
make test-coverage

# Run benchmarks
make benchmark

# Run security scan
make security

# Check for vulnerabilities
make vuln-check
```

### Code Quality
```bash
# Format code
make format

# Run linters
make lint

# Run all pre-commit checks
make pre-commit

# Run full CI pipeline
make ci
```

### Docker
```bash
# Build Docker image
make docker-build

# Run in Docker
make docker-run
```

## 📊 Performance

### Benchmarks
- **Small projects** (<1k files): ~1-3 seconds
- **Medium projects** (1k-10k files): ~5-15 seconds
- **Large projects** (10k+ files): ~30-90 seconds
- **Memory usage**: <100MB for most projects
- **Concurrency**: Configurable, default 10 concurrent vibes

### Optimizations
- Concurrent vibe execution
- File-level caching with TTL
- Efficient pattern matching with compiled regexes
- Streaming file processing
- Context-aware cancellation

## 🤝 Contributing

### Development Workflow
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and linting: `make pre-commit`
5. Submit a pull request

### Adding New Vibes
1. Create new vibe checker in `pkg/vibes/`
2. Implement the `Checker` interface
3. Register in `registry.go`
4. Add tests and documentation
5. Update configuration schema

### Adding Fix Rules
1. Add fix rule in `pkg/fix/fixer.go`
2. Include pattern, replacement, and validation
3. Add tests for the fix rule
4. Update documentation

## 📄 License

MIT License - Use freely in commercial and personal projects.

## 🔗 Links

- **GitHub**: https://github.com/KooshaPari/KodeVibe-Go
- **Documentation**: https://kodevibe.dev/docs
- **Issues**: https://github.com/KooshaPari/KodeVibe-Go/issues
- **Releases**: https://github.com/KooshaPari/KodeVibe-Go/releases

---

🌊 **Built with Go for maximum performance and reliability!**