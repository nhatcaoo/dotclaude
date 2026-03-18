"""
Post-process a pandoc-generated .docx:
- Add full grid borders (all cells, all sides) to every table
- Usage: python3 fix_tables.py input.docx [output.docx]
"""
import sys
from docx import Document
from docx.oxml.ns import qn
from docx.oxml import OxmlElement

def make_border_element(val="single", sz="6", space="0", color="AAAAAA"):
    """Return an <w:XXX> border element (caller sets the tag name)."""
    el = OxmlElement("w:top")   # tag replaced by caller
    el.set(qn("w:val"),   val)
    el.set(qn("w:sz"),    sz)
    el.set(qn("w:space"), space)
    el.set(qn("w:color"), color)
    return el

def set_cell_border(cell, **kwargs):
    """
    Set border on a single cell.
    kwargs keys: top, bottom, left, right, insideH, insideV
    Each value is a dict: {"val": "single", "sz": "6", "color": "AAAAAA"}
    """
    tc   = cell._tc
    tcPr = tc.get_or_add_tcPr()

    # remove existing tcBorders if any
    for existing in tcPr.findall(qn("w:tcBorders")):
        tcPr.remove(existing)

    tcBorders = OxmlElement("w:tcBorders")
    for edge, attrs in kwargs.items():
        el = OxmlElement(f"w:{edge}")
        el.set(qn("w:val"),   attrs.get("val",   "single"))
        el.set(qn("w:sz"),    attrs.get("sz",    "6"))
        el.set(qn("w:space"), attrs.get("space", "0"))
        el.set(qn("w:color"), attrs.get("color", "AAAAAA"))
        tcBorders.append(el)
    tcPr.append(tcBorders)

BORDER = {"val": "single", "sz": "6", "space": "0", "color": "AAAAAA"}
HEADER_BORDER = {"val": "single", "sz": "6", "space": "0", "color": "888888"}

def apply_table_borders(doc):
    for table in doc.tables:
        for row_idx, row in enumerate(table.rows):
            is_header = row_idx == 0
            border = HEADER_BORDER if is_header else BORDER
            for cell in row.cells:
                set_cell_border(
                    cell,
                    top=border, bottom=border,
                    left=border, right=border,
                )

def main():
    src = sys.argv[1]
    dst = sys.argv[2] if len(sys.argv) > 2 else src
    doc = Document(src)
    apply_table_borders(doc)
    doc.save(dst)
    print(f"Borders applied → {dst}")

if __name__ == "__main__":
    main()
