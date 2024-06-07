import 'package:dislife/pages/Create/index.dart';
import 'package:dislife/pages/Settings/index.dart';
import 'package:dislife/pages/View/index.dart';
import 'package:dislife/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String appVersion = '';
  int _currentIndex = 1;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
    _initializeAppVersion();
  }

  void _initializeAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        appVersion = packageInfo.version;
      });
    }
  }

  void changePage(int index) {
    if (mounted) {
      setState(() {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 200),
          curve: Curves.linearToEaseOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          if (mounted) {
            setState(() => _currentIndex = value);
          }
        },
        children: [
          const ViewPost(),
          CreateNewPost(
            changePage: changePage,
          ),
          const Settings()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: discordColor,
        currentIndex: _currentIndex,
        onTap: (value) => changePage(value),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'View',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
