{
  description = "RSR-Certified: Universal Rhodium Standard Repository Compliance Engine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "rust-analyzer" ];
          targets = [ "x86_64-unknown-linux-musl" "aarch64-unknown-linux-musl" ];
        };

        # Common build inputs
        buildInputs = with pkgs; [
          openssl
          pkg-config
        ];

        # Development tools
        devTools = with pkgs; [
          # Rust
          rustToolchain
          cargo-watch
          cargo-audit
          cargo-outdated
          cargo-release

          # Build tools
          just

          # Containers
          podman
          podman-compose

          # Database CLIs
          redis  # For DragonflyDB (redis-cli compatible)

          # Development utilities
          jq
          curl
          httpie

          # Git
          git
          git-lfs

          # Documentation
          mdbook
        ];

      in {
        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = buildInputs ++ devTools;

          shellHook = ''
            echo "🔷 RSR-Certified Development Environment"
            echo ""
            echo "Available commands:"
            echo "  just --list     - Show all available tasks"
            echo "  just build      - Build the project"
            echo "  just test       - Run tests"
            echo "  just check      - Check RSR compliance"
            echo "  just serve      - Run the server"
            echo "  just compose-up - Start full stack"
            echo ""
            export RUST_BACKTRACE=1
            export RUST_LOG=info
          '';
        };

        # Package
        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "rsr-certified";
          version = "0.1.0";

          src = ./.;

          cargoLock = {
            lockFile = ./Cargo.lock;
          };

          nativeBuildInputs = with pkgs; [ pkg-config ];
          buildInputs = buildInputs;

          meta = with pkgs.lib; {
            description = "Universal Rhodium Standard Repository Compliance Engine";
            homepage = "https://github.com/Hyperpolymath/git-rsr-certified";
            license = with licenses; [ mit asl20 ];
            maintainers = [];
          };
        };

        # Container image
        packages.container = pkgs.dockerTools.buildLayeredImage {
          name = "rsr-certified";
          tag = "latest";

          contents = [
            self.packages.${system}.default
            pkgs.cacert
            pkgs.git
          ];

          config = {
            Cmd = [ "rsr" "serve" "--host" "0.0.0.0" "--port" "8080" ];
            ExposedPorts = {
              "8080/tcp" = {};
            };
            Env = [
              "RSR_LOG_LEVEL=info"
              "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
            ];
          };
        };

        # Apps
        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/rsr";
        };

        apps.lsp = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/rsr-lsp";
        };
      }
    );
}
