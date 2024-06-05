import 'package:dislife/utils/const.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: discordColor,
          title: const Text('Settings', style: TextStyle(color: Colors.white)),
        ),
        body: Container(
          margin: const EdgeInsets.all(15),
          child: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder())),
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings/api');
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.api, color: Colors.black),
                      SizedBox(width: 10),
                      Text('API Endpoint',
                          style: TextStyle(fontSize: 20, color: Colors.black)),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ));
  }
}
