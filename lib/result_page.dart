import 'package:flutter/material.dart';

import './camera_screen.dart';

class ResultPage extends StatefulWidget {
  final String fileName;
  final bool isfromCamera;
  ResultPage({Key? key, required this.fileName, this.isfromCamera = false})
      : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Color cor1 = Color(0xFF1da5bb);
  Color cor2 = Color(0xFF8ace83);

  BoxDecoration generateBoxDecoration() {
    return BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/results/' + widget.fileName + '.png'),
          fit: BoxFit.fitWidth,
        ),
        border: Border.all(
          color: Colors.black.withOpacity(0),
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFFFFF).withAlpha(100),
            blurRadius: 15.0,
            spreadRadius: 5.0,
            offset: Offset(
              0.0,
              3.0,
            ),
          ),
        ]);
  }

  Container generateResult() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      decoration: generateBoxDecoration(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.isfromCamera) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CameraScreen()));
        }
        return Future.value(true);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [cor1, cor2],
            stops: [0.1, 1],
          ),
        ),
        child: generateResult(),
      ),
    );
  }
}
