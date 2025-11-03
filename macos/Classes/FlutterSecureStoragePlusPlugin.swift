import Cocoa
import FlutterMacOS
import Security

public class FlutterSecureStoragePlusPlugin: NSObject, FlutterPlugin {
  private let service = "com.dhiabechattaoui.flutter_secure_storage_plus"
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_secure_storage_plus", binaryMessenger: registrar.messenger)
    let instance = FlutterSecureStoragePlusPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  private func keychainQuery(forKey key: String) -> [String: Any] {
    return [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: key,
      kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
    ]
  }

  private func writeToKeychain(key: String, value: String) -> OSStatus {
    let data = value.data(using: .utf8)!
    var query = keychainQuery(forKey: key)
    
    // Delete any existing item
    SecItemDelete(query as CFDictionary)
    
    // Add new item
    query[kSecValueData as String] = data
    return SecItemAdd(query as CFDictionary, nil)
  }

  private func readFromKeychain(key: String) -> String? {
    var query = keychainQuery(forKey: key)
    query[kSecReturnData as String] = kCFBooleanTrue
    query[kSecMatchLimit as String] = kSecMatchLimitOne
    
    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)
    
    if status == errSecSuccess,
       let data = result as? Data,
       let value = String(data: data, encoding: .utf8) {
      return value
    }
    return nil
  }

  private func deleteFromKeychain(key: String) -> OSStatus {
    let query = keychainQuery(forKey: key)
    return SecItemDelete(query as CFDictionary)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
    case "write":
      guard let args = call.arguments as? [String: Any],
            let key = args["key"] as? String,
            let value = args["value"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Key and value are required", details: nil))
        return
      }
      let status = writeToKeychain(key: key, value: value)
      if status == errSecSuccess {
        result(nil)
      } else {
        result(FlutterError(code: "STORAGE_ERROR", message: "Failed to write to keychain: \(status)", details: nil))
      }
    case "read":
      guard let args = call.arguments as? [String: Any],
            let key = args["key"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Key is required", details: nil))
        return
      }
      if let value = readFromKeychain(key: key) {
        result(value)
      } else {
        result(nil)
      }
    case "delete":
      guard let args = call.arguments as? [String: Any],
            let key = args["key"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Key is required", details: nil))
        return
      }
      let status = deleteFromKeychain(key: key)
      if status == errSecSuccess || status == errSecItemNotFound {
        result(nil)
      } else {
        result(FlutterError(code: "STORAGE_ERROR", message: "Failed to delete from keychain: \(status)", details: nil))
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
