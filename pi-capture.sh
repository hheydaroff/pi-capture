#!/bin/bash
# pi-capture engine: selected text in → interactive pi session out
# Interface: stdin (text) → opens terminal with pi session
# Config: ~/.pi-capture/config.sh (user preferences)
# Adapters: ~/.pi-capture/adapters/*.sh (terminal launchers)

INSTALL_DIR="$HOME/.pi-capture"
CONFIG="$INSTALL_DIR/config.sh"

# Load config (defaults if missing)
PI_CAPTURE_PROMPT="I selected this text. Read it, explain it to me and help me with whatever I ask next."
PI_CAPTURE_TERMINAL="auto"
PI_CAPTURE_FLAGS=""
[ -f "$CONFIG" ] && source "$CONFIG"

# Read text from stdin
TEXT=$(cat)
if [ -z "$TEXT" ]; then
  echo "No text received" >&2
  exit 1
fi

# Save captured text
CAPTURE_FILE="/tmp/pi-capture-$$.md"
printf '%s' "$TEXT" > "$CAPTURE_FILE"

# Build launcher script
LAUNCHER="/tmp/pi-capture-$$.command"
cat > "$LAUNCHER" << LAUNCH
#!/bin/bash
clear
exec pi @"${CAPTURE_FILE}" ${PI_CAPTURE_FLAGS} "${PI_CAPTURE_PROMPT}"
LAUNCH
chmod +x "$LAUNCHER"

# Resolve terminal
TERMINAL="$PI_CAPTURE_TERMINAL"
if [ "$TERMINAL" = "auto" ]; then
  if open -Ra "Ghostty" 2>/dev/null; then
    TERMINAL="ghostty"
  elif open -Ra "iTerm" 2>/dev/null; then
    TERMINAL="iterm"
  else
    TERMINAL="terminal"
  fi
fi

# Load adapter and launch
ADAPTER="$INSTALL_DIR/adapters/${TERMINAL}.sh"
if [ -f "$ADAPTER" ]; then
  source "$ADAPTER"
  launch "$LAUNCHER"
else
  echo "Unknown terminal: $TERMINAL (no adapter at $ADAPTER)" >&2
  # Fallback: let macOS figure it out
  open "$LAUNCHER"
fi
