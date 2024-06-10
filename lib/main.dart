import 'package:camera/camera.dart';
import 'package:dislife/pages/Home/index.dart';
import 'package:dislife/pages/Settings/API/index.dart';
import 'package:dislife/pages/Settings/DefaultPost/index.dart';
import 'package:dislife/pages/Settings/Theme/index.dart';
import 'package:dislife/utils/const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lehttp_overrides/lehttp_overrides.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';

import 'pages/Settings/About/index.dart';

Future<void> main() async {
  if (!kIsWeb) {
    if (Platform.isAndroid) {
      HttpOverrides.global = LEHttpOverrides(allowExpiredDSTX3: true);
    }
  }
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final cameras = await availableCameras();
    runApp(MyApp(cameras: cameras));
  } catch (e) {
    runApp(const MyApp(cameras: []));
  }
}

class MyApp extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MyApp({super.key, required this.cameras});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String theme = 'Light';

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      theme = prefs.getString('theme') ?? 'Light';
    });
  }

  void updateThemeRuntime(String value) {
    setState(() {
      theme = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DisLife',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: discordColor,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: discordColor,
        ),
        textTheme: TextTheme(
          bodyLarge: const TextStyle(color: darkColor),
          bodyMedium: TextStyle(color: Colors.grey[800]),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: lightColor,
          shape: Border(
            bottom: BorderSide(color: darkColor.withOpacity(0.05), width: 1),
          ),
        ),
        switchTheme: SwitchThemeData(
          trackOutlineColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return null;
            }
            return Colors.grey[600];
          }),
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return discordColor;
            }
            return Colors.grey[600];
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return discordColor.withOpacity(0.5);
            }
            return Colors.grey[600];
          }),
        ),
        dividerTheme: DividerThemeData(
          color: Colors.grey[600],
          thickness: 1,
        ),
        scaffoldBackgroundColor: lightColor,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: discordColor,
          unselectedItemColor: Colors.grey[600],
          backgroundColor: lightColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          floatingLabelStyle: WidgetStateTextStyle.resolveWith(
            (states) {
              final Color color = states.contains(WidgetState.error)
                  ? Theme.of(context).colorScheme.error
                  : states.contains(WidgetState.focused)
                      ? discordColor
                      : darkColor;
              return TextStyle(color: color);
            },
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: darkColor),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: discordColor, width: 2),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: darkColor),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: lightColor,
            backgroundColor: discordColor,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: lightColor,
            backgroundColor: discordColor,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: discordColor,
            side: const BorderSide(color: discordColor),
          ),
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: lightColor,
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return discordColor;
            }
            return null;
          }),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: discordColor,
          selectionColor: discordColor.withOpacity(0.5),
          selectionHandleColor: discordColor,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: lightColor,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: lightColor,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: lightColor,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: lightColor),
          bodyMedium: TextStyle(color: lightColor),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: darkColor,
          iconTheme: const IconThemeData(color: lightColor),
          shape: Border(
            bottom: BorderSide(color: lightColor.withOpacity(0.05), width: 1),
          ),
        ),
        switchTheme: SwitchThemeData(
          trackOutlineColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return null;
            }
            return Colors.grey[600];
          }),
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return discordColor;
            }
            return Colors.grey[600];
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return discordColor.withOpacity(0.5);
            }
            return Colors.grey[600];
          }),
        ),
        dividerTheme: DividerThemeData(
          color: Colors.grey[600],
          thickness: 1,
        ),
        scaffoldBackgroundColor: darkColor,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: lightColor,
          unselectedItemColor: Colors.grey[600],
          backgroundColor: darkColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: WidgetStateTextStyle.resolveWith(
            (states) {
              final Color color = states.contains(WidgetState.error)
                  ? Theme.of(context).colorScheme.error
                  : lightColor;
              return TextStyle(color: color);
            },
          ),
          floatingLabelStyle: WidgetStateTextStyle.resolveWith(
            (states) {
              final Color color = states.contains(WidgetState.error)
                  ? Theme.of(context).colorScheme.error
                  : states.contains(WidgetState.focused)
                      ? discordColor
                      : lightColor;
              return TextStyle(color: color);
            },
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: lightColor),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: discordColor, width: 2),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: lightColor),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: lightColor,
            backgroundColor: discordColor,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: lightColor,
            backgroundColor: discordColor,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: discordColor,
            side: const BorderSide(color: discordColor),
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.grey[900],
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return discordColor;
            }
            return null;
          }),
          checkColor: WidgetStateProperty.all<Color>(lightColor),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: discordColor,
          selectionColor: discordColor.withOpacity(0.5),
          selectionHandleColor: discordColor,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.grey[900],
        ),
      ),
      themeMode: {
        'Light': ThemeMode.light,
        'Dark': ThemeMode.dark,
        'System default': ThemeMode.system,
      }[theme],
      home: Home(cameras: widget.cameras),
      routes: {
        '/settings/api': (context) => const SettingsAPI(),
        '/settings/default-post': (context) => const SettingsDefaultPost(),
        '/settings/theme': (context) =>
            SettingsTheme(updateThemeRuntime: updateThemeRuntime),
        '/settings/about': (context) => const SettingsAbout(),
      },
    );
  }
}
