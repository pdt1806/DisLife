import 'dart:io';

import 'package:dislife/utils/const.dart';
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
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Message',
                ),
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
                  const Text("Advanced Information",
                      style: TextStyle(fontSize: 18)),
                ],
              ),
              if (advancedInfo)
                Column(
                  children: [
                    const SizedBox(height: 15),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Message #2',
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Elapse time",
                            style: TextStyle(fontSize: 18)),
                        Switch(
                          activeColor: discordColor,
                          inactiveTrackColor: Colors.white,
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
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Button label',
                            ),
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
                      const Column(
                        children: [
                          SizedBox(height: 15),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Custom URL',
                            ),
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
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        "Post created!",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.green,
                    ));
                    Navigator.pop(context);
                    // then show preview page
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
