# Core Behavior Rules

## Code Style
- Match existing code style before introducing new patterns
- No dead code, no commented-out blocks
- Add error handling for external calls (network, filesystem, APIs)
- Don't add dependencies without asking first

## Security
- Never log sensitive data (tokens, passwords, PII)
- Never hardcode credentials — use env vars or config
- Validate at system boundaries (user input, external APIs); trust internal code

## Workflow
Before any task:
1. Check if Serena MCP is available → use for code navigation
2. Check if task involves external libraries → fetch docs via Context7
3. Check if analysis requires 20+ files → delegate to Gemini CLI

After implementation:
- Run existing tests before and after changes
- Run lint/build if available
- Prefer small focused diffs — avoid unnecessary scope creep

## Boundaries
- Don't refactor code that wasn't part of the task
- Don't add docstrings/comments to untouched code
- Don't add features not explicitly requested
- Three similar lines of code is better than a premature abstraction
