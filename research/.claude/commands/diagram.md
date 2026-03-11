Generate and save a Mermaid diagram.

Arguments: $ARGUMENTS (diagram type and description)

1. Generate Mermaid syntax for the requested diagram
2. Save as .mmd file in the current project's diagrams/ folder
3. Name format: {type}-{description-slug}.mmd
4. If mcp-mermaid is available: render to .png in same folder
5. If not available: print the Mermaid code and note: mermaid.live

Supported types: C4 context, C4 container, sequence,
ERD, flowchart, state diagram, Gantt
