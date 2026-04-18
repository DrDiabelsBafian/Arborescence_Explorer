# Contributing to Arborescence Explorer

## How to contribute

1. Fork the repo
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Commit changes with prefixed messages (`git commit -m "Add: my feature"`)
4. Push (`git push origin feature/my-feature`)
5. Open a Pull Request

## Commit message format

Use prefixed commit messages:

- `Add:` — new feature or file
- `Fix:` — bug fix
- `Refactor:` — code restructuring without behavior change
- `Doc:` — documentation only
- `Style:` — formatting, no logic change

## Code style

- PowerShell: `Verb-Noun` function names (PascalCase)
- ASCII only in strings and comments (no accents in code)
- All `.NET` method calls returning values must be prefixed with `[void]` (ps2exe compatibility)
- All user-facing strings must use `Get-Str 'KeyName'` — never hardcode text in GUI or export logic
- Test the GUI after any change: `.\Arborescence_Explorer_DrDiabelsBafian.bat`

## Internationalization (i18n)

The GUI supports English and French via a language hashtable system (`$script:Strings`).

When adding or modifying user-facing text:

1. Add a new key to **both** `EN` and `FR` blocks in `$script:Strings`
2. Use `Get-Str 'YourKey'` everywhere — GUI labels, export content, status messages, error messages
3. If the string uses format placeholders (`{0}`, `{1}`), call it as `(Get-Str 'YourKey') -f $value1, $value2`
4. If the string is a GUI control label, add it to the `$cboLang.Add_SelectedIndexChanged` handler for live switching
5. Test in both EN and FR before submitting

## Bug reports

Use GitHub Issues with:

- Steps to reproduce
- Expected vs actual behavior
- Windows version + PowerShell version (`$PSVersionTable.PSVersion`)
- Screenshot if GUI-related

## Feature requests

Use GitHub Issues. Describe the use case, not just the feature.
