# dotclaude

Personal Claude Code configuration. Drop `~/.claude/` contents here — rules, agents, skills, and scripts that travel with me across machines.

## Structure

```
~/.claude/
├── CLAUDE.md                    # Global instructions loaded in every session
├── README.md                    # This file
├── .gitignore                   # Excludes credentials, cache, runtime state
│
├── rules/                       # Behavioral rules (referenced from CLAUDE.md)
│   ├── git.md                   # Commit format, types, no AI references
│   ├── core.md                  # Code style, security, workflow boundaries
│   ├── ssh.md                   # SSH host alias priority, known hosts
│   ├── gemini.md                # When/how to delegate to Gemini CLI
│   ├── context7.md              # Fetch library docs before implementing
│   └── serena.md                # Serena MCP for code navigation
│
├── agents/                      # Custom subagents
│   └── gemini-analyzer.md       # Delegates large codebase analysis to Gemini
│
├── skills/                      # Slash command skills
│   └── gemini-web-fetch/
│       └── SKILL.md             # Fetch blocked/paywalled URLs via Gemini
│
└── scripts/                     # Setup automation
    ├── setup-mcp.sh             # Install MCP servers (Context7, GitHub MCP)
    └── setup-serena.sh          # Per-project Serena MCP setup
```

## Quick Start (new machine)

### 1. Clone
```bash
git clone git@github.com:nhatcaoo/dotclaude.git ~/.claude
```

### 2. Install Claude Code
```bash
npm install -g @anthropic-ai/claude-code
claude login
```

### 3. Run MCP setup
```bash
~/.claude/scripts/setup-mcp.sh
```

### 4. (Optional) Install Gemini CLI
```bash
npm install -g @google/gemini-cli
gemini auth
```

### 5. (Optional) Install uv/uvx for Serena
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
# then run setup-serena.sh from any project root
```

### 6. Verify
```bash
claude mcp list
```

---

## Sync Workflow

### Updating config on any machine

```bash
cd ~/.claude
git pull                  # always pull before editing
# ... edit CLAUDE.md, rules/, agents/, etc.
git add CLAUDE.md rules/ agents/ skills/ scripts/
git commit -m "chore: <what changed>"
git push
```

### Pulling updates on another machine

```bash
cd ~/.claude
git pull
# No restart needed — Claude Code reads files at session start
```

### After pulling: re-run setup if scripts changed

```bash
~/.claude/scripts/setup-mcp.sh   # if setup-mcp.sh changed
```

---

## What Is NOT synced (gitignored)

| Path | Reason |
|---|---|
| `.credentials.json` | Claude Code auth token |
| `settings.json` | May contain MCP server tokens |
| `history.jsonl` | Conversation history |
| `cache/`, `plugins/` | Auto-managed, machine-local |
| `projects/`, `session-env/` | Runtime state |

Each machine needs its own `claude login` and `setup-mcp.sh` run.

---

## Per-Project Serena Setup

Serena is intentionally **not** in this repo — it's scoped per project:

```bash
cd ~/my-project
~/.claude/scripts/setup-serena.sh
```

This adds Serena MCP with local scope and indexes the project.
`.serena/` is added to the project's `.gitignore` automatically.
