#!/usr/bin/env bash
#
# backup-config.sh — one-click backup of your local AI desktop config
#
# Rebuilding the desktop takes a while, but the *config* is cheap to lose: your
# git identity, where Ollama listens, which model you picked, a few notes. This
# script snapshots the small, safe bits into a timestamped tarball so you can
# restore a machine (or a fresh VM) in minutes instead of hours.
#
# It deliberately does NOT copy the model weights — those are large and you can
# always re-pull them with `ollama pull`. Backing up the config, not the weights,
# is the whole point.
#
# Usage:
#   bash scripts/backup-config.sh
#   BACKUP_DIR=~/Backups bash scripts/backup-config.sh
#   OLLAMA_HOME=~/.ollama KEEP=10 bash scripts/backup-config.sh
#
# It never touches your model weights or downloads anything.

set -euo pipefail

# ---------- small helpers: consistent colored output ----------
info() { printf '\033[1;34m[info]\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m[done]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[skip]\033[0m %s\n' "$*"; }
fail() { printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2; }

# Where to put the backup; override with BACKUP_DIR if you keep backups elsewhere.
BACKUP_DIR="${BACKUP_DIR:-$HOME/.desktop-tutorial-backups}"
# Where Ollama keeps its files; override with OLLAMA_HOME if you moved it.
OLLAMA_HOME="${OLLAMA_HOME:-$HOME/.ollama}"
# How many old backups to keep (older ones are removed); override with KEEP.
KEEP="${KEEP:-5}"

# ---------- 1. Check the system ----------
if [ "$(uname)" != "Darwin" ]; then
  warn "This script targets macOS (detected: $(uname)); it may still work."
fi

# ---------- 2. Make sure the backup folder exists ----------
mkdir -p "${BACKUP_DIR}"
ok "Backups will go to ${BACKUP_DIR}"

# ---------- 3. Build the list of things to back up ----------
# Small, safe, cheap-to-lose config. Model weights are intentionally excluded.
STAGE_DIR="$(mktemp -d)"
trap 'rm -rf "${STAGE_DIR}"' EXIT
info "Gathering config into a staging folder..."

# git identity (your name + email that the contribution graph keys off)
if [ -f "$HOME/.gitconfig" ]; then
  cp "$HOME/.gitconfig" "${STAGE_DIR}/.gitconfig"
  ok "Included git identity (.gitconfig)."
else
  warn "No ~/.gitconfig found — skipping."
fi

# Ollama config, but NOT the model weights (they live under models/ and are huge)
if [ -d "${OLLAMA_HOME}" ]; then
  # Copy everything in OLLAMA_HOME except the big models/ directory.
  # Find the config pieces and copy them, preserving relative paths.
  found_ollama=0
  for item in "${OLLAMA_HOME}"/*; do
    [ -e "${item}" ] || continue
    base="$(basename "${item}")"
    if [ "${base}" = "models" ]; then
      continue
    fi
    mkdir -p "${STAGE_DIR}/ollama/$(dirname "${item}")"
    cp -R "${item}" "${STAGE_DIR}/ollama/${base}" 2>/dev/null || true
    found_ollama=1
  done
  if [ "${found_ollama}" = "1" ]; then
    ok "Included Ollama config (model weights excluded)."
  else
    warn "No Ollama config to copy under ${OLLAMA_HOME}."
  fi
else
  warn "No ${OLLAMA_HOME} directory found — skipping Ollama config."
fi

# A tiny manifest so a future-you knows what this backup contains.
{
  echo "desktop-tutorial config backup"
  echo "created: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
  echo "ollama_home: ${OLLAMA_HOME}"
  echo "kept_backups: ${KEEP}"
} > "${STAGE_DIR}/manifest.txt"
ok "Wrote a manifest so the backup explains itself."

# ---------- 4. Pack it into a timestamped tarball ----------
STAMP="$(date '+%Y%m%d-%H%M%S')"
ARCHIVE="${BACKUP_DIR}/desktop-tutorial-${STAMP}.tar.gz"
info "Packing into ${ARCHIVE} ..."
tar -czf "${ARCHIVE}" -C "${STAGE_DIR}" .
SIZE="$(du -h "${ARCHIVE}" | cut -f1)"
ok "Backup created: ${ARCHIVE} (${SIZE})"

# ---------- 5. Keep only the last KEEP backups ----------
# List newest first, drop everything past the first KEEP.
old_count=0
for old in $(ls -1t "${BACKUP_DIR}"/desktop-tutorial-*.tar.gz 2>/dev/null | tail -n +$((KEEP + 1))); do
  rm -- "${old}"
  old_count=$((old_count + 1))
done
if [ "${old_count}" -gt 0 ]; then
  ok "Removed ${old_count} older backup(s); kept the newest ${KEEP}."
else
  ok "Kept all backups (fewer than ${KEEP} exist)."
fi

# ---------- Wrap up ----------
echo
ok "All done. Your config is safe in ${BACKUP_DIR}."
echo "  To restore later:  tar -xzf ${ARCHIVE} -C <somewhere>"
echo "  Model weights are not included — re-pull with:  ollama pull <model>"
