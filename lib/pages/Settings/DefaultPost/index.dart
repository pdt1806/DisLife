import 'package:dislife/utils/const.dart';
import 'package:dislife/utils/fns.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsDefaultPost extends StatefulWidget {
  const SettingsDefaultPost({super.key});

  @override
  State<SettingsDefaultPost> createState() => _SettingsDefaultPostState();
}

class _SettingsDefaultPostState extends State<SettingsDefaultPost> {
  TextEditingController description1Controller = TextEditingController();
  TextEditingController description2Controller = TextEditingController();
  bool timestamp = false, advancedInfo = false, viewFullImage = true;
  bool description1Invalid = false, description2Invalid = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        description1Controller.text =
            prefs.getString('description1_default') ?? '';
        description2Controller.text =
            prefs.getString('description2_default') ?? '';
        advancedInfo = prefs.getBool('advancedInfo_default') ?? false;
        timestamp = prefs.getBool('timestamp_default') ?? false;
        viewFullImage = prefs.getBool('viewFullImage_default') ?? true;
      });
    }
  }

  void toggleTimestamp() async {
    if (mounted) {
      setState(() {
        timestamp = !timestamp;
      });
    }
  }

  void toggleViewFullImage() async {
    if (mounted) {
      setState(() {
        viewFullImage = !viewFullImage;
      });
    }
  }

  void toggleAdvancedInfo() async {
    if (mounted) {
      setState(() {
        advancedInfo = !advancedInfo;
      });
    }
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: discordColor,
        title: const Text('Default post information',
            style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            margin: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Message',
                    hintText: 'This field is optional.',
                    hintStyle: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.normal),
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
                    hintStyle: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.normal),
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
                      activeColor: discordColor,
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
                    const Text("Enable elapsed time",
                        style: TextStyle(fontSize: 18)),
                    Switch(
                      activeColor: discordColor,
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
                      activeColor: discordColor,
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
                      if (mounted) {
                        setState(() {
                          description1Invalid =
                              description1Controller.text.isNotEmpty &&
                                  description1Controller.text.length < 2;
                        });
                      }
                      if (description1Controller.text.isNotEmpty &&
                          description1Controller.text.length < 2) return;

                      if (mounted) {
                        setState(() {
                          description2Invalid =
                              description2Controller.text.isNotEmpty &&
                                  description2Controller.text.length < 2;
                        });
                      }
                      if (description2Controller.text.isNotEmpty &&
                          description2Controller.text.length < 2) return;

                      if (mounted) {
                        setState(() {
                          isLoading = true;
                        });
                      }

                      saveDefaultPostSettings(
                        advancedInfo: advancedInfo,
                        description1: description1Controller.text,
                        description2: description2Controller.text,
                        timestamp: timestamp,
                        viewFullImage: viewFullImage,
                      ).then((isValid) {
                        if (mounted) {
                          setState(() {
                            isLoading = false;
                          });
                        }
                        if (isValid) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Text(
                                    "Default post information saved successfully!",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: Colors.green));
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                  "Cannot save default post information.",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.red),
                          );
                        }
                      });
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(discordColor),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    child: !isLoading
                        ? const Text('Save',
                            style: TextStyle(fontSize: 20, color: Colors.white))
                        : const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
