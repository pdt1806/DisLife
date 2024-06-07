import 'dart:io';

import 'package:dislife/pages/Home/index.dart';
import 'package:dislife/pages/Settings/API/index.dart';
import 'package:dislife/pages/Settings/DefaultPost/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lehttp_overrides/lehttp_overrides.dart';

void main() {
  if (!kIsWeb) {
    if (Platform.isAndroid) {
      HttpOverrides.global = LEHttpOverrides(allowExpiredDSTX3: true);
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DisLife',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Home(),
      routes: {
        '/settings/api': (context) => const SettingsAPI(),
        '/settings/default-post': (context) => const SettingsDefaultPost(),
      },
    );
  }
}
