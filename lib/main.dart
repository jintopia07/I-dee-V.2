import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:idee_flutter/maps/blocs/application_bloc.dart';
import 'package:idee_flutter/screen/complaint_factory.dart';
import 'package:idee_flutter/screen/home_page.dart';
import 'package:idee_flutter/screen/launcher.dart';
import 'package:provider/provider.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Applicationbloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: "Kanit",
            brightness: Brightness.light,
            primaryColor: Colors.deepPurple[400],
            accentColor: Colors.cyan[600]),

        initialRoute: '/', // สามารถใช้ home แทนได้
        routes: <String, WidgetBuilder>{
          Launcher.routeName: (context) => Launcher(),
          '/home': (BuildContext context) => new Home(),
          '/factory': (BuildContext context) => new ComplaintFactory(),
        },
        builder: EasyLoading.init(),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
