#!/usr/bin/env zsh
# ~/.claude/scripts/setup-mcp.sh
# Idempotent MCP server setup for Claude Code

set -e

echo "=== Claude Code MCP Setup ==="
echo ""

# ── Context7 ──────────────────────────────────────────────────────────────────
# Note: Context7 on this machine is already active as a plugin (context7@claude-plugins-official).
# The MCP transport version below is an alternative; skip if plugin is sufficient.

echo "Checking Context7..."
if claude mcp list 2>/dev/null | grep -q "context7"; then
  echo "  ✓ Context7 already configured via MCP"
else
  echo "  Context7 plugin is active (context7@claude-plugins-official)."
  echo "  To also add the HTTP transport version, uncomment the line below:"
  echo "  # claude mcp add --transport http context7 https://mcp.context7.com/mcp"
  echo "  Skipping — plugin version is already active."
fi
echo ""

# ── GitHub MCP ────────────────────────────────────────────────────────────────
echo "Checking GitHub MCP..."
if claude mcp list 2>/dev/null | grep -q "github"; then
  echo "  ✓ GitHub MCP already configured"
else
  echo -n "  Install GitHub MCP? (y/N): "
  read INSTALL_GITHUB
  if [[ "$INSTALL_GITHUB" =~ ^[Yy]$ ]]; then
    echo -n "  GitHub Personal Access Token (input hidden): "
    read -s GITHUB_TOKEN
    echo ""
    if [[ -z "$GITHUB_TOKEN" ]]; then
      echo "  No token provided — skipping GitHub MCP"
    else
      claude mcp add --transport http github https://api.githubcopilot.com/mcp/ \
        --header "Authorization: Bearer ${GITHUB_TOKEN}"
      echo "  ✓ GitHub MCP added"
      unset GITHUB_TOKEN
    fi
  else
    echo "  Skipped"
  fi
fi
echo ""

# ── Serena note ───────────────────────────────────────────────────────────────
echo "NOTE: Serena MCP is per-project (local scope)."
echo "  To enable Serena in a project, cd into the project root and run:"
echo "  ~/.claude/scripts/setup-serena.sh"
echo ""

# ── Final state ───────────────────────────────────────────────────────────────
echo "=== Current MCP servers ==="
claude mcp list
