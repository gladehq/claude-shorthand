#!/bin/bash
set -e
echo "🗑️  Uninstalling Claude Shorthand Plugin..."

PLUGIN_DIR="$HOME/.claude/plugins/shorthand"
SKILLS_DIR="$HOME/.claude/skills/shorthand"

# Remove plugin and skill directories (includes compress.log)
[ -d "$PLUGIN_DIR" ] && rm -rf "$PLUGIN_DIR" && echo "Removed $PLUGIN_DIR"
[ -d "$SKILLS_DIR" ] && rm -rf "$SKILLS_DIR" && echo "Removed $SKILLS_DIR"

# Remove hook from ~/.claude/settings.json
python3 - <<'EOF'
import json, os, sys

settings_path = os.path.expanduser("~/.claude/settings.json")
if not os.path.exists(settings_path):
    sys.exit(0)

with open(settings_path, "r") as f:
    settings = json.load(f)

hook_command = "python3 $HOME/.claude/plugins/shorthand/bin/compress.py"

if "hooks" in settings and "UserPromptSubmit" in settings["hooks"]:
    settings["hooks"]["UserPromptSubmit"] = [
        e for e in settings["hooks"]["UserPromptSubmit"]
        if not any(h.get("command") == hook_command for h in e.get("hooks", []))
    ]
    if not settings["hooks"]["UserPromptSubmit"]:
        del settings["hooks"]["UserPromptSubmit"]
    if not settings["hooks"]:
        del settings["hooks"]

with open(settings_path, "w") as f:
    json.dump(settings, f, indent=2)

print("Hook removed from settings.json.")
EOF

echo ""
echo "✅ Uninstalled. Restart Claude Code to complete removal."
