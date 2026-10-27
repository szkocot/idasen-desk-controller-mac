# Apple Silicon Implementation Plan

> **For agentic workers:** Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Publish v1.0.3 with native Apple Silicon and Intel support.

**Architecture:** Use the existing Swift/Xcode app and upstream LaunchAtLogin
4.2 universal helper. Build both architectures explicitly and inspect the ZIP.

**Tech Stack:** Swift, Xcode, shell, GitHub CLI.

**Spec:** ../specs/2026-10-27-apple-silicon-design.md

## Global Constraints

- Version 1.0.3; macOS 10.15 for Intel, macOS 11 or later for Apple Silicon.
- Both app and login helper contain arm64 and x86_64.
- Ad hoc signing; no notarization credentials available.

## Review Focus

- Intel-only nested helper: inspect all Mach-O files.
- Missing helper: require its executable explicitly.
- Invalid signature after packaging: verify extracted ZIP.
- Wrong release version: check bundle metadata and tag commit.
- Download link points upstream: point README to this fork.

### Task 1: Build and verify universal release

**Files:** project.pbxproj, Package.resolved, scripts/build-release.sh,
scripts/verify-release.sh, README.md, .github/workflows/release-build.yml.

- [ ] Add architecture verification and run against existing app; expect failure
  on the Intel-only login helper.
- [ ] Upgrade LaunchAtLogin to 4.2, set release architectures explicitly, bump
  version to 1.0.3/build 8, and add reproducible build/ZIP instructions.
- [ ] Build Release, inspect both executables, verify signatures and extracted ZIP.
- [ ] Review diff, commit, push main, create v1.0.3 via gh with ZIP and SHA256.
- [ ] Download published ZIP through gh and repeat verification.

## Execution record

- Architecture check fails on the original Intel-only helper, as expected.
- Ruling: build using GitHub Actions/Xcode 16.4 because installed Xcode 27 rejects the existing macOS 10.15 deployment target; preserve backwards compatibility.
- Local diagnostic compile exposed missing CoreGraphics import; adding it fixes compilation for both architectures.
- Strict signature verification exposed upstream helper signing using the display name instead of the identity hash; pass EXPANDED_CODE_SIGN_IDENTITY to its script.
- Clean diagnostic build passes architecture and deep signature checks. The published artifact will still use supported Xcode 16.4.
