import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ------------------------------------------
// Verify endpoint

Future<http.Response> verifyEndpoint(String apiEndpoint, String apiKey) async {
  return await http.get(
    Uri.parse('$apiEndpoint/verify'),
    headers: <String, String>{'Authorization': apiKey},
  );
}

Future<bool> savingAPIEndpoint(String apiEndpoint, String apiKey) async {
  try {
    if (apiEndpoint.endsWith('/')) {
      apiEndpoint = apiEndpoint.substring(0, apiEndpoint.length - 1);
    }

    http.Response response = await verifyEndpoint(apiEndpoint, apiKey);
    bool isValid = response.statusCode == 200;

    if (isValid) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('apiEndpoint', apiEndpoint);
      prefs.setString('apiKey', apiKey);
    }

    return isValid;
  } catch (e) {
    return false;
  }
}

// ------------------------------------------
// Clear post

Future<http.Response> clearPostHTTP(String apiEndpoint, String apiKey) async {
  return await http.get(
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

Future<http.Response> createPostHTTP(Map<String, dynamic> data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String apiEndpoint = prefs.getString('apiEndpoint') ?? '';
  String apiKey = prefs.getString('apiKey') ?? '';

  return await http.post(
    Uri.parse('$apiEndpoint/post'),
    headers: <String, String>{
      'Authorization': apiKey,
      'Content-Type': 'application/json'
    },
    body: jsonEncode(data),
  );
}

Future<bool> createPost(Map<String, dynamic> data) async {
  try {
    bool isValid = await createPostHTTP(data)
        .then((response) => response.statusCode == 200)
        .catchError((error) => false);

    return isValid;
  } catch (e) {
    return false;
  }
}

// ------------------------------------------
// Fetch post

Future<http.Response> fetchPostHTTP() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String apiEndpoint = prefs.getString('apiEndpoint') ?? '';
  String apiKey = prefs.getString('apiKey') ?? '';

  return await http.get(
    Uri.parse('$apiEndpoint/fetch'),
    headers: <String, String>{'Authorization': apiKey},
  );
}

Future<Map<String, dynamic>> fetchPost() async {
  try {
    Map<String, dynamic> post = await fetchPostHTTP()
        .then((response) => jsonDecode(response.body))
        .catchError((error) => {});

    return post;
  } catch (e) {
    return {
      "message": "Failed to fetch post",
    };
  }
}
