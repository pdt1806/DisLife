import 'package:dislife/utils/const.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: discordColor,
          title: const Text('DisLife',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        body: Container(
          margin: const EdgeInsets.all(15),
          child: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 150,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage('assets/images/create_bg.jpg'),
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.6), BlendMode.darken),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                        overlayColor:
                            WidgetStateProperty.all<Color>(Colors.transparent),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    onPressed: () {
                      Navigator.pushNamed(context, '/create');
                    },
                    child: const Text('Create new post',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 150,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage('assets/images/create_bg.jpg'),
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.6), BlendMode.darken),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                        overlayColor:
                            WidgetStateProperty.all<Color>(Colors.transparent),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    onPressed: () {
                      // Navigator.pushNamed(context, '/create');
                    },
                    child: const Text('Clear current post',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 150,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage('assets/images/create_bg.jpg'),
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.6), BlendMode.darken),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                        overlayColor:
                            WidgetStateProperty.all<Color>(Colors.transparent),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                    child: const Text('Settings',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ),
              ),
            ],
          )),
        ));
  }
}
