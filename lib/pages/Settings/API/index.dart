import 'package:dislife/utils/const.dart';
import 'package:dislife/utils/http.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsAPI extends StatefulWidget {
  const SettingsAPI({super.key});

  @override
  State<SettingsAPI> createState() => _SettingsAPIState();
}

class _SettingsAPIState extends State<SettingsAPI> {
  TextEditingController apiEndpointController = TextEditingController();
  TextEditingController apiKeyController = TextEditingController();
  bool passwordVisible = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiEndpointController.text = prefs.getString('apiEndpoint') ?? '';
    apiKeyController.text = prefs.getString('apiKey') ?? '';
    passwordVisible = false;
  }

  void togglePasswordVisibility() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: discordColor,
          title: const Text('Settings', style: TextStyle(color: Colors.white)),
        ),
        body: Container(
          margin: const EdgeInsets.all(15),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'API Endpoint',
                  prefixIcon: Icon(Icons.link),
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
                  labelText: 'API Key',
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      togglePasswordVisibility();
                    },
                  ),
                ),
                controller: apiKeyController,
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  onPressed: () {
                    String apiEndpoint = apiEndpointController.text;
                    String apiKey = apiKeyController.text;
                    savingAPIEndpoint(apiEndpoint, apiKey).then((isValid) {
                      if (isValid) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Text(
                                  "API Endpoint saved successfully!",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.green));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Text(
                                  "Cannot connect to the API Endpoint.",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.red));
                      }
                    });
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(discordColor),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                  child: const Text('Save',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            ],
          )),
        ));
  }
}
