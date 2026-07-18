# Changelog

All notable changes to **kiro-dusk** are documented here. Dates are `YYYY.MM.DD`, newest first.

## 2026.07.18

### What Changed
- Added application-launch keybindings to `dusk.cfg`, porting ohmychadwm's launcher set so dusk has the same app-launch muscle memory as the other Kiro editions. Previously dusk only launched alacritty, rofi and the Kiro system binds.

### Technical Details
- dusk's `spawn` resolves its argument to a **named command** (confirmed via `parse_void_reference` in `dusk-src/lib/conf.c` — a raw command string is not usable as an execv argv), so each launcher was added twice: as an entry in the `commands` list and as a `spawn` keybinding referencing it by name.
- New Super+Function-key launchers (`Super+F1..F10`): vivaldi-stable, code, inkscape, gimp, meld, vlc, virtualbox, thunar, virt-manager, spotify; `Super+F11/F12` → rofi; `Super+t` → terminal.
- New `Ctrl+Alt` row: f=firefox, b=brave, c/g=chromium, v=vivaldi, o=opera, d=obs, e=archlinux-tweak-tool, a/q=alacritty-tweak-tool, s=fish-tweak-tool, z/w=fastfetch-tweak-tool, i=kiro-iso-builder, p=pamac-manager, m=mintstick, u=pavucontrol, r=archlinux-betterlockscreen, l=archlinux-logout --settings, t=terminal. Plus `Super+Shift+x` → edu-powermenu and `Super+Shift+Escape` → xkill.
- **`Super+Shift+Return` rebound to thunar** (file-manager parity with ohmychadwm), overriding dusk's default rio-draw terminal on that combo.
- Conflicts with dusk's window-manager binds routed around: `Super+v` (group) kept — pavucontrol lives on `Ctrl+Alt+u`; `Super+e` (scratchpad) kept — code lives on `Super+F2`.
- Config validated with the libconfig parser (`config_read_file`) — parses cleanly. `keybindings.txt` cheatsheet regenerated to match.

### Files Modified
- `etc/skel/.config/dusk/dusk.cfg`, `etc/skel/.config/dusk/keybindings.txt`

## 2026.07.17

### What Changed
- Initial config package for the **dusk** edition of Kiro — the first X11 tiling-WM edition minted through `/kiro-create-x11-twm`.

### Technical Details
- Vendored dusk source at `dusk-src/` (source only — no `.git`, object files, compiled binaries or generated `config.h`); compiled at package-build time to `/usr/bin/dusk` + `/usr/bin/duskc`.
- Kiro identity carried entirely in the **runtime `dusk.cfg`** (dusk is libconfig-configured, not recompiled): terminal → alacritty, launcher → rofi, JetBrainsMono Nerd Font, and Kiro binds — `Super+Ctrl+S` (keybindings cheatsheet), `Super+X` / `Ctrl+Alt+K` (archlinux-logout), `Super+Ctrl+L` (lock), `Super+Shift+S` (screenshot). Config kept otherwise stock (workspaces model) and validated with the libconfig parser.
- Session scaffold modelled on ohmychadwm: `exec-dusk` seeds `~/.config/dusk` on first login and hands off to `scripts/run.sh` (AUTOSTART_TEMPLATE-conformant: tray applets, fastcompmgr, feh wallpaper, `dusk-status.sh` bar feeder, crash-guarded WM loop). Loop uses dusk's exit convention (0 = clean quit/logout, non-zero = crash) — the opposite of dwm's — so it does not respawn on logout.
- Bar/window-border colours themed to the **Kiro palette**: navy base (`#0F172A`), Kiro blue (`#0195F7`) for focused title + selected workspace + focused window border, deep blue (`#0245B7`) for scratchpads, Kiro green (`#2FC328`) for marked windows, red (`#E0483D`) for urgent; inactive/hidden dimmed. Replaces dusk's default maroon scheme.

### Files Modified
- `dusk-src/` (vendored source), `etc/skel/.config/dusk/{dusk.cfg,scripts/run.sh,scripts/dusk-status.sh,bg/kiro.jpg}`, `usr/bin/exec-dusk`, `usr/share/xsessions/dusk.desktop`, scaffold (`README.md`, `CLAUDE.md`, `up.sh`, `setup.sh`, `LICENSE`, `.gitignore`, `kiro.jpg`).
