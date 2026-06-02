# Pi Capture

Select text anywhere on macOS → **⌃⇧Q** → Pi explains it.

One script, one installer, zero manual setup. No sudo required.

## Install

```bash
git clone https://github.com/yourusername/pi-capture.git
cd pi-capture
./install.sh
```

The installer automatically:
1. Deploys the capture script to `~/.pi-capture/`
2. Creates an Automator Quick Action in `~/Library/Services/`
3. Assigns **⌃⇧Q** as the system-wide keyboard shortcut
4. Flushes the services cache

Restart any open apps, then select text and press **⌃⇧Q**.

## Try It

Select the text below, then press **⌃⇧Q**:

> The Zettelkasten method is a personal knowledge management system invented by German sociologist Niklas Luhmann. He used it to write over 70 books and 400 scholarly articles. The core idea is that notes should be atomic (one idea per note), linked to each other, and written in your own words. This forces you to think about how ideas connect rather than just collecting information passively.

If a terminal opened with Pi explaining Zettelkasten to you — it works.

## Usage

Select text anywhere → press **⌃⇧Q** → your terminal opens with an interactive Pi session, text loaded as context.

Works in browsers, PDFs, messaging apps, code editors, Notes, Mail — anything with selectable text.

## How It Works

```
⌃⇧Q triggers macOS Service → selected text piped to pi-capture.sh → opens terminal with:
pi @captured-text.md "I selected this text. Read it, explain it to me and help me with whatever I ask next."
```

Terminal preference: Ghostty > iTerm > Terminal.app (auto-detected).

## Compatibility

| Works | Doesn't work |
|-------|-------------|
| Safari, Chrome, Firefox, Arc | Text inside images (no OCR) |
| VS Code, Xcode, any editor | Password/secure text fields |
| Preview, PDF Expert | Some sandboxed apps |
| Teams, Slack, iMessage, Mail | |
| Notes, Pages, any text field | |

## Customization

Edit `~/.pi-capture/pi-capture.sh` — it's 13 lines.

To change the keyboard shortcut: **System Settings → Keyboard → Keyboard Shortcuts → Services** → "Send to Pi".

## Uninstall

```bash
rm -rf ~/.pi-capture ~/Library/Services/Send\ to\ Pi.workflow
```

## Security

This project is 2 files. Here's exactly what they do:

**`pi-capture.sh` (13 lines)** — the thing that runs when you press ⌃⇧Q:
1. Reads the selected text from stdin
2. Writes it to a temp file (`/tmp/pi-capture-XXXX.md`)
3. Opens your terminal with `pi` reading that file

That's it. No network calls, no data collection, no background processes.

**`install.sh`** — run once to set up:
1. Copies `pi-capture.sh` to `~/.pi-capture/`
2. Creates an Automator workflow in `~/Library/Services/` (the XML looks scary — it's Apple's required format for registering a Service)
3. Refreshes macOS services cache
4. Writes a keyboard shortcut preference

Nothing touches system files. No sudo. No admin. Everything lives in your home folder.

**Verify yourself:**
```bash
./install.sh --dry-run     # Shows what it would do, changes nothing
cat pi-capture.sh          # 13 lines, fully readable
```

**Uninstall removes everything:**
```bash
rm -rf ~/.pi-capture ~/Library/Services/Send\ to\ Pi.workflow
```

## Requirements

- macOS (tested on Sonoma/Sequoia)
- [Pi](https://github.com/earendil-works/pi-coding-agent) installed and on PATH
