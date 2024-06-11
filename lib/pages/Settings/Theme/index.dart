import 'package:dislife/utils/fns.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';

import '../../../utils/const.dart';

class SettingsTheme extends StatefulWidget {
  final void Function(String) updateThemeRuntime;
  const SettingsTheme({super.key, required this.updateThemeRuntime});

  @override
  State<SettingsTheme> createState() => _SettingsThemeState();
}

class _SettingsThemeState extends State<SettingsTheme> {
  String theme = 'Light';
  int cupertinoTheme = themes.indexOf('Light');

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
      cupertinoTheme = themes.indexOf(theme);
    });
  }

  void setTheme(String value) {
    setState(() {
      theme = value;
    });
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
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
                    Platform.isIOS
                        ? CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => _showDialog(
                              CupertinoPicker(
                                magnification: 1.22,
                                squeeze: 1.2,
                                useMagnifier: true,
                                itemExtent: 40.0,
                                scrollController: FixedExtentScrollController(
                                  initialItem: cupertinoTheme,
                                ),
                                onSelectedItemChanged: (int selectedItem) {
                                  setState(() {
                                    cupertinoTheme = selectedItem;
                                    theme = themes[selectedItem];
                                  });
                                },
                                children: List<Widget>.generate(
                                  themes.length,
                                  (int index) {
                                    return Center(
                                      child: Text(themes[index]),
                                    );
                                  },
                                ),
                              ),
                            ),
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: textColor.withOpacity(0.2),
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          themes[cupertinoTheme],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: textColor,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Icon(
                                          Icons.arrow_drop_down_sharp,
                                          color: textColor,
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                  ],
                                )),
                          )
                        : DropdownButton(
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
