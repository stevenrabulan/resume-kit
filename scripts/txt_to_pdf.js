#!/usr/bin/env node
// Convert a tailored resume .txt into an ATS-safe PDF.
//
// Usage: node scripts/txt_to_pdf.js "<input.txt>" ["<output.pdf>"]
//
// No npm dependencies. Renders HTML and prints it to PDF using a Chrome or
// Edge browser you already have installed. If none can be found, see
// resolveBrowser() below for the two escape hatches (CHROME_PATH, puppeteer).
//
// ATS-safe by construction: single column, real selectable text, standard
// fonts, standard headings, no tables, columns, images, headers or footers.
//
// Expects the canonical .txt layout (see templates/master-resume.template.md):
//   line 1: name
//   line 2: contact (pipe-separated)
//   blank
//   summary paragraph
//   blank
//   ALLCAPS section headings (no "|"): CORE SKILLS, WORK EXPERIENCE, EDUCATION
//   skill lines:  "Label: text"
//   job headers:  "TITLE | Company, Location    MM/YYYY - MM/YYYY"  (2+ spaces before the date)
//   bullet lines: plain text under a job header

const fs = require("fs");
const path = require("path");
const os = require("os");
const { execFileSync } = require("child_process");

// ---------------------------------------------------------------------------
// browser resolution
// ---------------------------------------------------------------------------

// Checked in order. First one that exists on disk wins.
const BROWSER_CANDIDATES = [
  // macOS
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
  "/Applications/Chromium.app/Contents/MacOS/Chromium",
  "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge",
  "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser",
  // Linux
  "/usr/bin/google-chrome",
  "/usr/bin/google-chrome-stable",
  "/usr/bin/chromium",
  "/usr/bin/chromium-browser",
  "/usr/bin/microsoft-edge",
  "/snap/bin/chromium",
  // Windows
  "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
  "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe",
  "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe",
  "C:\\Program Files\\Microsoft\\Edge\\Application\\msedge.exe",
];

const NO_BROWSER_MESSAGE = `
Could not find a Chrome-based browser to render the PDF.

Pick whichever is easiest:

  1. Point at a browser you already have:
       CHROME_PATH="/path/to/chrome" node scripts/txt_to_pdf.js "<input.txt>"

  2. Install a bundled one (adds a ~200MB dependency, but always works):
       npm install puppeteer
     Then re-run the same command. This script will detect and use it.

  3. Install Google Chrome: https://www.google.com/chrome/
`;

// On macOS, Codex spawns sandboxed shell commands with CODEX_SANDBOX=seatbelt
// (documented in openai/codex, codex-rs/core/src/spawn.rs). That sandbox
// denies the mach-lookups (windowserver, launchservicesd, and the Chromium
// process rendezvous service) that any Chromium-based browser needs just to
// start, in every mode, headless included, with no launch flag that bypasses
// it. See https://github.com/openai/codex/issues/30043 and
// https://github.com/openai/codex/issues/31560. There is no in-process
// workaround, so it is not worth attempting the launch: check up front and
// fail fast with the fix, instead of letting Chrome abort and macOS throw up
// a crash dialog.
function isInsideKnownBrowserHostileSandbox() {
  return process.platform === "darwin" && !!process.env.CODEX_SANDBOX;
}

function sandboxPreflightMessage(inputPath) {
  return `
Skipping the PDF render: this shell is running inside Codex's macOS sandbox
(CODEX_SANDBOX is set), which blocks a real browser from starting at all. This
is a known Codex sandbox limitation, not a bug in resume-kit or in Chrome —
see https://github.com/openai/codex/issues/30043. Attempting it anyway would
just crash Chrome and pop a macOS crash dialog.

Fix: ask the agent to re-run this exact command with escalated or unsandboxed
permissions. If that is not available, run it yourself in a plain Terminal
window instead:

  node scripts/txt_to_pdf.js "${inputPath}"
`;
}

// Fallback for sandboxes that block the same launch without setting
// CODEX_SANDBOX (or any future variant of this problem). Same fix, phrased
// for a launch that was actually attempted.
function sandboxCrashMessage(inputPath) {
  return `
Chrome crashed immediately on launch (signal SIGABRT).

If a coding agent is running this command inside a sandboxed shell, that
sandbox is blocking the macOS calls a real browser needs to register itself,
and Chrome aborts before it renders anything. This is a known sandbox
limitation, not a bug in resume-kit or in Chrome.

Fix: ask the agent to re-run this exact command with escalated or unsandboxed
permissions. If that is not available, run it yourself in a plain Terminal
window instead:

  node scripts/txt_to_pdf.js "${inputPath}"
`;
}

// Returns { kind: "binary", path } or { kind: "puppeteer" }.
function resolveBrowser() {
  if (process.env.CHROME_PATH) {
    if (!fs.existsSync(process.env.CHROME_PATH)) {
      throw new Error(`CHROME_PATH is set but does not exist: ${process.env.CHROME_PATH}`);
    }
    return { kind: "binary", path: process.env.CHROME_PATH };
  }

  const found = BROWSER_CANDIDATES.find((p) => fs.existsSync(p));
  if (found) return { kind: "binary", path: found };

  // Optional fallback. Only used if the user chose to install it.
  try {
    require.resolve("puppeteer");
    return { kind: "puppeteer" };
  } catch {
    throw new Error(NO_BROWSER_MESSAGE);
  }
}

// ---------------------------------------------------------------------------
// args & guards
// ---------------------------------------------------------------------------

const input = process.argv[2];
if (!input) {
  console.error('Usage: node scripts/txt_to_pdf.js "<input.txt>" ["<output.pdf>"]');
  process.exit(1);
}
if (!fs.existsSync(input)) {
  console.error(`Input not found: ${input}`);
  process.exit(1);
}
const output = process.argv[3] || input.replace(/\.txt$/i, ".pdf");

// ---------------------------------------------------------------------------
// parse
// ---------------------------------------------------------------------------

const esc = (s) => s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");

// Split a "left    right" line where right is a trailing date (2+ spaces).
function splitTrailing(line) {
  const m = line.match(/^(.*?)\s{2,}(\S.*)$/);
  return m ? [m[1].trim(), m[2].trim()] : [line.trim(), ""];
}

const isHeading = (l) => /^[A-Z0-9][A-Z0-9 &/]+$/.test(l) && !l.includes("|");

const raw = fs.readFileSync(input, "utf-8").replace(/\r\n/g, "\n");
const lines = raw.split("\n");

let i = 0;
const name = (lines[i++] || "").trim();
const contact = (lines[i++] || "").trim();
if (!name || !contact) {
  console.error(
    "Missing name/contact. Line 1 must be your name, line 2 your contact details."
  );
  process.exit(1);
}

// summary = everything until the first ALLCAPS heading
const summaryLines = [];
while (i < lines.length && !isHeading(lines[i].trim())) {
  if (lines[i].trim()) summaryLines.push(lines[i].trim());
  i++;
}
const summary = summaryLines.join(" ");

const sections = []; // { heading, items }
let cur = null;
for (; i < lines.length; i++) {
  const t = lines[i].trim();
  if (!t) continue;
  if (isHeading(t)) {
    cur = { heading: t, items: [] };
    sections.push(cur);
    continue;
  }
  if (!cur) continue; // stray line before any heading
  cur.items.push(t);
}

// ---------------------------------------------------------------------------
// render
// ---------------------------------------------------------------------------

function renderSection(sec) {
  const h = sec.heading.toUpperCase();
  let body = "";

  if (h.includes("SKILL")) {
    // "Label: text" pairs
    body = sec.items
      .map((it) => {
        const idx = it.indexOf(":");
        if (idx === -1) return `<p class="skill">${esc(it)}</p>`;
        const label = it.slice(0, idx).trim();
        const text = it.slice(idx + 1).trim();
        return `<p class="skill"><span class="skill-label">${esc(label)}:</span> ${esc(text)}</p>`;
      })
      .join("\n");
  } else if (h.includes("EXPERIENCE")) {
    // Group each job header (contains "|") with its bullets in one block, so a
    // page break cannot strand a job title alone at the bottom of a page.
    let html = "";
    let blockOpen = false;
    let bullets = [];
    const closeBlock = () => {
      if (!blockOpen) return;
      if (bullets.length) {
        html += `<ul>${bullets.map((b) => `<li>${esc(b)}</li>`).join("")}</ul>`;
        bullets = [];
      }
      html += `</div>`;
      blockOpen = false;
    };
    for (const it of sec.items) {
      if (it.includes("|")) {
        closeBlock();
        const [left, date] = splitTrailing(it);
        const [title, company] = left.split("|").map((s) => s.trim());
        html += `<div class="job-block"><div class="job"><span class="job-head"><span class="job-title">${esc(title)}</span>`;
        if (company) html += ` <span class="job-co">| ${esc(company)}</span>`;
        html += `</span>`;
        if (date) html += `<span class="job-date">${esc(date)}</span>`;
        html += `</div>`;
        blockOpen = true;
      } else {
        bullets.push(it);
      }
    }
    closeBlock();
    body = html;
  } else {
    // EDUCATION and anything else: render lines, splitting trailing dates
    body = sec.items
      .map((it) => {
        if (/\s{2,}\S/.test(it)) {
          const [left, date] = splitTrailing(it);
          return `<div class="job"><span class="job-co">${esc(left)}</span><span class="job-date">${esc(date)}</span></div>`;
        }
        return `<p>${esc(it)}</p>`;
      })
      .join("\n");
  }

  return `<h2>${esc(sec.heading)}</h2>\n${body}`;
}

const sectionsHtml = sections.map(renderSection).join("\n");

const html = `<!doctype html><html><head><meta charset="utf-8">
<style>
  @page { size: letter; margin: 0.5in; }
  * { box-sizing: border-box; }
  body { font-family: Arial, Helvetica, sans-serif; color: #111; font-size: 10.5pt; line-height: 1.32; margin: 0; }
  h1 { font-size: 19pt; margin: 0 0 2px; letter-spacing: .3px; }
  .contact { font-size: 9pt; color: #333; margin: 0 0 10px; }
  .summary { margin: 0 0 12px; }
  h2 { font-size: 11pt; text-transform: uppercase; letter-spacing: .6px;
       border-bottom: 1px solid #888; padding-bottom: 2px; margin: 14px 0 7px; }
  p { margin: 0 0 6px; }
  .skill { margin: 0 0 5px; }
  .skill-label { font-weight: bold; }
  .job-block { break-inside: avoid-page; page-break-inside: avoid; }
  .job { display: flex; justify-content: space-between; align-items: baseline; margin: 9px 0 2px; gap: 12px; }
  .job-head { font-weight: bold; }
  .job-date { color: #333; white-space: nowrap; font-size: 9.5pt; }
  ul { margin: 2px 0 6px; padding-left: 18px; }
  li { margin: 0 0 3px; }
</style></head><body>
<h1>${esc(name)}</h1>
<p class="contact">${esc(contact)}</p>
<p class="summary">${esc(summary)}</p>
${sectionsHtml}
</body></html>`;

// ---------------------------------------------------------------------------
// print to PDF
// ---------------------------------------------------------------------------

async function printPdf(browser, htmlPath, outPath) {
  if (browser.kind === "binary") {
    execFileSync(
      browser.path,
      [
        "--headless",
        "--disable-gpu",
        "--no-sandbox",
        "--no-pdf-header-footer",
        `--print-to-pdf=${path.resolve(outPath)}`,
        htmlPath,
      ],
      { stdio: "ignore" }
    );
    return;
  }

  const puppeteer = require("puppeteer");
  const b = await puppeteer.launch();
  try {
    const page = await b.newPage();
    await page.goto(`file://${htmlPath}`, { waitUntil: "load" });
    await page.pdf({
      path: path.resolve(outPath),
      format: "letter",
      printBackground: true,
      margin: { top: "0.5in", right: "0.5in", bottom: "0.5in", left: "0.5in" },
    });
  } finally {
    await b.close();
  }
}

(async () => {
  if (isInsideKnownBrowserHostileSandbox()) {
    console.error(sandboxPreflightMessage(input));
    process.exit(1);
  }

  let browser;
  try {
    browser = resolveBrowser();
  } catch (err) {
    console.error(err.message);
    process.exit(1);
  }

  const tmpHtml = path.join(os.tmpdir(), `resume-${Date.now()}.html`);
  fs.writeFileSync(tmpHtml, html, "utf-8");
  try {
    await printPdf(browser, tmpHtml, output);
  } catch (err) {
    fs.unlinkSync(tmpHtml);
    if (err.signal === "SIGABRT") {
      console.error(sandboxCrashMessage(input));
    } else {
      console.error(`The browser failed to render the PDF: ${err.message}`);
    }
    process.exit(1);
  }
  fs.unlinkSync(tmpHtml);

  if (!fs.existsSync(output)) {
    console.error("The browser did not produce a PDF.");
    process.exit(1);
  }
  console.log(`PDF written to ${output}`);
})();
