import 'dart:async';

import 'package:dislife/utils/const.dart';
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
    fetchPost().then((value) {
      setState(() {
        post = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: discordColor,
        title: const Text('View current post',
            style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: SingleChildScrollView(
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
                                image: NetworkImage(post["data"]["image"]),
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
                              startTime:
                                  DateTime.parse(post["data"]["timestamp"]),
                            ),
                          ),
                        if (post["data"]["viewFullImage"])
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: true,
                                    onChanged: (_) {},
                                    splashRadius: 0.0,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text('Allow viewing full image',
                                    style: TextStyle(fontSize: 20)),
                              ],
                            ),
                          ),
                      ],
                    )
                  : const Center(
                      child: Text('No current post.',
                          style: TextStyle(fontSize: 20)),
                    )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
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
    setState(() {
      _currentTime = DateTime.now();
      _elapsed = _currentTime.difference(widget.startTime);
    });
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
