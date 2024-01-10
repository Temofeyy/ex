import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/colors.dart';

class InternetStatusOnStream extends StatefulWidget {
  const InternetStatusOnStream({super.key});

  @override
  State<InternetStatusOnStream> createState() => _InternetStatusOnStreamState();
}

class _InternetStatusOnStreamState extends State<InternetStatusOnStream> {
  late final StreamSubscription<InternetConnectionLog> _sub;
  String _status = '';
  final List<InternetConnectionLog> _logs = [];

  void onStreamData(InternetConnectionLog log){
    updateOnScreenStatus(log.status.isConnected ? 'Connected' : 'Disconnected');
    displayChangesInSnackBar(log.message);
    addLog(log);
  }

  void displayChangesInSnackBar(String event){
    mounted;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(event)),
    );
  }

  void addLog(InternetConnectionLog log) {
    _logs.add(log);
    setState(() {});
  }

  void updateOnScreenStatus(String newStatus){
    _status = newStatus;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _sub = Connectivity().onConnectivityChanged.toLog().listen(onStreamData);
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Connection checker'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: [
                const Text('Current internet connection status:'),
                Text(_status, style: const TextStyle(fontSize: 20)),
              ],
            ),
            ListView.builder(
              reverse: true,
              itemCount: _logs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final current = _logs[index];
                final formatter = DateFormat('dd.MM.yyyy \n  hh:mm:ss');
                return ListTile(
                  tileColor: current.status != ConnectivityResult.none ? AppColors.lightGreen : AppColors.lightRed,
                  title: Text(current.message),
                  leading: Text(formatter.format(current.time)),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}

abstract class ILog {
  DateTime get time;
  String get message;
}

class InternetConnectionLog implements ILog{
  final DateTime _time;
  final ConnectivityResult status;

  InternetConnectionLog({required DateTime time, required this.status})
      : _time = time;

  InternetConnectionLog.now({required this.status})
      : _time = DateTime.now();

  @override
  DateTime get time => _time;

  @override
  String get message => 'Status changed to: ${status.name.toUpperCase()}';
}

class InternetConnectionStreamTransformer extends StreamTransformerBase<ConnectivityResult, InternetConnectionLog>{

  @override
  Stream<InternetConnectionLog> bind(Stream<ConnectivityResult> stream) {
    StreamSubscription<ConnectivityResult>? sub;

    final controller = StreamController<InternetConnectionLog>(
      onPause: () => sub?.pause(),
      onResume: () => sub?.resume(),
      onCancel: () => sub?.cancel(),
    );

    sub = stream.listen(
          (event) {
        controller.add(InternetConnectionLog.now(status: event));
      },
      onError: controller.addError,
      onDone: controller.close,
      cancelOnError: false,
    );

    return controller.stream;
  }

}

extension StatusToLogTransformer on Stream<ConnectivityResult>{
  Stream<InternetConnectionLog> toLog() => transform(InternetConnectionStreamTransformer());
}

extension IsConnected on ConnectivityResult{
  bool get isConnected => (index > 0 && index < 4) || index == 5;
}