# Context7 MCP Rules

> Context7 is already active as a plugin (`context7@claude-plugins-official`).

## Purpose
Fetch up-to-date library documentation before implementing with any external library.
Prevents hallucinated or outdated APIs.

## Always Use Context7 For
- React / Next.js
- ORMs: Prisma, Drizzle, TypeORM
- Auth libraries: NextAuth, Lucia, Clerk
- Cloud SDKs: AWS, GCP, Vercel, Supabase
- UI frameworks: shadcn/ui, Radix, MUI, Tailwind
- Any library where the exact API matters

## Tools
1. `mcp__context7__resolve-library-id` — find the library ID by name
2. `mcp__context7__get-library-docs` — fetch docs for a topic

## Workflow
```
User asks to implement X with library Y
→ resolve-library-id for Y
→ get-library-docs for relevant topic
→ implement using fetched docs
```

## Note on Plugin vs MCP
Context7 on this machine runs as a Claude plugin, not a traditional MCP server.
The tool names may appear as `mcp__plugin_context7_context7__*` depending on session context.
