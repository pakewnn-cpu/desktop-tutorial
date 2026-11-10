# 01 · Environment setup

Before we touch any AI tooling, let's get the basics right. The next few steps
all build on these three things.

## 1. Open Terminal

macOS ships with Terminal. Press `Command + Space`, type `Terminal`, and hit
Enter. Every command in this guide goes into that black window.

## 2. Install Homebrew (the command-line "app store" for macOS)

We'll use it to install Ollama and the other tools below. Install it once:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After it finishes, follow the on-screen instructions to add `brew` to your PATH
(the terminal prints the exact command — just paste it and hit Enter).
Verify with `brew --version`; if it prints a version number, you're good.

## 3. Install git (the tool that manages code)

```bash
xcode-select --install      # first run pops a dialog — click "Install"
git --version               # verify
```

## 4. Set your git identity (so commits are attributed to you)

```bash
git config --global user.name  "pakewnn-cpu"
git config --global user.email "your-email@example.com"   # replace with your email
```

> This one matters more than it looks: GitHub's contribution graph keys off
> *who* committed. Without an identity set, your commits won't count toward you.

## 5. Network proxy (optional)

Some connections to GitHub are slow or flaky. If that's you, route git through a
local proxy — a proxy tool that listens on a port on your own machine:

```bash
git config --global http.proxy  http://127.0.0.1:7892
git config --global https.proxy http://127.0.0.1:7892
```

> `7892` is just an example port — use whatever your proxy software shows.
> To turn it off later: `git config --global --unset http.proxy`.

### Gotchas I hit

- On Apple Silicon Macs, Homebrew installs to `/opt/homebrew`, and the PATH line it prints is different from the one in most older tutorials. If `brew` says "command not found" right after install, run the `echo 'export PATH ...'` line that the installer printed for you — don't copy the Intel version.
- I left the git proxy on once and got confused when pushes suddenly failed on a fast connection. `git config --global --unset http.proxy` (and the `https.proxy` one) fixed it.

## Summary

- ✅ Homebrew installed
- ✅ git installed and identity configured
- ✅ proxy configured (if you need it)

Foundation done. Next: [02 · Local models with Ollama](02-ollama-local-models.md).
