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

**Q: First time I `git push` to GitHub it asks for a username and password, or I get "Permission denied (publickey)"?**
A: I was pushing over the HTTPS remote and had no credentials saved, or I never set up an SSH key in the first place. The fix that stuck was doing the SSH setup once: `ssh-keygen -t ed25519 -C "me@example.com"`, copy the public key at `~/.ssh/id_ed25519.pub` into GitHub under Settings → SSH keys, then switch the remote to the SSH form with `git remote set-url origin git@github.com:me/repo.git`. After that push just works without asking for a password.

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

**Q: After a reboot, the desktop assistant can't reach the local model, even though it worked before?**
A: Ollama doesn't start by itself when the Mac boots, so the `http://localhost:11434`
endpoint is down until you launch it. Start Ollama again (open the app, or run
`ollama serve` in a terminal), then retry. To stop it from happening every time,
turn on "Start at login" in Ollama's settings so it comes back on its own.

**Q: `check-model.sh` says the model is offline, but `ollama list` shows it?**
A: `ollama list` only reads the model files on disk — it doesn’t mean the server
is running. The checks that actually matter talk to `http://localhost:11434`, so
if the Ollama server isn’t up, every HTTP check fails even though the model is
clearly downloaded. Start the server (`ollama serve`, or open the Ollama app),
then re-run `check-model.sh`.

**Q: Each response is slow, or the model seems to reload every time?**
A: That's usually the model being unloaded between requests. I set `OLLAMA_KEEP_ALIVE=-1` (unload right after each request) to free RAM, but with a
27B-class model that means it has to reload ~30GB from disk on the next message,
so the first token of every reply is slow. To keep it warm, raise the value --
`export OLLAMA_KEEP_ALIVE=30m` (or `1h` / `24h`) before starting the server, so it
stays in memory for that long after the last request. Trade-off: a kept-alive
model holds its RAM the whole time, so only keep it alive if you have the memory
to spare. The default is 5 minutes.

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
