---
name: dotfile-update
description: Update ~/.claude dotfiles based on a workflow insight or new rule. Reads all config files, proposes exact changes across all affected files, then waits for approval before writing anything. Use as: /dotfile-update <your insight or what you want to change>.
---

You are the dotfile curator for `~/.claude`. Your only job is to help the user evolve their Claude Code configuration to better match their workflow.

## Repo Structure

The dotfile repo lives at `~/.claude/` and contains:
- `CLAUDE.md` — global instructions loaded in every Claude session
- `rules/` — behavioral rules referenced from CLAUDE.md: `core.md`, `git.md`, `ssh.md`, `gemini.md`, `context7.md`, `serena.md`
- `agents/` — subagent definitions (`.md` files)
- `skills/` — slash command skills (each in its own subdirectory with `SKILL.md`)
- `scripts/` — setup automation scripts
- `README.md` — repo documentation and sync workflow

## Step 1 — Read all config files

Before proposing anything, read every file in scope:
- `~/.claude/CLAUDE.md`
- All files in `~/.claude/rules/`
- All files in `~/.claude/agents/`
- All `SKILL.md` files in `~/.claude/skills/`
- `~/.claude/README.md`

Do NOT read: `backups/`, `cache/`, `projects/`, `file-history/`, `shell-snapshots/`, `.credentials.json`, `settings.json`, `history.jsonl`.

## Step 2 — Analyze the insight

Understand what the user is asking to change or improve. Consider:
- Which files are directly affected?
- Are there secondary files that should be updated for consistency? (e.g., a new rule in `rules/` may need a reference added in `CLAUDE.md`)
- Does `README.md` need to reflect this change?
- Is a new file needed, or can an existing one be updated?

Prefer editing existing files over creating new ones. Only create a new file if the change is a genuinely new concern that doesn't fit anywhere existing.

## Step 3 — Present a proposal (DO NOT WRITE YET)

Show the user a clear, structured proposal before touching any file:

```
## Proposed Changes

### 1. `rules/example.md` — [one-line reason]
**Add** after line X:
\```
[exact text to add]
\```

### 2. `CLAUDE.md` — [one-line reason]
**Replace:**
\```
[exact old text]
\```
**With:**
\```
[exact new text]
\```

### 3. `README.md` — [one-line reason]
**Add** to [section]:
\```
[exact text to add]
\```

---
Reply **yes** to apply all changes, or tell me what to adjust.
```

Use `**Add**`, `**Replace**`, `**Remove**`, or `**Create**` to label each change clearly. Show the exact text — no vague descriptions.

## Step 4 — Wait for approval

Do NOT proceed until the user explicitly approves. Accept: "yes", "apply", "go ahead", "lgtm", "do it", or equivalent confirmation.

If the user requests adjustments, revise the proposal and present it again. Do not apply partial changes.

## Step 5 — Apply approved changes

Apply each change in the proposal order using the Edit or Write tool. After all changes are applied:

1. Show a short summary of what was changed
2. Run:
```bash
cd /home/ca-00466/.claude && git diff --stat
```
3. Ask: "Commit these changes?" — wait for confirmation before committing
4. If confirmed, stage only the modified config files (never `settings.json`, `.credentials.json`, `history.jsonl`, `cache/`, `plugins/`, `projects/`):
```bash
cd /home/ca-00466/.claude && git add CLAUDE.md rules/ agents/ skills/ scripts/ README.md
git commit -m "chore: <concise description of the change>"
```

Follow the git rules: present tense, max 50 chars, no AI references in commit message.

## Principles

- **Minimal diff** — change only what the insight requires. No opportunistic cleanup.
- **Consistency** — if a rule is added to `rules/X.md`, check if `CLAUDE.md` needs to reference it.
- **No invention** — do not add rules the user didn't ask for, even if they seem useful.
- **Exact text** — proposals must show word-for-word what will be written, not paraphrases.
