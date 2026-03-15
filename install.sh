#!/bin/bash
set -e
echo "🚀 Installing Claude Shorthand Plugin..."

# 1. Install dependencies
pip install llmlingua --quiet

# 2. Setup target directory
PLUGIN_DIR="$HOME/.claude/plugins/shorthand"
mkdir -p "$PLUGIN_DIR/bin"
mkdir -p "$PLUGIN_DIR/skills/shorthand"

# 3. Copy files (Run this from the root of your manually created folder)
cp bin/compress.py "$PLUGIN_DIR/bin/"
cp skills/shorthand/SKILL.md "$PLUGIN_DIR/skills/shorthand/"
cp plugin.json "$PLUGIN_DIR/"

# 4. Make script executable
chmod +x "$PLUGIN_DIR/bin/compress.py"

echo "✅ Success! Restart Claude Code and test with a long prompt."
