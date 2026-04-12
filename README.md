# Arborescence Explorer

**The zero-install Windows directory scanner built for LLM workflows.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows-0078D6.svg)](https://github.com/DrDiabelsBafian/arborescence-explorer/releases)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE.svg)](https://docs.microsoft.com/en-us/powershell/)

> Scan any folder. Export the tree. Know if it fits your LLM's context window. No install, no CLI, no dependencies.

<!-- SCREENSHOT: replace with actual screenshot -->
<!-- ![Arborescence Explorer GUI](docs/screenshot.png) -->

---

## Why Arborescence Explorer?

You need to feed a directory structure to Claude, ChatGPT, or Gemini. You don't want to install Node.js, Python, or learn CLI flags. You want to **double-click and go**.

| | Arborescence Explorer | Repomix | gptree | `tree` (CMD) |
|---|:---:|:---:|:---:|:---:|
| GUI (no CLI needed) | **Yes** | No | Tauri app | No |
| Zero install (portable EXE) | **Yes** | npm required | pip/brew | Built-in |
| Token estimation | **Yes** | Yes | No | No |
| LLM context compatibility | **Yes** | Yes | No | No |
| File metadata (size, dates) | **Yes** | No | No | No |
| Media analysis (FFprobe) | **Optional** | No | No | No |
| Markdown export | **Yes** | Yes | Yes | No |
| Works offline | **Yes** | Yes | Yes | Yes |
| Open source | **Yes (MIT)** | Yes | Yes | N/A |

## Features

**Core** — Recursive directory scanning with real-time progress. Folders only or folders + files. Configurable max depth. Smart exclusion list (.git, node_modules, __pycache__, .vscode, dist, .cache, and more).

**LLM-ready exports** — TXT (raw, paste directly into any LLM) and Markdown (with metadata table, token count, and context window compatibility chart for Claude 200k, GPT-4o 128k, GPT-4 8k, Gemini 1M).

**Token estimation** — Local calculation (characters / 4), displayed in real-time after each scan. Shows compatibility status for major LLMs: OK, LIMIT, or EXCEEDED.

**File metadata** — Optional file size, creation date, and modification date for every file.

**Media analysis** — Optional FFprobe integration for video/audio files (duration, resolution, codec, bitrate). Greyed out if FFprobe is not installed. Zero forced dependencies.

**Export options** — Save to Downloads, beside the scanned folder, inside it, or choose manually. Auto-versioning (V1, V2...) prevents overwrites. Clipboard copy available.

## Download

### Option 1: Portable EXE (recommended)

Download the latest release from the [Releases page](https://github.com/DrDiabelsBafian/arborescence-explorer/releases).

Double-click. That's it. No install, no admin rights, no dependencies.

> **Note:** Windows SmartScreen may warn you on first launch since the EXE is not code-signed. Click "More info" then "Run anyway". You can verify the SHA-256 hash on the release page.

### Option 2: Run from source

Requires PowerShell 5.1+ (included in Windows 10/11).

1. Download `Arborescence_Explorer_DrDiabelsBafian_ByC.ps1` and `Arborescence_Explorer_DrDiabelsBafian.bat`
2. Place both files in the same folder
3. Double-click the `.bat` file

## Markdown Export Sample

The Markdown export includes a context window compatibility table:

```
### Compatibilite fenetres contexte LLM

| Modele          | Limite | Usage | Statut  |
|-----------------|--------|-------|---------|
| Claude (200k)   | 200.0k | 6.2%  | OK      |
| GPT-4o (128k)   | 128.0k | 9.7%  | OK      |
| GPT-4 (8k)      | 8.0k   | 155%  | DEPASSE |
| Gemini 2.0 (1M) | 1.0M   | 1.2%  | OK      |
```

## Build EXE from Source

Requires the `ps2exe` PowerShell module:

```powershell
Install-Module ps2exe -Scope CurrentUser

ps2exe -InputFile Arborescence_Explorer_DrDiabelsBafian_ByC.ps1 `
       -OutputFile Arborescence_Explorer_Portable.exe `
       -NoConsole `
       -Title "Arborescence Explorer" `
       -Company "DrDiabelsBafian" `
       -Version "5.0.0"
```

## Optional: FFprobe

For video/audio metadata (duration, resolution, codec), install FFprobe:

1. Download from [gyan.dev/ffmpeg/builds](https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip)
2. Extract and add the `bin` folder to your PATH
3. Restart Arborescence Explorer — the checkbox will activate automatically

## Roadmap

- [ ] Drag & drop folder selection
- [ ] Custom exclusion list editor
- [ ] Batch processing mode (scan multiple folders)
- [ ] Export file contents (like Repomix) for full LLM context
- [ ] MCP server integration

## Contributing

Pull requests welcome. For major changes, please open an issue first.

## License

[MIT](LICENSE) — free to use, modify, and distribute.

---

**Made by [Dr. Diabels Bafian](https://github.com/DrDiabelsBafian)** — Built with PowerShell, designed for humans who talk to AIs.

---

# Arborescence Explorer (FR)

**Le scanner d'arborescence Windows sans installation, concu pour les workflows LLM.**

Scannez n'importe quel dossier. Exportez l'arbre. Sachez si ca rentre dans la fenetre contexte de votre LLM. Aucune installation, aucune CLI, aucune dependance.

## Pourquoi cet outil ?

Vous devez fournir une structure de dossier a Claude, ChatGPT ou Gemini. Vous ne voulez pas installer Node.js, Python, ni apprendre des commandes CLI. Vous voulez **double-cliquer et c'est parti**.

## Telecharger

Rendez-vous sur la [page Releases](https://github.com/DrDiabelsBafian/arborescence-explorer/releases) pour telecharger l'EXE portable.

## Licence

[MIT](LICENSE) — libre d'utilisation, modification et distribution.
