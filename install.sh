#!/bin/bash
set -e

# ╔══════════════════════════════════════════════════════════════════════╗
# ║  Pi Capture Installer                                               ║
# ║                                                                      ║
# ║  This script does exactly 4 things:                                  ║
# ║  1. Copies pi-capture.sh to ~/.pi-capture/                           ║
# ║  2. Creates an Automator workflow in ~/Library/Services/             ║
# ║     (this is how macOS registers "Services" / Quick Actions)         ║
# ║  3. Tells macOS to refresh its list of available Services            ║
# ║  4. Assigns Control+Shift+Q as the keyboard shortcut                ║
# ║                                                                      ║
# ║  • No sudo. No admin privileges. No network access.                 ║
# ║  • Only writes to YOUR home folder.                                  ║
# ║  • The big XML blocks below are Automator boilerplate —             ║
# ║    it's the format macOS requires. The actual logic is 5 lines.     ║
# ║                                                                      ║
# ║  Run with --dry-run to see what it would do without doing it.       ║
# ╚══════════════════════════════════════════════════════════════════════╝

WORKFLOW_NAME="Send to Pi"
WORKFLOW_DIR="$HOME/Library/Services/${WORKFLOW_NAME}.workflow"
SCRIPT_DIR="$HOME/.pi-capture"
SHORTCUT_KEY='^$q'  # ^ = Control, $ = Shift, q = Q

# --- Dry run mode ---
if [[ "$1" == "--dry-run" ]]; then
    echo "DRY RUN — nothing will be changed."
    echo ""
    echo "Would do:"
    echo "  1. Copy pi-capture.sh → $SCRIPT_DIR/pi-capture.sh"
    echo "  2. Create workflow   → $WORKFLOW_DIR/"
    echo "     (registers 'Send to Pi' in macOS Services menu)"
    echo "  3. Flush services cache (pbs -flush)"
    echo "  4. Set shortcut ⌃⇧Q → defaults write pbs NSServicesStatus"
    echo ""
    echo "All files go in your home folder. No sudo needed."
    exit 0
fi

echo "=== Pi Capture Installer ==="

# ── Step 1: Copy the 13-line capture script ──────────────────────────
mkdir -p "$SCRIPT_DIR"
SELF_DIR="$(cd "$(dirname "$0")" && pwd)"
cp "$SELF_DIR/pi-capture.sh" "$SCRIPT_DIR/pi-capture.sh"
chmod +x "$SCRIPT_DIR/pi-capture.sh"
echo "✓ Script installed → $SCRIPT_DIR/pi-capture.sh"

# ── Step 2: Create Automator Quick Action ────────────────────────────
# This is an Automator ".workflow" bundle. macOS requires this XML format
# to register a Service that receives text. The meaningful part is:
#   - Info.plist: "I accept text from any app"
#   - document.wflow: "Run this shell script with the text on stdin"
# Everything else is required boilerplate.
mkdir -p "$WORKFLOW_DIR/Contents"

cat > "$WORKFLOW_DIR/Contents/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>NSServices</key>
	<array>
		<dict>
			<key>NSMenuItem</key>
			<dict>
				<key>default</key>
				<string>Send to Pi</string>
			</dict>
			<key>NSMessage</key>
			<string>runWorkflowAsService</string>
			<key>NSSendTypes</key>
			<array>
				<string>NSStringPboardType</string>
			</array>
		</dict>
	</array>
</dict>
</plist>
PLIST

cat > "$WORKFLOW_DIR/Contents/document.wflow" << WFLOW
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>AMApplicationBuild</key>
	<string>527</string>
	<key>AMApplicationVersion</key>
	<string>2.10</string>
	<key>AMDocumentVersion</key>
	<string>2</string>
	<key>actions</key>
	<array>
		<dict>
			<key>action</key>
			<dict>
				<key>AMAccepts</key>
				<dict>
					<key>Container</key>
					<string>List</string>
					<key>Optional</key>
					<true/>
					<key>Types</key>
					<array>
						<string>com.apple.cocoa.string</string>
					</array>
				</dict>
				<key>AMActionVersion</key>
				<string>2.0.2</string>
				<key>AMApplication</key>
				<array>
					<string>Automator</string>
				</array>
				<key>AMParameterProperties</key>
				<dict>
					<key>COMMAND_STRING</key>
					<dict/>
					<key>CheckedForUserDefaultShell</key>
					<dict/>
					<key>inputMethod</key>
					<dict/>
					<key>shell</key>
					<dict/>
					<key>source</key>
					<dict/>
				</dict>
				<key>AMProvides</key>
				<dict>
					<key>Container</key>
					<string>List</string>
					<key>Types</key>
					<array>
						<string>com.apple.cocoa.string</string>
					</array>
				</dict>
				<key>ActionBundlePath</key>
				<string>/System/Library/Automator/Run Shell Script.action</string>
				<key>ActionName</key>
				<string>Run Shell Script</string>
				<key>ActionParameters</key>
				<dict>
					<key>COMMAND_STRING</key>
					<string>${SCRIPT_DIR}/pi-capture.sh</string>
					<key>CheckedForUserDefaultShell</key>
					<true/>
					<key>inputMethod</key>
					<integer>0</integer>
					<key>shell</key>
					<string>/bin/bash</string>
					<key>source</key>
					<string></string>
				</dict>
				<key>BundleIdentifier</key>
				<string>com.apple.RunShellScript</string>
				<key>CFBundleVersion</key>
				<string>2.0.2</string>
				<key>CanShowSelectedItemsWhenRun</key>
				<false/>
				<key>CanShowWhenRun</key>
				<true/>
				<key>Category</key>
				<array>
					<string>AMCategoryUtilities</string>
				</array>
				<key>Class Name</key>
				<string>RunShellScriptAction</string>
				<key>InputUUID</key>
				<string>8B5B5055-4F14-4116-B828-D3E7B4E1F7A0</string>
				<key>Keywords</key>
				<array>
					<string>Shell</string>
					<string>Script</string>
					<string>Command</string>
					<string>Run</string>
					<string>Unix</string>
				</array>
				<key>OutputUUID</key>
				<string>37E6D311-D661-44CD-B0E6-6A0E0B5E02A3</string>
				<key>UUID</key>
				<string>C2B3FE23-5F05-4E35-98FF-EEDC47A6D026</string>
				<key>UnlocalizedApplications</key>
				<array>
					<string>Automator</string>
				</array>
				<key>arguments</key>
				<dict>
					<key>0</key>
					<dict>
						<key>default value</key>
						<string>echo "Hello World"</string>
						<key>name</key>
						<string>COMMAND_STRING</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>0</string>
					</dict>
					<key>1</key>
					<dict>
						<key>default value</key>
						<string>/bin/sh</string>
						<key>name</key>
						<string>shell</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>1</string>
					</dict>
					<key>2</key>
					<dict>
						<key>default value</key>
						<integer>0</integer>
						<key>name</key>
						<string>inputMethod</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>2</string>
					</dict>
					<key>3</key>
					<dict>
						<key>default value</key>
						<string></string>
						<key>name</key>
						<string>source</string>
						<key>required</key>
						<string>0</string>
						<key>type</key>
						<string>0</string>
						<key>uuid</key>
						<string>3</string>
					</dict>
				</dict>
				<key>conversionLabel</key>
				<integer>0</integer>
				<key>isViewVisible</key>
				<integer>1</integer>
				<key>location</key>
				<string>309.000000:253.000000</string>
				<key>nibPath</key>
				<string>/System/Library/Automator/Run Shell Script.action/Contents/Resources/Base.lproj/main.nib</string>
			</dict>
			<key>isViewVisible</key>
			<integer>1</integer>
		</dict>
	</array>
	<key>connectors</key>
	<dict/>
	<key>workflowMetaData</key>
	<dict>
		<key>serviceInputTypeIdentifier</key>
		<string>com.apple.Automator.text</string>
		<key>serviceOutputTypeIdentifier</key>
		<string>com.apple.Automator.nothing</string>
		<key>serviceProcessesInput</key>
		<false/>
		<key>workflowTypeIdentifier</key>
		<string>com.apple.Automator.servicesMenu</string>
	</dict>
</dict>
</plist>
WFLOW

echo "✓ Quick Action created → $WORKFLOW_DIR/"

# ── Step 3: Tell macOS to re-read the Services list ──────────────────
/System/Library/CoreServices/pbs -flush 2>/dev/null || true
echo "✓ Services cache flushed"

# ── Step 4: Assign keyboard shortcut (⌃⇧Q) ──────────────────────────
/usr/libexec/PlistBuddy -c "Delete :NSServicesStatus:\"(null) - ${WORKFLOW_NAME} - runWorkflowAsService\"" ~/Library/Preferences/pbs.plist 2>/dev/null || true
defaults write pbs NSServicesStatus -dict-add "\"(null) - ${WORKFLOW_NAME} - runWorkflowAsService\"" "{key_equivalent = \"${SHORTCUT_KEY}\";}"
echo "✓ Keyboard shortcut assigned: ⌃⇧Q"

echo ""
echo "=== Done! Select text anywhere → ⌃⇧Q → Pi opens ==="
echo "(Restart apps if the shortcut doesn't work immediately)"
