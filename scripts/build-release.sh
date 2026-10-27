#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."

output="$PWD/build/release"
mkdir -p "$output"
xcodebuild -project 'Desk Controller.xcodeproj' -scheme 'Desk Controller' \
    -configuration Release -destination 'generic/platform=macOS' \
    -derivedDataPath "$PWD/build/DerivedData" \
    ARCHS=arm64 ONLY_ACTIVE_ARCH=NO \
    CODE_SIGN_STYLE=Manual CODE_SIGN_IDENTITY=- DEVELOPMENT_TEAM= \
    clean build

app="$PWD/build/DerivedData/Build/Products/Release/Desk Controller.app"
helper="$app/Contents/Library/LoginItems/LaunchAtLoginHelper.app"
binary="$helper/Contents/MacOS/LaunchAtLoginHelper"
# Upstream ships a universal helper; keep only the release architecture.
lipo "$binary" -thin arm64 -output "$binary.arm64"
mv "$binary.arm64" "$binary"
codesign --force --sign - --options runtime --preserve-metadata=entitlements "$helper"
codesign --force --sign - --options runtime --entitlements 'Desk Controller/Desk_Controller.entitlements' "$app"
bash scripts/verify-release.sh "$app"
ditto -c -k --sequesterRsrc --keepParent "$app" "$output/Desk.Controller.app.zip"
(cd "$output" && shasum -a 256 Desk.Controller.app.zip > SHA256SUMS)
printf 'Release: %s\n' "$output/Desk.Controller.app.zip"
