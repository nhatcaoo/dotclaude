#!/bin/bash
# Setup TechLead Research Workspace from dotclaude repo
# Run from any machine after cloning dotclaude

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTCLAUDE_DIR="$(dirname "$SCRIPT_DIR")"
RESEARCH_SRC="$DOTCLAUDE_DIR/research"
WORKSPACE="$HOME/research-workspace"
SKILLS_DIR="$WORKSPACE/.claude/skills"

echo "=== TechLead Research Workspace Setup ==="
echo ""

# 1. Create workspace from template
if [ -d "$WORKSPACE" ]; then
  echo "  ⚠ $WORKSPACE already exists — updating files (not overwriting projects/)"
fi

echo "→ Creating workspace at $WORKSPACE..."
mkdir -p "$WORKSPACE/projects"
mkdir -p "$SKILLS_DIR"

if command -v rsync &> /dev/null; then
  rsync -a "$RESEARCH_SRC/.claude/agents/"   "$WORKSPACE/.claude/agents/"
  rsync -a "$RESEARCH_SRC/.claude/commands/" "$WORKSPACE/.claude/commands/"
  cp "$RESEARCH_SRC/.claude/CLAUDE.md"       "$WORKSPACE/.claude/CLAUDE.md"
  rsync -a "$RESEARCH_SRC/templates/"        "$WORKSPACE/templates/"
else
  rm -rf "$WORKSPACE/.claude/agents" "$WORKSPACE/.claude/commands" "$WORKSPACE/templates"
  cp -r "$RESEARCH_SRC/.claude/agents"    "$WORKSPACE/.claude/agents"
  cp -r "$RESEARCH_SRC/.claude/commands"  "$WORKSPACE/.claude/commands"
  cp    "$RESEARCH_SRC/.claude/CLAUDE.md" "$WORKSPACE/.claude/CLAUDE.md"
  cp -r "$RESEARCH_SRC/templates"         "$WORKSPACE/templates"
fi

echo "  ✓ Workspace structure created"

# 2. Install community skills via git clone (workspace-local, no npx skills)
echo ""
echo "→ Installing community skills ($SKILLS_DIR)..."

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# deanpeters/Product-Manager-Skills — prd-development
if [ -d "$SKILLS_DIR/prd-development" ]; then
  echo "  ✓ prd-development (already installed)"
else
  echo "  → cloning prd-development..."
  git clone --depth 1 --filter=blob:none --sparse \
    https://github.com/deanpeters/Product-Manager-Skills.git "$TMP/pm" -q
  git -C "$TMP/pm" sparse-checkout set skills/prd-development -q
  cp -r "$TMP/pm/skills/prd-development" "$SKILLS_DIR/prd-development"
  echo "  ✓ prd-development"
fi

# obra/superpowers — brainstorming, writing-plans, verification-before-completion
OBRA_NEEDED=()
for skill in brainstorming writing-plans verification-before-completion; do
  if [ -d "$SKILLS_DIR/$skill" ]; then
    echo "  ✓ $skill (already installed)"
  else
    OBRA_NEEDED+=("$skill")
  fi
done

if [ ${#OBRA_NEEDED[@]} -gt 0 ]; then
  echo "  → cloning obra/superpowers (${OBRA_NEEDED[*]})..."
  git clone --depth 1 \
    https://github.com/obra/superpowers.git "$TMP/obra" -q
  for skill in "${OBRA_NEEDED[@]}"; do
    cp -r "$TMP/obra/skills/$skill" "$SKILLS_DIR/$skill"
    echo "  ✓ $skill"
  done
fi

# SpillwaveSolutions/design-doc-mermaid — better Mermaid diagrams
if [ -d "$SKILLS_DIR/design-doc-mermaid" ]; then
  echo "  ✓ design-doc-mermaid (already installed)"
else
  echo "  → cloning design-doc-mermaid..."
  git clone --depth 1 \
    https://github.com/SpillwaveSolutions/design-doc-mermaid.git \
    "$SKILLS_DIR/design-doc-mermaid" -q
  echo "  ✓ design-doc-mermaid"
fi

# NeoLabHQ context-engineering-kit (SDD plugin)
# Requires plugin installation inside the workspace — cannot be automated here
echo "  ℹ sdd: run inside workspace after setup:"
echo "      /plugin marketplace add NeoLabHQ/context-engineering-kit"
echo "      /plugin install sdd@NeoLabHQ/context-engineering-kit"

# 3. MCP servers (global — available across all projects)
echo ""
echo "→ Setting up MCP servers..."

# Context7 — library docs fetching (used by architect + tech-advisor agents)
if claude mcp list 2>/dev/null | grep -q "context7"; then
  echo "  ✓ Context7 already configured"
else
  claude mcp add --transport http context7 https://mcp.context7.com/mcp \
    && echo "  ✓ Context7 installed" \
    || echo "  ⚠ Context7: run manually: claude mcp add --transport http context7 https://mcp.context7.com/mcp"
fi

# mcp-mermaid — diagram rendering (used by /diagram command)
if claude mcp list 2>/dev/null | grep -q "mcp-mermaid"; then
  echo "  ✓ mcp-mermaid already configured"
else
  echo -n "  Install mcp-mermaid for diagram rendering? (y/N): "
  read -r INSTALL_MERMAID
  if [[ "$INSTALL_MERMAID" =~ ^[Yy]$ ]]; then
    claude mcp add --transport stdio mcp-mermaid -- npx -y mcp-mermaid \
      && echo "  ✓ mcp-mermaid installed" \
      || echo "  ⚠ mcp-mermaid: run manually: claude mcp add --transport stdio mcp-mermaid -- npx -y mcp-mermaid"
  else
    echo "  ⚠ mcp-mermaid skipped — diagrams will render as Mermaid code only"
  fi
fi

echo ""
echo "=== Setup complete ==="
echo ""
echo "Next steps:"
echo "  1. cd $WORKSPACE && claude"
echo "  2. Run: /plugin marketplace add NeoLabHQ/context-engineering-kit"
echo "  3. Run: /plugin install sdd@NeoLabHQ/context-engineering-kit"
echo "  4. Run: /new-project"
echo ""
