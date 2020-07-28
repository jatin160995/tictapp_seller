import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


var primaryColor = Colors.blue[700]; //Color(0xFF222222);
//const primaryColor = Color(0xFF3aaa35);
const white = Color(0xffffffff);
const background = Color(0xFFf8f8f8);
//const accent = Color(0xFFED3134);
const darkText = Color(0xFF222222);
const lightText = Color(0xFF454545);
const lightestText = Color(0xFF656565);
const transparent = Color(0x005391cf);
const transparentBlack = Color(0xa0000000);
const transparentBackground = Color(0x20000000);
const lightGrey = Color(0xa0d8d8d8);
const iconColor = Color(0xa0888888);
const transparentREd = Color(0x70df0000);
const backgroundGrey = Color(0xFF90a4ae);
const statusBarColor = Color(0xffd8d8d8);
const greenButton = Color(0xff3aaa35);
const orange = Color(0xfffa7e37);
const blueColor = Colors.blue;
var tealColor = Colors.teal[300];
const drawerColor = Color(0xff051e34);


const apiKey = "5JuJS3YZP3NOtHaRMQp3RO15Uqnkn5KJshPYsYEA4nu4PxJmQoVV4uhqtviS0kHH8WeXOqNWc3ZGKqTBrLsf7hOFlG40SW1DIKJTOo6sFOtwEqWHhwxBVAIaelJ0NK4ipIXVXIlWhnyf6fuwD2noYLCFUSTZT5Pvxu0oJ4ze2X2dsGjWkb5J742SR7XInr0DKM8Z4ZluqJhlGAbeOpcusDGqLf2J3FNhgwmWFtkFAcEqJXasD7OSrqXhXhORurnp";
const url_string = "http://wetesting.in/tictapp/";
const contentType = 'application/json';
const website_username = "tictapp";

const getTokenUrl = url_string + "index.php?route=api/login";
const driverOrders = url_string + "index.php?route=api/seller/order";
const login = url_string + "index.php?route=api/seller/login";
const finishOrderUrl = url_string + "index.php?route=api/driver/order/addHistory";
const orderDetailUrl = url_string + "index.php?route=api/seller/order/get";
const orderEditUrl = url_string + "index.php?route=api/seller/order/update";
const acceptOrderUrl = url_string + "index.php?route=api/driver/order/acceptOrDeclineOrder";
const acceptingOrderUrl = url_string + "index.php?route=api/driver/order/acceptingOrders";
const searchUrl = url_string + "index.php?route=api/myproducts/search";
const earningUrl =  url_string + "index.php?route=api/driver/order/earnings";



List<dynamic> orderDoneItem;
List<dynamic> orderDeleteItem;

String api_token = 'api_token';
String token = 'token';
String is_logged_in = 'is_logged_in';
String username = 'username';
String password = 'password';
String savedEmail = 'savedEmail';
String firstname = 'firstname';
String lastname = 'lastname';
String savedtelephone = "savedtelephone";
String id = 'id';
String earnings = 'earnings';


String inr = "\$";


void showToast(String message)
{
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: darkText,
      textColor: Colors.white,
      fontSize: 16.0
  );
}