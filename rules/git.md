# Git Commit Rules

## Format
`<type>: <subject>`

## Rules
- Present tense, max 50 chars total
- No period at end
- No capital letter after colon
- NEVER include AI references in commits, body, or author field

## Types
- `feat` — new feature
- `fix` — bug fix
- `docs` — documentation only
- `style` — formatting, no logic change
- `refactor` — code restructure, no behavior change
- `test` — adding or updating tests
- `chore` — build, deps, tooling

## Examples
- Good: `feat: add user authentication flow`
- Good: `fix: handle null pointer in parser`
- Bad: `feat: Added auth (generated with Claude)`
- Bad: `Fix: Updated the authentication module.`
