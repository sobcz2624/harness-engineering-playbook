# Harness Engineering Playbook

## Project Structure

This is a trilingual HonKit book with content in `en/`, `zh/`, and `ja/` directories. Each language directory has the same file structure:
- `README.md` — Book introduction
- `SUMMARY.md` — Table of contents (display titles are translated, file paths stay the same)
- `chapters/` — Chapter content
- `contributors.md` — Contributor list (names are NOT translated)

`LANGS.md` at root registers available languages for HonKit.

## Translation Rules

When translating content between languages:

1. **Technical terms to keep in English across all languages**: Agent, Vibe Coding, closed-loop control, context window, TDD, CI/CD, platform engineering, Conway's Law, YOLO, PR, spec, feedback loop, open-loop control, benchmark
2. **Preserve exactly**: Markdown formatting, link targets, file paths, code blocks, image references
3. **Translate**: Heading text, body text, list items, blockquote content
4. **Do NOT translate**: Contributor names, tool names (HonKit, GitBook), project names (AgentZones, PingCAP, TiDB, Pigsty)
5. **Chinese (zh)**: Simplified Chinese, professional tone, accessible to both technical and business readers
6. **Japanese (ja)**: Professional technical book style, です/ます form for explanatory passages
7. **English (en)**: Clear, concise, professional technical writing

## Build

```bash
npm install
npm run serve   # local dev server at localhost:4000
npm run build   # build to _book/
```
