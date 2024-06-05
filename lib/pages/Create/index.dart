import 'dart:convert';
import 'dart:io';

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
  bool elaspseTime = false;
  bool advancedInfo = false;
  bool viewFullImage = true;
  List dropdownOptions = ['Current location', 'Custom'];
  String dropdownValue = 'Current location';
  File? image;

  TextEditingController description1Controller = TextEditingController();
  TextEditingController description2Controller = TextEditingController();

  bool description1Invalid = false;
  bool description2Invalid = false;

  bool uploadingPost = false;

  Future<bool> pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile == null) return false;

      setState(() {
        image = File(pickedFile.path);
      });
      return true;
    } on PlatformException {
      return false;
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
    pickImage();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: discordColor,
          title: const Text('Create new post',
              style: TextStyle(color: Colors.white)),
        ),
        body: Container(
          margin: const EdgeInsets.all(15),
          child: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: width - 30,
                child: Container(
                  decoration: BoxDecoration(
                    image: image != null
                        ? DecorationImage(
                            image: Image.file(image!).image,
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
                        pickImage().then(
                          (isValid) {
                            if (!isValid) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Failed to take an image.'),
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
                  onPressed: () {
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

                    final bytes = image!.readAsBytesSync();
                    final base64Image = base64Encode(bytes);

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
                        Navigator.pushNamed(context, '/view');
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
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            ],
          )),
        ));
  }
}
