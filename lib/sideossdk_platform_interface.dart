import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:path_provider/path_provider.dart';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sideossdk_method_channel.dart';

final DynamicLibrary nativeAddLib = Platform.isAndroid
    ? DynamicLibrary.open('libcryptolib.so')
    : DynamicLibrary.process();

typedef SharedKeypairFunction = Pointer<Utf8> Function();
typedef SharedKeypairFunctionDart = Pointer<Utf8> Function();
typedef SharedStringFunction = Pointer<Utf8> Function(Pointer<Utf8>);
typedef SharedStringFunctionDart = Pointer<Utf8> Function(Pointer<Utf8>);
typedef SharedStringStringFunctionDart = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>);
typedef SharedStringStringStringFunctionDart = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>);
typedef CStringFree = void Function(Pointer<Utf8>);
typedef CStringFreeFFI = Void Function(Pointer<Utf8>);

final CStringFree cstringFree = nativeAddLib
    .lookup<NativeFunction<CStringFreeFFI>>("rust_free_string")
    .asFunction();

abstract class SideossdkPlatform extends PlatformInterface {
  /// Constructs a SideossdkPlatform.
  SideossdkPlatform() : super(token: _token);

  static final Object _token = Object();
  static String _path = "";
  static SideossdkPlatform _instance = MethodChannelSideossdk();

  /// The default instance of [SideossdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelSideossdk].
  static SideossdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SideossdkPlatform] when
  /// they register themselves.
  static set instance(SideossdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String> getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    var path = directory.path;
    return '$path/ssidb.sqlite';
  }

  Future<String?> initSDK() async {
    _path = await getLocalFile();
    return _instance.initialize();
  }

  String getLocalDid(String version) {
    final SharedStringFunctionDart result = nativeAddLib
        .lookup<NativeFunction<SharedStringFunction>>('get_local_did')
        .asFunction();
    var ptr = result(version.toNativeUtf8());
    var str = ptr.toDartString();

    cstringFree(ptr);

    return str;
  }

  String createLocalDid(String version) {
    final SharedStringFunctionDart result = nativeAddLib
        .lookup<NativeFunction<SharedStringFunction>>('create_keys')
        .asFunction();
    var ptr = result(version.toNativeUtf8());
    var str = ptr.toDartString();

    cstringFree(ptr);

    return str;
  }

  String setKeys(String keys) {
    final SharedStringFunctionDart result = nativeAddLib
        .lookup<NativeFunction<SharedStringFunction>>('set_keys')
        .asFunction();
    var ptr = result(keys.toNativeUtf8());
    var str = ptr.toDartString();

    cstringFree(ptr);

    return str;
  }

  String signVC(String vc) {
    final SharedStringFunctionDart result = nativeAddLib
        .lookup<NativeFunction<SharedStringFunction>>('rust_signVC')
        .asFunction();
    var ptr = result(vc.toNativeUtf8());
    var str = ptr.toDartString();

    cstringFree(ptr);

    return str;
  }

  String verifyVC(String vc, String signature) {
    final SharedStringStringFunctionDart result = nativeAddLib
        .lookup<NativeFunction<SharedStringStringFunctionDart>>('rust_verifyVC')
        .asFunction();
    var ptr = result(vc.toNativeUtf8(), signature.toNativeUtf8());
    var str = ptr.toDartString();

    cstringFree(ptr);

    return str;
  }

  String getSharedKeyPair() {
    final SharedKeypairFunctionDart result = nativeAddLib
        .lookup<NativeFunction<SharedKeypairFunction>>('create_shared_keypair')
        .asFunction();
    var ptr = result();
    var str = ptr.toDartString();

    cstringFree(ptr);

    return str;
  }

  String cryptDataExt(String key, String data) {
    final SharedStringStringFunctionDart result = nativeAddLib
        .lookup<NativeFunction<SharedStringStringFunctionDart>>(
            'rust_CryptDataExt')
        .asFunction();
    var ptr = result(key.toNativeUtf8(), data.toNativeUtf8());
    var str = ptr.toDartString();

    cstringFree(ptr);

    return str;
  }

  String decryptDataExt(String key, String data) {
    final SharedStringStringFunctionDart result = nativeAddLib
        .lookup<NativeFunction<SharedStringStringFunctionDart>>(
            'rust_DeryptDataExt')
        .asFunction();
    var ptr = result(key.toNativeUtf8(), data.toNativeUtf8());
    var str = ptr.toDartString();

    cstringFree(ptr);

    return str;
  }

  String deriveSharedKey(String prKey, String puKey) {
    final SharedStringStringFunctionDart result = nativeAddLib
        .lookup<NativeFunction<SharedStringStringFunctionDart>>(
            'rust_DeriveSharedKey')
        .asFunction();
    var ptr = result(prKey.toNativeUtf8(), puKey.toNativeUtf8());
    var str = ptr.toDartString();

    cstringFree(ptr);

    return str;
  }

  String getVerifiableCredentials() {
    final SharedStringFunction result = nativeAddLib
        .lookup<NativeFunction<SharedStringFunction>>(
            'rust_getVerifiableCredentials')
        .asFunction();
    var ptr = result(_path.toNativeUtf8());
    var str = ptr.toDartString();

    cstringFree(ptr);

    return str;
  }

  String saveVerifiableCredential(String vc, String type) {
    final SharedStringStringStringFunctionDart result = nativeAddLib
        .lookup<NativeFunction<SharedStringStringStringFunctionDart>>(
            'rust_saveVerifiableCredential')
        .asFunction();
    var ptr =
        result(vc.toNativeUtf8(), type.toNativeUtf8(), _path.toNativeUtf8());
    var str = ptr.toDartString();

    cstringFree(ptr);

    return str;
  }

  String deleteVerifiableCredential(String vc) {
    final SharedStringStringFunctionDart result = nativeAddLib
        .lookup<NativeFunction<SharedStringStringFunctionDart>>(
            'rust_deleteVerifiableCredential')
        .asFunction();
    var ptr = result(vc.toNativeUtf8(), _path.toNativeUtf8());
    var str = ptr.toDartString();

    cstringFree(ptr);

    return str;
  }

  String respondToServer(String url, String payload) {
    final SharedStringStringFunctionDart result = nativeAddLib
        .lookup<NativeFunction<SharedStringStringFunctionDart>>(
            'rust_respondToServer')
        .asFunction();
    var ptr = result(url.toNativeUtf8(), payload.toNativeUtf8());
    var str = ptr.toDartString();

    cstringFree(ptr);

    return str;
  }

  String parseVC(String vc) {
    final SharedStringFunctionDart result = nativeAddLib
        .lookup<NativeFunction<SharedStringFunctionDart>>('rust_parseVC')
        .asFunction();
    var ptr = result(vc.toNativeUtf8());
    var str = ptr.toDartString();

    cstringFree(ptr);

    return str;
  }

  String parseJWT(String jwt) {
    final SharedStringFunctionDart result = nativeAddLib
        .lookup<NativeFunction<SharedStringFunctionDart>>('rust_parseJWT')
        .asFunction();
    var ptr = result(jwt.toNativeUtf8());
    var str = ptr.toDartString();

    cstringFree(ptr);

    return str;
  }

  String signAcceptanceJWT(
      String jwt, String destinationDID, String challenge) {
    final SharedStringStringStringFunctionDart result = nativeAddLib
        .lookup<NativeFunction<SharedStringStringStringFunctionDart>>(
            'rust_signAcceptanceJWT')
        .asFunction();
    var ptr = result(jwt.toNativeUtf8(), destinationDID.toNativeUtf8(),
        challenge.toNativeUtf8());
    var str = ptr.toDartString();

    cstringFree(ptr);

    return str;
  }

  String signSharedJWT(String jwt, String destinationDID, String challenge) {
    final SharedStringStringStringFunctionDart result = nativeAddLib
        .lookup<NativeFunction<SharedStringStringStringFunctionDart>>(
            'rust_signSharedJWT')
        .asFunction();
    var ptr = result(jwt.toNativeUtf8(), destinationDID.toNativeUtf8(),
        challenge.toNativeUtf8());
    var str = ptr.toDartString();

    cstringFree(ptr);

    return str;
  }

  Future<String?> initialize() {
    return _instance.initialize();
  }
}
