# 04 · My AI workflow

The tools are installed — the real question is **how to use them with a rhythm**.
This is my daily loop, shared for reference.

## A day in the loop

1. **Morning (5 min)**: open the desktop assistant and spell out what I want done today.
2. **Work (anytime)**: have the AI plan first → I review → it acts → I review the result.
3. **Wrap-up (5 min)**: `git commit` the day's changes, with a clear note on what I did.

## Three principles

- **Plan before acting**: for anything non-trivial, get a plan first instead of
  diving straight into edits.
- **Commit in small steps**: commit as soon as a small piece is done, with a
  clear message. It's a good habit on its own, and a nice side effect is that it
  keeps your contribution graph active.
- **Local first**: if it can run on your machine, keep it there — privacy, cost,
  and offline access all come for free.

## How I split the tools

| Tool | What it's for |
| --- | --- |
| Ollama | run large models locally; data stays on the machine |
| Codex (desktop) | assistant that reads/writes files, writes code, runs commands |
| git + GitHub | manage code, record progress, show the world what I'm building |
| GitHub Actions | run checks automatically on every commit, so I don't do it by hand |

## Summary

The environment is ready — what's left is to **keep using it and keep committing**.
Small, frequent, honest commits are what turn a one-time setup into a habit you can
actually stick with.
