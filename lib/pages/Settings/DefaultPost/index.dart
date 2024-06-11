import 'package:dislife/utils/const.dart';
import 'package:dislife/utils/fns.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';

class SettingsDefaultPost extends StatefulWidget {
  const SettingsDefaultPost({super.key});

  @override
  State<SettingsDefaultPost> createState() => _SettingsDefaultPostState();
}

class _SettingsDefaultPostState extends State<SettingsDefaultPost> {
  TextEditingController description1Controller = TextEditingController();
  TextEditingController description2Controller = TextEditingController();
  String expirationTime = '12 hours';
  int cupertinoExpirationTime = expirationTimeItems.indexOf('12 hours');
  bool timestamp = false, advancedInfo = false, viewFullImage = true;
  bool description1Invalid = false, description2Invalid = false;
  bool isLoading = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      description1Controller.text =
          prefs.getString('description1_default') ?? '';
      description2Controller.text =
          prefs.getString('description2_default') ?? '';
      advancedInfo = prefs.getBool('advancedInfo_default') ?? false;
      timestamp = prefs.getBool('timestamp_default') ?? false;
      viewFullImage = prefs.getBool('viewFullImage_default') ?? true;
      expirationTime = prefs.getString('expirationTime_default') ?? '12 hours';
      cupertinoExpirationTime = expirationTimeItems.indexOf(expirationTime);
    });
  }

  void toggleTimestamp() async {
    setState(() {
      timestamp = !timestamp;
    });
  }

  void toggleViewFullImage() async {
    setState(() {
      viewFullImage = !viewFullImage;
    });
  }

  void toggleAdvancedInfo() async {
    setState(() {
      advancedInfo = !advancedInfo;
    });
  }

  void setExpirationTimeDropdownValue(String value) {
    setState(() {
      expirationTime = value;
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
  void dispose() {
    description1Controller.dispose();
    description2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).textTheme.bodyLarge!.color!;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        titleSpacing: 0,
        title: Text('Default post information',
            style: TextStyle(color: textColor)),
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
                TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Message',
                    hintText: 'This field is optional.',
                    hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                    errorText: description1Invalid
                        ? "This field requires at least 2 characters."
                        : null,
                  ),
                  controller: description1Controller,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Message #2',
                    hintText: 'This field is optional.',
                    hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                    errorText: description2Invalid
                        ? "This field requires at least 2 characters."
                        : null,
                  ),
                  controller: description2Controller,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Advanced information",
                        style: TextStyle(fontSize: 18)),
                    Switch(
                      inactiveTrackColor: Colors.transparent,
                      value: advancedInfo,
                      onChanged: (_) {
                        toggleAdvancedInfo();
                      },
                    )
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Expiration time",
                        style: TextStyle(fontSize: 18)),
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
                                  initialItem: cupertinoExpirationTime,
                                ),
                                onSelectedItemChanged: (int selectedItem) {
                                  setState(() {
                                    cupertinoExpirationTime = selectedItem;
                                    expirationTime =
                                        expirationTimeItems[selectedItem];
                                  });
                                },
                                children: List<Widget>.generate(
                                  expirationTimeItems.length,
                                  (int index) {
                                    return Center(
                                      child: Text(expirationTimeItems[index]),
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
                                          expirationTimeItems[
                                              cupertinoExpirationTime],
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
                            items: expirationTimeItems
                                .map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value.toString(),
                                          style: TextStyle(color: textColor)),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setExpirationTimeDropdownValue(value.toString());
                            },
                            value: expirationTime,
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Enable elapsed time",
                        style: TextStyle(fontSize: 18)),
                    Switch(
                      inactiveTrackColor: Colors.transparent,
                      value: timestamp,
                      onChanged: (_) {
                        toggleTimestamp();
                      },
                    )
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Allow viewing full image",
                        style: TextStyle(fontSize: 18)),
                    Switch(
                      inactiveTrackColor: Colors.transparent,
                      value: viewFullImage,
                      onChanged: (_) {
                        toggleViewFullImage();
                      },
                    )
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        description1Invalid =
                            description1Controller.text.isNotEmpty &&
                                description1Controller.text.length < 2;
                      });

                      if (description1Controller.text.isNotEmpty &&
                          description1Controller.text.length < 2) return;

                      setState(() {
                        description2Invalid =
                            description2Controller.text.isNotEmpty &&
                                description2Controller.text.length < 2;
                      });

                      if (description2Controller.text.isNotEmpty &&
                          description2Controller.text.length < 2) return;

                      setState(() {
                        isLoading = true;
                      });

                      saveDefaultPostSettings(
                        advancedInfo: advancedInfo,
                        description1: description1Controller.text,
                        description2: description2Controller.text,
                        timestamp: timestamp,
                        viewFullImage: viewFullImage,
                        expirationTime: expirationTime,
                      ).then((isValid) {
                        setState(() {
                          isLoading = false;
                        });

                        if (isValid) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  "Default post information saved successfully!",
                                  style: TextStyle(color: lightColor)),
                              backgroundColor: Colors.green));
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Cannot save default post information.",
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
                    ))),
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
