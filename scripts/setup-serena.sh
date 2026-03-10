#!/usr/bin/env zsh
# ~/.claude/scripts/setup-serena.sh
# Run from a project root to enable Serena MCP (locally scoped)

set -e

echo "=== Serena MCP Setup ==="
echo "Project root: $(pwd)"
echo ""

# ── Check uvx ─────────────────────────────────────────────────────────────────
if ! command -v uvx &>/dev/null; then
  echo "ERROR: uvx is not installed."
  echo ""
  echo "Install uv (which includes uvx):"
  echo "  curl -LsSf https://astral.sh/uv/install.sh | sh"
  echo "  # then restart your shell or: source ~/.zshrc"
  echo ""
  echo "After installing, re-run this script from your project root."
  exit 1
fi

echo "✓ uvx found: $(which uvx)"
echo ""

# ── Check we're in a real project directory ────────────────────────────────────
if [[ "$(pwd)" == "$HOME" ]] || [[ "$(pwd)" == "/" ]]; then
  echo "ERROR: Run this script from your project root, not from $HOME or /."
  exit 1
fi

PROJECT_DIR="$(pwd)"

# ── Add Serena MCP (local scope) ───────────────────────────────────────────────
echo "Checking if Serena MCP is already configured..."
if claude mcp list 2>/dev/null | grep -q "serena"; then
  echo "  ✓ Serena already configured for this project"
else
  echo "  Adding Serena MCP (local scope)..."
  claude mcp add serena --scope local -- \
    uvx --from git+https://github.com/oraios/serena \
    serena start-mcp-server \
    --context ide-assistant \
    --project "${PROJECT_DIR}"
  echo "  ✓ Serena MCP added"
fi
echo ""

# ── Index the project ──────────────────────────────────────────────────────────
echo "Indexing project with Serena (this may take a minute)..."
uvx --from git+https://github.com/oraios/serena serena project index
echo "✓ Project indexed"
echo ""

# ── Add .serena/ to .gitignore ────────────────────────────────────────────────
GITIGNORE="${PROJECT_DIR}/.gitignore"
if [[ -f "$GITIGNORE" ]]; then
  if grep -q "^\.serena/" "$GITIGNORE" 2>/dev/null || grep -q "^\.serena$" "$GITIGNORE" 2>/dev/null; then
    echo "✓ .serena/ already in .gitignore"
  else
    echo "" >> "$GITIGNORE"
    echo "# Serena MCP index" >> "$GITIGNORE"
    echo ".serena/" >> "$GITIGNORE"
    echo "✓ Added .serena/ to .gitignore"
  fi
else
  echo "# Serena MCP index" > "$GITIGNORE"
  echo ".serena/" >> "$GITIGNORE"
  echo "✓ Created .gitignore with .serena/"
fi
echo ""

echo "=== Serena setup complete ==="
echo "Restart Claude Code in this project to activate Serena tools."
