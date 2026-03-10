# Serena MCP Rules

> Serena is per-project. Run `~/.claude/scripts/setup-serena.sh` from a project root to enable.

## Priority
If `mcp__serena__*` tools are available in the current session, use them for ALL code navigation.

## Session Start Check
Look for `mcp__serena__initial_instructions` — if it exists, call it first.

## Prefer Serena Over Native Tools For
- Find symbol definition
- Find all references to a symbol
- Navigate to definition
- Get file/module overview
- List symbols in a file

## Why Serena
- Symbol-level semantic understanding (not text search)
- ~70% token savings vs. grep + read approach
- Understands rename, inheritance, imports across files

## Fallback
Projects without Serena active → use native Grep/Glob/Read tools.
