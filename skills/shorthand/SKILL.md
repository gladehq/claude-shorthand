---
name: shorthand
description: Toggle prompt compression ON or OFF
---

# Shorthand Toggle
This command updates the local `state.json` to enable or disable the LLMLingua-2 hook.

```bash
# Update the state file
STATE_DIR="$HOME/.claude/plugins/shorthand/bin"
mkdir -p "$STATE_DIR"
if [ "$ARGUMENTS" = "off" ]; then
    echo '{"enabled": "off"}' > "$STATE_DIR/state.json"
    echo "Shorthand mode disabled."
else
    echo '{"enabled": "on"}' > "$STATE_DIR/state.json"
    echo "Shorthand mode enabled."
fi
