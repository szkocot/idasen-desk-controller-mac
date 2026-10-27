#!/bin/bash
set -euo pipefail

app="${1:?Usage: verify-release.sh path/to/Desk Controller.app}"
test -x "$app/Contents/MacOS/Desk Controller"
test -x "$app/Contents/Library/LoginItems/LaunchAtLoginHelper.app/Contents/MacOS/LaunchAtLoginHelper"
test "$(/usr/libexec/PlistBuddy -c 'Print :LSMinimumSystemVersion' "$app/Contents/Info.plist")" = '26.0'

while IFS= read -r -d '' binary; do
    if file -b "$binary" | grep -q 'Mach-O'; then
        if [[ "$(lipo -archs "$binary")" != arm64 ]]; then
            printf 'Expected arm64 only: %s\n' "$binary" >&2
            exit 1
        fi
        printf 'arm64: %s\n' "$binary"
    fi
done < <(find "$app" -type f -print0)

codesign --verify --deep --strict --verbose=2 "$app"
