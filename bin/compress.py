import sys, json, os

# Try to import LLMLingua-2, fallback to original if missing
try:
    from llmlingua import PromptCompressor
except ImportError:
    class PromptCompressor:
        def __init__(self, **kwargs): pass
        def compress_prompt(self, p, **kwargs): 
            return {"compressed_prompt": p, "origin_tokens": len(p)//4, "compressed_tokens": len(p)//4}

# Path to toggle state
STATE_FILE = os.path.expanduser("~/.claude/plugins/shorthand/bin/state.json")

def get_state():
    if not os.path.exists(STATE_FILE): return True
    try:
        with open(STATE_FILE, 'r') as f:
            data = json.load(f)
            return data.get("enabled") != "off"
    except:
        return True

def main():
    try:
        input_data = sys.stdin.read()
        if not input_data.strip():
            return
        data = json.loads(input_data)
        prompt = data.get("prompt", "")
    except Exception:
        prompt = ""

    # Threshold check: Only compress if enabled and prompt is long (> 800 chars)
    if not get_state() or len(prompt) < 800:
        print(json.dumps({"prompt": prompt}))
        return

    try:
        compressor = PromptCompressor(
            model_name="microsoft/llmlingua-2-bert-base-multilingual-cased-meetingbank",
            use_llmlingua2=True,
            device_map="cpu"
        )
        
        # rate=0.4 keeps 40% of the original info
        result = compressor.compress_prompt(
            prompt, 
            rate=0.4, 
            force_tokens=['.php', '.js', 'SQL', 'Error', 'Exception', 'public', 'private', 'function']
        )
        compressed = result['compressed_prompt']
        
        # Report savings to terminal stderr
        orig_t = result.get('origin_tokens', len(prompt)//4)
        comp_t = result.get('compressed_tokens', len(compressed)//4)
        savings = round((1 - (comp_t / orig_t)) * 100, 1)
        
        sys.stderr.write(f"\n[Shorthand] 📉 {orig_t} -> {comp_t} tokens (-{savings}%)\n")
        print(json.dumps({"prompt": compressed}))
    except Exception as e:
        sys.stderr.write(f"\n[Shorthand Error] {str(e)}\n")
        print(json.dumps({"prompt": prompt}))

if __name__ == "__main__":
    main()
