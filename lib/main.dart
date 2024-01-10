import 'dart:async';

// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ex/constants/colors.dart';
import 'package:ex/context/stl_without_construct_param.dart';
import 'package:ex/save_zone_ex.dart';
import 'package:ex/tangram_test/tangram_test.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'method_channel/screen.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const LauncherController(),
    );
  }
}
