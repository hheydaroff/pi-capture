#!/bin/bash
TEXT=$(cat)
[ -z "$TEXT" ] && exit 1

FILE="/tmp/pi-capture-$$.md"
printf '%s' "$TEXT" > "$FILE"

LAUNCHER="/tmp/pi-capture-$$.command"
printf '#!/bin/bash\nclear\nexec pi @"%s" "I selected this text. Read it, explain it to me and help me with whatever I ask next."\n' "$FILE" > "$LAUNCHER"
chmod +x "$LAUNCHER"

if open -Ra "Ghostty" 2>/dev/null; then open -a Ghostty "$LAUNCHER"
elif open -Ra "iTerm" 2>/dev/null; then open -a iTerm "$LAUNCHER"
else open "$LAUNCHER"
fi
