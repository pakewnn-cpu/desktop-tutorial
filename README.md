# 🖥️ desktop-tutorial · Building a local AI desktop on macOS

> A self-taught developer's hands-on guide to setting up a "desktop AI assistant +
> local large model" environment on macOS from scratch, with every step written so
> you can just follow along.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![CI](https://github.com/pakewnn-cpu/desktop-tutorial/actions/workflows/ci.yml/badge.svg)](.github/workflows/ci.yml)

---

## What this is

A **practical, hands-on** guide: how I built a day-to-day AI workspace on my own Mac
using open-source tools — a local large model (Ollama), a desktop AI assistant
(Codex), and a CI pipeline that checks things automatically.

It's not an article you read once and forget — it's something you can **actually run**.
Follow `scripts/setup.sh` and you'll reproduce my setup.

## Contents

| Doc | What's inside |
| --- | --- |
| [01 · Environment setup](docs/01-environment-setup.md) | git, Terminal, and a proxy — the foundation |
| [02 · Local models with Ollama](docs/02-ollama-local-models.md) | run a large model locally; your data stays on the machine |
| [03 · Desktop assistant with Codex](docs/03-codex-desktop.md) | install the desktop app, wire up the local model, daily use |
| [04 · My AI workflow](docs/04-my-ai-workflow.md) | string the tools together into a rhythm you can keep |
| [05 · FAQ](docs/05-faq.md) | real errors I hit while setting up, and how I fixed them |
| [CONTRIBUTING](CONTRIBUTING.md) | want to contribute code or docs? read this first |

## Quick start

```bash
# 1. clone the repo
git clone https://github.com/pakewnn-cpu/desktop-tutorial.git
cd desktop-tutorial

# 2. one-command setup (macOS)
bash scripts/setup.sh
```

> The full walkthrough is in [`docs/`](docs/). Each file explains not just *how*
> but *why* — so it sticks.

> Stuck or unsure after setup? Run `bash scripts/check-model.sh` — it tells you
> in one line whether Ollama is up, the model is pulled, and it actually answers.
> Rebuilding the desktop is the slow part; the config is cheap to lose. Run `bash scripts/backup-config.sh` to snapshot your git identity and Ollama settings into a timestamped backup — model weights are excluded, so it stays small.

## Requirements

Before you run `setup.sh`, make sure your machine meets these:

| Dependency | Requirement | Notes |
| --- | --- | --- |
| OS | macOS (Apple Silicon / Intel) | this guide targets macOS |
| RAM | 16GB or more recommended | local models are memory-hungry; use a smaller model if you're tight |
| Homebrew | auto-installed if missing | the package manager; `setup.sh` detects and installs it |
| git | any recent version | version control; the contribution graph keys off the committer, so set your identity |
| Ollama | auto-installed by the script | runs local models |
| Proxy (optional) | enable when direct access is slow | route git through a local proxy port |

> Not enough RAM? Use a smaller model: `MODEL=qwen2.5:7b bash scripts/setup.sh`.

## What you get

- ✅ a **local-first** AI setup (private, offline, no cloud dependency)
- ✅ a **reproducible** one-command install script
- ✅ a CI pipeline that **checks automatically** on every commit
- ✅ a tiny **health-check** script to confirm the local model is online
- ✅ a guide written **for self-taught developers**

## FAQ

Common errors and fixes are collected in [`docs/05-faq.md`](docs/05-faq.md).
The top few:

- **Slow or failing downloads**: route git through a local proxy port (see 05).
- **Not enough RAM for the model**: use a smaller one, `MODEL=qwen2.5:7b bash scripts/setup.sh`.
- **Desktop app can't reach the local model**: make sure Ollama is running, the model
  is pulled, and the provider points at `http://localhost:11434`.

> Want to contribute? Start with [`CONTRIBUTING.md`](CONTRIBUTING.md).

## About the author

Self-taught, independent developer. I like turning the things I figure out into
guides other people can actually use. This repo is part of that — every commit on
GitHub is a small proof that I'm still learning and still shipping.

📮 Want to collaborate or just talk shop? Open an [issue](https://github.com/pakewnn-cpu/desktop-tutorial/issues)
or email me at `Pakewnn@gmail.com`.

## License

[MIT](LICENSE) — use it freely, change it freely, just keep the attribution.
