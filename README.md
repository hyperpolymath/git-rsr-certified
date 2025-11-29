# RSR-Certified

**Universal Rhodium Standard Repository Compliance Engine**

[![RSR Certification](badges/silver.svg)](https://rsr-certified.dev)
[![License](https://img.shields.io/badge/license-MIT%2FApache--2.0-blue.svg)](LICENSE)

One compliance engine. Every git platform. Universal repository excellence.

## What is RSR?

RSR (Rhodium Standard Repository) is a tiered certification framework for software repositories. It defines clear, measurable standards for repository quality across:

- **Bronze** - Foundation: LICENSE, README, .gitignore, no secrets
- **Silver** - Established: CONTRIBUTING, SECURITY policy, CI/CD, changelog
- **Gold** - Excellence: Documentation, test coverage, dependency scanning
- **Rhodium** - Exemplary: SBOM, reproducible builds, SLSA compliance

## Features

- **Universal Platform Support** - GitHub, GitLab, Bitbucket, Gitea/Forgejo
- **Containerized Deployment** - Run anywhere with Podman or Docker
- **IDE Integration** - LSP server for VS Code, Neovim, and more
- **CLI Tool** - Check compliance locally before pushing
- **Webhook Server** - Automatic checks on push/PR events
- **Badge Generation** - Show your certification proudly

## Quick Start

### Check Local Repository

```bash
# Install the CLI
cargo install rsr-engine

# Check compliance
rsr check .

# Initialize configuration
rsr init --tier silver
```

### Run with Docker/Podman

```bash
# Pull and run
podman run -p 8080:8080 ghcr.io/hyperpolymath/rsr-certified:latest

# Or use compose
cd container && podman-compose up -d
```

### Check a Remote Repository

```bash
# Via API
curl https://rsr-certified.dev/api/v1/repo/owner/repo/status
```

## Configuration

Create `.rsr.toml` in your repository root:

```toml
[compliance]
target_tier = "gold"
strict_mode = false

[checks]
license.required = true
license.allowed = ["MIT", "Apache-2.0"]
readme.min_length = 100

[ignore]
paths = ["vendor/", "node_modules/"]
```

## Certification Tiers

| Tier | Symbol | Requirements |
|------|--------|--------------|
| **Rhodium** | ◆ RSR-Rh | Full compliance + SBOM + SLSA + threat model |
| **Gold** | ★ RSR-Au | Full compliance + docs + coverage + security scanning |
| **Silver** | ☆ RSR-Ag | Core compliance + CONTRIBUTING + CI/CD + SECURITY |
| **Bronze** | ● RSR-Cu | LICENSE + README + .gitignore + no secrets |

## Architecture

```
┌─────────────────────────────────────────────────┐
│              RSR-CERTIFIED ENGINE               │
├─────────────────────────────────────────────────┤
│  GitHub │ GitLab │ Bitbucket │ Gitea/Forgejo   │
│    ↓        ↓         ↓           ↓            │
│        Universal Event Translator               │
│                    ↓                            │
│            Compliance Engine                    │
│         ↙        ↓         ↘                   │
│    Badges    Reports    IDE/LSP                │
└─────────────────────────────────────────────────┘
```

## Installation

### From Source

```bash
git clone https://github.com/Hyperpolymath/git-rsr-certified
cd git-rsr-certified
cargo build --release
```

### From Cargo

```bash
cargo install rsr-engine
```

### As GitHub App

Visit [github.com/apps/rsr-certified](https://github.com/apps/rsr-certified) to install.

## IDE Extensions

- **VS Code**: Search "RSR Certified" in extensions
- **Neovim**: Use any LSP client with `rsr-lsp`
- **Emacs**: Configure `lsp-mode` or `eglot` with `rsr-lsp`

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Security

See [SECURITY.md](SECURITY.md) for our security policy.

## License

Dual-licensed under [MIT](LICENSE-MIT) or [Apache-2.0](LICENSE-APACHE) at your option.

---

**RSR-Certified** - Raising the bar for repository excellence, everywhere.
