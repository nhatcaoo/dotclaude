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
│   ├── serena.md                # Serena MCP for code navigation
│   └── research.md              # Diagram high-res PNG + MD→PDF export rules
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
    ├── setup-serena.sh          # Per-project Serena MCP setup
    └── docx_fix_tables.py       # Post-processor: add full grid borders to all tables in .docx
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

## Research Workspace

A structured research pipeline for techleads: requirements → architecture
→ tech stack → estimation → spec.

### Quick Setup (new machine)

```bash
./scripts/setup-research.sh
```

This creates `~/research-workspace/` and installs all required skills.

### How to Use

```bash
cd ~/research-workspace
claude
# Type: /new-project
```

### Pipeline (RIPER Workflow)

```
Paste brief → /new-project
  └─ [R] Requirements Analysis    → 01-requirements.md    ✋ approve
  └─ [I] Architecture Options     → 02-architecture/      ✋ choose 1
  └─ [P] Tech Stack + Estimation  → 03 + 04               ✋ approve
  └─ [E] Final Spec               → 05-spec.md            ✋ review
  └─ [Export]                     → /export-pdf (pdf-exports/)
```

### Research Agents

Two specialized agents for research projects (no pipeline needed):

| Command | Agent | Output folder |
|---|---|---|
| `/research-partner [company]` | `partner-researcher` | `projects/YYYY-MM-partner-{slug}/` |
| `/research-topic [topic]` | `topic-researcher` | `projects/YYYY-MM-topic-{slug}/` |

**partner-researcher** — Company/partner due diligence. Sections: Company Overview, Products & Services, Financials, Team & Leadership, Market Position, Vietnam Context. Output: MD + PDF.

**topic-researcher** — General topic research (market, technology, landscape). Sections: Background & Context, Key Players, Market/Landscape Overview, Technology Angle, Community Signals, Risks & Opportunities. Output: MD + DOCX.

Both agents: multi-round web search, full citations with dates, source freshness flags, RIPER checkpoints.

### Skills Installed

Skills are installed globally (`~/.claude/skills/`) by the setup script.
Claude Code discovers them automatically in all sessions.

| Skill                          | Source                            | Purpose                                      |
|--------------------------------|-----------------------------------|----------------------------------------------|
| prd-development                | deanpeters/Product-Manager-Skills | PRD workflow                                 |
| sdd (plugin)                   | NeoLabHQ/context-engineering-kit  | Spec-driven dev (/sdd:plan, /sdd:implement)  |
| brainstorming                  | obra/superpowers                  | Creative exploration                         |
| writing-plans                  | obra/superpowers                  | Plan writing                                 |
| verification-before-completion | obra/superpowers                  | Output validation                            |
| mcp-mermaid                    | hustcc                            | Diagram rendering (MCP, global)              |
| seminar-prep                   | custom (dotclaude)                | Process training doc sections into slide content, deep-read analysis, and shorthand seminar notes |
| architecture-diagram           | Cocoon-AI/architecture-diagram-generator | Generate dark-themed SVG architecture diagrams as standalone HTML files |

> **Note:** The SDD plugin must be installed separately inside the workspace:
> ```
> /plugin marketplace add NeoLabHQ/context-engineering-kit
> /plugin install sdd@context-engineering-kit
> ```

### Project Output Structure

```
projects/YYYY-MM-{name}/
  00-brief.md
  01-requirements.md
  02-architecture/
    options.md
    decision.md        ← ADR
    diagrams/          ← .mmd + .png (high-res via mmdc --scale 3)
  03-tech-stack.md
  04-estimation.md
  05-spec.md           ← share this with team
```

---

## Per-Project Serena Setup

Serena is intentionally **not** in this repo — it's scoped per project:

```bash
cd ~/my-project
~/.claude/scripts/setup-serena.sh
```

This adds Serena MCP with local scope and indexes the project.
`.serena/` is added to the project's `.gitignore` automatically.
