#!/usr/bin/env bash
set -e

# ==============================================================================
# Pipeline Skills Installer
# Installs pipeline-proof-review, pipeline-contract-coder and companion skills
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-}"

# Auto-detect target directory if not provided
if [ -z "$TARGET_DIR" ]; then
  if [ -d "$HOME/.agents" ]; then
    TARGET_DIR="$HOME/.agents/skills"
  elif [ -d "$HOME/.claude" ]; then
    TARGET_DIR="$HOME/.claude/skills"
  elif [ -d "$HOME/.codex" ]; then
    TARGET_DIR="$HOME/.codex/skills"
  else
    TARGET_DIR="$HOME/.agents/skills"
  fi
fi

echo "======================================================"
echo "Installing Pipeline Skills bundle..."
echo "Source: $SCRIPT_DIR/skills"
echo "Target: $TARGET_DIR"
echo "======================================================"

mkdir -p "$TARGET_DIR"

count=0
for skill_dir in "$SCRIPT_DIR"/skills/*; do
  if [ -d "$skill_dir" ]; then
    skill_name="$(basename "$skill_dir")"
    dest="$TARGET_DIR/$skill_name"
    
    # Remove existing skill if present
    if [ -e "$dest" ] || [ -L "$dest" ]; then
      rm -rf "$dest"
    fi
    
    # Copy fresh skill directory
    cp -R "$skill_dir" "$dest"
    echo "  [✓] Installed: $skill_name"
    count=$((count + 1))
  fi
done

echo ""
echo "Successfully installed $count skills into $TARGET_DIR!"
echo ""
echo "Available workflows & skills:"
echo "  • /pipeline-proof-review  - Primary QA proof & invariant verification"
echo "  • /pipeline-contract-coder - Stable contract implementation & minimal diffs"
echo "  • /ponytail               - Senior lazy developer & YAGNI ladder"
echo "  • security-review          - General security & secrets audit"
echo "  • api-security-review      - OWASP API Top 10 & IDOR authorization"
echo "  • supabase-postgres-best-practices - Postgres RLS, locks & transactions"
echo "  • php-pro & php-best-practices     - Modern PHP 8.4 patterns & standards"
echo ""
