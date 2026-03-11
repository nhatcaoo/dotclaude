Review a document or diagram for completeness, clarity, technical
correctness, and alignment with the current project.

Usage: /review [optional: file path or description]

Accepts:
- Uploaded image (architecture diagram, whiteboard photo, screenshot)
- Uploaded file (PDF, docx, md, txt)
- Pasted text (paste after the command)
- File path: /review path/to/file.md

Steps:
1. Determine input type (image / file / text / path)
2. If $ARGUMENTS contains a file path, read that file first
3. Check for active project in projects/ to load alignment context
4. Invoke the reviewer agent
5. Save review output to current project folder if one is active:
   projects/YYYY-MM-{name}/reviews/YYYY-MM-DD-{doc-type}-review.md
   If no active project, print to terminal only.
