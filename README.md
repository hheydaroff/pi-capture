# Pi Capture

Select text anywhere on macOS → ⌃⇧Q → Pi explains it. Zero manual setup.

## Install

```bash
git clone <this-repo> ~/development/pi-capture
cd ~/development/pi-capture
./install.sh
```

That's it. The installer:
1. Copies the capture script to `~/.pi-capture/`
2. Creates an Automator Quick Action in `~/Library/Services/`
3. Assigns ⌃⇧Q as the keyboard shortcut

Restart any open apps, then select text and press **⌃⇧Q**.

## Usage

Select text anywhere (browser, PDF, Teams, Notes, code editor) → press **⌃⇧Q** → Ghostty/iTerm/Terminal opens with Pi reading your text.

## Customization

Edit `~/.pi-capture/pi-capture.sh` directly. It's 13 lines.

To change the keyboard shortcut, go to **System Settings → Keyboard → Keyboard Shortcuts → Services** → find "Send to Pi".

## Uninstall

```bash
rm ~/.pi-capture/pi-capture.sh
rm -r ~/Library/Services/Send\ to\ Pi.workflow
```
