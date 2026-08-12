# The .txt is the source of truth; the PDF is derived

Tailored resumes are written as plain text, and `scripts/txt_to_pdf.js` renders
the PDF from that text. This makes output diffable between applications,
reproducible from the same input, and ATS-safe by construction: single column,
real selectable text, no tables or images.

## Consequences

The layout rules in `skills/resume-builder.md` are parsed literally, so they are
functional rather than cosmetic: ALL CAPS section headings, a `|` in job headers,
two or more spaces before a trailing date, and no bullet characters on
accomplishment lines. Never add a path that produces a PDF some other way.
