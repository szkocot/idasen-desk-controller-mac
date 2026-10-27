#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."

output="$PWD/build/release"
mkdir -p "$output"
xcodebuild -project 'Desk Controller.xcodeproj' -scheme 'Desk Controller' \
    -configuration Release -destination 'generic/platform=macOS' \
    -derivedDataPath "$PWD/build/DerivedData" \
    ARCHS='arm64 x86_64' ONLY_ACTIVE_ARCH=NO \
    CODE_SIGN_STYLE=Manual CODE_SIGN_IDENTITY=- DEVELOPMENT_TEAM= \
    EXPANDED_CODE_SIGN_IDENTITY_NAME=- build

app="$PWD/build/DerivedData/Build/Products/Release/Desk Controller.app"
bash scripts/verify-release.sh "$app"
ditto -c -k --sequesterRsrc --keepParent "$app" "$output/Desk.Controller.app.zip"
(cd "$output" && shasum -a 256 Desk.Controller.app.zip > SHA256SUMS)
printf 'Release: %s\n' "$output/Desk.Controller.app.zip"
