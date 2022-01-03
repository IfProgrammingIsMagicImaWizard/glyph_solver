import 'package:flutter/material.dart';

import './help_page.dart';

class HelpButton extends StatelessWidget {
  final cor = Color(0xFFFFC100);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 40),
        child: Material(
          color: cor,
          child: Center(
            child: Ink(
              decoration: const ShapeDecoration(
                color: Color(0xFF189ea0),
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: Icon(Icons.menu_book_rounded),
                color: Colors.white,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return HelpPage();
                    },
                  );
                },
              ),
            ),
          ),
        ));
  }
}
