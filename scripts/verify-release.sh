#!/bin/bash
set -euo pipefail

app="${1:?Usage: verify-release.sh path/to/Desk Controller.app}"
test -x "$app/Contents/MacOS/Desk Controller"
test -x "$app/Contents/Library/LoginItems/LaunchAtLoginHelper.app/Contents/MacOS/LaunchAtLoginHelper"

while IFS= read -r -d '' binary; do
    if file -b "$binary" | grep -q 'Mach-O'; then
        architectures=" $(lipo -archs "$binary") "
        for architecture in arm64 x86_64; do
            if [[ "$architectures" != *" $architecture "* ]]; then
                printf 'Missing %s: %s\n' "$architecture" "$binary" >&2
                exit 1
            fi
        done
        printf 'Universal: %s\n' "$binary"
    fi
done < <(find "$app" -type f -print0)

codesign --verify --deep --strict --verbose=2 "$app"
