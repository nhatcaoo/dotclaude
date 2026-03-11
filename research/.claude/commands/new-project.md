Create a new research project.

Steps:
1. Ask for project name (slug format: kebab-case)
2. Ask user to paste the raw brief or provide a file path
3. Ask for preferred output format for the final spec (05-spec.md):
   - **Markdown** (default) — saved as 05-spec.md, readable anywhere
   - **PDF** — requires pandoc; generated from markdown at Phase E
   - **DOCX** — requires pandoc; Word format for non-technical stakeholders
   - **HTML** — standalone HTML file with embedded styles
   Save the chosen format to project.json in the project folder.
4. Create folder: projects/YYYY-MM-{name}/ (use today's date)
5. Save brief to 00-brief.md
6. Save project metadata to project.json:
   { "name": "<slug>", "format": "<chosen-format>", "created": "<date>" }
7. Automatically invoke the requirements-analyst agent
8. State: [PHASE: R — Requirements Analysis Started]
9. List assumptions first, then begin Round 1 questioning
