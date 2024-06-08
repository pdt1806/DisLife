import 'dart:convert';

import 'package:dislife/utils/const.dart';
import 'package:dislife/utils/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNewPost extends StatefulWidget {
  final void Function(int) changePage;

  const CreateNewPost({super.key, required this.changePage});

  @override
  State<CreateNewPost> createState() => _CreateNewPostState();
}

class _CreateNewPostState extends State<CreateNewPost> {
  bool timestamp = false,
      advancedInfo = false,
      viewFullImage = true,
      description1Invalid = false,
      description2Invalid = false,
      uploadingPost = false;

  String expirationTime = '12 hours';

  Uint8List? image;

  TextEditingController description1Controller = TextEditingController(),
      description2Controller = TextEditingController();

  void listTileTakeImage(ImageSource source) {
    takeImage(source).then((isValid) {
      if (!isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to select image.',
                style: TextStyle(color: lightColor)),
            backgroundColor: Colors.red,
          ),
        );
      }
      Navigator.pop(context);
    });
  }

  Future<void> displayBottomSheet(BuildContext context) async {
    Color textColor = Theme.of(context).textTheme.bodyLarge!.color!;

    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
      ),
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            leading: Icon(
              Icons.camera_alt,
              color: textColor,
            ),
            title: Text(
              'Take a photo',
              style: TextStyle(color: textColor),
            ),
            onTap: () {
              listTileTakeImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.photo_library,
              color: textColor,
            ),
            title: Text(
              'Choose from gallery',
              style: TextStyle(color: textColor),
            ),
            onTap: () {
              listTileTakeImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  Future<dynamic> takeImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile == null) return false;

      final bytes = await pickedFile.readAsBytes();

      setState(() {
        image = bytes;
      });

      return true;
    } on PlatformException catch (_) {
      return null;
    }
  }

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
    });
  }

  @override
  void dispose() {
    description1Controller.dispose();
    description2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width > 600
        ? 600
        : MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Row(
          children: [
            SvgPicture.asset(
              "assets/images/icons/flower.svg",
              colorFilter: Theme.of(context).brightness == Brightness.light
                  ? const ColorFilter.mode(discordColor, BlendMode.srcIn)
                  : const ColorFilter.mode(lightColor, BlendMode.srcIn),
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 5),
            Text(
              'DisLife',
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? discordColor
                      : lightColor,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
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
                  width: double.infinity,
                  height: width - 30,
                  child: Container(
                    decoration: BoxDecoration(
                      image: image != null
                          ? DecorationImage(
                              image: MemoryImage(image!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: image == null ? discordColor : null,
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
                        onPressed: () {
                          displayBottomSheet(context);
                        },
                        icon: image == null
                            ? const Icon(Icons.add_a_photo,
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
                      child: Checkbox(
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
                          DropdownButton(
                            dropdownColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[900]
                                    : lightColor,
                            items: expirationTimeItems
                                .map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value.toString(),
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .color)),
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
                    ],
                  ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: () async {
                      Map<String, dynamic> data;

                      if (image == null) {
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
                        description1Invalid =
                            description1Controller.text.isNotEmpty &&
                                description1Controller.text.length < 2;
                      });

                      if (description1Controller.text.isNotEmpty &&
                          description1Controller.text.length < 2) return;

                      final base64Image = base64Encode(image!);

                      data = {
                        'description1': description1Controller.text,
                        'image': base64Image,
                        'viewFullImage': viewFullImage,
                        'expirationTime':
                            dropdownToSeconds[expirationTime] ?? 12 * 60 * 60,
                      };

                      if (advancedInfo) {
                        setState(() {
                          description2Invalid =
                              description2Controller.text.isNotEmpty &&
                                  description2Controller.text.length < 2;
                        });

                        if (description2Controller.text.isNotEmpty &&
                            description2Controller.text.length < 2) return;

                        data['description2'] = description2Controller.text;
                        data['timestamp'] = timestamp;
                      }

                      setState(() {
                        uploadingPost = true;
                      });

                      createPost(data).then(
                        (value) {
                          setState(() {
                            uploadingPost = false;
                          });

                          if (value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Post created.',
                                    style: TextStyle(color: lightColor)),
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
                            widget.changePage(0);
                          }
                        },
                      );
                    },
                    style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ))),
                    child: uploadingPost
                        ? const CircularProgressIndicator(
                            color: lightColor,
                          )
                        : const Text('Create post',
                            style: TextStyle(fontSize: 20, color: lightColor)),
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
