import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


/// MainActivity.kt must contain next code:
///
/// override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
///     super.configureFlutterEngine(flutterEngine)
///     val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
///     channel.setMethodCallHandler {
///         call, result ->
///         if(call.method == "send100"){
///            channel.invokeMethod("add100", null)
///         }
///     }
/// }
class KotlinAndroidHandler extends StatefulWidget {
  const KotlinAndroidHandler({super.key});

  @override
  State<KotlinAndroidHandler> createState() => _KotlinAndroidHandlerState();
}

class _KotlinAndroidHandlerState extends State<KotlinAndroidHandler> {
  static const platform = MethodChannel('test');
  int sum = 100;

  Future<void> requestKotlinForInvokeMethod() async {
    print('Send request for Kotlin call Flutter');
    try{
      await platform.invokeMethod('send100');
    } catch(e, st){
      print('$e\n$st');
    }
  }

  void increaseSum(){
    sum += 100;
    setState(() {});
  }

  @override
  void initState() {
    platform.setMethodCallHandler((call) {
      print('received a call from Kotlin ${call.method}');
      if(call.method == "add100"){
        increaseSum();
      }
      return Future.value();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kotlin to Flutter Handler'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(sum.toString()),
            FilledButton(
              onPressed: requestKotlinForInvokeMethod,
              child: const Text("Request Kotlin"),
            )
          ],
        ),
      ),
    );
  }
}
