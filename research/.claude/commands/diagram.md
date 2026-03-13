Generate and save a Mermaid diagram.

Arguments: $ARGUMENTS (diagram type and description)

1. Generate Mermaid syntax for the requested diagram
2. Save as .mmd file in the current project's diagrams/ folder
3. Name format: {type}-{description-slug}.mmd
4. Render to high-resolution .png using mmdc:
   ```bash
   timeout 30 mmdc -i <file.mmd> -o <file.png> --scale 3 --width 2400 2>&1
   ```
   - Exit 0 → success, report file size
   - Exit 124 (timeout) → warn user and suggest:
     a. **mermaid.live** — paste .mmd content, export PNG manually (best option)
     b. **Reduce complexity** — split into sub-diagrams, retry with `--scale 2 --width 1600`
     c. **Skip PNG for now** — keep the .mmd; PDF export works without it
   - Other error → show error output, fix Mermaid syntax and retry
   - Never silently skip — always report success or failure with reason
5. If mmdc is not installed: `npm install -g @mermaid-js/mermaid-cli`

Supported types: C4 context, C4 container, sequence,
ERD, flowchart, state diagram, Gantt

## Styling rules — always apply when generating architecture diagrams

Use the design-doc-mermaid skill for syntax reference and best practices.

- Add `%%{ init: { 'theme': 'base', 'themeVariables': { 'fontSize': '14px',
  'primaryColor': '#dbeafe', 'primaryBorderColor': '#3b82f6',
  'secondaryColor': '#fef3c7', 'tertiaryColor': '#dcfce7' } } }%%`
  at the top of every architecture diagram
- Apply `classDef` to visually group components:
  ```
  classDef external fill:#f3f4f6,stroke:#6b7280,color:#111
  classDef internal fill:#dbeafe,stroke:#3b82f6,color:#111
  classDef datastore fill:#fef3c7,stroke:#f59e0b,color:#111
  classDef client fill:#dcfce7,stroke:#16a34a,color:#111
  classDef queue fill:#fae8ff,stroke:#a855f7,color:#111
  ```
- Use unicode in node labels: 🗄️ database, 📱 mobile, 🔒 auth,
  ⚡ queue/async, 🌐 external API, 🛡️ security layer
- Direction: `LR` for context diagrams, `TD` for flow/sequence
- Add `%% comment` on non-obvious edges
- After generating, validate syntax:
  ```bash
  mmdc -i <file.mmd> -o /tmp/validate.svg 2>&1
  ```
  Fix any errors before saving the file.
