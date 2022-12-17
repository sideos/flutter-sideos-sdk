import 'sideossdk_platform_interface.dart';

class Sideossdk {
  Future<String?> initSDK() async {
    return await SideossdkPlatform.instance.initSDK();
  }

  String getSharedKeyPair() {
    return SideossdkPlatform.instance.getSharedKeyPair();
  }

  String getLocalDid(String version) {
    return SideossdkPlatform.instance.getLocalDid(version);
  }

  String signVC(String vc) {
    return SideossdkPlatform.instance.signVC(vc);
  }

  String verifyVC(String vc, String signature) {
    return SideossdkPlatform.instance.verifyVC(vc, signature);
  }

  String cryptDataExt(String key, String data) {
    return SideossdkPlatform.instance.cryptDataExt(key, data);
  }

  String decryptDataExt(String key, String data) {
    return SideossdkPlatform.instance.decryptDataExt(key, data);
  }

  String deriveSharedKey(String prKey, String puKey) {
    return SideossdkPlatform.instance.deriveSharedKey(prKey, puKey);
  }

  String getVerifiableCredentials() {
    return SideossdkPlatform.instance.getVerifiableCredentials();
  }
}
