import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

import './home_page.dart';
import './matrix_filter.dart';
import './globals.dart' as globals;

class CameraScreen extends StatefulWidget {
  CameraScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    initializeCamera(selectedCamera); //Initially selectedCamera = 0
    super.initState();
    _player = VideoPlayerController.asset("assets/Icon2.mp4")
      ..initialize().then((_) {
        _player.play();
        _player.setLooping(true);
        setState(() {});
      });
  }

  late VideoPlayerController _player;
  late CameraController _controller; //To control the camera
  late Future<void>
      _initializeControllerFuture; //Future to wait until camera initializes
  int selectedCamera = 0;
  List<File> capturedImages = [];

  initializeCamera(int cameraIndex) async {
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      globals.globalCameraList[cameraIndex],
      // Define the resolution to use.
      ResolutionPreset.ultraHigh,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  Future<File> loadFile() async {
    //FOR TESTING PURPOSES
    String filePath = "assets/giant.png";
    final byteData = await rootBundle.load(filePath);
    List pieces = filePath.split('/');
    final file = File('${(await getTemporaryDirectory()).path}/' + pieces.last);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));

        return Future.value(true);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            child: Stack(children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // If the Future is complete, display the preview.
                        return Container(
                            height: MediaQuery.of(context).size.height - 148,
                            child: CameraPreview(_controller));
                      } else {
                        // Otherwise, display a loading indicator.
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await _initializeControllerFuture;
                            XFile xFile = await _controller.takePicture();
                            final xFileToFile = File(xFile.path);
                            setState(() {
                              //FOR TESTING PURPOSES
                              //loadFile().then((file) => Navigator.push(
                              //context,
                              //MaterialPageRoute(
                              //builder: (context) =>
                              // MatrixFilter(file: file))));

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MatrixFilter(file: xFileToFile)));
                            });
                          },
                          child: Container(
                            child: Center(
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Color(0xFFFFC100),
                                size: 50.0,
                              ),
                            ),
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFE02B42),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFE02B42).withAlpha(100),
                                    blurRadius: 15.0,
                                    spreadRadius: 5.0,
                                    offset: Offset(
                                      0.0,
                                      3.0,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
              Positioned(
                bottom: 5,
                left: 20,
                width: 148 * 0.4,
                height: 300 * 0.4,
                child: Container(
                  child: VideoPlayer(_player),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
              ),
            ]),
          )),
    );
  }
}
