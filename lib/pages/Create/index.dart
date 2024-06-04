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
  List dropdownOptions = ['Current location', 'Custom'];
  String dropdownValue = 'Current location';
  File? image;

  TextEditingController description1Controller = TextEditingController();
  TextEditingController description2Controller = TextEditingController();
  TextEditingController buttonLabelController = TextEditingController();
  TextEditingController buttonURLController = TextEditingController();

  bool description1Invalid = false;
  bool description2Invalid = false;
  bool buttonLabelInvalid = false;
  bool buttonURLInvalid = false;

  Future pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile == null) return;

      setState(() {
        image = File(pickedFile.path);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void toggleElapseTime() {
    setState(() {
      elaspseTime = !elaspseTime;
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
                        pickImage();
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
                  errorText: description1Invalid
                      ? "This field requires more than 2 characters."
                      : null,
                ),
                controller: description1Controller,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Checkbox(
                      activeColor: discordColor,
                      value: advancedInfo,
                      onChanged: (_) {
                        toggleAdvancedInfo();
                      }),
                  const Text("Advanced information",
                      style: TextStyle(fontSize: 18)),
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
                        errorText: description2Invalid
                            ? "This field requires more than 2 characters."
                            : null,
                      ),
                      controller: description2Controller,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Elapse time",
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
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Button label',
                              errorText: buttonLabelInvalid
                                  ? "This field should not be empty and requires less than 32 characters."
                                  : null,
                            ),
                            controller: buttonLabelController,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: DropdownButton(
                            value: dropdownValue,
                            items: dropdownOptions.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                dropdownValue = value as String;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    if (dropdownValue == 'Custom')
                      Column(
                        children: [
                          const SizedBox(height: 15),
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Custom URL',
                            ),
                            controller: buttonURLController,
                          ),
                        ],
                      )
                  ],
                ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  onPressed: () {
                    Map<String, dynamic> data;

                    if (!advancedInfo) {
                      if (image == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select an image.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      if (description1Controller.text.isEmpty ||
                          description1Controller.text.length < 2) {
                        setState(() {
                          description1Invalid = true;
                        });
                        return;
                      }
                      data = {
                        'description1': description1Controller.text,
                      };
                    } else {
                      if (image == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please take an image.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      if (description1Controller.text.isEmpty ||
                          description1Controller.text.length < 2) {
                        setState(() {
                          description1Invalid = true;
                        });
                        return;
                      }
                      if (description2Controller.text.isNotEmpty &&
                          description2Controller.text.length < 2) {
                        setState(() {
                          description2Invalid = true;
                        });
                        return;
                      }
                      if (buttonLabelController.text.isNotEmpty &&
                          buttonLabelController.text.length > 32) {
                        setState(() {
                          buttonLabelInvalid = true;
                        });
                        return;
                      }
                      if (dropdownValue == 'Custom' &&
                          buttonURLController.text.isNotEmpty) {
                        if (buttonURLController.text.isNotEmpty &&
                            !Uri.parse(buttonURLController.text).isAbsolute) {
                          setState(() {
                            buttonURLInvalid = true;
                          });
                          return;
                        }
                      }
                      data = {
                        'description1': description1Controller.text,
                        'description2': description2Controller.text.isNotEmpty
                            ? description2Controller.text
                            : '',
                        'timestamp': elaspseTime,
                        'button1': buttonLabelController.text.isNotEmpty
                            ? {
                                'label': buttonLabelController.text.isNotEmpty
                                    ? buttonLabelController.text
                                    : '',
                                'url': dropdownValue == 'Custom'
                                    ? buttonURLController.text.isNotEmpty
                                        ? buttonURLController.text
                                        : ''
                                    : ''
                              }
                            : null
                      };
                    }

                    createPost(image, data).then(
                      (value) {
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
                      },
                    );

                    // Navigator.pushNamed(context, '/preview');
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(discordColor),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                  child: const Text('Create post',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            ],
          )),
        ));
  }
}
