import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ------------------------------------------
// Verify endpoint

Future<http.Response> verifyEndpoint(String apiEndpoint, String apiKey) {
  return http.get(
    Uri.parse('$apiEndpoint/verify'),
    headers: <String, String>{'Authorization': apiKey},
  );
}

Future<bool> savingAPIEndpoint(String apiEndpoint, String apiKey) async {
  try {
    http.Response response = await verifyEndpoint(apiEndpoint, apiKey);
    bool isValid = response.statusCode == 200;
    String imgbbKey = jsonDecode(response.body)['imgbb_key'];

    if (isValid) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('apiEndpoint', apiEndpoint);
      prefs.setString('apiKey', apiKey);
      prefs.setString('imgbbKey', imgbbKey);
    }

    return isValid;
  } catch (e) {
    return false;
  }
}

// ------------------------------------------
// Clear post

Future<http.Response> clearPostHTTP(String apiEndpoint, String apiKey) {
  return http.get(
    Uri.parse('$apiEndpoint/clear'),
    headers: <String, String>{'Authorization': apiKey},
  );
}

Future<bool> clearPost() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiEndpoint = prefs.getString('apiEndpoint') ?? '';
    String apiKey = prefs.getString('apiKey') ?? '';

    bool cleared = await clearPostHTTP(apiEndpoint, apiKey)
        .then((response) => response.statusCode == 200)
        .catchError((error) => false);

    return cleared;
  } catch (e) {
    return false;
  }
}

// ------------------------------------------
// Create post

Future<http.Response> uploadImage(File image) async {
  final bytes = image.readAsBytesSync();
  final base64Image = base64Encode(bytes);

  SharedPreferences prefs = await SharedPreferences.getInstance();

  final Map<String, String> payload = {
    'key': prefs.getString('imgbbKey') ?? '',
    'image': base64Image,
    'expiration': '43200', // 12 hours in seconds
  };

  return http.post(
    Uri.parse('https://api.imgbb.com/1/upload'),
    body: payload,
  );
}

Future<http.Response> createPostHTTP(Map<String, dynamic> data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String apiEndpoint = prefs.getString('apiEndpoint') ?? '';
  String apiKey = prefs.getString('apiKey') ?? '';

  return http.post(
    Uri.parse('$apiEndpoint/post'),
    headers: <String, String>{
      'Authorization': apiKey,
      'Content-Type': 'application/json'
    },
    body: jsonEncode(data),
  );
}

Future<bool> createPost(File? image, Map<String, dynamic> data) async {
  try {
    if (image == null) {
      return false;
    }

    http.Response uploadImageResponse = await uploadImage(image);
    String imageUrl = uploadImageResponse.statusCode == 200
        ? jsonDecode(uploadImageResponse.body)['data']['url']
        : '';

    if (uploadImageResponse.statusCode != 200 || imageUrl.isEmpty) {
      return false;
    }

    data['image'] = imageUrl;

    bool isValid = await createPostHTTP(data)
        .then((response) => response.statusCode == 200)
        .catchError((error) => false);

    return isValid;
  } catch (e) {
    return false;
  }
}
