// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'flutter_secure_storage_plus_platform_interface.dart';

/// Web implementation of [FlutterSecureStoragePlusPlatform].
///
/// Note: Web storage using localStorage is not as secure as native keychain/keystore
/// implementations. Data is stored in the browser's localStorage which is accessible
/// to JavaScript on the same origin. For production applications handling sensitive
/// data, consider using additional encryption layers or server-side storage.
class FlutterSecureStoragePlusWeb extends FlutterSecureStoragePlusPlatform {
  /// Constructs a FlutterSecureStoragePlusWeb
  FlutterSecureStoragePlusWeb();

  static const String _storagePrefix = 'flutter_secure_storage_plus_';

  static void registerWith(Registrar registrar) {
    FlutterSecureStoragePlusPlatform.instance = FlutterSecureStoragePlusWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = web.window.navigator.userAgent;
    return version;
  }

  /// Gets the storage key with prefix
  String _getStorageKey(String key) {
    return '$_storagePrefix$key';
  }

  @override
  Future<void> write({
    required String key,
    required String value,
    bool? requireBiometrics,
  }) async {
    try {
      final storageKey = _getStorageKey(key);
      web.window.localStorage.setItem(storageKey, value);
    } catch (e) {
      throw Exception('Failed to write to localStorage: $e');
    }
  }

  @override
  Future<String?> read({required String key, bool? requireBiometrics}) async {
    try {
      final storageKey = _getStorageKey(key);
      return web.window.localStorage.getItem(storageKey);
    } catch (e) {
      throw Exception('Failed to read from localStorage: $e');
    }
  }

  @override
  Future<void> delete({required String key}) async {
    try {
      final storageKey = _getStorageKey(key);
      web.window.localStorage.removeItem(storageKey);
    } catch (e) {
      throw Exception('Failed to delete from localStorage: $e');
    }
  }
}
