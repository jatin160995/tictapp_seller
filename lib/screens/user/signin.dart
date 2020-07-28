import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tictapp_seller/screens/dashboard.dart';
import 'package:tictapp_seller/utils/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SignIn extends StatefulWidget {
  String identifier;

  SignIn(this.identifier);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String usernameString = '';
  String passwordString = '';

  final signInKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'SIGN IN',
          style: TextStyle(fontWeight: FontWeight.bold, color: darkText),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(15, 30, 15, 0),
        child: Column(
          children: <Widget>[
            Center(
                child: Container(
                    height: 150,
                    width: 150,
                    child: Image.asset("assets/images/logo1.jpg"))),
            SizedBox(
              height: 15,
            ),
            Form(
              key: signInKey,
              child: Column(
                children: <Widget>[
                  Container(
                    child: TextFormField(
                      enabled: isLoading ? false : true,
                      onChanged: (text) {
                        usernameString = text;
                      },
                      cursorColor: primaryColor,
                      decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      validator: (val) {
                        if (val.length == 0) {
                          return "Email cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: new TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: TextFormField(
                      enabled: isLoading ? false : true,
                      obscureText: true,
                      onChanged: (text) {
                        passwordString = text;
                      },
                      cursorColor: primaryColor,
                      decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      validator: (val) {
                        if (val.length == 0) {
                          return "Password cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: new TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FlatButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8)),
                color: primaryColor,
                onPressed: () {
                  getToken();
                  //loginRequest();
                 
                },
                textColor: white,
                child: isLoading
                    ? CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(white),
                      )
                    : Text("SIGNIN"),
              ),
            ),
            /* SizedBox(height: 10,),
        FlatButton(
          onPressed:()
          {
            Navigator.of(context).push(
                CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => ForgotPassword()
                )
            );
          },
          child: Text("Forgot Password"),
        ),*/
          ],
        ),
      ),
    );
  }

  bool isLoading = false;

  Future<void> getToken() async {
    try {


      if(usernameString == "" || passwordString == "")
      {
        showToast("Please fill all fields");
        return;
      }
      setState(() {
        isLoading = true;
      });

      final response = await http.post(getTokenUrl, body: {"key": apiKey,"username": website_username});
      //response.add(utf8.encode(json.encode(itemInfo)));

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        
         print(responseJson);
          var preferences = await SharedPreferences.getInstance();
          preferences.setString(api_token, responseJson["api_token"]);
          signIn() ;
          
       
      } else {
        final responseJson = json.decode(response.body);
        showToast("Something went wrong");
        print(responseJson);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> signIn() async {
    try {
      setState(() {
        isLoading = true;
      });
      var preferences = await SharedPreferences.getInstance();
      // preferences.setString(api_token, responseJson["api_token"]);
      final response = await http.post(
          login + "&api_token=" + preferences.getString(api_token),
          body: {"email": usernameString, "password": passwordString});
      //response.add(utf8.encode(json.encode(itemInfo)));
    
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        print(responseJson);
        if (responseJson['status']) {
          
          saveData(responseJson);

          print(responseJson);
        } else {
          setState(() {
            isLoading = false;
          });
          showToast("Something went wrong");
        }
      } else {
        final responseJson = json.decode(response.body);
        showToast("Something went wrong");
        print(responseJson);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  void splashTimer() async
  {
    print('start');
    Future.delayed(Duration(seconds: 5) ,() {
       /*Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(),
        ));*/
        Navigator.of(context).pushReplacement(
                      CupertinoPageRoute(builder: (context) => Dashboard()));
        
    });
  }

  void saveData(dynamic data) async {
    try {
      var preferences = await SharedPreferences.getInstance();
      
      print(data);
      print(data['data']['firstname']);
      //return;
      // preferences.setInt(store_id, data['store_id']);
      preferences.setString(username, usernameString);
      preferences.setString(password, passwordString);
      preferences.setBool(is_logged_in, true);
      preferences.setString(token, data['token'].toString());
      preferences.setInt(id, int.parse(data['data']['customer_id']));
      preferences.setString(firstname, data['data']['firstname']);
      preferences.setString(lastname, data['data']['lastname']);
      preferences.setString(savedEmail, data['data']['email']);
      preferences.setString(savedtelephone, data['data']["telephone"]);
      //double totalEarning = double.parse(data['data']["earnings"]['commission_amount']);// + double.parse(data['data']["earnings"]['order_amount']);
      //preferences.setString(earnings, totalEarning.toString());
      
      //preferences.commit();
      splashTimer();

      
    } catch (e) {
      print(e);
      showToast("Wrong username or password");
    }
    
    // loginRequest();

    //print(preferences.getString(user_token));
    // var savedValue = preferences.getString('value_key');
  }
}
