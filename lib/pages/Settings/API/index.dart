import 'package:dislife/utils/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';

import '../../../utils/const.dart';

class SettingsAPI extends StatefulWidget {
  const SettingsAPI({super.key});

  @override
  State<SettingsAPI> createState() => _SettingsAPIState();
}

class _SettingsAPIState extends State<SettingsAPI> {
  TextEditingController apiEndpointController = TextEditingController(),
      passwordController = TextEditingController();

  bool passwordVisible = false,
      apiEndpointInvalid = false,
      passwordInvalid = false;

  bool isLoading = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiEndpointController.text = prefs.getString('apiEndpoint') ?? '';
    passwordController.text = prefs.getString('password') ?? '';
    passwordVisible = false;
  }

  void togglePasswordVisibility() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  void onSubmit() {
    String apiEndpoint = apiEndpointController.text;
    String password = passwordController.text;

    setState(() {
      apiEndpointInvalid =
          apiEndpoint.isEmpty || !Uri.parse(apiEndpoint).isAbsolute;
    });

    if (apiEndpoint.isEmpty || !Uri.parse(apiEndpoint).isAbsolute) return;

    setState(() {
      passwordInvalid = password.isEmpty;
    });

    if (password.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    savingAPIEndpoint(apiEndpoint, password).then((isValid) {
      setState(() {
        isLoading = false;
      });

      if (isValid) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "API Endpoint saved successfully!",
              style: TextStyle(color: lightColor),
            ),
            backgroundColor: Colors.green));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                "Cannot connect to the API Endpoint.",
                style: TextStyle(color: lightColor),
              ),
              backgroundColor: Colors.red),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        titleSpacing: 0,
        title: Text('API Endpoint',
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color)),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                TextFormField(
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'API Endpoint',
                    prefixIcon: const Icon(Icons.link),
                    errorText:
                        apiEndpointInvalid ? 'Invalid API Endpoint' : null,
                  ),
                  controller: apiEndpointController,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  obscureText: !passwordVisible,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.key),
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        togglePasswordVisibility();
                      },
                    ),
                    errorText:
                        passwordInvalid ? 'Password cannot be empty' : null,
                  ),
                  controller: passwordController,
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Platform.isIOS
                      ? CupertinoButton(
                          color: discordColor,
                          onPressed: isLoading ? null : () => onSubmit(),
                          child: const Text(
                            'Save',
                            style: TextStyle(color: lightColor),
                          ))
                      : TextButton(
                          onPressed: isLoading ? null : () => onSubmit(),
                          style: ButtonStyle(
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                          child: !isLoading
                              ? const Text('Save',
                                  style: TextStyle(
                                      fontSize: 20, color: lightColor))
                              : const CircularProgressIndicator(
                                  color: lightColor,
                                ),
                        ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
