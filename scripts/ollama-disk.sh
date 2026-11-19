#!/usr/bin/env bash
#
# ollama-disk.sh — see how much disk your local models are eating
#
# Pulling a 27B-class model quietly takes 15–16GB, and the library grows without
# asking. This script shows the real footprint: the total size of the Ollama
# models folder, how much free space is left on that volume, and — when the
# Ollama server is up — a per-model breakdown, largest first, so you can spot the
# heavy ones.
#
# It follows the models symlink, because I keep my models on an external drive
# (the SSD is too small), so a plain `du` on the link would just report 0.
#
# Usage:
#   bash scripts/ollama-disk.sh
#   OLLAMA_HOME=~/.ollama bash scripts/ollama-disk.sh
#   WARN_GB=10 bash scripts/ollama-disk.sh   # warn if free space drops under 10GB
#
# It only reads disk and the Ollama API — it never pulls, deletes, or changes
# anything.

set -euo pipefail

# ---------- small helpers: consistent colored output ----------
info() { printf '\033[1;34m[info]\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m[done]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[skip]\033[0m %s\n' "$*"; }
fail() { printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2; }

# Where Ollama keeps its files; override with OLLAMA_HOME if you moved it.
OLLAMA_HOME="${OLLAMA_HOME:-$HOME/.ollama}"
MODELS_DIR="${OLLAMA_HOME}/models"
# Where Ollama listens; override with OLLAMA_HOST if you run it elsewhere.
OLLAMA_HOST="${OLLAMA_HOST:-http://127.0.0.1:11434}"
# Warn if the free space on the model volume drops below this many GB.
WARN_GB="${WARN_GB:-10}"

# ---------- 1. Check the system ----------
if [ "$(uname)" != "Darwin" ]; then
  warn "This script targets macOS (detected: $(uname)); it may still work."
fi

# ---------- 2. Find the model library (follow the symlink) ----------
# I keep models on an external drive, so MODELS_DIR is often a symlink. Resolve
# it to the real path so `du`/`df` measure the actual folder, not the link.
if [ -L "${MODELS_DIR}" ]; then
  REAL_DIR="$(cd "${MODELS_DIR}" 2>/dev/null && pwd -P)" || REAL_DIR=""
else
  REAL_DIR="${MODELS_DIR}"
fi

if [ -z "${REAL_DIR}" ] || [ ! -d "${REAL_DIR}" ]; then
  warn "Can't reach the model library at ${MODELS_DIR}."
  warn "Is the external drive mounted, or have you pulled a model yet? (ollama pull <model>)"
  exit 0
fi
info "Model library lives at ${REAL_DIR}"

# ---------- 3. How big is the whole model library? ----------
# -sk gives 1024-byte blocks (a number we can do math on). A large library on a
# slow drive can take a few seconds to measure, so we walk it only once.
info "Measuring the model library (can take a moment on a large drive)..."
total_kb="$(du -sk "${REAL_DIR}" | cut -f1)"
total_gb="$(awk -v kb="${total_kb}" 'BEGIN { printf "%.1f", kb / 1024 / 1024 }')"
total_human="$(awk -v kb="${total_kb}" 'BEGIN {
  if (kb >= 1073741824) printf "%.1f GB", kb / 1073741824;
  else if (kb >= 1048576) printf "%.1f MB", kb / 1048576;
  else printf "%d KB", kb;
}')"
ok "Model library is ${total_human} (${total_gb} GB)."

# ---------- 4. How much free space is left on that volume? ----------
# df -k reports 1024-byte blocks; the last line is the data line for our path.
avail_kb="$(df -k "${REAL_DIR}" | awk 'END { print $4 }')"
avail_gb="$(awk -v kb="${avail_kb}" 'BEGIN { printf "%.1f", kb / 1024 / 1024 }')"
if awk -v a="${avail_gb}" -v w="${WARN_GB}" 'BEGIN { exit !(a < w) }'; then
  warn "Only ${avail_gb} GB free on this volume — a big model pull might not fit."
  warn "Free some space, or lower the threshold (e.g. WARN_GB=4) if this is expected."
else
  ok "Plenty of room: ${avail_gb} GB free on this volume."
fi

# ---------- 5. Per-model breakdown (needs the Ollama server) ----------
if curl -fsS --max-time 5 "${OLLAMA_HOST}/api/tags" >/dev/null 2>&1; then
  if command -v ollama >/dev/null 2>&1; then
    info "Per-model sizes, largest first:"
    # The SIZE column is "number unit" (e.g. "18 GB"), so split it into a
    # comparable GB value with awk before sorting — a plain sort would mix up
    # "274 MB" and "5 GB".
    ollama list 2>/dev/null | awk 'NR>1 {
      num=$3; unit=$4; mult=1;
      if (unit ~ /TB/) mult=1024;
      else if (unit ~ /MB/) mult=0.000976562;
      else if (unit ~ /KB/) mult=0.000000954;
      printf "%.6f\t%s\n", num * mult, $0
    }' | sort -k1,1 -rn | cut -f2- || true
  else
    warn "Ollama is up but the 'ollama' command isn't on your PATH — skipping per-model detail."
  fi
else
  warn "Ollama server isn't reachable, so I can't list per-model sizes."
  warn "Start it with:  ollama serve   (then re-run this script)"
fi

# ---------- Wrap up ----------
echo
ok "Disk check done. Total models: ${total_gb} GB · free: ${avail_gb} GB."
