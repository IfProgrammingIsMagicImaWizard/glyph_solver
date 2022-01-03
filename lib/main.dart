import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';

import './home_page.dart';
import './globals.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  final camerasList = await availableCameras();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      EasyLocalization(
          supportedLocales: [
            Locale('ar'),
            Locale('bn'),
            Locale('de'),
            Locale('en'),
            Locale('es'),
            Locale('fr'),
            Locale('hi'),
            Locale('id'),
            Locale('it'),
            Locale('ja'),
            Locale('ko'),
            Locale('mr'),
            Locale('pa'),
            Locale('pl'),
            Locale('pt'),
            Locale('ru'),
            Locale('sw'),
            Locale('ta'),
            Locale('te'),
            Locale('th'),
            Locale('tr'),
            Locale('uk'),
            Locale('ur'),
            Locale('vi'),
            Locale('zh'),
          ],
          path:
              'assets/translations', // <-- change the path of the translation files
          fallbackLocale: Locale('en'),
          child: MyApp(
            cameras: camerasList,
          )),
    );
  });
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({Key? key, required this.cameras}) : super(key: key);

  void initiateGlobals() {
    globals.globalCameraList = cameras;
    globals.loading = CupertinoActivityIndicator(radius: 50);
  }

  @override
  Widget build(BuildContext context) {
    initiateGlobals();
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Mass Glyph Solver',
      home: HomePage(),
    );
  }
}
