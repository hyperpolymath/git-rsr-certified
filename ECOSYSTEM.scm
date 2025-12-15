;; SPDX-License-Identifier: AGPL-3.0-or-later
;; SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell
;; ECOSYSTEM.scm — git-rsr-certified

(ecosystem
  (version "1.0.0")
  (name "git-rsr-certified")
  (type "project")
  (purpose "*Universal Rhodium Standard Repository Compliance Engine*")

  (position-in-ecosystem
    "Part of hyperpolymath ecosystem. Follows RSR guidelines.")

  (related-projects
    (project (name "rhodium-standard-repositories")
             (url "https://github.com/hyperpolymath/rhodium-standard-repositories")
             (relationship "standard")))

  (what-this-is "*Universal Rhodium Standard Repository Compliance Engine*")
  (what-this-is-not "- NOT exempt from RSR compliance"))
