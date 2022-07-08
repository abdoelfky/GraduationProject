import 'package:arduino_app/modules/on_boarding/on_boarding_screen.dart';

import 'modules/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'shared/cash_helper.dart';
import 'shared/constants.dart';
import 'modules/homePage.dart';


void main() async{
  Widget widget;
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Firebase.initializeApp();
  uId = CacheHelper.getData(key: 'uId');
  bool onBoarding = CacheHelper.getData(key: 'onBoarding');

  if (onBoarding != null) {
    if (uId != null) {
      print(uId);
      widget = HomePage();
    } else {
      widget = Login();
    }
  } else {
    widget = On_boarding_Screen();
  }
  runApp(MyApp(startWidget: widget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  MyApp({this.startWidget});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: startWidget,
    );
  }
}

