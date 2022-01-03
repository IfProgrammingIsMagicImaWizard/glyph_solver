import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

import 'package:path_provider/path_provider.dart';

import './run_model.dart';
import './globals.dart' as globals;

class Brigde extends StatefulWidget {
  final Uint8List uint8List;
  Brigde({Key? key, required this.uint8List}) : super(key: key);

  @override
  State<Brigde> createState() => _BrigdeState();
}

class _BrigdeState extends State<Brigde> {
  Future<String> getFilePath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/image.png';

    return filePath;
  }

  Future<File> saveFile() async {
    File file = File(await getFilePath());
    file.writeAsBytesSync(widget.uint8List);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    //FOR TESTING PURPOSES use
    //Image.file(snapshot.data) over RunModel(file: snapshot.data)
    return FutureBuilder(
        future: saveFile(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? RunModel(
                  file: snapshot.data,
                  isfromCamera: true,
                )
              : globals.loading;
        });
  }
}
