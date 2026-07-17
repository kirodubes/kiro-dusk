# kiro-dusk

The **dusk** edition of Kiro — a ready-to-run desktop built on [dusk](https://github.com/bakkeby/dusk), bakkeby's feature-complete fork of dwm.

Where dwm/chadwm are configured by editing C and recompiling, **dusk is configured at runtime** from a single [libconfig](https://hyperrealm.github.io/libconfig/) file, `~/.config/dusk/dusk.cfg` — change a keybinding, colour or window rule and restart dusk (`Super+Shift+R`), no rebuild needed.

## What it ships

- **dusk** + **duskc** (its D-Bus control client), compiled from vendored source into `/usr/bin`.
- A Kiro-tailored **`~/.config/dusk/dusk.cfg`** — SUPER-based keybindings, Kiro apps (alacritty, rofi), workspace layout, colours and window rules.
- The Kiro session scaffold: `exec-dusk` (display-manager entry) → `scripts/run.sh` (starts tray, compositor, wallpaper, status bar, then launches dusk).
- A simple status feeder (`scripts/dusk-status.sh`) for dusk's built-in bar, the Kiro wallpaper, and a `keybindings.txt` reference (`Super+Ctrl+S` opens the cheatsheet).

## How to install

`kiro-dusk` is available from the Kiro **nemesis** repo:

```bash
sudo pacman -S kiro-dusk
```

Then pick **dusk** from your display manager's session menu and log in. On first login the config is seeded from `/etc/skel/.config/dusk` into your home directory.

## Configuring

Everything lives in `~/.config/dusk/dusk.cfg`. See the [dusk wiki](https://github.com/bakkeby/dusk/wiki) for the full configuration reference. Session autostart (tray applets, compositor, wallpaper) is in `~/.config/dusk/scripts/run.sh`.

<!-- KIRO-FUNDING-FOOTER:START — managed by Kiro-HQ/cascade-readme-footer.sh -->
## Help fund Kiro

Everything I build here stays free and open — always. If Kiro or any of these
tools have ever saved you time or taught you something, a small monthly
contribution helps keep the work going. Donations target break-even, nothing
more — the core always stays free for everyone.

- GitHub Sponsors: https://github.com/sponsors/erikdubois
- Patreon: https://www.patreon.com/c/kiroproject
- YouTube memberships: https://www.youtube.com/@ErikDubois/join
- Ko-fi: https://ko-fi.com/erikdubois
- PayPal: https://www.paypal.me/erikdubois
<!-- KIRO-FUNDING-FOOTER:END -->
