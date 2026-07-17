#!/bin/sh
# =============================================================================
# run.sh — dusk session startup script (Kiro edition)
#
# This file is executed by your display manager (via exec-dusk) to launch the
# full dusk desktop session. It starts all background services, then enters the
# window manager loop at the bottom.
#
# To autostart your own apps, add:  run "your-app"
# To stop an autostart entry, comment it out with #
# =============================================================================

# run() — start a program only if it is not already running.
# Exact-match (-x) on the 15-char process comm name avoids false "already up"
# hits from loose substring matching.
run() {
  if ! pgrep -x "$(basename "$1" | head -c 15)" >/dev/null; then
    "$@" &
  fi
}

# ── Default home folders ────────────────────────────────────────────────────────
# Create the standard XDG user dirs (Desktop, Downloads, …) on login, idempotently.
command -v xdg-user-dirs-update >/dev/null 2>&1 && xdg-user-dirs-update

# ── Monitor layout ──────────────────────────────────────────────────────────
# Apply a saved arandr/xrandr screen layout named after the current user.
# Generate your layout with arandr, save it to ~/.screenlayout/<username>.sh
# Uncomment the xrandr line below if you are running inside VirtualBox.
#run xrandr --output Virtual-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
[ -f "$HOME/.screenlayout/$(whoami).sh" ] && sh "$HOME/.screenlayout/$(whoami).sh"

# ── System tray applets ───────────────────────────────────────────────────────
run nm-applet                                         # NetworkManager wifi/eth tray
run pamac-tray                                        # Package manager tray
run flameshot                                         # Screenshot tool (tray + daemon)
run xfce4-power-manager                               # Battery / display power management
run xfce4-clipman                                     # Clipboard manager
run blueberry-tray                                    # Bluetooth manager tray
run /usr/lib/xfce4/notifyd/xfce4-notifyd              # Desktop notification daemon
run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1  # Polkit auth popups (sudo GUI)

# ── Compositor ────────────────────────────────────────────────────────────────
# Provides transparency, shadows and smooth window rendering.
run fastcompmgr -c

# ── Keyboard ──────────────────────────────────────────────────────────────────
# dusk reads all its keybindings at runtime from ~/.config/dusk/dusk.cfg, so no
# sxhkd is started here (unlike the config-file WMs).
run numlockx on                                       # Enable numlock on login

# ── Volume control ────────────────────────────────────────────────────────────
run volctl                                            # PipeWire/PulseAudio volume tray

# ── Wallpaper ─────────────────────────────────────────────────────────────────
# Restore the last wallpaper set by feh, else fall back to the default dusk one.
if [ -f "$HOME/.fehbg" ]; then
    sh "$HOME/.fehbg" &
else
    feh --bg-scale ~/.config/dusk/bg/kiro.jpg &
fi

# ── Status bar ────────────────────────────────────────────────────────────────
# dusk draws its own bar; dusk-status.sh feeds the status area via xsetroot.
pkill -x dusk-status.sh 2>/dev/null
~/.config/dusk/scripts/dusk-status.sh &

# ── Window manager loop (with crash guard) ────────────────────────────────────
# dusk handles Super+Shift+R restarts internally (it re-execs itself), so this
# loop only sees dusk actually exit. dusk returns 0 on a deliberate quit/logout
# and non-zero on a crash — the OPPOSITE of dwm's convention, so exit 0 breaks
# the session here rather than relaunching. The crash guard stops an
# autologin lockout: if dusk dies within MIN_UPTIME seconds MAX_CRASHES times in
# a row we drop to a terminal instead of respawning forever.
LOG_DIR="$HOME/.cache/dusk"
SESSION_LOG="$LOG_DIR/session.log"
MIN_UPTIME=5
MAX_CRASHES=3
mkdir -p "$LOG_DIR"
: > "$SESSION_LOG"
crashes=0

while type dusk >/dev/null 2>&1; do
    start=$(date +%s)
    dusk -c "$HOME/.config/dusk/dusk.cfg" 2>> "$SESSION_LOG"
    code=$?
    uptime=$(( $(date +%s) - start ))

    if [ "$code" -eq 0 ]; then
        break                             # clean quit → logout
    fi

    if [ "$uptime" -ge "$MIN_UPTIME" ]; then
        break                             # ran a while then died → treat as logout
    fi

    crashes=$((crashes + 1))
    printf '%s dusk exited %s after %ss — crash %s/%s\n' \
        "$(date '+%F %T')" "$code" "$uptime" "$crashes" "$MAX_CRASHES" >> "$SESSION_LOG"

    if [ "$crashes" -ge "$MAX_CRASHES" ]; then
        for term in alacritty xterm; do
            command -v "$term" >/dev/null 2>&1 || continue
            "$term" -e sh -c 'printf "\n  dusk failed to start (see log below).\n\n  Crash log: ~/.cache/dusk/session.log\n\n"; exec "${SHELL:-sh}"'
            break
        done
        break
    fi
done
