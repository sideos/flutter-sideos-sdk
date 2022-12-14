import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sideossdk_method_channel.dart';

final DynamicLibrary nativeAddLib = Platform.isAndroid
    ? DynamicLibrary.open('libcryptolib.so')
    : DynamicLibrary.process();

typedef SharedKeypairFunction = Pointer<Utf8> Function();
typedef SharedKeypairFunctionDart = Pointer<Utf8> Function();
typedef SharedStringFunction = Pointer<Utf8> Function(Pointer<Utf8>);
typedef SharedStringFunctionDart = Pointer<Utf8> Function(Pointer<Utf8>);

typedef CStringFree = void Function(Pointer<Utf8>);
typedef CStringFreeFFI = Void Function(Pointer<Utf8>);

final CStringFree cstringFree = nativeAddLib
    .lookup<NativeFunction<CStringFreeFFI>>("rust_free_string")
    .asFunction();

abstract class SideossdkPlatform extends PlatformInterface {
  /// Constructs a SideossdkPlatform.
  SideossdkPlatform() : super(token: _token);

  static final Object _token = Object();

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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
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

  String getSharedKeyPair() {
    final SharedKeypairFunctionDart result = nativeAddLib
        .lookup<NativeFunction<SharedKeypairFunction>>('create_shared_keypair')
        .asFunction();
    var ptr = result();
    var str = ptr.toDartString();

    cstringFree(ptr);

    return str;
  }
}
