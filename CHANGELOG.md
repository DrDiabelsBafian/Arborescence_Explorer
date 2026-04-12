# Changelog

## v5.0 — GitHub Edition (April 2026)

### Added
- **Token estimation** — Local calculation (characters / 4) displayed in real-time after each scan
- **LLM context window compatibility** — Shows OK/LIMIT/EXCEEDED for Claude 200k, GPT-4o 128k, GPT-4 8k, Gemini 1M
- **Markdown export** — Structured .md with metadata table, token count, and compatibility chart
- **Enriched exclusion list** — Added .next, dist, .cache, .tmp to default exclusions
- **Open source** — Full source code published under MIT license

### Removed
- Ollama Vision integration (image description via local AI) — unused, added ~80 lines of dead code
- Whisper/Faster-Whisper integration (audio transcription) — unused, added ~40 lines of dead code
- HTML OLED export — not useful for LLM workflows
- JSON export — low demand

### Changed
- Script reduced from 1,207 to ~840 lines (-30%)
- GUI simplified: "Modes Avances" section replaced by single FFprobe checkbox
- FFprobe remains as optional media analysis (greyed out if absent)
- Default export destination changed to Downloads folder
- Version bumped to v5.0

## v4.0 — GUI WinForms (January 2026)

- Full Windows Forms GUI with cyberpunk dark theme
- FFprobe integration for video/audio metadata
- Ollama Vision integration for image description
- Whisper/Faster-Whisper integration for audio transcription
- Multi-format export: TXT, HTML (OLED), JSON
- Auto tool detection via Get-Command (PATH-based)
- DPI awareness for high-resolution displays

## v3.0 — ASCII Pure (January 2026)

- Complete rewrite eliminating all encoding bugs
- ASCII-only output (no box-drawing Unicode characters)
- Stable console menu with multi-choice input

## v2.0 — Interactive Menu (January 2026)

- Unified interactive console menu
- Configurable exclusions, depth, and export options
- HTML OLED export added

## v1.0 — Basic Scripts (January 2026)

- Initial release: 2 separate scripts (folders only + complete)
- TXT export with timestamps and file metadata
