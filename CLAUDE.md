# Global Claude Config

## Language
- Default: English
- Switch to Vietnamese when I explicitly ask ("trả lời bằng tiếng Việt", "explain in Vietnamese")
- Input may mix both languages — understand both freely

## Behavior
- Direct and specific, no hedging or filler preamble
- Ask ONE clarifying question when ambiguous — not multiple
- Prefer small focused diffs over large rewrites
- Verify work: run build/tests/lint when available
- Match existing code style before introducing new patterns
- No dead code, no commented-out blocks
- Don't add dependencies without asking
- Never log sensitive data, never hardcode credentials

## Tools Priority (in order)
1. **Serena MCP** — if `mcp__serena__*` tools are active, use for ALL code navigation
2. **Context7 MCP** — fetch docs before implementing with any external library
3. **Gemini CLI** — for large codebase analysis (20+ files, architecture overview)
4. **Native file tools** — fallback when above are unavailable

## SSH to Servers
- Always check `~/.ssh/config` first before constructing any ssh/scp/rsync command
- Use the `Host` alias from `~/.ssh/config` when one exists (e.g. `ssh loyalty-aws` not `ssh ec2-user@13.x.x.x`)
- Never hardcode IPs, users, or key paths if they are already defined in `~/.ssh/config`
- If target host is not in `~/.ssh/config`, suggest adding an entry before proceeding
- See rules/ssh.md for full SSH conventions

## Rules References
- Git conventions: see rules/git.md
- Core coding behavior: see rules/core.md
- Gemini delegation: see rules/gemini.md
- Context7 usage: see rules/context7.md
- Serena usage: see rules/serena.md
- SSH conventions: see rules/ssh.md
- Research workspace: see rules/research.md
