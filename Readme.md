# Claude Shorthand Plugin (2026)

> Extend your context window and slash token costs.

This plugin integrates **LLMLingua-2** directly into your Claude Code workflow to automatically compress massive prompts and stack traces by **up to 60%** — without losing critical debugging details.

---

## Features

- **Smart Shorthanding** — Uses BERT-based compression to strip redundant boilerplate while keeping your code logic intact.
- **Developer First** — Specifically tuned to protect SQL queries, file paths (`.php`, `.js`, `.py`), and exception names.
- **Token Stats Logging** — Compression stats are written to a log file after every compressed prompt.
- **Dynamic Toggle** — Enable or disable compression on the fly with the `/shorthand` slash command.
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

> **macOS Note:** LLMLingua runs on CPU (`device_map="cpu"`) since Macs do not have CUDA. First run downloads the BERT-base model (~400MB) from HuggingFace. Subsequent runs are near-instant.

---

## How to Use

The plugin runs silently in the background on every prompt.

### Automatic Mode

Whenever you submit a prompt exceeding **800 characters**, the plugin automatically compresses it before sending to Claude. Compression stats are appended to a log file:

```
15:29:54 [Shorthand] 📉 5462 -> 2701 tokens (-50.5%)
```

### Monitoring Stats

Open a second terminal tab and run:

```bash
tail -f ~/.claude/plugins/shorthand/compress.log
```

Every compressed prompt will append a timestamped line showing tokens saved.

### Manual Control

| Command | Description |
|---|---|
| `/shorthand on` | Enable automatic compression |
| `/shorthand off` | Disable automatic compression |

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
│   ├── compress.py       # Hook entrypoint — compresses prompts via LLMLingua-2
│   ├── state.json        # Created at runtime — stores enabled/disabled state
│   └── compress.log      # Appended at runtime — token savings per prompt
└── plugin.json           # Plugin metadata

~/.claude/skills/shorthand/
└── SKILL.md              # Slash command definition for /shorthand
```

---

## Changelog

### 2026-03-15
- Fixed `install.sh` to use `pip3` instead of `pip` (resolves `command not found` on macOS)
- Fixed skill registration path — skills must live in `~/.claude/skills/shorthand/`, not inside the plugin directory
- Registered `UserPromptSubmit` hook in `~/.claude/settings.json`
- Fixed LLMLingua CUDA error on macOS by adding `device_map="cpu"` to `PromptCompressor` init
- Fixed terminal corruption caused by writing stats to `/dev/tty` mid-TUI render — stats now append to `compress.log` instead
- Verified end-to-end: prompts under 800 chars pass through unchanged; prompts over 800 chars compress ~50-60%
