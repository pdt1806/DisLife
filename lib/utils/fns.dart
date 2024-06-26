import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> linkTo(Uri url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

Future<bool> saveDefaultPostSettings({
  required String description1,
  required String description2,
  required bool advancedInfo,
  required bool timestamp,
  required bool viewFullImage,
  required String expirationTime,
}) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('description1_default', description1);
    await prefs.setString('description2_default', description2);
    await prefs.setBool('advancedInfo_default', advancedInfo);
    await prefs.setBool('timestamp_default', timestamp);
    await prefs.setBool('viewFullImage_default', viewFullImage);
    await prefs.setString('expirationTime_default', expirationTime);
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> saveTheme(String theme, Function updateThemeRuntime) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
    updateThemeRuntime(theme);
    return true;
  } catch (e) {
    return false;
  }
}
