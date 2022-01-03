import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:path_provider/path_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import './result_page.dart';
import './globals.dart' as globals;

class Gallery extends StatefulWidget {
  final String planetName;
  const Gallery({Key? key, this.planetName = ""}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  BoxDecoration pageDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFfac319), Color(0xFFf0d170)],
      stops: [0.1, 1],
    ),
  );

  Future<List<String>> getFilesPath(String folder) {
    return DefaultAssetBundle.of(context).loadString('AssetManifest.json').then(
        (assetManifest) => (json.decode(assetManifest).keys.where(
                (String key) => key.startsWith('assets/' + folder + '/')))
            .toList());
  }

  Future<File> loadFile(String path) async {
    final byteData = await rootBundle.load(path);
    final file =
        File('${(await getTemporaryDirectory()).path}/' + path.split('/').last);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  List<File> generateFileList(List paths) {
    List<File> output = [];
    for (var path in paths) {
      loadFile(path).then((file) => output.add(file));
    }
    return output;
  }

  List<String> filterList(List<String> filesPath) {
    List<String> output = [];
    for (String i in filesPath) {
      if (i.contains(widget.planetName)) {
        output.add(i);
      }
    }
    return output;
  }

  List<int> generateItems(int length) {
    List<int> output = [];
    length = length - 1;
    while (length != -1) {
      output.add(length);
      length = length - 1;
    }
    output.sort();
    return output;
  }

  Container generateContainer(String filePath) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          child: Image.asset(
            filePath,
            fit: BoxFit.contain,
          ),
          onTap: () {
            //generate Link
            if (filePath.contains('planets')) {
              String fileName = filePath.split('/').last;
              String planetName = fileName.split('.').elementAt(1);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Gallery(
                          planetName: planetName,
                        )),
              );
            } else {
              String fileName = filePath.split('/').last;
              String resultName = fileName.split('.').elementAt(0);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ResultPage(fileName: resultName)),
              );
            }
          },
        ));
  }

  CarouselSlider generateSlider(List<String> filesPath) {
    return CarouselSlider(
      options: CarouselOptions(
        //height: 400,
        height: MediaQuery.of(context).size.height,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
      ),
      items: generateItems(filesPath.length).map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: generateContainer(filesPath.elementAt(i)),
            );
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.planetName == '') {
      return FutureBuilder(
          future: getFilesPath('planets'),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return snapshot.hasData
                ? Container(
                    decoration: pageDecoration,
                    child: generateSlider(snapshot.data))
                : CupertinoActivityIndicator(radius: 50);
          });
    } else {
      return FutureBuilder(
          future: getFilesPath('results'),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return snapshot.hasData
                ? Container(
                    decoration: pageDecoration,
                    child: generateSlider(filterList(snapshot.data)))
                : globals.loading;
          });
    }
  }
}
