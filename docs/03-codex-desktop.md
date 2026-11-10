# 03 · Desktop assistant with Codex

**Codex (desktop)** is an AI assistant that can read and write files on your
machine and help you write code or get things done. Point it at the local model
from the last step and you get a "local + offline" desktop assistant.

## 1. Install

Download the macOS build from the official site, double-click to install, and
sign in with your account.
(If the site won't open, use the proxy from [01](01-environment-setup.md).)

## 2. Connect the local model

In Codex's settings, point the "model / provider" at your local Ollama:

- Endpoint / Base URL: `http://localhost:11434`
- Model name: `qwen-codex:27b` (the same one you see in `ollama list`)

> Exact menu names can shift between versions — look for something like
> "Model / Provider".

Before you start using it, I run a quick health check to make sure the
desktop app can actually reach the model:

```bash
bash scripts/check-model.sh
```

![Running `check-model.sh` on my machine — all four checks pass, so the desktop app can reach the local model.](images/check-model.png)

## 3. Day-to-day use

- Hand it a project folder and let it read, edit, and run commands.
- For anything non-trivial, have it lay out a plan first, then review before it acts.
- For important changes, have it work on a branch — don't touch the main branch directly.

## 4. Why pair it with a local model

- **Privacy**: your code never goes to a cloud provider.
- **Offline**: it keeps working when you're disconnected.
- **Cost**: running locally means no API bill.

### Gotchas I hit

- I let it edit the main branch directly on a real project and had to untangle a mess. The rule I wrote down for myself: for anything non-trivial, have it work on a branch, never on main.
- The app couldn't reach `localhost:11434` at first because Ollama wasn't started yet. Start Ollama first, then open the desktop app.

## Summary

- ✅ the desktop assistant is wired to the local model
- ✅ you now have a "local model + desktop assistant" loop

Next: [04 · My AI workflow](04-my-ai-workflow.md).
