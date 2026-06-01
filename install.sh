#!/bin/bash
set -e

INSTALL_DIR="$HOME/.pi-capture"
SCRIPT_NAME="pi-capture.sh"
SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Pi Capture Installer ==="
echo ""

# 1. Install the script
mkdir -p "$INSTALL_DIR"
cp "$SOURCE_DIR/$SCRIPT_NAME" "$INSTALL_DIR/$SCRIPT_NAME"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
echo "✓ Installed $SCRIPT_NAME to $INSTALL_DIR/"

# 2. Verify pi is available
if command -v pi &>/dev/null; then
  echo "✓ pi found at $(which pi)"
else
  echo "⚠ pi not found in PATH — make sure it's installed"
fi

echo ""
echo "=== Manual Steps (one-time setup) ==="
echo ""
echo "1. Open Shortcuts.app"
echo "2. Create a new shortcut named \"Send to Pi\""
echo "3. Click ℹ️ → Use as Quick Action → enable Services Menu"
echo "4. Set: receives TEXT from ANY APPLICATION"
echo "5. Add action: Run Shell Script"
echo "   - Shell: /bin/bash"
echo "   - Input: Shortcut Input"
echo "   - Pass Input: to stdin"
echo "   - Script: $INSTALL_DIR/$SCRIPT_NAME"
echo ""
echo "6. Assign keyboard shortcut:"
echo "   System Settings → Keyboard → Keyboard Shortcuts → Services"
echo "   Find \"Send to Pi\" → assign e.g. ⌃⇧P"
echo ""
echo "=== Done ==="
