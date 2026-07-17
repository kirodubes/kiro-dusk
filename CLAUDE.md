# CLAUDE.md — kiro-dusk

Guidance for Claude Code when working in this repo. User-facing description is in [README.md](./README.md). Full research/rationale: `Kiro-HQ/Docs/study-of-dusk.md`.

## What this is

The **dusk** edition of the Kiro X11 tiling-WM line — the first edition minted through `/kiro-create-x11-twm` (the X11 sibling of `/kiro-create-wayland-twm`). Ships to the public **nemesis** repo. dusk is [bakkeby/dusk](https://github.com/bakkeby/dusk), a feature-complete dwm fork.

## Edition matrix (the decisions this repo encodes)

| Field | Value |
|---|---|
| WM | dusk (compiled from `dusk-src/`) |
| Family | **compiled suckless**, but **runtime-configured** |
| Config model | **runtime `~/.config/dusk/dusk.cfg`** (libconfig). `config.def.h` holds compile-time defaults only. **NEVER edit `config.h`** — the Makefile regenerates it from `config.def.h`. |
| Repo shape | **binary-only + runtime cfg** — source vendored at `dusk-src/` and compiled at build time; `etc/skel/.config/dusk/` ships only the runtime config + session bits. No C source in the user's home, no recompile hook (dusk never needs recompiling for config). |
| Bar/status | dusk's **built-in bar**, fed by `scripts/dusk-status.sh` via `xsetroot -name` |
| Launcher | rofi (`rofi -show drun`) |
| Terminal | alacritty |
| Notify | xfce4-notifyd (run.sh) |
| Compositor | fastcompmgr (default), picom available |
| Lock | betterlockscreen / slock (`Super+Ctrl+L`) |
| Autostart | Kiro `exec-dusk` → `scripts/run.sh` (AUTOSTART_TEMPLATE). dusk.cfg's native `autostart` is left empty. |
| Model | **workspaces, not tags** — binds use dusk's workspace vocabulary (`viewws`, `movews`, …) |

## Gotchas

- **Config is runtime.** All Kiro identity lives in `etc/skel/.config/dusk/dusk.cfg`. Validate edits with the libconfig parser (`config_read_file`) or `dusk -c dusk.cfg` on a real dusk boot — X11 renders fine in VirtualBox (unlike the Wayland line).
- **Never commit build artifacts.** `dusk-src/` is source only; `config.h`, `*.o`, and the compiled `dusk`/`duskc` are `.gitignore`d. The chroot build regenerates them.
- **Exit-code convention is inverted vs dwm.** dusk self-restarts internally (`execvp`) and returns 0 only on a deliberate quit; `run.sh`'s loop breaks on 0 (logout) and crash-guards non-zero. Don't "fix" it to dwm's `&& continue` semantics.
- **`duskc` + `dbus`.** `HAVE_DBUS=1` is on by default, so `duskc` ships and `dbus` is a runtime dep.
- **Session-exit wiring.** `Super+X` / `Ctrl+Alt+K` call `archlinux-logout`, which needs a `dusk` branch in its `_get_logout()` (see Kiro-HQ command Step 5b). That lives in `archlinux-logout-gtk4`, not here.

## Build

Recipe: `~/KIRO-PKG-BUILD-APPS/kiro-dusk/` (PKGBUILD `build()` runs `make` in `dusk-src/`, `package()` installs the binaries + skel). Flow: `flow-kiro-dusk` (source → chroot build → nemesis_repo). Do not build by hand — Erik runs the flow.
