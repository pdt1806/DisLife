import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final List<Map<String, dynamic>> settings = [
    {
      'title': 'API Endpoint',
      'route': '/settings/api',
      'icon': Icons.api,
    },
    {
      'title': 'Default post information',
      'route': '/settings/default-post',
      'icon': Icons.post_add,
    },
    {
      'title': 'Theme',
      'route': '/settings/theme',
      'icon': Icons.palette,
    },
    {
      'title': 'About this app',
      'route': '/settings/about',
      'icon': Icons.info,
    }
  ];

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).textTheme.bodyLarge!.color!;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text('Settings', style: TextStyle(color: textColor)),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              for (var setting in settings)
                ListTile(
                  leading: Icon(
                    setting['icon'],
                    color: textColor,
                  ),
                  title: Text(setting['title'],
                      style: TextStyle(fontSize: 20, color: textColor)),
                  onTap: () {
                    Navigator.pushNamed(context, setting['route']);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
