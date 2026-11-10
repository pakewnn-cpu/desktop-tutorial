#!/usr/bin/env bash
#
# check-model.sh — verify the local Ollama model is up and answering
#
# A quick health check for the local model. Handy when the desktop app says it
# "can't reach the model", or right after a reboot. It does:
#   1. Check that we're on macOS
#   2. Check that the Ollama server is reachable
#   3. Check that the model you want is pulled
#   4. Send it a tiny prompt to confirm it actually answers
#
# Usage:
#   bash scripts/check-model.sh
#   MODEL=llama3.1:8b bash scripts/check-model.sh
#
# It never downloads or changes anything — it only reads and probes.

set -euo pipefail

# ---------- small helpers: consistent colored output ----------
info() { printf '\033[1;34m[info]\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m[done]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[skip]\033[0m %s\n' "$*"; }
fail() { printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2; }

# The model to check; override with the MODEL env var before running.
MODEL="${MODEL:-qwen-codex:27b}"
# Where Ollama listens; override with OLLAMA_HOST if you run it elsewhere.
OLLAMA_HOST="${OLLAMA_HOST:-http://127.0.0.1:11434}"

# ---------- 1. Check the system ----------
if [ "$(uname)" != "Darwin" ]; then
  warn "This script targets macOS (detected: $(uname)); it may still work."
fi

# ---------- 2. Is the Ollama server up? ----------
if curl -fsS --max-time 5 "${OLLAMA_HOST}/api/tags" >/dev/null 2>&1; then
  ok "Ollama server is reachable at ${OLLAMA_HOST}."
else
  fail "Can't reach Ollama at ${OLLAMA_HOST}."
  fail "Start it with:  ollama serve   (or:  brew services start ollama)"
  exit 1
fi

# ---------- 3. Is the model pulled? ----------
if curl -fsS --max-time 5 "${OLLAMA_HOST}/api/tags" 2>/dev/null | grep -q "\"${MODEL}\""; then
  ok "Model ${MODEL} is present."
else
  fail "Model ${MODEL} is not pulled yet."
  fail "Pull it with:  ollama pull ${MODEL}"
  exit 1
fi

# ---------- 4. Does it actually answer? ----------
info "Sending ${MODEL} a tiny prompt to confirm it answers..."
if curl -fsS --max-time 120 -X POST "${OLLAMA_HOST}/api/generate" \
     -H 'Content-Type: application/json' \
     -d "{\"model\": \"${MODEL}\", \"prompt\": \"ping\", \"stream\": false}" \
     >/dev/null 2>&1; then
  ok "Model ${MODEL} answered — you're good to go."
else
  fail "Model ${MODEL} did not answer in time (the first run loads it, which can be slow)."
  exit 1
fi

echo
ok "All checks passed. Point your desktop app's model source at ${OLLAMA_HOST}."
