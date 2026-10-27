# Apple Silicon release

Approved scope: release v1.0.3 as a universal macOS app supporting arm64 and
x86_64, including the login helper. Preserve macOS 10.15 support for Intel.

The existing main executable is universal, but LaunchAtLogin 4.0 bundles an
Intel-only helper. Upgrade within its existing major version to 4.2, which
includes the upstream Apple Silicon fix. Keep application behavior unchanged.

Alternatives: an arm64-only release would remove Intel support; rebuilding the
dependency's helper ourselves would duplicate upstream packaging. A universal
app using the fixed dependency is the smallest complete solution.

Verify every bundled Mach-O executable contains both architectures and verify
code signatures before publishing a ZIP and checksum through gh. Update README
downloads to this fork. No Developer ID identity is installed, so use ad hoc
signing and disclose the lack of notarization. Desk hardware testing remains
with the user.
