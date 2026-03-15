# Claude Shorthand

> Extend your context window and slash token costs.

This plugin integrates **LLMLingua-2** directly into your Claude Code workflow to automatically compress massive prompts and stack traces by **up to 60%** — without losing critical debugging details.

---

## Features

- **Smart Shorthanding** — Uses BERT-based compression to strip redundant boilerplate while keeping your code logic intact.
- **Multi-language** — Protects tokens across PHP, Python, JS/TS, Ruby, Go, Java, Rust, and more out of the box.
- **Configurable** — Tune compression rate, threshold, and protected tokens via `config.json`.
- **Token Stats Logging** — Every compression is logged with timestamp and savings to `compress.log`.
- **Log Rotation** — Log is automatically trimmed to 200 lines when it exceeds 50KB.
- **Dynamic Toggle** — Enable, disable, or switch to dry-run mode with `/shorthand`.
- **Global** — Applies to every project automatically. No per-project setup needed.

---

## Requirements

- Python 3.9+
- `pip3` available on PATH
- Claude Code (CLI)

---

## Installation

1. **Clone or extract** the repository into your preferred directory.

2. **Navigate to the folder:**
   ```bash
   cd claude-shorthand
   ```

3. **Run the installer:**
   ```bash
   ./install.sh
   ```
   This will:
   - Install `llmlingua` and its dependencies via `pip3`
   - Copy plugin files to `~/.claude/plugins/shorthand/`
   - Copy the `/shorthand` skill to `~/.claude/skills/shorthand/`
   - Copy `config.json` to `~/.claude/plugins/shorthand/` (skipped if one already exists)
   - Auto-register the `UserPromptSubmit` hook in `~/.claude/settings.json`
   - Pre-download the LLMLingua-2 BERT model (~400MB) so first use is instant

4. **Restart Claude Code** to activate.

---

## Uninstallation

```bash
./uninstall.sh
```

This removes all plugin files, the skill, and the hook entry from `settings.json`.

---

## How to Use

### Automatic Mode

Every prompt over **800 characters** is automatically compressed before being sent to Claude. Stats are logged silently:

```
15:29:54 [Shorthand] 📉 5462 -> 2701 tokens (-50.5%)
```

### Monitoring Stats

```bash
tail -f ~/.claude/plugins/shorthand/compress.log
```

### Slash Commands

| Command | Description |
|---|---|
| `/shorthand on` | Enable compression (default) |
| `/shorthand off` | Disable compression |
| `/shorthand dry-run` | Log stats but send original prompt unchanged |
| `/shorthand status` | Show current mode and last 5 log entries |

---

## Configuration

Edit `~/.claude/plugins/shorthand/config.json` to customise behaviour:

```json
{
  "rate": 0.4,
  "threshold": 800,
  "extra_force_tokens": ["MyClass", "myFunction", ".blade.php"]
}
```

| Key | Default | Description |
|---|---|---|
| `rate` | `0.4` | Compression aggressiveness — `0.2` = more aggressive, `0.6` = less |
| `threshold` | `800` | Minimum characters before compression triggers |
| `extra_force_tokens` | `[]` | Additional tokens to always preserve (merged with built-in defaults) |

### Default Protected Tokens

The following are protected out of the box across all languages:

- **File extensions:** `.php` `.js` `.ts` `.py` `.rb` `.go` `.java` `.cs` `.cpp` `.rs` `.vue` `.jsx` `.tsx`
- **Keywords:** `function` `class` `def` `self` `import` `async` `await` `return`
- **Errors:** `Error` `Exception` `Traceback` `TypeError` `ValueError` `KeyError` `AttributeError`
- **Database:** `SQL` `SELECT` `INSERT` `UPDATE` `DELETE` `WHERE` `JOIN`
- **HTTP/API:** `HTTP` `API` `GET` `POST` `PUT` `PATCH` `JSON`

---

## File Structure

```
~/.claude/plugins/shorthand/
├── bin/
│   ├── compress.py       # Hook entrypoint
│   └── state.json        # Runtime state (on / off / dry-run)
├── compress.log          # Token savings log (auto-rotated at 50KB)
├── config.json           # User configuration
└── plugin.json           # Plugin metadata

~/.claude/skills/shorthand/
└── SKILL.md              # /shorthand slash command
```

---

## Platform Support

| Platform | Status |
|---|---|
| macOS | ✅ Fully supported |
| Linux | ✅ Fully supported |
| Windows (WSL2 / Git Bash) | ✅ Works |
| Windows (native CMD / PowerShell) | ❌ Not supported |

### Windows Limitation

`install.sh` and `uninstall.sh` are bash scripts and will not run in native Windows CMD or PowerShell. The compression core (`compress.py`) is pure Python and is already cross-platform — the only gap is the installer and uninstaller.

**Want to help?** If you're a Windows developer, contributions are very welcome. What's needed:

- `install.ps1` — PowerShell equivalent of `install.sh`
- `uninstall.ps1` — PowerShell equivalent of `uninstall.sh`

The scripts would need to handle:
- Installing `llmlingua` via `pip` (not `pip3`)
- Copying files to `%USERPROFILE%\.claude\plugins\shorthand\`
- Copying the skill to `%USERPROFILE%\.claude\skills\shorthand\`
- Registering the hook in `%USERPROFILE%\.claude\settings.json` via PowerShell JSON manipulation
- Pre-downloading the LLMLingua-2 model

If you'd like to take this on, please open an issue or submit a PR. Any contribution, no matter how small, is appreciated.

---

## Changelog

### 2026-03-15
- Fixed `install.sh` to use `pip3` instead of `pip`
- Fixed skill registration path to `~/.claude/skills/shorthand/`
- Fixed LLMLingua CUDA error on macOS — added `device_map="cpu"`
- Fixed terminal corruption — stats now go to `compress.log` instead of `/dev/tty`
- `install.sh` now auto-registers the hook in `settings.json`
- `install.sh` now pre-downloads the model so first use is instant
- Added `uninstall.sh` for clean removal
- Added `config.json` for user-configurable rate, threshold, and extra force tokens
- Expanded default `force_tokens` to cover PHP, Python, JS/TS, Ruby, Go, Java, Rust, and more
- Implemented `/shorthand dry-run` — logs stats but passes original prompt unchanged
- Implemented `/shorthand status` — shows current mode and recent log activity
- Added log rotation — trims to 200 lines when file exceeds 50KB
