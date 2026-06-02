#!/bin/bash
set -e

INSTALL_DIR="$HOME/.pi-capture"
SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Pi Capture Installer ==="
echo ""

# 1. Install engine (always updated)
mkdir -p "$INSTALL_DIR/adapters"
cp "$SOURCE_DIR/pi-capture.sh" "$INSTALL_DIR/pi-capture.sh"
chmod +x "$INSTALL_DIR/pi-capture.sh"
echo "✓ Engine installed"

# 2. Install adapters (always updated)
cp "$SOURCE_DIR/adapters/"*.sh "$INSTALL_DIR/adapters/"
echo "✓ Adapters installed ($(ls "$SOURCE_DIR/adapters/"*.sh | wc -l | tr -d ' ') terminals)"

# 3. Config — create only if missing (never overwrite user config)
if [ ! -f "$INSTALL_DIR/config.sh" ]; then
  cp "$SOURCE_DIR/config.sh" "$INSTALL_DIR/config.sh"
  echo "✓ Config created at $INSTALL_DIR/config.sh"
else
  echo "✓ Config preserved (already exists)"
fi

# 4. Verify pi
if command -v pi &>/dev/null; then
  echo "✓ pi found at $(which pi)"
else
  echo "⚠ pi not found in PATH"
fi

echo ""
echo "=== Shortcuts Setup (one-time) ==="
echo ""
echo "1. Open Shortcuts.app → New Shortcut → name: \"Send to Pi\""
echo "2. ℹ️ → Use as Quick Action → Services Menu → receives TEXT from Any App"
echo "3. Add action: Run Shell Script"
echo "   Shell: /bin/bash | Input: Shortcut Input | Pass Input: to stdin"
echo "   Script body:  $INSTALL_DIR/pi-capture.sh"
echo ""
echo "4. System Settings → Keyboard → Keyboard Shortcuts → Services"
echo "   Find \"Send to Pi\" → assign shortcut (e.g. ⌃⇧P)"
echo ""
echo "=== Customize ==="
echo "   Edit: $INSTALL_DIR/config.sh"
echo "   (prompt, terminal, pi flags — safe across upgrades)"
echo ""
echo "=== Done ==="
