# 05 · FAQ

> A running list of real errors I hit while setting things up, and how I fixed them.
> When you hit a new one, add an entry: "symptom → cause → fix" so others don't
> have to learn it the hard way.

## Environment

**Q: `setup.sh` says "this script currently supports macOS only"?**
A: Right now it's macOS only. For Linux / Windows, follow the install steps for
those platforms (the Ollama site has them).

**Q: Homebrew's installer asks for a password?**
A: That's normal — it's your Mac login password (nothing shows on screen as you
type). Just type it and press Enter.

**Q: Downloads from GitHub / model pulls are slow or fail?**
A: Route git through a local proxy port. I use a proxy that listens on `7892`:

```bash
git config --global http.proxy  http://127.0.0.1:7892
git config --global https.proxy http://127.0.0.1:7892
```

> Use whatever port your proxy software shows. To disable it later:
> `git config --global --unset http.proxy`.

**Q: `git commit` says "Committer identity unknown"?**
A: git doesn't know who I am yet. Set it once with `git config --global user.name "..."` and `git config --global user.email "..."`. I hit this on a fresh machine and my commits weren't attributed to me.

## Local models (Ollama)

**Q: `ollama run` hangs or I run out of memory?**
A: Bigger models need more RAM. For a 27B-class model, aim for 16GB+. On a smaller
machine, use a lighter model: `MODEL=qwen2.5:7b bash scripts/setup.sh`.

**Q: What's the local model endpoint?**
A: By default `http://localhost:11434` — point your desktop assistant's model
provider at it.

**Q: After installing Ollama, `ollama` says "command not found"?**
A: The terminal hasn't picked up the new command yet. Open a brand-new terminal
window, or reload your shell config (`source ~/.zshrc` on zsh, `source
~/.bash_profile` on bash). If it's still missing, the installer put the binary in
a folder that isn't on your `PATH` — add that folder to `PATH` in your shell
config and reload again.

## Desktop assistant

**Q: The desktop app can't reach the local model?**
A: Check three things: ① Ollama is running (`ollama serve`); ② the model is pulled
(it shows up in `ollama list`); ③ the provider URL is `http://localhost:11434`.

**Q: The desktop assistant says it can't use the network, even though I'm on a VPN?**
A: The app doesn't always pick up the system VPN by itself. When it needed to
reach GitHub or other sites, I pointed it at my local proxy
(`http://127.0.0.1:7892` — use whatever port your proxy software shows) and made
sure the proxy was actually running first. SSH `git push` often works without
it; HTTPS and the GitHub API usually don't.

---

> Got a question that isn't covered here? Open an [issue](https://github.com/pakewnn-cpu/desktop-tutorial/issues)
> and I'll add the answer to this page once it's sorted.
