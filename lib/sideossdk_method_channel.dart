import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sideossdk_platform_interface.dart';

/// An implementation of [SideossdkPlatform] that uses method channels.
class MethodChannelSideossdk extends SideossdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sideossdk');

  @override
  Future<String?> initialize() async {
    final version = await methodChannel.invokeMethod<String>('initSDK');
    if (version == "") {
      var keys = createLocalDid("V003");
      return await methodChannel
          .invokeMethod<String>('saveKeys', {"keys": keys});
    } else {
      setKeys(version!);
    }
    return version;
  }
}
