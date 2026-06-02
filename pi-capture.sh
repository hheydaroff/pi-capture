#!/bin/bash
# pi-capture: Opens a new terminal with pi session, passing selected text as initial prompt
# Called by macOS Quick Action (Shortcuts)

# Read text from stdin
TEXT=$(cat)

if [ -z "$TEXT" ]; then
  echo "No text received" >&2
  exit 1
fi

# Save captured text
CAPTURE_FILE="/tmp/pi-capture-$$.md"
printf '%s' "$TEXT" > "$CAPTURE_FILE"

# Write a .command file
LAUNCHER="/tmp/pi-capture-$$.command"
cat > "$LAUNCHER" << LAUNCH
#!/bin/bash
clear
exec pi @"${CAPTURE_FILE}" "I selected this text. Read it, explain it to me and help me with whatever I ask next."
LAUNCH
chmod +x "$LAUNCHER"

# Open in Ghostty
open -a Ghostty "$LAUNCHER"
