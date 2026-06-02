# Pi Capture

Select text anywhere on macOS → hit a keyboard shortcut → get an interactive Pi session with that text.

## How It Works

```
Select text in any app → ⌃⇧P → Terminal opens → Pi reads your text → you ask questions
```

Works in: browsers, PDFs, Teams, Apple Notes, emails, code editors — anywhere you can select text.

## Install

```bash
./install.sh
```

Deploys engine + adapters to `~/.pi-capture/`. Safe to re-run after `git pull` — upgrades the engine without touching your config.

## Setup (one-time)

### 1. Create the Quick Action in Shortcuts.app

1. Open **Shortcuts.app** → **+** → name it **"Send to Pi"**
2. Click **ℹ️** → **Use as Quick Action** → enable **Services Menu**
3. Set "receives" → **Text** → from **Any Application**
4. Add action: **Run Shell Script**
   - Shell: `/bin/bash`
   - Input: `Shortcut Input`
   - Pass Input: `to stdin`
   - Script: `~/.pi-capture/pi-capture.sh`

### 2. Assign a Keyboard Shortcut

1. **System Settings → Keyboard → Keyboard Shortcuts → Services**
2. Find **"Send to Pi"** → assign shortcut (e.g., **⌃⇧P**)

## Configuration

Edit `~/.pi-capture/config.sh`:

```bash
# Prompt sent to pi with your selected text
PI_CAPTURE_PROMPT="I selected this text. Read it, explain it to me and help me with whatever I ask next."

# Terminal: auto | ghostty | iterm | terminal
PI_CAPTURE_TERMINAL="auto"

# Extra pi flags (e.g., "--model anthropic/claude-sonnet-4" or "--thinking high")
PI_CAPTURE_FLAGS=""
```

Config is never overwritten by the installer — your customizations survive upgrades.

## Architecture

```
~/.pi-capture/
├── config.sh        # Your preferences (prompt, terminal, pi flags)
├── pi-capture.sh    # Engine: stdin text → builds launcher → picks adapter
└── adapters/
    ├── ghostty.sh   # Opens Ghostty with the pi command
    ├── iterm.sh     # Opens iTerm
    └── terminal.sh  # Opens Terminal.app (fallback)
```

**Adding a terminal:** Create `adapters/myterminal.sh` with a `launch()` function, then set `PI_CAPTURE_TERMINAL="myterminal"` in config.

## Uninstall

Remove `~/.pi-capture/` directory, delete the "Send to Pi" shortcut, and remove the keyboard shortcut from System Settings.
