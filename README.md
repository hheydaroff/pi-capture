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

This copies the capture script to `~/.pi-capture/` and prints setup instructions.

## Setup (one-time)

### 1. Create the Quick Action in Shortcuts.app

1. Open **Shortcuts.app**
2. Click **+** → name it **"Send to Pi"**
3. Click **ℹ️** (top toolbar) → check **Use as Quick Action** → enable **Services Menu**
4. Set "receives" → **Text** → from **Any Application**
5. Add action: **Run Shell Script**
   - Shell: `/bin/bash`
   - Input: `Shortcut Input`
   - Pass Input: `to stdin`
   - Script body:
     ```bash
     ~/.pi-capture/pi-capture.sh
     ```

### 2. Assign a Keyboard Shortcut

1. **System Settings → Keyboard → Keyboard Shortcuts → Services**
2. Find **"Send to Pi"** under the Text section
3. Click "none" and press your shortcut (e.g., **⌃⇧P**)

## Usage

1. Select any text (browser, PDF, Teams, Notes, anywhere)
2. Press your shortcut (e.g., ⌃⇧P)
3. A Terminal window opens with Pi reading your selected text
4. Pi explains the text and waits for your follow-up questions
5. Full interactive session — ask as many follow-ups as you want

## How It Works (Technical)

1. macOS Quick Action captures selected text via the Services menu
2. Text is piped to `pi-capture.sh` via stdin
3. Script saves text to a temp file (`/tmp/pi-capture-<pid>.md`)
4. Creates a `.command` launcher file
5. `open` runs it — macOS opens a new Terminal window
6. Pi starts with `@file` (attaches the text) + initial prompt

## Customization

Edit `~/.pi-capture/pi-capture.sh` to change:
- The initial prompt Pi receives
- Terminal behavior (add `--model`, `--thinking`, etc.)

### Use iTerm instead of Terminal.app

Right-click any `.command` file → Get Info → Open With → iTerm → Change All

## Uninstall

Remove `~/.pi-capture/pi-capture.sh`, then delete the "Send to Pi" shortcut in Shortcuts.app and remove the keyboard shortcut from System Settings.
