import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sideossdk/sideossdk_method_channel.dart';

void main() {
  MethodChannelSideossdk platform = MethodChannelSideossdk();
  const MethodChannel channel = MethodChannel('sideossdk');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
