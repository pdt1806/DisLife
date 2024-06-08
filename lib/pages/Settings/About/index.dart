import 'package:dislife/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsAbout extends StatefulWidget {
  const SettingsAbout({super.key});

  @override
  State<SettingsAbout> createState() => _SettingsAboutState();
}

class _SettingsAboutState extends State<SettingsAbout> {
  String markdown = '';
  String version = '';

  @override
  void initState() {
    super.initState();
    loadVersion();
    loadMarkdown();
  }

  Future<String> fetchMarkdown() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/pdt1806/DisLife/main/README.md'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load markdown');
    }
  }

  void loadMarkdown() {
    fetchMarkdown().then((value) {
      setState(() {
        markdown = value;
      });
    }).catchError((error) {
      setState(() {
        markdown = 'Failed to load markdown';
      });
    });
  }

  void loadVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    double imageWidth = MediaQuery.of(context).size.width * 0.5 > 300
        ? 300
        : MediaQuery.of(context).size.width * 0.5;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        titleSpacing: 0,
        title: Text('About this app',
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color)),
      ),
      body: Container(
        height: markdown.isEmpty && mounted
            ? MediaQuery.of(context).size.height - 56 - 56 - 50
            : null,
        alignment: Alignment.topCenter,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: markdown.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/icons/curved.png',
                              width: imageWidth,
                              height: imageWidth,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'DisLife',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            ),
                            Text(
                              'Version $version',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            ),
                            const SizedBox(height: 15),
                            GestureDetector(
                              onTap: () {
                                launchUrl(Uri.parse(
                                    'https://github.com/pdt1806/DisLife'));
                              },
                              child: const Text(
                                'GitHub repository',
                                style: TextStyle(
                                    fontSize: 16, color: discordColor),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              'Transform your Discord Rich Presence into a Locket-like experience: instantly share your moments with friends and peers!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Made with ❤️ by ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    launchUrl(Uri.parse(
                                        'https://github.com/pdt1806'));
                                  },
                                  child: const Text(
                                    'pdt1806',
                                    style: TextStyle(
                                        fontSize: 16, color: discordColor),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Divider(),
                      const SizedBox(height: 15),
                      MarkdownBody(
                        onTapLink: (text, href, title) =>
                            href != null ? launchUrl(Uri.parse(href)) : null,
                        styleSheet: MarkdownStyleSheet(
                          p: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            fontSize: 16,
                          ),
                          a: const TextStyle(
                            color: discordColor,
                            fontSize: 16,
                          ),
                        ),
                        data: markdown,
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
