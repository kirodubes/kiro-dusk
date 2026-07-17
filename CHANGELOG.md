# Changelog

All notable changes to **kiro-dusk** are documented here. Dates are `YYYY.MM.DD`, newest first.

## 2026.07.17

### What Changed
- Initial config package for the **dusk** edition of Kiro — the first X11 tiling-WM edition minted through `/kiro-create-x11-twm`.

### Technical Details
- Vendored dusk source at `dusk-src/` (source only — no `.git`, object files, compiled binaries or generated `config.h`); compiled at package-build time to `/usr/bin/dusk` + `/usr/bin/duskc`.
- Kiro identity carried entirely in the **runtime `dusk.cfg`** (dusk is libconfig-configured, not recompiled): terminal → alacritty, launcher → rofi, JetBrainsMono Nerd Font, and Kiro binds — `Super+Ctrl+S` (keybindings cheatsheet), `Super+X` / `Ctrl+Alt+K` (archlinux-logout), `Super+Ctrl+L` (lock), `Super+Shift+S` (screenshot). Config kept otherwise stock (workspaces model) and validated with the libconfig parser.
- Session scaffold modelled on ohmychadwm: `exec-dusk` seeds `~/.config/dusk` on first login and hands off to `scripts/run.sh` (AUTOSTART_TEMPLATE-conformant: tray applets, fastcompmgr, feh wallpaper, `dusk-status.sh` bar feeder, crash-guarded WM loop). Loop uses dusk's exit convention (0 = clean quit/logout, non-zero = crash) — the opposite of dwm's — so it does not respawn on logout.

### Files Modified
- `dusk-src/` (vendored source), `etc/skel/.config/dusk/{dusk.cfg,scripts/run.sh,scripts/dusk-status.sh,bg/kiro.jpg}`, `usr/bin/exec-dusk`, `usr/share/xsessions/dusk.desktop`, scaffold (`README.md`, `CLAUDE.md`, `up.sh`, `setup.sh`, `LICENSE`, `.gitignore`, `kiro.jpg`).
