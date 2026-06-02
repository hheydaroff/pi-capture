# Pi Capture

Select text anywhere on macOS → keyboard shortcut → Pi explains it.

## Setup

1. Copy the script:
   ```bash
   mkdir -p ~/.pi-capture
   cp pi-capture.sh ~/.pi-capture/
   chmod +x ~/.pi-capture/pi-capture.sh
   ```

2. Create Quick Action in **Shortcuts.app**:
   - New shortcut → name: **"Send to Pi"**
   - ℹ️ → Use as Quick Action → Services Menu → receives **Text** from **Any Application**
   - Add: **Run Shell Script** (bash, Shortcut Input, to stdin)
   - Script: `~/.pi-capture/pi-capture.sh`

3. Assign shortcut in **System Settings → Keyboard → Keyboard Shortcuts → Services** → e.g. **⌃⇧P**

## Usage

Select text anywhere → press ⌃⇧P → Ghostty opens with Pi reading your text.

## Customization

Edit `~/.pi-capture/pi-capture.sh` directly. It's 13 lines.
