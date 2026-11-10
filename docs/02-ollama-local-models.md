# 02 · Local models with Ollama

**Ollama** lets you run a large language model on **your own machine** — your
data never leaves the computer, and it works offline. This is the core of a
"local-first" AI setup.

## 1. Install

```bash
brew install ollama
brew services start ollama      # start at login, keep it running in the background
```

Verify: open a browser to `http://localhost:11434`. If it loads, it's running.

## 2. Pull a model

You download a model once, then reuse it locally. I usually reach for
`qwen-codex:27b` (good for coding):

```bash
ollama pull qwen-codex:27b
ollama list                    # see what's on your machine
```

> 27B is a big model and eats memory. If your Mac has little RAM, grab a lighter
> one instead: `ollama pull qwen2.5:7b` or `ollama pull llama3.1:8b`.

![The output of `ollama list` on my machine — five models, and the 27B one is the one I code with.](images/ollama-list.png)

## 3. Run it

```bash
# one-shot question
ollama run qwen-codex:27b "explain a vector database in one sentence"

# interactive chat (Ctrl+C to quit)
ollama run qwen-codex:27b
```

## 4. Let other programs call it

Ollama exposes a local HTTP endpoint at `http://localhost:11434`. The desktop
assistant in the next step, and any other AI tool, can talk to the local model
through it — **no need to send your data to a cloud provider**.

### Gotchas I hit

- The first `ollama pull` of a 27B model takes a while and the terminal looks completely frozen. It's downloading, not stuck — I killed it twice before I trusted it.
- `ollama list` showed the model but `ollama run` just hung. The service wasn't actually running in the background; `brew services start ollama` (or `ollama serve` in a separate terminal) fixed it.
- On a Mac with limited RAM, a 27B model will swap and crawl. I switched to `qwen2.5:7b` and it became usable again.

## Summary

- ✅ a local model is running, and your data stays on your machine
- ✅ you know the endpoint: `http://localhost:11434`

Next: [03 · Desktop assistant with Codex](03-codex-desktop.md).
