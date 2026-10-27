# Apple Silicon release

User-approved final scope: release v1.0.3 for arm64 Apple Silicon only,
requiring macOS 26 or later. This supersedes the earlier universal release scope.

Use the existing Swift/Xcode app and LaunchAtLogin 4.2, which contains the
upstream Apple Silicon helper fix. Build the app for arm64, thin the upstream
universal helper to arm64, and sign the helper then the containing app.
Keep application behavior unchanged. Add the missing CoreGraphics import needed
by current Swift compilers.

Alternatives: a universal release was initially approved, then explicitly
replaced by the user's arm64-only/macOS 26 requirement. No Intel slice or older
macOS compatibility is required in the release.

Verify every bundled Mach-O is arm64-only, the app requires macOS 26.0, and
all signatures are valid before publishing a ZIP and checksum through gh.
Update README downloads to this fork. Use ad hoc signing and disclose the lack
of notarization because no Developer ID identity is available. Desk hardware
testing remains with the user.
