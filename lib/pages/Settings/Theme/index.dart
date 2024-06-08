import 'package:dislife/utils/fns.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/const.dart';

class SettingsTheme extends StatefulWidget {
  final void Function(String) updateThemeRuntime;
  const SettingsTheme({super.key, required this.updateThemeRuntime});

  @override
  State<SettingsTheme> createState() => _SettingsThemeState();
}

class _SettingsThemeState extends State<SettingsTheme> {
  String theme = 'Light';
  final List<String> themes = [
    'Light',
    'Dark',
    'System default',
  ];
  bool isLoading = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      theme = prefs.getString('theme') ?? 'Light';
    });
  }

  void setTheme(String value) {
    setState(() {
      theme = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).textTheme.bodyLarge!.color!;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        titleSpacing: 0,
        title: Text(
          'Theme',
          style: TextStyle(color: textColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Theme", style: TextStyle(fontSize: 18)),
                    DropdownButton(
                      dropdownColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[900]
                              : lightColor,
                      items: themes
                          .map((value) => DropdownMenuItem(
                                value: value,
                                child: Text(value.toString(),
                                    style: TextStyle(color: textColor)),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setTheme(value.toString());
                      },
                      value: theme,
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });

                      saveTheme(theme, widget.updateThemeRuntime)
                          .then((isValid) {
                        setState(() {
                          isLoading = false;
                        });

                        if (isValid) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Theme saved successfully!",
                                      style: TextStyle(color: lightColor)),
                                  backgroundColor: Colors.green));
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Cannot save theme.",
                                    style: TextStyle(color: lightColor)),
                                backgroundColor: Colors.red),
                          );
                        }
                      });
                    },
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    child: !isLoading
                        ? const Text('Save',
                            style: TextStyle(fontSize: 20, color: lightColor))
                        : const CircularProgressIndicator(
                            color: lightColor,
                          ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
