#!/bin/bash
# Setup TechLead Research Workspace from dotclaude repo
# Run from any machine after cloning dotclaude

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTCLAUDE_DIR="$(dirname "$SCRIPT_DIR")"
RESEARCH_SRC="$DOTCLAUDE_DIR/research"
WORKSPACE="$HOME/research-workspace"

echo "=== TechLead Research Workspace Setup ==="
echo ""

# 1. Create workspace from template
if [ -d "$WORKSPACE" ]; then
  echo "  ⚠ $WORKSPACE already exists — updating files (not overwriting projects/)"
fi

echo "→ Creating workspace at $WORKSPACE..."
mkdir -p "$WORKSPACE/projects"
mkdir -p "$WORKSPACE/.claude/skills"

if command -v rsync &> /dev/null; then
  rsync -a "$RESEARCH_SRC/.claude/agents/"   "$WORKSPACE/.claude/agents/"
  rsync -a "$RESEARCH_SRC/.claude/commands/" "$WORKSPACE/.claude/commands/"
  rsync -a "$RESEARCH_SRC/.claude/skills/"   "$WORKSPACE/.claude/skills/"
  cp "$RESEARCH_SRC/.claude/CLAUDE.md"       "$WORKSPACE/.claude/CLAUDE.md"
  rsync -a "$RESEARCH_SRC/templates/"        "$WORKSPACE/templates/"
else
  rm -rf "$WORKSPACE/.claude/agents" "$WORKSPACE/.claude/commands" "$WORKSPACE/templates"
  cp -r "$RESEARCH_SRC/.claude/agents"    "$WORKSPACE/.claude/agents"
  cp -r "$RESEARCH_SRC/.claude/commands"  "$WORKSPACE/.claude/commands"
  cp -r "$RESEARCH_SRC/.claude/skills/."  "$WORKSPACE/.claude/skills/"
  cp    "$RESEARCH_SRC/.claude/CLAUDE.md" "$WORKSPACE/.claude/CLAUDE.md"
  cp -r "$RESEARCH_SRC/templates"         "$WORKSPACE/templates"
fi

echo "  ✓ Workspace structure created"

# 2. Install community skills into workspace-local skills folder
echo ""
echo "→ Installing community skills ($WORKSPACE/.claude/skills/)..."

if command -v npx &> /dev/null; then
  npx skills add deanpeters/Product-Manager-Skills --skill prd-development \
    -a claude-code --path "$WORKSPACE/.claude/skills/" -y \
    && echo "  ✓ prd-development" || echo "  ⚠ prd-development: install manually"

  npx skills add obra/superpowers --skill brainstorming \
    -a claude-code --path "$WORKSPACE/.claude/skills/" -y \
    && echo "  ✓ brainstorming" || echo "  ⚠ brainstorming: install manually"

  npx skills add obra/superpowers --skill writing-plans \
    -a claude-code --path "$WORKSPACE/.claude/skills/" -y \
    && echo "  ✓ writing-plans" || echo "  ⚠ writing-plans: install manually"

  npx skills add obra/superpowers --skill verification-before-completion \
    -a claude-code --path "$WORKSPACE/.claude/skills/" -y \
    && echo "  ✓ verification-before-completion" || echo "  ⚠ verification-before-completion: install manually"
else
  echo "  ⚠ npx not found — install Node.js first, then re-run"
  echo "    Or manually copy SKILL.md files to $WORKSPACE/.claude/skills/"
fi

# NeoLabHQ context-engineering-kit (SDD plugin)
# Requires plugin installation inside the workspace — cannot be automated here
echo "  ℹ sdd: run inside workspace after setup:"
echo "      /plugin marketplace add NeoLabHQ/context-engineering-kit"
echo "      /plugin install sdd@NeoLabHQ/context-engineering-kit"

# mcp-mermaid installs globally (available across all projects)
echo ""
echo "→ Checking mcp-mermaid..."
if claude mcp list 2>/dev/null | grep -q "mcp-mermaid"; then
  echo "  ✓ mcp-mermaid already installed"
else
  echo "  → Installing mcp-mermaid..."
  claude mcp add --transport stdio mcp-mermaid -- npx -y mcp-mermaid \
    && echo "  ✓ mcp-mermaid installed" \
    || echo "  ⚠ Run manually: claude mcp add --transport stdio mcp-mermaid -- npx -y mcp-mermaid"
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
