import 'package:flutter/material.dart';

import 'package:rate_my_app/rate_my_app.dart';
import 'package:easy_localization/easy_localization.dart';

import './gallery.dart';
import './help_button.dart';
import './camera_screen.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cor = Color(0xFFFFC100);
  final RateMyApp rateMyApp = RateMyApp(
    googlePlayIdentifier: "",
    preferencesPrefix: 'rateMyApp_',
    minDays: 0, // Show rate popup on first day of install.
    minLaunches:
        5, // Show rate popup after 5 launches of app after minDays is passed.
  );
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await rateMyApp.init();
      if (mounted && rateMyApp.shouldOpenDialog) {
        rateMyApp.showRateDialog(
          context,
          title: "Message3".tr(),
          message: "Message4".tr(),
          rateButton: "Opt1".tr(),
          noButton: "Opt2".tr(),
          laterButton: "",
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cor,
      child: Container(
          margin: EdgeInsets.only(left: 50, right: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 45),
              Image.asset(
                'assets/home/AppTitle White.png',
                width: MediaQuery.of(context).size.width - 130,
              ),
              SizedBox(height: 80),
              GestureDetector(
                  child: Image.asset('assets/home/GalleryButton.png'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Gallery()),
                    );
                  }),
              SizedBox(height: 70),
              GestureDetector(
                child: Image.asset('assets/home/ImageRocognitionButton.png'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraScreen()),
                  );
                },
              ),
              HelpButton(),
            ],
          )),
    );
  }
}
