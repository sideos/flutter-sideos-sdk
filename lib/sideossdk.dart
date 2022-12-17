import 'sideossdk_platform_interface.dart';

class Sideossdk {
  static Future<Sideossdk> create() async {
    var component = Sideossdk._create();

    await SideossdkPlatform.instance.initSDK();

    return component;
  }

  Sideossdk._create();

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

  String saveVerifiableCredential(String vc, String type) {
    return SideossdkPlatform.instance.saveVerifiableCredential(vc, type);
  }

  String deleteVerifiableCredential(String vc) {
    return SideossdkPlatform.instance.deleteVerifiableCredential(vc);
  }

  String respondToServer(String url, String payload) {
    return SideossdkPlatform.instance.respondToServer(url, payload);
  }

  String parseVC(String vc) {
    return SideossdkPlatform.instance.parseVC(vc);
  }

  String signAcceptanceJWT(
      String jwt, String destinationDID, String challenge) {
    return SideossdkPlatform.instance
        .signAcceptanceJWT(jwt, destinationDID, challenge);
  }

  String signSharedJWT(String jwt, String destinationDID, String challenge) {
    return SideossdkPlatform.instance
        .signSharedJWT(jwt, destinationDID, challenge);
  }

  String parseJWT(String jwt) {
    return SideossdkPlatform.instance.parseJWT(jwt);
  }
}
