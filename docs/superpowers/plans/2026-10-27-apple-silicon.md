# Apple Silicon Implementation Plan

> **For agentic workers:** Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Publish v1.0.3 for arm64 Macs running macOS 26 or later.

**Architecture:** Use the existing Swift/Xcode app and LaunchAtLogin 4.2.
Build arm64 only, thin the bundled helper and sign from inside out.

**Tech Stack:** Swift, Xcode, shell, GitHub CLI.

**Spec:** ../specs/2026-10-27-apple-silicon-design.md

## Global Constraints

- Version 1.0.3/build 8; minimum macOS 26.0.
- Both app and login helper contain arm64 only.
- Ad hoc signing; no notarization credentials available.

## Review Focus

- Intel slices: inspect all Mach-O files.
- Missing helper: require its executable explicitly.
- Invalid signatures after thinning/packaging: verify extracted ZIP.
- Wrong release version or OS floor: check bundle metadata and tag commit.
- Download link points upstream: point README to this fork.

### Task 1: Build and verify arm64 release

**Files:** project.pbxproj, Package.resolved, AutoStand.swift,
scripts/build-release.sh, scripts/verify-release.sh, README.md,
.github/workflows/release-build.yml.

- [x] Add verification; confirm the prior app fails the new macOS 26 requirement.
- [x] Upgrade LaunchAtLogin to 4.2, set arm64 and macOS 26.0, bump version to
  1.0.3/build 8, and add repeatable ad hoc signed build/ZIP instructions.
- [x] Build Release, inspect both executables, verify signatures and extracted ZIP.
- [ ] Review diff, commit, merge main, create v1.0.3 via gh with ZIP and SHA256.
- [ ] Download published ZIP through gh and repeat verification.

## Execution record

- User replaced universal/older macOS scope with arm64-only and macOS 26+.
- Compile exposed missing CoreGraphics import; adding it fixes both architectures.
- Signature verification exposed upstream helper signing with a display name;
  passing EXPANDED_CODE_SIGN_IDENTITY fixes it.
- Use clean builds to prevent stale incremental resources invalidating signatures.
- Final scope can be built locally using installed Xcode 27 without overrides.
- Independent review verified the extracted ZIP, version 1.0.3/build 8/minimum 26.0, both arm64-only executables, valid signatures and preserved sandbox/Bluetooth entitlements. No blockers.
