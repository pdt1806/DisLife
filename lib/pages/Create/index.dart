import 'dart:convert';

import 'package:dislife/utils/const.dart';
import 'package:dislife/utils/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class CreateNewPost extends StatefulWidget {
  const CreateNewPost({super.key});

  @override
  State<CreateNewPost> createState() => _CreateNewPostState();
}

class _CreateNewPostState extends State<CreateNewPost> {
  bool elaspseTime = false,
      advancedInfo = false,
      viewFullImage = true,
      description1Invalid = false,
      description2Invalid = false,
      uploadingPost = false;

  Uint8List? image;

  TextEditingController description1Controller = TextEditingController(),
      description2Controller = TextEditingController();

  Future displayBottomSheet(BuildContext context) {
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
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take a photo'),
            onTap: () {
              takeImage(ImageSource.camera).then((isValid) {
                if (!isValid) {
                  Navigator.pop(context, false);
                } else {
                  Navigator.pop(context, true);
                }
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from gallery'),
            onTap: () {
              takeImage(ImageSource.gallery).then((isValid) {
                if (!isValid) {
                  Navigator.pop(context, false);
                } else {
                  Navigator.pop(context, true);
                }
              });
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

  void toggleElapseTime() {
    setState(() {
      elaspseTime = !elaspseTime;
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width > 600
        ? 600
        : MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: discordColor,
        title: const Text('Create new post',
            style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            margin: const EdgeInsets.all(15),
            child: Column(
              children: [
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
                          displayBottomSheet(context).then(
                            (isValid) {
                              if (isValid == null) return;

                              if (!isValid) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to select image.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          );
                        },
                        icon: image == null
                            ? const Icon(Icons.add_a_photo,
                                size: 50, color: Colors.white)
                            : const Text("")),
                  ),
                ),
                const SizedBox(height: 15),
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
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        activeColor: discordColor,
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
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
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
                          const Text("Enable elapse time",
                              style: TextStyle(fontSize: 18)),
                          Switch(
                            activeColor: discordColor,
                            inactiveTrackColor: Colors.transparent,
                            value: elaspseTime,
                            onChanged: (_) {
                              toggleElapseTime();
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
                            content: Text('Please select an image.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      setState(() {
                        description1Invalid =
                            description2Controller.text.isNotEmpty &&
                                description2Controller.text.length < 2;
                      });
                      if (description2Controller.text.isNotEmpty &&
                          description2Controller.text.length < 2) return;

                      final base64Image = base64Encode(image!);

                      data = {
                        'description1': description1Controller.text,
                        'image': base64Image,
                        'viewFullImage': viewFullImage,
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
                        data['timestamp'] = elaspseTime;
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
                                content: Text('Post created.'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to create post.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          Navigator.pop(context);
                          if (value) Navigator.pushNamed(context, '/view');
                        },
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(discordColor),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    child: uploadingPost
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('Create post',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
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
