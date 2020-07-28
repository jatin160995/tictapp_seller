import 'package:flutter/material.dart';
import 'package:tictapp_seller/screens/splash_screen.dart';
import 'package:tictapp_seller/screens/user/signin.dart';
import 'package:tictapp_seller/utils/common.dart';

void main() {
  runApp(MaterialApp(
    routes: {
    '/': (context) => SplashScreen(),
    '/signin': (context) => SignIn("finish"),
    },
    theme: ThemeData(fontFamily: 'proxima',
  primaryColor: primaryColor,accentColor: primaryColor),
  ));
}



