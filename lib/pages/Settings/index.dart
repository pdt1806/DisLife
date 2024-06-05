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
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            margin: const EdgeInsets.all(15),
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: const Icon(Icons.api),
                  title: const Text('API Endpoint',
                      style: TextStyle(fontSize: 20)),
                  onTap: () {
                    Navigator.pushNamed(context, '/settings/api');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
