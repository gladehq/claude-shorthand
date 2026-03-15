# 🚀 Claude Shorthand Plugin (2026)

> Extend your context window and slash token costs.

This plugin integrates **LLMLingua-2** directly into your Claude Code workflow to automatically compress massive prompts and stack traces by **up to 80%** — without losing critical debugging details.

---

## ✨ Features

- **Smart Shorthanding** — Uses BERT-based compression to strip redundant framework boilerplate while keeping your code logic intact.
- **Developer First** — Specifically tuned to protect SQL queries, file paths (`.php`, `.js`, `.py`), and exception names.
- **Real-time Stats** — Displays a "Dry-Run" efficiency report in your terminal before the prompt is sent.
- **Dynamic Toggle** — Enable or disable compression on the fly with custom slash commands.

---

## 🛠️ Installation

1. **Extract the Package** — Unzip `claude-shorthand-plugin.zip` into your preferred development directory.

2. **Navigate to the Folder** — Open your terminal and `cd` into the extracted directory:
   ```bash
   cd claude-shorthand-plugin
   ```

3. **Run the Installer** — Execute the installation script to set up local dependencies and register the hook:
   ```bash
   ./install.sh
   ```

4. **Restart** — Restart your Claude Code instance to activate the plugin.

---

## 🎮 How to Use

The plugin runs silently in the background to save you credits and context space.

### 📉 Automatic Mode

Whenever you paste a prompt or stack trace exceeding **800 characters**, the plugin automatically compresses the text and displays an efficiency report in your terminal:

```
[Shorthand] 📉 1540 -> 420 tokens (-72.7%)
```

### 🕹️ Manual Control

Manage the compression engine using these custom slash commands:

| Command | Description |
|---|---|
| `/shorthand on` | Enable automatic compression |
| `/shorthand off` | Disable automatic compression |
| `/shorthand dry-run` | Preview compression stats without sending |

---

## 📝 Configuration

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

> [!IMPORTANT]
> **Initial Setup Note:** The first run may take a few seconds longer as it downloads the local BERT-base model (~400MB) from HuggingFace. Subsequent runs are near-instant and happen entirely on your local machine.
