;; git-rsr-certified - Guix Package Definition
;; Run: guix shell -D -f guix.scm

(use-modules (guix packages)
             (guix gexp)
             (guix git-download)
             (guix build-system cargo)
             ((guix licenses) #:prefix license:)
             (gnu packages base))

(define-public git_rsr_certified
  (package
    (name "git-rsr-certified")
    (version "0.1.0")
    (source (local-file "." "git-rsr-certified-checkout"
                        #:recursive? #t
                        #:select? (git-predicate ".")))
    (build-system cargo-build-system)
    (synopsis "Universal Rhodium Standard Repository Compliance Engine")
    (description "RSR-Certified is a compliance checking engine that verifies git
repositories against the Rhodium Standard Repository (RSR) framework.  It supports
multiple platforms (GitHub, GitLab, Bitbucket, Gitea/Forgejo) and checks compliance
across Bronze, Silver, Gold, and Rhodium tiers.  Features include webhook-based
real-time monitoring, badge generation, and an LSP server for editor integration.")
    (home-page "https://github.com/hyperpolymath/git-rsr-certified")
    (license license:agpl3+)))

;; Return package for guix shell
git_rsr_certified
