import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sideossdk/sideossdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    final sideossdkPlugin = await Sideossdk.create();
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      var value = sideossdkPlugin.signVC(
          "{\"issuer\":{\"id\":\"did:key:V003:z6MkndMNLuBoqwQM8iZpHBvSQxF5nt9BwW9XvpgwHokRCN7V\"}}");
      print(value);
      /*var p1 = _sideossdkPlugin.initSDK();
      p1.then((value) {
        print(value);
        value = _sideossdkPlugin.signVC(
            "{\"issuer\":{\"id\":\"did:key:V003:z6MkndMNLuBoqwQM8iZpHBvSQxF5nt9BwW9XvpgwHokRCN7V\"}}");
        print(value);
        value = _sideossdkPlugin.verifyVC(
            "{\"issuer\":{\"id\":\"did:key:V003:z6MkndMNLuBoqwQM8iZpHBvSQxF5nt9BwW9XvpgwHokRCN7V\"}}",
            "eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCJ9.eyJpc3N1ZXIiOnsiaWQiOiJkaWQ6a2V5OlYwMDM6ejZNa25kTU5MdUJvcXdRTThpWnBIQnZTUXhGNW50OUJ3VzlYdnBnd0hva1JDTjdWIn19.T4EwOojjDK4rJ0KMfxt_OHeNf3BNFEoChmHXsiKCTtP2JSTImIJ9RDb8djgIBqybzl3XQQBkj-mSqTKqUwPUDg");
        print(value);
        value = _sideossdkPlugin.getVerifiableCredentials();
        print(value);
      });
*/
      //platformVersion = _sideossdkPlugin.getSharedKeyPair();
      //platformVersion = _sideossdkPlugin.getKeys();
      platformVersion = 'PP';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
