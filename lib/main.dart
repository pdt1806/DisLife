import 'dart:io';

import 'package:dislife/pages/Create/index.dart';
import 'package:dislife/pages/Home/index.dart';
import 'package:dislife/pages/Settings/API/index.dart';
import 'package:dislife/pages/Settings/index.dart';
import 'package:dislife/pages/View/index.dart';
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

  final String title = 'DisLife';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Home(),
      routes: {
        '/home': (context) => const Home(),
        '/create': (context) => const CreateNewPost(),
        '/settings': (context) => const Settings(),
        '/settings/api': (context) => const SettingsAPI(),
        '/view': (context) => const ViewPost(),
      },
    );
  }
}
