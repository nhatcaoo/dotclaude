Create a new RFP → technical-solution-deck (+ estimation) project.

For proposal / bid work: turn an RFP into a technical solution deck (per-slide
content + diagram prompts) and, optionally, a high-level estimation BoQ aligned
to that deck. Follows the RIPER workflow; reply in Vietnamese; state `[PHASE: X]`
at the top of each turn.

Steps:
1. Ask for the project name (slug: kebab-case).
2. Ask the user to paste the RFP / brief, or give a file path.
3. Ask what to produce: (a) deck only, (b) estimation only, (c) both (default c).
   Ask the final shareable format: Markdown (default) / PDF / DOCX / HTML.
4. Create folder `projects/YYYY-MM-{name}/` (today's date) with a `diagrams/` subdir.
5. Save the RFP to `00-brief.md`.
6. Write `project.json`:
   `{ "name": "<slug>", "type": "rfp-deck", "produce": "<a|b|c>", "format": "<fmt>", "created": "<date>" }`
7. Scaffold the numbered slot files (headers only; omit those out of scope):
   - `01-requirements.md` — requirements extracted from the RFP (Phase R)
   - `02-decisions.md` — stack / integration / residency choices + rationale (Phase I→P)
   - `03-slide-blueprint.md` — slide list + the ONE idea each diagram conveys (Phase P; **GATE**)
   - `04-slides-content-and-prompts.md` — content + diagram prompts (Phase E) — deck scope
   - `05-estimation.md` — high-level estimation BoQ (Phase P) — estimation scope
   - `06-boq-content-alignment.md` — align BoQ ↔ deck (Review) — estimation scope
   (deck-only → skip 05/06; estimation-only → skip 03/04.)
8. State `[PHASE: R — Requirements from RFP]`. List assumptions first (reveal-first rule),
   then begin Round 1 questioning.

Guardrails to carry through every phase:
- The deck must clear the "specific, not box-stack" bar: real engineering diagrams
  (flow / topology / sequence / data model), named technology, real numbers
  (tag "indicative / confirmed at PoC"), traceable compliance (control → mechanism → evidence).
- Get `03-slide-blueprint.md` approved **before** writing any diagram prompt in `04`.
- At Execute, drive `04` with the **`solution-deck-prompts`** skill and lint the result;
  drive `05` → `06` with the **`boq-deck-alignment`** skill (verify arithmetic + scan
  divergence + write the alignment doc).
