import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          height: 200,
          child: Column(//mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Text(
              "Gallery Mode",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Text("Message1".tr()),
            Spacer(),
            Text(
              "Image Recognition Mode",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Text("Message2".tr()),
          ])),
      actions: [
        TextButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
