Start a partner or company research project.

Usage: /research-partner [company name]

Steps:
1. Extract company name from $ARGUMENTS or ask if not provided
2. Create project folder: projects/YYYY-MM-partner-{slug}/ (today's date)
   slug = company name lowercased, spaces → hyphens
3. Save initial brief to 00-brief.md with:
   - Company name
   - Date started
   - Any info provided in $ARGUMENTS beyond the name
4. Invoke partner-researcher agent
5. All research output saves to this project folder:
   01-research-questions.md  ← approved question list
   02-raw-sources.md         ← all URLs + dates collected
   03-draft.md               ← analysis draft
   04-report.md              ← final report
   04-report.pdf             ← if PDF requested
