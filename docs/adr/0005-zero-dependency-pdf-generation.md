# PDF generation has no npm dependencies

`scripts/txt_to_pdf.js` renders through a Chrome-based browser already installed
on the machine rather than bundling one. That is what lets setup be a single
shell script with no install step, no lockfile, and no supply chain.

## Considered options

Puppeteer, which is the obvious choice and would remove the browser-detection
code entirely, at the cost of a ~200MB download on first install. It stays
available as a lazily-required opt-in for machines with no usable browser, and
must not be promoted to a real dependency.
