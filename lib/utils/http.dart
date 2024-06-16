import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';

// ------------------------------------------
// Verify endpoint

Future<http.Response> verifyEndpoint(
    String apiEndpoint, String password) async {
  try {
    return await http.post(
      Uri.parse('$apiEndpoint/verify'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode({'password': password}),
    );
  } on SocketException {
    return http.Response('Failed to connect to the server.', 500);
  } catch (e) {
    return http.Response('Failed to verify the endpoint.', 500);
  }
}

Future<bool> savingAPIEndpoint(String apiEndpoint, String password) async {
  try {
    if (apiEndpoint.endsWith('/')) {
      apiEndpoint = apiEndpoint.substring(0, apiEndpoint.length - 1);
    }

    http.Response response = await verifyEndpoint(apiEndpoint, password);
    bool isValid = response.statusCode == 200;

    if (isValid) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('apiEndpoint', apiEndpoint);
      prefs.setString('password', password);
    }

    return isValid;
  } catch (e) {
    return false;
  }
}

// ------------------------------------------
// Clear post

Future<http.Response> clearPostHTTP(String apiEndpoint, String password) async {
  return await http.post(
    Uri.parse('$apiEndpoint/clear'),
    headers: <String, String>{'Content-Type': 'application/json'},
    body: jsonEncode({'password': password}),
  );
}

Future<bool> clearPost() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiEndpoint = prefs.getString('apiEndpoint') ?? '';
    String password = prefs.getString('password') ?? '';

    bool cleared = await clearPostHTTP(apiEndpoint, password)
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
  String password = prefs.getString('password') ?? '';

  data['password'] = password;

  return await http.post(
    Uri.parse('$apiEndpoint/post'),
    headers: <String, String>{'Content-Type': 'application/json'},
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
  String password = prefs.getString('password') ?? '';

  return await http.post(
    Uri.parse('$apiEndpoint/fetch'),
    headers: <String, String>{'Content-Type': 'application/json'},
    body: jsonEncode({'password': password}),
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
      "message": "Failed to fetch post.",
    };
  }
}
