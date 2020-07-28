import 'package:flutter/material.dart';
import 'package:tictapp_seller/utils/common.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
       // iconTheme: IconThemeData(color: darkText),
        title: Text(
          "Profile",
          //style: TextStyle(color: darkText),
        ),
        //backgroundColor: white,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          
        ],
      ),
      
    );
  }
}