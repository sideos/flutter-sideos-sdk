import Flutter
import UIKit

func getRustString(result: UnsafePointer<CChar>?) -> String {
    let swift_result = String(cString: result!)
    rust_free_string(UnsafeMutablePointer(mutating: result))
    return swift_result
}

func getSavedKey() -> String {
    let query = [
           kSecAttrService: "sideos-key",
           kSecAttrAccount: "sideos",
           kSecClass: kSecClassGenericPassword,
           kSecReturnData: true
       ] as CFDictionary
  
    var item: AnyObject?
    let status = SecItemCopyMatching(query, &item)
    guard status == errSecSuccess else {
        return ""
    }
    let key = item as! Data
    return String(decoding: key, as: UTF8.self)
}

@_cdecl("getKeys")
public func getKeys(result: UnsafePointer<CChar>?) ->  UnsafeMutablePointer<Int8> {
    let str = getSavedKey()
    let unsafePointer = UnsafeMutablePointer<Int8>(mutating: (str as NSString).utf8String)
    return unsafePointer.unsafelyUnwrapped
}

@_cdecl("saveKeys")
public func saveKeys(keys: UnsafeMutablePointer<Int8>?) {
    let key = String(cString: keys!)
    let addquery = [   kSecClass as String: kSecClassGenericPassword,
                       kSecAttrService as String: "sideos-key",
                       kSecAttrAccount as String: "sideos",
                       kSecValueData: Data(key.utf8)] as CFDictionary
    let status = SecItemAdd(addquery as CFDictionary, nil)
    guard status == errSecSuccess else {
        return
    }
}


public class SwiftSideossdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "sideossdk", binaryMessenger: registrar.messenger())
    let instance = SwiftSideossdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch (call.method) {
        case "initSDK":
            result(getSavedKey())
            break;
        case "saveKeys":
          guard let args = call.arguments else {
              return
          }
          if let myArgs = args as? [String: Any],
             let keys = myArgs["keys"] as? String {
             let data = UnsafeMutablePointer(mutating: (keys as NSString).utf8String!)

              saveKeys(keys:data);
              result(keys);
          }
        break;
        default:
              result(FlutterMethodNotImplemented)
        }
    }
}
