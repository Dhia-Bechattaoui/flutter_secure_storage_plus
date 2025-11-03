

















# flutter_secure_storage_plus

[![Pub Score](https://img.shields.io/pub/v/flutter_secure_storage_plus.svg)](https://pub.dev/packages/flutter_secure_storage_plus)
[![Pana Score](https://pub.dev/packages/flutter_secure_storage_plus/score)](https://pub.dev/packages/flutter_secure_storage_plus/score)
[![Platforms](https://img.shields.io/badge/platform-android%20|%20ios%20|%20web%20|%20windows%20|%20macos%20|%20linux%20|%20wasm-blue)](https://pub.dev/packages/flutter_secure_storage_plus)

Enhanced secure storage with biometric unlock and key rotation.

**Supports:**
- Android
- iOS
- Web (including WASM)
- Windows
- macOS
- Linux

## Features

- Biometric-gated read/write operations (Face ID/Touch ID, Android Biometrics)
- Transparent key rotation helpers
- Secure storage using platform best practices (Keychain/Keystore/Credential Storage)
- Web fallback with WASM-friendly APIs

## WASM Compatibility

This package is compatible with [Dart WASM](https://dart.dev/web/wasm). You can use it in Flutter web projects compiled to WASM. See the [example](example/) for usage.

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_secure_storage_plus: ^0.0.5
```

## Usage

```dart
import 'package:flutter_secure_storage_plus/flutter_secure_storage_plus.dart';

final storage = FlutterSecureStoragePlus();

Future<void> example() async {
  await storage.write(key: 'token', value: 'abc', requireBiometrics: true);
  final token = await storage.read(key: 'token', requireBiometrics: true);
  print(token);
}
```

## Example

<img src="assets/example.gif" width="300" alt="Example usage of flutter_secure_storage_plus">

API surface is evolving; see examples and docs as features land.

## Roadmap

- Biometric unlock across platforms
- Key rotation helpers
- Migrations from popular secure storage packages

## License

MIT

