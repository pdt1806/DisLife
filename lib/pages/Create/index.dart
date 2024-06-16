import 'dart:convert';

import 'package:dislife/utils/const.dart';
import 'package:dislife/utils/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';

class CreateNewPost extends StatefulWidget {
  final void Function(int) changePage;
  final Uint8List? image;

  const CreateNewPost(
      {super.key, required this.changePage, required this.image});

  @override
  State<CreateNewPost> createState() => _CreateNewPostState();
}

class _CreateNewPostState extends State<CreateNewPost> {
  bool timestamp = false,
      advancedInfo = false,
      viewFullImage = true,
      description1Invalid = false,
      description2Invalid = false,
      isLoading = false;

  String expirationTime = '12 hours';
  int cupertinoExpirationTime = expirationTimeItems.indexOf('12 hours');

  TextEditingController description1Controller = TextEditingController(),
      description2Controller = TextEditingController();

  void toggleTimestamp() {
    setState(() {
      timestamp = !timestamp;
    });
  }

  void toggleViewFullImage() {
    setState(() {
      viewFullImage = !viewFullImage;
    });
  }

  void toggleAdvancedInfo() {
    setState(() {
      advancedInfo = !advancedInfo;
    });
  }

  void setExpirationTimeDropdownValue(String value) {
    setState(() {
      expirationTime = value;
    });
  }

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

    final apiEndpoint = prefs.getString('apiEndpoint') ?? '';
    final password = prefs.getString('password') ?? '';

    verifyEndpoint(apiEndpoint, password).then((res) {
      if (res.statusCode != 200 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 5),
            content: Text(
              'Could not connect to the API. Please check your API endpoint and password.',
              style: TextStyle(color: lightColor),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
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

  Future<void> onSubmit() async {
    Map<String, dynamic> data;

    if (widget.image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image.',
              style: TextStyle(color: lightColor)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      description1Invalid = description1Controller.text.isNotEmpty &&
          description1Controller.text.length < 2;
    });

    if (description1Controller.text.isNotEmpty &&
        description1Controller.text.length < 2) return;

    final base64Image = base64Encode(widget.image!);

    data = {
      'description1': description1Controller.text,
      'image': base64Image,
      'viewFullImage': viewFullImage,
      'expirationTime': dropdownToSeconds[expirationTime] ?? 12 * 60 * 60,
    };

    if (advancedInfo) {
      setState(() {
        description2Invalid = description2Controller.text.isNotEmpty &&
            description2Controller.text.length < 2;
      });

      if (description2Controller.text.isNotEmpty &&
          description2Controller.text.length < 2) {
        return;
      }

      data['description2'] = description2Controller.text;
      data['timestamp'] = timestamp;
    }

    setState(() {
      isLoading = true;
    });

    createPost(data).then(
      (value) {
        setState(() {
          isLoading = false;
        });

        if (value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Post created.', style: TextStyle(color: lightColor)),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to create post.',
                  style: TextStyle(color: lightColor)),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (value) {
          Navigator.pop(context);
          widget.changePage(0);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width > 600
        ? 600
        : MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        titleSpacing: 0,
        title: Text('Create new post',
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color)),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                const SizedBox(height: 15),
                SizedBox(
                  width: width - 30,
                  height: width - 30,
                  child: Container(
                    decoration: BoxDecoration(
                      image: widget.image != null
                          ? DecorationImage(
                              image: MemoryImage(widget.image!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: widget.image == null ? discordColor : null,
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: IconButton(
                        style: ButtonStyle(
                            overlayColor: WidgetStateProperty.all<Color>(
                                Colors.transparent),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                        onPressed: () {},
                        icon: widget.image == null
                            ? const Icon(Icons.photo,
                                size: 50, color: lightColor)
                            : const Text("")),
                  ),
                ),
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
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Platform.isIOS
                          ? CupertinoCheckbox(
                              activeColor: discordColor,
                              value: advancedInfo,
                              onChanged: (_) {
                                toggleAdvancedInfo();
                              },
                            )
                          : Checkbox(
                              value: advancedInfo,
                              onChanged: (_) {
                                toggleAdvancedInfo();
                              },
                            ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      child: const Text("Advanced information",
                          style: TextStyle(fontSize: 18)),
                      onTap: () {
                        toggleAdvancedInfo();
                      },
                    ),
                  ],
                ),
                if (advancedInfo)
                  Column(
                    children: [
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Message #2',
                          hintText: 'This field is optional.',
                          hintStyle:
                              const TextStyle(fontWeight: FontWeight.normal),
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
                                      scrollController:
                                          FixedExtentScrollController(
                                        initialItem: cupertinoExpirationTime,
                                      ),
                                      onSelectedItemChanged:
                                          (int selectedItem) {
                                        setState(() {
                                          cupertinoExpirationTime =
                                              selectedItem;
                                          expirationTime =
                                              expirationTimeItems[selectedItem];
                                        });
                                      },
                                      children: List<Widget>.generate(
                                        expirationTimeItems.length,
                                        (int index) {
                                          return Center(
                                            child: Text(
                                                expirationTimeItems[index]),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color!
                                                .withOpacity(0.2),
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
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Icon(
                                                Icons.arrow_drop_down_sharp,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color,
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                        ],
                                      )),
                                )
                              : DropdownButton(
                                  dropdownColor: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey[900]
                                      : lightColor,
                                  items: expirationTimeItems
                                      .map((value) => DropdownMenuItem(
                                            value: value,
                                            child: Text(
                                              value.toString(),
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setExpirationTimeDropdownValue(
                                        value.toString());
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
                          Platform.isIOS
                              ? CupertinoSwitch(
                                  activeColor: discordColor,
                                  value: timestamp,
                                  onChanged: (_) {
                                    toggleTimestamp();
                                  },
                                )
                              : Switch(
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
                          Platform.isIOS
                              ? CupertinoSwitch(
                                  activeColor: discordColor,
                                  value: viewFullImage,
                                  onChanged: (_) {
                                    toggleViewFullImage();
                                  },
                                )
                              : Switch(
                                  inactiveTrackColor: Colors.transparent,
                                  value: viewFullImage,
                                  onChanged: (_) {
                                    toggleViewFullImage();
                                  },
                                )
                        ],
                      ),
                    ],
                  ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Platform.isIOS
                      ? CupertinoButton(
                          color: discordColor,
                          onPressed: isLoading
                              ? null
                              : () async {
                                  await onSubmit();
                                },
                          child: const Text(
                            'Create post',
                            style: TextStyle(color: lightColor),
                          ),
                        )
                      : TextButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  await onSubmit();
                                },
                          style: ButtonStyle(
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: lightColor,
                                )
                              : const Text('Create post',
                                  style: TextStyle(
                                      fontSize: 20, color: lightColor)),
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
