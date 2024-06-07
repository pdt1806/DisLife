import 'dart:async';

import 'package:dislife/utils/const.dart';
import 'package:dislife/utils/fns.dart';
import 'package:dislife/utils/http.dart';
import 'package:flutter/material.dart';

class ViewPost extends StatefulWidget {
  const ViewPost({super.key});

  @override
  State<ViewPost> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  Map<String, dynamic> post = {};

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() {
    if (mounted) {
      setState(() {
        post = {};
      });
    }
    fetchPost().then((value) {
      if (mounted) {
        setState(() {
          post = value;
        });
      }
    });
  }

  clearPostAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: const Text("Clear current post"),
      content: const Text("Are you sure you want to clear the current post?"),
      actions: [
        TextButton(
          child: const Text("Clear"),
          onPressed: () {
            clearPost().then(
              (value) {
                if (value) {
                  if (mounted) {
                    setState(() {
                      post = {"data": null};
                    });
                  }
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Post cleared.'),
                      backgroundColor: Colors.green));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Failed to clear post.'),
                      backgroundColor: Colors.red));
                }
              },
            );
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("Cancel", style: TextStyle(color: Colors.red)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
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
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: discordColor,
        title: const Text('View current post',
            style: TextStyle(color: Colors.white)),
      ),
      body: RefreshIndicator(
        color: discordColor,
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 0), () {
            loadData();
          });
        },
        child: ListView(
          children: [
            SingleChildScrollView(
              child: Container(
                height: (post["data"] == null || post.isEmpty) && mounted
                    ? MediaQuery.of(context).size.height - 56 - 56 - 50
                    : null,
                alignment: Alignment.topCenter,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  margin: const EdgeInsets.all(15),
                  child: post.isNotEmpty
                      ? post["data"] != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Created on ${post["data"]["created"]}",
                                    style: const TextStyle(fontSize: 15)),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  height: width - 30,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            NetworkImage(post["data"]["image"]),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    child: null,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                if (post["data"]["description1"] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      post["data"]["description1"],
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                if (post["data"]["description2"] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      post["data"]["description2"],
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                if (post["data"]["timestamp"] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: CountUpTimer(
                                      startTime: DateTime.parse(
                                          post["data"]["timestamp"]),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: TextButton(
                                      onPressed: () {
                                        linkTo(Uri.parse(
                                            post["data"]["image"].toString()));
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  post["data"]["viewFullImage"]
                                                      ? discordColor
                                                      : Colors.transparent),
                                          shape: WidgetStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: post["data"]["viewFullImage"]
                                                ? BorderSide.none
                                                : const BorderSide(
                                                    color: discordColor,
                                                    width: 2),
                                          ))),
                                      child: Text(
                                        'View full image',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: post["data"]["viewFullImage"]
                                                ? Colors.white
                                                : discordColor),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                const Divider(),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: TextButton(
                                      onPressed: () {
                                        clearPostAlertDialog(context);
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  Colors.red),
                                          shape: WidgetStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          ))),
                                      child: const Text('Clear this post',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const Center(
                              child: Text('No current post.',
                                  style: TextStyle(fontSize: 20)),
                            )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: discordColor,
                          ),
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CountUpTimer extends StatefulWidget {
  final DateTime startTime;

  const CountUpTimer({super.key, required this.startTime});

  @override
  CountUpTimerState createState() => CountUpTimerState();
}

class CountUpTimerState extends State<CountUpTimer> {
  late Timer _timer;
  late DateTime _currentTime;
  late Duration _elapsed;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _elapsed = _currentTime.difference(widget.startTime);
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTime);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime(Timer timer) {
    if (mounted) {
      setState(() {
        _currentTime = DateTime.now();
        _elapsed = _currentTime.difference(widget.startTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(_formatDuration(_elapsed),
        style: const TextStyle(fontSize: 20));
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds elapsed";
  }
}
