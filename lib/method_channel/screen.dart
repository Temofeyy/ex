import 'package:ex/method_channel/flutter_android.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LauncherController extends StatefulWidget {
  const LauncherController({super.key});

  @override
  State<LauncherController> createState() => _LauncherControllerState();
}

class _LauncherControllerState extends State<LauncherController> {
  bool _isLocked = true;
  static const platform = MethodChannel('test');
  int sum = 100;

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler((call) {
      var name = call.method;
      print('received a call from Kotlin $name');
      if(name == "add100"){
        sum += 100;
        setState(() {});
      } else if(name == "minus100"){
        sum -= 100;
        setState(() {});
      } else if (name == "broadcast"){
        print('received args: ${call.arguments}');
        var pass = (call.arguments as Map<String, dynamic>)['pass'];
        print(pass);
      }
      return Future.value();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Launcher controller'),
        backgroundColor: _isLocked? Colors.red: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(sum.toString()),
            // const FilledButton(onPressed: FlutterAndroidBridge.sendLocalBroadcast, child: Text("send")),
            // const FilledButton(onPressed: FlutterAndroidBridge.requestForMethodCall, child: Text("request")),
            const FilledButton(onPressed: FlutterAndroidBridge.sendBroadcast, child: Text("Unlock Launcher")),
          ],
        ),
      ),
    );
  }
}
