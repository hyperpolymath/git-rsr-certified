;;; STATE.scm - RSR-Certified Project State
;;; Format: Guile Scheme (homoiconic, human-readable)
;;; Spec: https://github.com/hyperpolymath/state.scm

;;;============================================================================
;;; METADATA
;;;============================================================================

(define-module (state rsr-certified)
  #:export (project-state))

(define metadata
  '((format-version . "1.0")
    (created . "2025-12-08")
    (last-updated . "2025-12-08")
    (project-name . "rsr-certified")
    (project-version . "0.1.0-dev")
    (repository . "hyperpolymath/git-rsr-certified")))

;;;============================================================================
;;; CURRENT POSITION
;;;============================================================================

(define current-position
  '((summary . "Universal repository compliance engine with 17 checks implemented across 4 tiers. Core CLI functional, webhook server scaffolded but not integrated.")

    (completion-overview
     ((core-engine . 80)
      (platform-integrations . 60)
      (database-layer . 75)
      (api-server . 40)
      (testing . 0)
      (documentation . 65)
      (overall . 50)))

    (what-works
     ("CLI tool: rsr check, rsr init, rsr badge commands"
      "All 17 compliance checks (Bronze/Silver/Gold/Rhodium tiers)"
      "Local repository scanning with gix"
      "Badge SVG generation with tier colors"
      ".rsr.toml configuration templating"
      "GitHub webhook signature verification"
      "GitHub event parsing (push, PR, issues)"
      "Database adapter structure (Dragonfly, Surreal, Arango)"
      "Multi-stage container build (Alpine 3.19)"
      "Structured logging with tracing"))

    (what-doesnt-work
     ("API endpoints return hardcoded responses (not connected to DB)"
      "Webhook events not queued for async processing"
      "GitLab/Bitbucket/Gitea adapters are stubs"
      "LSP server commands not integrated with engine"
      "VS Code extension not connected to LSP"
      "Worker mode not implemented"
      "Metrics endpoint returns placeholder data"))

    (architecture-state
     ((engine . "4750 LOC Rust, well-structured")
      (database . "3-database design: cache/documents/graphs")
      (deployment . "Docker Compose with 5 services")
      (cli . "clap-based, functional")
      (lsp . "tower-lsp scaffold, commands stubbed")))))

;;;============================================================================
;;; ROUTE TO MVP v1
;;;============================================================================

(define mvp-v1-route
  '((definition . "Functional webhook server that processes GitHub events, runs compliance checks, stores results, and returns accurate API responses")

    (critical-path
     ((phase-1 "Database Integration"
       ((task "Wire API endpoints to database layer")
        (files ("engine/src/server/routes.rs"))
        (todos (65 96 144))
        (effort . "medium")
        (blocking . #t)))

      (phase-2 "Async Job Queue"
       ((task "Implement webhook -> queue -> worker flow")
        (files ("engine/src/server/routes.rs" "engine/src/main.rs"))
        (todos (243))
        (effort . "medium")
        (blocking . #t)))

      (phase-3 "Test Foundation"
       ((task "Add unit tests for compliance checks")
        (files ("engine/src/compliance/*.rs"))
        (effort . "large")
        (blocking . #t)))

      (phase-4 "Platform Adapters"
       ((task "Complete GitLab, Bitbucket, Gitea webhook parsing")
        (files ("engine/src/adapters/*.rs"))
        (todos (40 55 57 86))
        (effort . "medium")
        (blocking . #f)))))

    (mvp-v1-checklist
     (("Database stores compliance results" . pending)
      ("API returns real data from database" . pending)
      ("Webhooks queued and processed async" . pending)
      ("GitHub integration end-to-end working" . pending)
      ("Core compliance checks have unit tests" . pending)
      ("Container builds and runs successfully" . done)
      ("CLI tool functional for local repos" . done)))))

;;;============================================================================
;;; KNOWN ISSUES
;;;============================================================================

(define issues
  '((critical
     ((issue "Zero test coverage"
       (impact . "Cannot safely refactor or verify correctness")
       (location . "entire codebase")
       (resolution . "Add comprehensive test suite"))

      (issue "API endpoints disconnected from database"
       (impact . "Server returns fake data")
       (location . "engine/src/server/routes.rs:65,96,144")
       (resolution . "Implement database queries in handlers"))

      (issue "Webhook processing not async"
       (impact . "Requests block, no job queue")
       (location . "engine/src/server/routes.rs:243")
       (resolution . "Implement DragonflyDB-based job queue"))))

    (moderate
     ((issue "Platform adapters incomplete"
       (impact . "Only GitHub fully supported")
       (locations ("engine/src/adapters/gitlab.rs:57"
                   "engine/src/adapters/bitbucket.rs:40,55"
                   "engine/src/adapters/gitea.rs:86"))
       (resolution . "Implement webhook parsing for each platform"))

      (issue "LSP commands not integrated"
       (impact . "IDE extension non-functional")
       (locations ("lsp/src/main.rs:97,112,120"))
       (resolution . "Connect LSP handlers to compliance engine"))

      (issue "Metrics placeholder only"
       (impact . "No observability")
       (location . "engine/src/server/routes.rs:21")
       (resolution . "Implement Prometheus metrics collection"))))

    (minor
     ((issue "VS Code extension not connected"
       (impact . "Extension scaffold unusable")
       (locations ("extensions/vscode/src/extension.ts:298,354"))
       (resolution . "Integrate with LSP server"))))))

;;;============================================================================
;;; QUESTIONS FOR MAINTAINER
;;;============================================================================

(define questions
  '((architecture
     ("Should the worker be a separate binary or a mode of the main binary?"
      "Is DragonflyDB the right choice for job queue, or should we use a dedicated queue like RabbitMQ?"
      "Should compliance results be cached with TTL or stored permanently?"))

    (scope
     ("Is MVP v1 GitHub-only, or do we need GitLab/Bitbucket too?"
      "Should the LSP/IDE integration be part of v1 or deferred?"
      "What's the minimum test coverage target for v1?"))

    (deployment
     ("Is the 3-database architecture (Dragonfly+Surreal+Arango) still the plan, or should we simplify?"
      "Should we support self-hosted deployment from v1?"
      "Is there a timeline or deadline for v1?"))

    (compliance-framework
     ("Are the current 17 checks the final set for v1?"
      "Should compliance checks be configurable/disableable per-repo?"
      "Should we support custom compliance rules in v1?"))))

;;;============================================================================
;;; LONG-TERM ROADMAP
;;;============================================================================

(define roadmap
  '((v0.1.0-mvp "Foundation"
     ((status . in-progress)
      (target . "Q1 2025")
      (goals
       ("GitHub webhook integration end-to-end"
        "All 17 compliance checks functional"
        "API returns accurate compliance status"
        "Badge generation working"
        "Basic test coverage (>60%)"
        "Container deployment working"))))

    (v0.2.0 "Platform Expansion"
     ((status . planned)
      (goals
       ("GitLab full support"
        "Bitbucket full support"
        "Gitea/Forgejo full support"
        "Platform-specific badge embedding"
        "Multi-repo dashboard"))))

    (v0.3.0 "IDE Integration"
     ((status . planned)
      (goals
       ("VS Code extension published"
        "Neovim LSP integration"
        "Real-time compliance feedback"
        "Quick-fix suggestions"
        "Inline diagnostics"))))

    (v0.4.0 "Enterprise Features"
     ((status . future)
      (goals
       ("Organization-wide policies"
        "Custom compliance rules"
        "Compliance trends/history"
        "RBAC and team management"
        "SSO integration"))))

    (v1.0.0 "Production Ready"
     ((status . future)
      (goals
       ("All platforms stable"
        "Comprehensive documentation"
        "Performance optimized"
        "Security audited"
        "SLA guarantees"
        "Enterprise support tier"))))))

;;;============================================================================
;;; PROJECT CATALOG
;;;============================================================================

(define project-catalog
  '((component "Compliance Engine"
     ((status . in-progress)
      (completion . 80)
      (category . core)
      (files ("engine/src/compliance/*.rs" "engine/src/lib.rs"))
      (blockers . none)
      (next-action . "Add unit tests for each check")))

    (component "Platform Adapters"
     ((status . in-progress)
      (completion . 60)
      (category . integration)
      (files ("engine/src/adapters/*.rs"))
      (blockers ("GitLab/Bitbucket/Gitea parsing incomplete"))
      (next-action . "Implement GitLab webhook parsing")))

    (component "HTTP Server"
     ((status . blocked)
      (completion . 40)
      (category . api)
      (files ("engine/src/server/*.rs"))
      (blockers ("Endpoints not connected to database"
                 "Job queue not implemented"))
      (next-action . "Wire status endpoint to database")))

    (component "Database Layer"
     ((status . in-progress)
      (completion . 75)
      (category . infrastructure)
      (files ("engine/src/db/*.rs"))
      (blockers . none)
      (next-action . "Add compliance result storage methods")))

    (component "CLI Tool"
     ((status . complete)
      (completion . 95)
      (category . interface)
      (files ("engine/src/main.rs"))
      (blockers . none)
      (next-action . "Add --json output flag")))

    (component "LSP Server"
     ((status . blocked)
      (completion . 30)
      (category . ide)
      (files ("lsp/src/main.rs"))
      (blockers ("Commands not integrated with engine"))
      (next-action . "Connect check command to compliance engine")))

    (component "VS Code Extension"
     ((status . blocked)
      (completion . 20)
      (category . ide)
      (files ("extensions/vscode/src/*.ts"))
      (blockers ("LSP not functional" "Not connected to backend"))
      (next-action . "Wait for LSP completion")))

    (component "Container/Deploy"
     ((status . complete)
      (completion . 90)
      (category . operations)
      (files ("container/*" "flake.nix"))
      (blockers . none)
      (next-action . "Add health check for worker")))

    (component "Documentation"
     ((status . in-progress)
      (completion . 65)
      (category . docs)
      (files ("docs/*" "README.md" "CONTRIBUTING.md"))
      (blockers . none)
      (next-action . "Add API documentation")))

    (component "Test Suite"
     ((status . not-started)
      (completion . 0)
      (category . quality)
      (files . none)
      (blockers ("No tests written yet"))
      (next-action . "Create test infrastructure and first tests")))))

;;;============================================================================
;;; CRITICAL NEXT ACTIONS
;;;============================================================================

(define next-actions
  '((priority-1 "Implement database integration for API endpoints"
     ((component . "HTTP Server")
      (file . "engine/src/server/routes.rs")
      (reason . "Core functionality blocked without this")))

    (priority-2 "Add compliance check unit tests"
     ((component . "Test Suite")
      (reason . "Cannot verify correctness or safely refactor")))

    (priority-3 "Implement async job queue for webhooks"
     ((component . "HTTP Server")
      (reason . "Production readiness requires non-blocking webhook handling")))

    (priority-4 "Complete GitLab adapter"
     ((component . "Platform Adapters")
      (file . "engine/src/adapters/gitlab.rs")
      (reason . "Second most popular git platform")))

    (priority-5 "Wire LSP commands to engine"
     ((component . "LSP Server")
      (file . "lsp/src/main.rs")
      (reason . "IDE integration is key differentiator")))))

;;;============================================================================
;;; DEPENDENCIES & TECH STACK
;;;============================================================================

(define tech-stack
  '((language . "Rust 1.75+")
    (async-runtime . "tokio 1.35")
    (http-framework . "axum 0.8")
    (git-operations . "gix 0.75")
    (cli . "clap 4.4")
    (lsp . "tower-lsp 0.20")
    (databases
     ((cache . "DragonflyDB via redis crate")
      (documents . "SurrealDB")
      (graphs . "ArangoDB")))
    (container . "Alpine 3.19, multi-stage build")
    (ci . "GitHub Actions")))

;;;============================================================================
;;; SESSION CONTEXT
;;;============================================================================

(define session-context
  '((session-id . "01EzKA9J53yCpgFQeSeUvFbM")
    (branch . "claude/create-state-scm-01EzKA9J53yCpgFQeSeUvFbM")
    (date . "2025-12-08")
    (actions-taken
     ("Comprehensive codebase analysis"
      "Identified all TODOs and blockers"
      "Created STATE.scm checkpoint"))
    (context-for-next-session
     ("Focus on database integration in routes.rs"
      "Clarify MVP scope with maintainer"
      "Consider test infrastructure setup"))))

;;;============================================================================
;;; EXPORT
;;;============================================================================

(define project-state
  `((metadata . ,metadata)
    (current-position . ,current-position)
    (mvp-v1-route . ,mvp-v1-route)
    (issues . ,issues)
    (questions . ,questions)
    (roadmap . ,roadmap)
    (project-catalog . ,project-catalog)
    (next-actions . ,next-actions)
    (tech-stack . ,tech-stack)
    (session-context . ,session-context)))

;;; End of STATE.scm
