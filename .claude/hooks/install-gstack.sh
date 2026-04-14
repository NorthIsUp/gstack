#!/usr/bin/env bash
# install-gstack.sh — idempotent gstack install + auto-update for Claude Code web
#
# Runs on every SessionStart. Safe to call repeatedly — skips install if already
# present, pulls latest if it is. Always exits 0 so it never blocks a session.

set +e

GSTACK_DIR="$HOME/.claude/skills/gstack"
GSTACK_REPO="https://github.com/garrytan/gstack.git"

if [ -d "$GSTACK_DIR/.git" ]; then
  # Already installed — pull latest in the background (team auto-update)
  git -C "$GSTACK_DIR" pull --ff-only -q 2>/dev/null &
else
  # Fresh install — clone and run setup with team mode (enables auto_upgrade)
  git clone --depth 1 "$GSTACK_REPO" "$GSTACK_DIR" 2>/dev/null && \
    cd "$GSTACK_DIR" && ./setup --team -q 2>/dev/null &
fi

exit 0
