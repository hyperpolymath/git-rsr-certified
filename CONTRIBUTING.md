# Contributing to RSR-Certified

Thank you for your interest in contributing to RSR-Certified! This document provides guidelines and information for contributors.

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## Getting Started

### Prerequisites

- Rust 1.75 or later
- Git
- Podman or Docker (for container builds)

### Development Setup

```bash
# Clone the repository
git clone https://github.com/Hyperpolymath/git-rsr-certified
cd git-rsr-certified

# Build all packages
cargo build

# Run tests
cargo test

# Run clippy
cargo clippy --all-targets --all-features

# Format code
cargo fmt
```

## How to Contribute

### Reporting Issues

Before creating an issue, please:

1. Search existing issues to avoid duplicates
2. Use the appropriate issue template
3. Provide as much detail as possible

### Pull Requests

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feat/my-feature`
3. **Make** your changes
4. **Test** your changes: `cargo test`
5. **Lint** your code: `cargo clippy && cargo fmt --check`
6. **Commit** with a descriptive message (see below)
7. **Push** to your fork
8. **Open** a Pull Request

### Commit Messages

We follow conventional commits:

```
type(scope): subject

body (optional)

footer (optional)
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting, no code change
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance tasks

**Scopes:**
- `engine`: Core compliance engine
- `lsp`: Language server
- `github`: GitHub adapter
- `gitlab`: GitLab adapter
- `bitbucket`: Bitbucket adapter
- `gitea`: Gitea/Forgejo adapter
- `ci`: CI/CD changes
- `container`: Container/Docker changes

**Examples:**
```
feat(engine): add support for custom compliance checks
fix(github): correct webhook signature verification
docs(readme): update installation instructions
```

## Development Guidelines

### Code Style

- Follow Rust idioms and best practices
- Run `cargo fmt` before committing
- Ensure `cargo clippy` passes without warnings
- Write documentation for public APIs

### Testing

- Write unit tests for new functionality
- Ensure all tests pass: `cargo test`
- Add integration tests for adapter changes
- Test webhook handling with mock payloads

### Documentation

- Update relevant documentation with code changes
- Add doc comments to public functions and types
- Update README if adding new features

## Project Structure

```
git-rsr-certified/
├── engine/          # Core compliance engine
│   └── src/
│       ├── compliance/  # Tier checks
│       ├── adapters/    # Platform adapters
│       ├── events/      # Event types
│       └── server/      # HTTP server
├── lsp/             # Language server
├── extensions/      # IDE extensions
├── container/       # Docker/Podman files
└── badges/          # Badge assets
```

## Adding New Compliance Checks

1. Identify the appropriate tier (bronze/silver/gold/rhodium)
2. Create a new check struct implementing `ComplianceCheck`
3. Add tests for the check
4. Register the check in the tier's `get_checks()` function
5. Update documentation

Example:

```rust
pub struct MyNewCheck;

#[async_trait]
impl ComplianceCheck for MyNewCheck {
    fn id(&self) -> &'static str { "tier.my_check" }
    fn name(&self) -> &'static str { "My New Check" }
    fn tier(&self) -> CertificationTier { CertificationTier::Silver }

    async fn check_local(&self, path: &Path) -> Result<CheckResult> {
        // Implementation
    }

    async fn check_remote(&self, contents: &RepoContents) -> Result<CheckResult> {
        // Implementation
    }
}
```

## Adding Platform Support

1. Create a new adapter file in `engine/src/adapters/`
2. Implement the `PlatformAdapter` trait
3. Add webhook parsing for platform events
4. Register in `AdapterFactory`
5. Add to container configuration
6. Update documentation

## Release Process

Releases are managed by maintainers. The process:

1. Update version in `Cargo.toml` files
2. Update CHANGELOG.md
3. Create a git tag: `git tag v0.x.x`
4. Push tag: `git push origin v0.x.x`
5. CI builds and publishes artifacts

## Getting Help

- Open an issue for bugs or feature requests
- Discussions for questions and ideas
- Check existing documentation

## License

By contributing, you agree that your contributions will be licensed under the same MIT/Apache-2.0 dual license as the project.
