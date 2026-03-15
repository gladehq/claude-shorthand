#!/bin/bash
set -e
echo "🚀 Installing Claude Shorthand Plugin..."

# 1. Install dependencies
pip3 install llmlingua --quiet

# 2. Setup target directories
PLUGIN_DIR="$HOME/.claude/plugins/shorthand"
mkdir -p "$PLUGIN_DIR/bin"

# Skills must live in ~/.claude/skills/ to be recognised by Claude Code
SKILLS_DIR="$HOME/.claude/skills/shorthand"
mkdir -p "$SKILLS_DIR"

# 3. Copy files
cp bin/compress.py "$PLUGIN_DIR/bin/"
cp skills/shorthand/SKILL.md "$SKILLS_DIR/"
cp plugin.json "$PLUGIN_DIR/"

# 4. Copy default config only if user doesn't already have one
if [ ! -f "$PLUGIN_DIR/config.json" ]; then
    cp config.json "$PLUGIN_DIR/"
    echo "Default config installed at $PLUGIN_DIR/config.json"
else
    echo "Existing config.json preserved."
fi

# 5. Make script executable
chmod +x "$PLUGIN_DIR/bin/compress.py"

# 6. Create empty log file if it doesn't exist
touch "$PLUGIN_DIR/compress.log"

# 7. Auto-register hook in ~/.claude/settings.json
echo "🔧 Registering hook in ~/.claude/settings.json..."
python3 - <<'EOF'
import json, os, sys

settings_path = os.path.expanduser("~/.claude/settings.json")
if not os.path.exists(settings_path):
    print("settings.json not found — skipping hook registration. Add it manually.")
    sys.exit(0)

with open(settings_path, "r") as f:
    settings = json.load(f)

hook_command = "python3 $HOME/.claude/plugins/shorthand/bin/compress.py"
hook_entry   = {"hooks": [{"type": "command", "command": hook_command}]}

settings.setdefault("hooks", {}).setdefault("UserPromptSubmit", [])

already = any(
    any(h.get("command") == hook_command for h in e.get("hooks", []))
    for e in settings["hooks"]["UserPromptSubmit"]
)

if already:
    print("Hook already registered — skipping.")
else:
    settings["hooks"]["UserPromptSubmit"].append(hook_entry)
    with open(settings_path, "w") as f:
        json.dump(settings, f, indent=2)
    print("Hook registered.")
EOF

# 8. Pre-download the LLMLingua-2 model so first use is instant
echo "📦 Pre-downloading LLMLingua-2 model (~400MB, one-time only)..."
python3 - <<'EOF' 2>/dev/null && echo "✅ Model cached." || echo "⚠️  Model download failed — will retry on first use."
from llmlingua import PromptCompressor
PromptCompressor(
    model_name="microsoft/llmlingua-2-bert-base-multilingual-cased-meetingbank",
    use_llmlingua2=True,
    device_map="cpu"
)
EOF

echo ""
echo "✅ Done! Restart Claude Code to activate."
echo "   Monitor compression: tail -f $HOME/.claude/plugins/shorthand/compress.log"
