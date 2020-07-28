
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictapp_seller/screens/dashboard.dart';
import 'package:tictapp_seller/screens/user/signin.dart';
import 'package:tictapp_seller/utils/common.dart';

class SplashScreen extends StatefulWidget {


  @override
  _SplashScreenState createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {

  void splashTimer() async
  {
    print('start');
    Future.delayed(Duration(seconds: 2) ,() {
       /*Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(),
        ));*/
        isLoggedIn();
        print('end');
    });
  }

  clearPref() async {
    var preferences = await SharedPreferences.getInstance();
    preferences.clear();
    
  }

  @override
  void initState() {
    super.initState();
    //clearPref();
    splashTimer();
  }

   isLoggedIn() async
{
  var preferences = await SharedPreferences.getInstance();
  try
  {
    if(preferences.getBool(is_logged_in ?? false) )
    {
      Navigator.of(context).pushReplacement(
                      CupertinoPageRoute(builder: (context) => Dashboard()));
    }
    else
    {
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => SignIn("finish") ));
    }
  }
  catch(e)
  {
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => SignIn("finish") ));
  }
}

  @override
  Widget build(BuildContext context) {
    print('hello');
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(90.0),
          child: Image(
            image: AssetImage('assets/images/logo2.jpg'),
          ),
        ),
      ),
    );
  }


}