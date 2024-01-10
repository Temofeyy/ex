import 'package:flutter/services.dart';
import 'package:android_intent_plus/android_intent.dart';

abstract class FlutterAndroidBridge{

  static Future<void> requestForMethodCall() async {
    print('Send request for Kotlin call Flutter');
    const channel = MethodChannel("test");
    try{
      await channel.invokeMethod('send100', {"pass": 1234});
    } catch(e, st){
      print('$e\n$st');
    }
  }

  static Future<void> sendLocalBroadcast() async {
    print('Intent was sent as local broadcast');

    var intent = const AndroidIntent(
      action: 'com.example.android.ACTION_CUSTOM_BROADCAST',
      arguments: {"pass": 1234},
      package: "com.watchgas.launcher"
    );
    intent.sendBroadcast();
  }

  static Future<void> sendBroadcast() async {
    print('Intent was sent as broadcast');

    var intent = const AndroidIntent(
      action: 'com.example.android.UNLOCK_LAUNCHER',
      arguments: {"pass": "12345"},
    );
    intent.sendBroadcast();
  }

}