#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const MarkdownIt = require('markdown-it');
const md = new MarkdownIt({ html: true, linkify: true, typographer: true });

const file = process.argv[2];
const src = fs.readFileSync(file, 'utf8');
const body = md.render(src);
const outPath = path.join(path.dirname(file), path.basename(file, '.md') + '.html');

// Try to include project stylesheet if it exists
const stylePath = path.join(process.cwd(), 'style.css');
let styleLink = '';
if (fs.existsSync(stylePath)) {
  const rel = path.relative(path.dirname(outPath), stylePath).replace(/\\/g, '/');
  styleLink = `<link rel="stylesheet" href="${rel}">`;
}

const html = `<!DOCTYPE html>
<html><head><meta charset="UTF-8"><title>${path.basename(file)}</title>${styleLink}</head>
<body>${body}</body></html>`;

fs.writeFileSync(outPath, html);
