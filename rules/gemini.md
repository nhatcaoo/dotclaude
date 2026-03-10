# Gemini CLI Delegation Rules

> NOTE: `gemini` CLI is not currently installed on this machine.
> Install via: https://github.com/google-gemini/gemini-cli
> Or: `npm install -g @google/gemini-cli`

## When to Use Gemini
- Analyzing 20+ files at once
- Full architecture overview of a codebase
- Pre-refactor impact analysis
- Security scan across the entire codebase
- Finding all usages of a pattern/symbol across the repo
- Performance bottleneck analysis across many files

## When NOT to Use Gemini
- Small repos or single-file tasks
- Specific debugging sessions
- Code implementation tasks (Gemini analyzes → Claude implements)

## Command Pattern
```bash
# Basic analysis
gemini --all-files -p "<prompt>" -y

# Save large output
gemini --all-files -p "<prompt>" -y > /tmp/gemini-analysis.md
```

Always use `-y` flag for read-only analysis (safe, non-interactive).

## Prompt Templates

### Architecture overview
```
Describe the overall architecture: main modules, data flow, key dependencies, entry points.
```

### Find all usages
```
Find all usages of [symbol/pattern]. List file paths and line numbers.
```

### Pre-refactor impact
```
I plan to [describe change]. What files will be affected? What are the risks?
```

### Security scan
```
Scan for security issues: hardcoded secrets, injection vulnerabilities, unsafe deserialization, exposed credentials.
```

### Performance bottlenecks
```
Identify performance bottlenecks: N+1 queries, missing indexes, blocking I/O, memory leaks.
```

## Division of Labor
- **Gemini**: reads and analyzes (large context)
- **Claude**: implements changes based on Gemini's findings
- Never ask Gemini to write production code
