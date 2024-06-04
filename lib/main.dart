import 'dart:io';

import 'package:dislife/pages/Create/index.dart';
import 'package:dislife/pages/Home/index.dart';
import 'package:dislife/pages/Settings/API/index.dart';
import 'package:dislife/pages/Settings/index.dart';
import 'package:flutter/material.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
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
      },
    );
  }
}
