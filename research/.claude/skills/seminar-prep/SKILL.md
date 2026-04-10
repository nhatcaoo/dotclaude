---
name: seminar-prep
description: Process a single training document section into 3 seminar output formats. Use when given a section file with YAML frontmatter containing SECTION, PART, and SECTION_NUMBER fields. Invoke as /seminar-prep or call directly via claude --print. Outputs 3 blocks separated by ---BLOCK_SEPARATOR--- markers: deep-read analysis (Vietnamese), slide content bullets (Vietnamese), and shorthand presenter notes (Vietnamese with English tech terms).
---

# Seminar Prep Skill

## Purpose
Process one section of a technical training document at a time, producing three output formats for seminar delivery. Designed to be called in a loop (one section per invocation) by a shell script.

## Language Rule
All output is in Vietnamese. English tech terms are kept in English exactly as they appear in the source. Do NOT translate: EBP, ModelBank, BaaS, Journeys, Banking Services, Flow, Connector, Entitlements, Identity, Foundation Services, Composable, SDK, API, microservice, container, OAuth, OIDC, RBAC, DevOps, CI/CD, or any Backbase product names.

## Input Format
A markdown file with this frontmatter:
```
---
SECTION: <section name>
PART: <Technology | Environments>
SECTION_NUMBER: <N of 19>
---
<raw markdown content>
```
Content types in the body:
- Regular text = official key points (concise, authoritative)
- Italic text wrapped in `*...*` = video transcript = richest source: contains examples, reasoning, nuance that key points omit. Use both. Do not skip transcript content.

## Output Format
Produce exactly 3 blocks separated by `---BLOCK_SEPARATOR---`. Start output with:
`Processing: Section N/19 — [Name] | Part: [Technology/Environments]`
End output with: `Next: Section N+1 — [Name]` (or `Done` if final section)

---

### BLOCK 1 — DEEP READ

Header: `## [Section Name] — Đọc sâu`

Framing rule: Every major factual claim must be attributed with one of:
- "Tài liệu chỉ ra rằng..."
- "Transcript video giải thích rằng..."
- "Theo tài liệu..."
- "Tài liệu mô tả..."

Structure: defined by the AI based on the section's content — choose headings that best serve the material. Examples: Định nghĩa, Kiến trúc, Cơ chế hoạt động, Luồng xử lý, Tích hợp, Lợi ích & Trade-off, So sánh, v.v. Always end with **Góc nhìn AI** — your synthesis: connections to other sections, patterns a senior engineer would notice. Label clearly.

Minimum 400 words. Expand, do not summarize.

**Thuật ngữ kỹ thuật** — after the main body, add a glossary subsection:
`### Thuật ngữ trong phần này`
For every English tech term used in the section: one line each, format:
`**<Term>** — <1–2 câu giải thích ngắn bằng tiếng Việt, giữ nguyên tên tiếng Anh>`
Do not skip terms that appear in diagrams or image captions.

**Hình ảnh & Sơ đồ** — after the glossary, add:
`### Hình ảnh & Sơ đồ trong phần này`
List every image or diagram referenced in the source. Format per item:
`**[Hình N / Tên diagram]** — <mô tả ngắn nội dung> | Vị trí: <slide number, page, or caption text from source>`
If the source references a diagram but provides no description, write: `[nội dung không được mô tả trong tài liệu — xem tại: <location>]`
Never omit this subsection even if the section has no images — write: `Không có hình ảnh trong phần này.`

---

### BLOCK 2 — SLIDE CONTENT

Header: `## [Section Name] — Slide`

- Follow the textbook's own order and structure — section flow, sub-topics, and emphasis dictate slide breakdown
- Max 6 slides per section (add a slide if images/diagrams require it)
- Each slide: `### Slide N: [Title]` + 3–5 bullet points
- Bullets: Vietnamese noun phrases, max 12 words, English tech terms preserved
- Images & diagrams: include on the slide where the textbook places them. Format:
  `[IMG: <tên/mô tả ngắn> | Nguồn: <caption or page/slide ref from textbook>]`
  If the exact image cannot be extracted: `[IMG: <mô tả> | Xem tại: <location in source>]`
  Never skip a diagram that the textbook uses to explain a concept.
- End with: `### Key Message` — 1 sentence, the single most important takeaway

---

### BLOCK 3 — SEMINAR NOTES (SHORTHAND)

Header: `## [Section Name] — Notes`

Shorthand system:
| Symbol | Meaning |
|--------|---------|
| `→` | leads to / flow |
| `↔` | bidirectional / integration |
| `∵` | because |
| `∴` | therefore |
| `≈` | analogous to |
| `◎` | official definition |
| `△` | architecture component |
| `⚡` | key insight |
| `[?]` | anticipated audience question |
| `※` | external analogy / real-world reference |
| `✓` | benefit |
| `✗` | limitation / trade-off |
| `>>` | drill-down if time allows |
| `[DEMO]` | point to diagram on slide |
| `[PAUSE]` | stop and engage audience |
| `[SKIP?]` | cut if short on time |
| `[LINK]` | connects to another section |

**Opening cluster** (always first, even for mid-series sections):
- `◎ Phần này về:` — 1 line: what this section covers
- `✓ Sau phần này:` — 1–2 lines: what the audience will know/can do
- `[LINK]` back to prior section if relevant

**Body:** concept clusters, not linear bullets. Shorthand throughout.

**Highlighting rules:**
- Wrap key phrases in `**bold**` when: concept appears 3+ times in source, diagram is built around it, or it's load-bearing for understanding later sections
- Add `⚡ TRỌNG TÂM: <phrase>` on its own line for the 1–2 most important ideas per section — things worth pausing on or repeating aloud
- If something is surprising or counterintuitive: prefix with `※ Thú vị:` before the shorthand note

**Rich but short:** each cluster should be scannable in <5 seconds. Never write full sentences — use shorthand symbols. But for anything important, add the bold + ⚡ marker rather than omitting detail.

Include: 1–2 `[?]` with short answer hints, 1–2 `※` mapped to AWS/Kubernetes/Spring Boot/OAuth/BPM equivalents, natural `[PAUSE]` points.

## Processing Rules
- Never invent technical details not in source
- Unreferenced images: `[IMG: diagram referenced in source — add manually]`
- Unexplained concepts: `[không được giải thích trong tài liệu]`
- Preserve all proper nouns exactly

## Self-check Before Outputting
- All Block 1 claims framed as "Tài liệu chỉ ra rằng..."
- Transcript content utilized (not just key points)
- Glossary covers all English tech terms in the section
- Images & diagrams subsection present (even if empty)
- Slide order follows textbook structure
- No diagram skipped in slides
- Seminar notes open with ◎ Phần này về + ✓ Sau phần này
- At least 1 ⚡ TRỌNG TÂM present in notes
- At least 1 external analogy (※) present
- English tech terms not translated
