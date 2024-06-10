import 'package:camera/camera.dart';
import 'package:dislife/pages/Create/index.dart';
import 'package:dislife/utils/const.dart';
import 'package:dislife/utils/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShotNewPost extends StatefulWidget {
  final List<CameraDescription> cameras;
  final void Function(int) changePage;

  const ShotNewPost(
      {super.key, required this.changePage, required this.cameras});

  @override
  State<ShotNewPost> createState() => _ShotNewPostState();
}

class _ShotNewPostState extends State<ShotNewPost> {
  CameraController cameraController = CameraController(
    const CameraDescription(
      name: '0',
      lensDirection: CameraLensDirection.front,
      sensorOrientation: 0,
    ),
    ResolutionPreset.max,
    enableAudio: false,
  );
  bool takingPicture = false, choosingImage = false, isPortrait = true;

  Future<dynamic> chooseImage() async {
    try {
      final XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return null;

      final bytes = await pickedFile.readAsBytes();

      return bytes;
    } on PlatformException catch (_) {
      return null;
    }
  }

  Future<Uint8List?> takeImage() async {
    try {
      final XFile pickedFile = await cameraController.takePicture();
      cameraController.pausePreview();
      setState(() {
        takingPicture = true;
      });

      final bytes = await pickedFile.readAsBytes();

      return bytes;
    } on PlatformException catch (_) {
      return null;
    }
  }

  @override
  void initState() {
    loadData();
    startCamera();
    super.initState();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final apiEndpoint = prefs.getString('apiEndpoint') ?? '';
    final password = prefs.getString('password') ?? '';

    verifyEndpoint(apiEndpoint, password).then((res) {
      if (res.statusCode != 200 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 5),
            content: Text(
              'Could not connect to the API. Please check your API endpoint and password.',
              style: TextStyle(color: lightColor),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    });
  }

  void startCamera() async {
    cameraController = CameraController(
      widget.cameras[0],
      ResolutionPreset.max,
      enableAudio: false,
    );

    cameraController.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        isPortrait = cameraController.value.deviceOrientation
            .toString()
            .contains("portrait");
      });
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width > 600
        ? 600
        : MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Row(
          children: [
            SvgPicture.asset(
              "assets/images/icons/flower.svg",
              colorFilter: Theme.of(context).brightness == Brightness.light
                  ? const ColorFilter.mode(discordColor, BlendMode.srcIn)
                  : const ColorFilter.mode(lightColor, BlendMode.srcIn),
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 5),
            Text(
              'DisLife',
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? discordColor
                      : lightColor,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: cameraController.value.isInitialized || widget.cameras.isEmpty
          ? SingleChildScrollView(
              child: Container(
                alignment: Alignment.topCenter,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      widget.cameras.isNotEmpty
                          ? SizedBox(
                              width: width - 30,
                              height: width - 30,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18.0),
                                child: OverflowBox(
                                  maxWidth: double.infinity,
                                  maxHeight: double.infinity,
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                      width: isPortrait
                                          ? (width - 30) /
                                              cameraController.value.aspectRatio
                                          : width - 30,
                                      height: isPortrait
                                          ? width - 30
                                          : (width - 30) /
                                              cameraController
                                                  .value.aspectRatio,
                                      child: CameraPreview(cameraController),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: discordColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              width: width - 30,
                              height: width - 30,
                              child: Center(
                                child: Text(
                                  'No camera available',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: RawMaterialButton(
                              onPressed: () {
                                setState(() {
                                  choosingImage = true;
                                });
                                chooseImage().then(
                                  (image) {
                                    setState(() {
                                      choosingImage = false;
                                    });
                                    if (image == null) {
                                      return;
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return CreateNewPost(
                                            image: image,
                                            changePage: widget.changePage,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              padding: const EdgeInsets.all(15.0),
                              shape: const CircleBorder(),
                              child: !choosingImage
                                  ? Icon(
                                      Icons.image,
                                      size: 40.0,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color,
                                    )
                                  : Center(
                                      child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .color ??
                                                      discordColor),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          cameraController.value.isInitialized
                              ? Expanded(
                                  flex: 1,
                                  child: RawMaterialButton(
                                    onPressed: () {
                                      takeImage().then(
                                        (image) {
                                          setState(() {
                                            takingPicture = false;
                                          });
                                          cameraController.resumePreview();
                                          if (image == null) {
                                            return ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                duration: Duration(seconds: 5),
                                                content: Text(
                                                  'Could not take picture. Please try again.',
                                                  style: TextStyle(
                                                      color: lightColor),
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return CreateNewPost(
                                                  image: image,
                                                  changePage: widget.changePage,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    padding: const EdgeInsets.all(15.0),
                                    shape: const CircleBorder(),
                                    fillColor: discordColor,
                                    child: !takingPicture
                                        ? const Icon(
                                            Icons.camera,
                                            size: 50.0,
                                            color: Colors.white,
                                          )
                                        : const Center(
                                            child: SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                            ),
                                          ),
                                  ))
                              : const SizedBox(),
                          cameraController.value.isInitialized
                              ? const Expanded(
                                  flex: 1,
                                  child: SizedBox(),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
