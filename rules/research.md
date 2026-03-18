# Research Workspace Rules

## Diagram PNG Generation
- Always render Mermaid diagrams to high-resolution PNG:
  ```bash
  timeout 30 mmdc -i <file.mmd> -o <file.png> --scale 3 --width 2400 2>&1
  ```
- Check exit code:
  - `0` → success, report file size
  - `124` (timeout) → warn the user and suggest:
    a. **mermaid.live** — paste .mmd content and export PNG manually (best option)
    b. **Reduce complexity** — split into sub-diagrams, retry with `--scale 2 --width 1600`
    c. **Skip PNG for now** — keep the .mmd source; PDF export works without the PNG
  - Other error → show the error output and suggest fixing the Mermaid syntax
- Never silently skip PNG generation — always report success or failure with reason
- If `mmdc` is not installed: `npm install -g @mermaid-js/mermaid-cli`

## MD to PDF Export
- Use `/export-pdf` command for all MD → PDF conversions in research projects
- Do NOT use `md-to-pdf` CLI directly — it hangs when markdown embeds images >500KB
  (its internal HTTP server stalls on large PNG files)
- The correct approach: puppeteer with images inlined as base64 (see export-pdf command)

## MD to DOCX Export
- Use `pandoc` to convert markdown to `.docx`, then always run the table-border post-processor as a final step
- Two-step process:
  ```bash
  # Step 1 — generate docx
  pandoc input.md -o output.docx --from markdown --to docx --reference-doc reference.docx

  # Step 2 — apply full grid borders to all tables (ALWAYS run this)
  python3 ~/.claude/scripts/docx_fix_tables.py output.docx
  ```
- `docx_fix_tables.py` applies single-line borders (`#AAAAAA`, size 6) to every cell on all sides; header row uses `#888888`
- Script location: `~/.claude/scripts/docx_fix_tables.py`
- If no custom `reference.docx` is needed, omit `--reference-doc` from pandoc command
- Never skip Step 2 — pandoc default tables have no visible borders
