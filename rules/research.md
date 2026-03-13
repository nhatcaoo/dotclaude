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
