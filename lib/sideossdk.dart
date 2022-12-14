import 'sideossdk_platform_interface.dart';

class Sideossdk {
  Future<String?> getPlatformVersion() {
    return SideossdkPlatform.instance.getPlatformVersion();
  }

  String getSharedKeyPair() {
    return SideossdkPlatform.instance.getSharedKeyPair();
  }

  String getLocalDid(String version) {
    return SideossdkPlatform.instance.getLocalDid(version);
  }
}
