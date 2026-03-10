---
name: gemini-web-fetch
description: Use Gemini CLI to fetch web content Claude's WebFetch cannot access — blocked sites, Reddit, forums, paywalled content, or when WebFetch returns empty or an error.
---

## When to Use
Fall back to this skill when:
- Claude's built-in WebFetch returns empty, blocked, or an error
- Target is Reddit, forums, or community content
- Site requires JavaScript rendering
- Content appears paywalled or rate-limited

## Workflow
1. Try Claude's WebFetch first
2. If that fails or returns empty, run:

```bash
gemini -p "Fetch and summarize the content at this URL. Return the full main content, not just a summary: [URL]" -y
```

3. For structured data extraction:
```bash
gemini -p "Fetch [URL] and extract: [specific data you need]. Format as [JSON/list/table]." -y
```

## Pre-flight Check
```bash
which gemini || { echo "ERROR: gemini CLI not installed. Install: npm install -g @google/gemini-cli"; exit 1; }
```

## Notes
- Gemini has its own web access separate from Claude's WebFetch
- Works well for Reddit threads, GitHub discussions, Stack Overflow
- `-y` flag is safe for read-only fetching
