#!/usr/bin/env bash
#
# setup.sh — one-command setup for a Mac AI desktop environment
#
# It does the following in order:
#   1. Check that we're on macOS
#   2. Install Homebrew (if not already present)
#   3. Install Ollama and start it at login
#   4. Pull a local model
#   5. Configure the git identity (optional)
#
# Usage:
#   bash scripts/setup.sh
#
# Note: each step checks whether it's already done, so re-running is safe.
# To use a different model: MODEL=llama3.1:8b bash scripts/setup.sh

set -euo pipefail

# ---------- small helpers: consistent colored output ----------
info() { printf '\033[1;34m[info]\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m[done]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[skip]\033[0m %s\n' "$*"; }
fail() { printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2; }

# The model to pull; override with the MODEL env var before running.
MODEL="${MODEL:-qwen-codex:27b}"

# ---------- 1. Check the system ----------
if [ "$(uname)" != "Darwin" ]; then
  fail "This script currently supports macOS only (detected: $(uname))."
  exit 1
fi
ok "System is macOS, continuing."

# ---------- 2. Install Homebrew ----------
if command -v brew >/dev/null 2>&1; then
  ok "Homebrew is already installed."
else
  info "Installing Homebrew (this step asks for a password — type it and press Enter)..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # On Apple Silicon brew lives in /opt/homebrew, on Intel in /usr/local
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  ok "Homebrew installed."
fi

# ---------- 3. Install Ollama ----------
if command -v ollama >/dev/null 2>&1; then
  ok "Ollama is already installed."
else
  info "Installing Ollama..."
  brew install ollama
  ok "Ollama installed."
fi

# Keep it running in the background (no error if it's already started)
info "Starting Ollama in the background..."
brew services start ollama || warn "brew services failed to start it; you can run it later with: ollama serve"

# ---------- 4. Pull the model ----------
if ollama list 2>/dev/null | grep -q "^${MODEL}"; then
  ok "Model ${MODEL} already exists, skipping download."
else
  info "Downloading model ${MODEL} (the first pull is large, please wait)..."
  ollama pull "${MODEL}"
  ok "Model ${MODEL} downloaded."
fi

# ---------- 5. Configure the git identity (optional) ----------
if git config --global user.name >/dev/null 2>&1; then
  ok "git identity is already set, skipping."
else
  info "Configuring git identity (the contribution graph keys off the committer, so set this)..."
  read -r -p "  Your GitHub username (Enter for default pakewnn-cpu): " name
  name="${name:-pakewnn-cpu}"
  read -r -p "  Your email (Enter for default your-email@example.com): " email
  email="${email:-your-email@example.com}"
  git config --global user.name  "${name}"
  git config --global user.email "${email}"
  ok "git identity saved."
fi

# ---------- Wrap up ----------
echo
ok "All done!"
echo "  Local model endpoint: http://localhost:11434"
echo "  Try it:               ollama run ${MODEL} \"hello\""
echo "  Next step:            open the Codex desktop app and point the model source at http://localhost:11434"
