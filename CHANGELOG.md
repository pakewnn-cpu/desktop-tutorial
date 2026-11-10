# Changelog

All notable changes to this project are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- Added a one-click config backup script (`scripts/backup-config.sh`) that snapshots your git identity and Ollama settings into a timestamped tarball, excluding model weights.
- Added a real terminal screenshot of `ollama list` to the local-models guide (`docs/images/ollama-list.png`) so the step is easier to follow.
- Added a "command not found" entry to the FAQ (`docs/05-faq.md`) for the common case where the `ollama` command is missing right after install.

## [0.1.0] - 2026-11-10

### Added
- Initialized the repo and replaced the default GitHub README.
- Added the Mac AI desktop setup tutorial (`docs/`).
- Added a one-command install script (`scripts/setup.sh`).
- Added the MIT license and `.gitignore`.
- Added a CI check (`.github/workflows/ci.yml`).
- Added a contribution guide (`CONTRIBUTING.md`) for issues and pull requests.
- Added a FAQ (`docs/05-faq.md`) and filled in the "Requirements" and "FAQ"
  sections of the README.
- Added a health-check script (`scripts/check-model.sh`) to verify the local model is online.

### Changed
- Wrote all tutorial and project docs in English and tidied the layout.
