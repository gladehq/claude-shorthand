---
name: shorthand
description: Toggle prompt compression ON, OFF, DRY-RUN, or show STATUS
---

# Shorthand Toggle

Controls the LLMLingua-2 compression hook via `state.json`.

```bash
STATE_DIR="$HOME/.claude/plugins/shorthand/bin"
LOG_FILE="$HOME/.claude/plugins/shorthand/compress.log"
mkdir -p "$STATE_DIR"

if [ "$ARGUMENTS" = "off" ]; then
    echo '{"enabled": "off"}' > "$STATE_DIR/state.json"
    echo "Shorthand compression disabled."
elif [ "$ARGUMENTS" = "dry-run" ]; then
    echo '{"enabled": "dry-run"}' > "$STATE_DIR/state.json"
    echo "Shorthand dry-run enabled — stats will be logged but prompts will not be compressed."
elif [ "$ARGUMENTS" = "status" ]; then
    if [ -f "$STATE_DIR/state.json" ]; then
        STATE=$(python3 -c "import json; print(json.load(open('$STATE_DIR/state.json')).get('enabled','on'))")
        echo "Shorthand is: $STATE"
    else
        echo "Shorthand is: on (default)"
    fi
    if [ -f "$LOG_FILE" ]; then
        echo ""
        echo "Recent activity:"
        tail -5 "$LOG_FILE"
    fi
else
    echo '{"enabled": "on"}' > "$STATE_DIR/state.json"
    echo "Shorthand compression enabled."
fi
```
