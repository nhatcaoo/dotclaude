Start a topic research project.

Usage: /research-topic [topic]

Steps:
1. Extract topic from $ARGUMENTS or ask if not provided
2. Create project folder: projects/YYYY-MM-topic-{slug}/ (today's date)
   slug = topic lowercased, spaces → hyphens, max 4 words
3. Save initial brief to 00-brief.md with:
   - Topic name
   - Date started
   - Any info provided in $ARGUMENTS beyond the topic name
4. Invoke topic-researcher agent
5. All research output saves to this project folder:
   01-research-questions.md  ← approved question list
   02-raw-sources.md         ← all URLs + dates collected
   03-draft.md               ← analysis draft
   04-report.md              ← final report (markdown)
   04-report.docx            ← final report (Word)
