# Claude Shorthand Plugin (2026)

> Extend your context window and slash token costs.

This plugin integrates **LLMLingua-2** directly into your Claude Code workflow to automatically compress massive prompts and stack traces by **up to 80%** — without losing critical debugging details.

---

## Features

- **Smart Shorthanding** — Uses BERT-based compression to strip redundant framework boilerplate while keeping your code logic intact.
- **Developer First** — Specifically tuned to protect SQL queries, file paths (`.php`, `.js`, `.py`), and exception names.
- **Real-time Stats** — Displays a "Dry-Run" efficiency report in your terminal before the prompt is sent.
- **Dynamic Toggle** — Enable or disable compression on the fly with custom slash commands.

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
   - Copy the `/shorthand` skill to `~/.claude/plugins/shorthand/skills/shorthand/`
   - Make `compress.py` executable

4. **Register the hook** — Add the following to your `~/.claude/settings.json` under the top-level object:
   ```json
   "hooks": {
     "UserPromptSubmit": [
       {
         "hooks": [
           {
             "type": "command",
             "command": "python3 $HOME/.claude/plugins/shorthand/bin/compress.py"
           }
         ]
       }
     ]
   }
   ```

5. **Restart Claude Code** to activate the plugin.

> **Note:** `pip` is not aliased on all systems. The installer uses `pip3` explicitly to ensure compatibility.

---

## How to Use

The plugin runs silently in the background to save you credits and context space.

### Automatic Mode

Whenever you paste a prompt or stack trace exceeding **800 characters**, the plugin automatically compresses the text and displays an efficiency report in your terminal:

```
[Shorthand] 📉 1540 -> 420 tokens (-72.7%)
```

### Manual Control

Manage the compression engine using these custom slash commands:

| Command | Description |
|---|---|
| `/shorthand on` | Enable automatic compression |
| `/shorthand off` | Disable automatic compression |
| `/shorthand dry-run` | Preview compression stats without sending |

---

## Configuration

To tune the sensitivity of the compressor, edit `bin/compress.py`:

```python
# Minimum character count to trigger compression (default: 800)
if len(prompt) < 800:
    ...

# Compression rate: lower = more aggressive, higher = more detail retained
rate = 0.4
```

| Parameter | Default | Description |
|---|---|---|
| `len(prompt) < 800` | `800` | Minimum characters required to trigger compression |
| `rate` | `0.4` | Compression aggressiveness (`0.2` = more, `0.6` = less) |

---

## File Structure

```
~/.claude/plugins/shorthand/
├── bin/
│   ├── compress.py      # Hook entrypoint — compresses prompts via LLMLingua-2
│   └── state.json       # Created at runtime — stores enabled/disabled state
├── skills/
│   └── shorthand/
│       └── SKILL.md     # Slash command definition for /shorthand
└── plugin.json          # Plugin metadata
```

---

## Changelog

### 2026-03-15
- Fixed `install.sh` to use `pip3` instead of `pip` (resolves `command not found` on macOS systems where `pip` is not aliased)
- Registered `UserPromptSubmit` hook in `~/.claude/settings.json`
- Verified end-to-end: `compress.py` correctly passes through short prompts and triggers LLMLingua-2 for prompts over 800 characters

---

> [!IMPORTANT]
> **Initial Setup Note:** The first run may take a few seconds longer as it downloads the local BERT-base model (~400MB) from HuggingFace. Subsequent runs are near-instant and happen entirely on your local machine.
