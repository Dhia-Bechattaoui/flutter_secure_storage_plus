## [Unreleased]

### Changed
- Example GIF added to README

## [0.0.5] - TBD

### Security
- **CRITICAL**: Fixed security vulnerability - replaced insecure storage implementations with proper secure storage:
  - **Android**: Now uses `EncryptedSharedPreferences` (AES-256 encryption) instead of plain `SharedPreferences`
  - **iOS**: Now uses Keychain Services instead of `UserDefaults` (encrypted keychain storage)
  - **macOS**: Now uses Keychain Services instead of `UserDefaults` (encrypted keychain storage)
  - **Web**: Now uses `localStorage` instead of in-memory Map (persistent storage)
- Added `androidx.security:security-crypto` dependency for Android encryption
- All platforms now properly encrypt data at rest

### Documentation
- Added example GIF to README demonstrating plugin usage

**Note**: Data stored with previous versions will not be accessible after upgrading. Users will need to re-write their data with the new secure storage implementation.

## [0.0.4]

### Changed
- pubspec.yaml cleaned for pub.dev and pana compliance
- No breaking changes, just metadata and publishing fixes

## [0.0.3]

### Added
- Full platform support: Android, iOS, Web, Windows, macOS, Linux
- WASM compatible
- Native handlers for write/read/delete on all platforms

### Changed
- Example and tests improved

## [0.0.2] - 2025-08-24

### Added
- Add `.pubignore` to exclude build and example artifacts

### Changed
- Prepare for publish
- Update metadata and version

## [0.0.1] - 2025-08-22

### Added
- Initial release
- Multi-platform plugin scaffold (iOS, Android, Web, Windows, macOS, Linux)
- WASM-compatible web implementation placeholder

### Planned
- Biometric unlock and key rotation APIs

[Unreleased]: https://github.com/Dhia-Bechattaoui/flutter_secure_storage_plus/compare/v0.0.5...HEAD
[0.0.5]: https://github.com/Dhia-Bechattaoui/flutter_secure_storage_plus/compare/v0.0.4...v0.0.5
[0.0.4]: https://github.com/Dhia-Bechattaoui/flutter_secure_storage_plus/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/Dhia-Bechattaoui/flutter_secure_storage_plus/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/Dhia-Bechattaoui/flutter_secure_storage_plus/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/Dhia-Bechattaoui/flutter_secure_storage_plus/releases/tag/v0.0.1
