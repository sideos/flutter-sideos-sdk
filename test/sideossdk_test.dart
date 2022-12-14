import 'package:flutter_test/flutter_test.dart';
import 'package:sideossdk/sideossdk.dart';
import 'package:sideossdk/sideossdk_platform_interface.dart';
import 'package:sideossdk/sideossdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSideossdkPlatform 
    with MockPlatformInterfaceMixin
    implements SideossdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SideossdkPlatform initialPlatform = SideossdkPlatform.instance;

  test('$MethodChannelSideossdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSideossdk>());
  });

  test('getPlatformVersion', () async {
    Sideossdk sideossdkPlugin = Sideossdk();
    MockSideossdkPlatform fakePlatform = MockSideossdkPlatform();
    SideossdkPlatform.instance = fakePlatform;
  
    expect(await sideossdkPlugin.getPlatformVersion(), '42');
  });
}
