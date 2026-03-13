Convert markdown file(s) in the current research project to PDF.

Usage:
  /export-pdf                  — convert all .md files in current project folder
  /export-pdf path/to/file.md  — convert a single file

## Pre-flight

Check puppeteer is available (installed as part of md-to-pdf):
```bash
node -e "require('/home/ca-00466/.nvm/versions/node/v20.11.0/lib/node_modules/md-to-pdf/node_modules/puppeteer')" 2>/dev/null \
  || npm install -g md-to-pdf
```

## Why not use `md-to-pdf` CLI directly?
It hangs when a markdown file embeds PNG images larger than ~500KB because its
internal HTTP server stalls serving large files to headless Chrome. Use the
puppeteer-inline approach below instead.

## Conversion method

For each target .md file, run:

```bash
node - "$MD_FILE" "$OUT_FILE" <<'SCRIPT'
const fs = require('fs'), path = require('path');
const PPTR = '/home/ca-00466/.nvm/versions/node/v20.11.0/lib/node_modules/md-to-pdf/node_modules/puppeteer';
const MARKED = '/home/ca-00466/.nvm/versions/node/v20.11.0/lib/node_modules/md-to-pdf/node_modules/marked';
const puppeteer = require(PPTR);
const { marked } = require(MARKED);
const [,, mdFile, outFile] = process.argv;
const basedir = path.dirname(path.resolve(mdFile));
let html = marked.parse(fs.readFileSync(mdFile, 'utf8'));
html = html.replace(/src="([^"]+)"/g, (m, src) => {
  if (src.startsWith('http')) return m;
  const p = path.resolve(basedir, src);
  if (!fs.existsSync(p)) return m;
  const ext = path.extname(p).slice(1).toLowerCase();
  const mime = (ext === 'jpg' || ext === 'jpeg') ? 'image/jpeg' : 'image/png';
  return `src="data:${mime};base64,${fs.readFileSync(p).toString('base64')}"`;
});
const fullHtml = `<!DOCTYPE html><html><head><meta charset="utf-8"><style>
body{font-family:-apple-system,sans-serif;max-width:900px;margin:0 auto;padding:20px;font-size:14px;line-height:1.6}
h1{font-size:24px;border-bottom:2px solid #333;padding-bottom:8px}
h2{font-size:20px;border-bottom:1px solid #ddd;padding-bottom:4px}
h3{font-size:16px}
code{background:#f4f4f4;padding:2px 4px;border-radius:3px;font-size:12px}
pre code{display:block;padding:12px;overflow-x:auto}
table{border-collapse:collapse;width:100%;margin:16px 0}
th,td{border:1px solid #ddd;padding:8px 12px;text-align:left}
th{background:#f0f0f0;font-weight:bold}
img{max-width:100%;height:auto;display:block;margin:16px auto}
blockquote{border-left:4px solid #ddd;margin:0;padding-left:16px;color:#666}
</style></head><body>${html}</body></html>`;
const tmp = '/tmp/_export_pdf_render.html';
fs.writeFileSync(tmp, fullHtml);
(async () => {
  const b = await puppeteer.launch({ args: ['--no-sandbox', '--disable-setuid-sandbox'] });
  const pg = await b.newPage();
  await pg.goto('file://' + tmp, { waitUntil: 'networkidle0', timeout: 60000 });
  await pg.pdf({ path: outFile, format: 'A4',
    margin: { top: '20mm', right: '20mm', bottom: '20mm', left: '20mm' },
    printBackground: true });
  await b.close();
  console.log('Done ->', outFile);
})().catch(e => { console.error(e); process.exit(1); });
SCRIPT
```

## Output location
- Place PDFs in `pdf-exports/` subfolder alongside the source .md files (create if missing)
- Naming: same basename, `.pdf` extension
- Report each: `filename.md → pdf-exports/filename.pdf (size)`
