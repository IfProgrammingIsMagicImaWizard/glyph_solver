import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:screenshot/screenshot.dart';
import 'package:on_image_matrix/on_image_matrix.dart';

import './brigde.dart';

class MatrixFilter extends StatefulWidget {
  final File file;
  MatrixFilter({Key? key, required this.file}) : super(key: key);

  @override
  _MatrixFilterState createState() => _MatrixFilterState();
}

class _MatrixFilterState extends State<MatrixFilter> {
  ScreenshotController screenshotController = ScreenshotController();
  final andromedaMatrix = [
    1.0,
    1.0,
    -3.0,
    0.0,
    0.0,
    -3.0,
    -3.0,
    -3.0,
    -3.0,
    3.0,
    -3.0,
    -3.0,
    -3.0,
    -3.0,
    3.0,
    3.0,
    3.0,
    3.0,
    3.0,
    3.0
  ];

  @override
  Widget build(BuildContext context) {
    //Image myImage = Image.memory(widget.file.readAsBytesSync());
    Image fileAsImage = Image.file(
      widget.file,
      fit: BoxFit.cover,
    );

    OnImageMatrixWidget wid = OnImageMatrixWidget(
      child: fileAsImage,
      colorFilter: OnImageMatrix.custom(andromedaMatrix),
    );

    Screenshot ssWid = Screenshot(
      controller: screenshotController,
      child: wid,
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GestureDetector(
            onTap: () async {
              screenshotController.capture().then((Uint8List? image) {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Brigde(uint8List: (image!))));
                });
              }).catchError((onError) {
                print(onError);
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Container(
                  width: 416,
                  height: 416,
                  child: ssWid,
                ),
                Spacer(),
                Container(
                    padding: const EdgeInsets.only(bottom: 37),
                    child: Container(
                      child: Center(
                        child: Text(
                          "Go",
                          style:
                              TextStyle(color: Color(0xFFFFC100), fontSize: 25),
                        ),
                      ),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFe02b42),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF23aaf2).withAlpha(100),
                              blurRadius: 15.0,
                              spreadRadius: 5.0,
                              offset: Offset(
                                0.0,
                                3.0,
                              ),
                            ),
                          ]),
                    ))
              ],
            ),
          ),
        ));
  }
}
