import 'package:dislife/utils/const.dart';
import 'package:dislife/utils/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  String appVersion = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        appVersion = packageInfo.version;
      });
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
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: discordColor,
          title: Row(
            children: [
              SvgPicture.asset(
                "assets/images/icons/flower.svg",
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 5),
              const Text(
                'DisLife',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                margin: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 150,
                            child: Container(
                              decoration: BoxDecoration(
                                color: homeButtonColors[0],
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              child: TextButton(
                                style: ButtonStyle(
                                    overlayColor:
                                        WidgetStateProperty.all<Color>(
                                            Colors.transparent),
                                    shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/create');
                                },
                                child: const Text('Create new post',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                            child: SizedBox(
                          height: 150,
                          child: Container(
                            decoration: BoxDecoration(
                              color: homeButtonColors[1],
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            child: TextButton(
                              style: ButtonStyle(
                                  overlayColor: WidgetStateProperty.all<Color>(
                                      Colors.transparent),
                                  shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                              onPressed: () {
                                clearPostAlertDialog(context);
                              },
                              child: const Text('Clear current post',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white)),
                            ),
                          ),
                        ))
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 150,
                            child: Container(
                              decoration: BoxDecoration(
                                color: homeButtonColors[2],
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              child: TextButton(
                                style: ButtonStyle(
                                    overlayColor:
                                        WidgetStateProperty.all<Color>(
                                            Colors.transparent),
                                    shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/view');
                                },
                                child: const Text('View current post',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: SizedBox(
                            height: 150,
                            child: Container(
                              decoration: BoxDecoration(
                                color: homeButtonColors[3],
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              child: TextButton(
                                style: ButtonStyle(
                                    overlayColor:
                                        WidgetStateProperty.all<Color>(
                                            Colors.transparent),
                                    shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/settings');
                                },
                                child: const Text('Settings',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Made with ❤️ by ',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                        GestureDetector(
                          child: const Text(
                            'pdt1806',
                            style: TextStyle(color: discordColor, fontSize: 15),
                          ),
                          onTap: () {
                            _launchUrl(Uri.parse('https://github.com/pdt1806'));
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'DisLife v$appVersion',
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ],
                )),
          ),
        ));
  }
}
