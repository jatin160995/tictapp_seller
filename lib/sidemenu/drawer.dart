import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tictapp_seller/screens/earnings.dart';
import 'package:tictapp_seller/screens/order_history.dart';
import 'package:tictapp_seller/screens/user/signin.dart';
import 'package:tictapp_seller/utils/common.dart';

class DrawerMenu extends StatefulWidget {
  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {

  String nameString = "";
  String emailString = "";
  String phoneString = "";
  String earningsString = "";

  getDriveInfo() async
  {
    var preferences = await SharedPreferences.getInstance();
    setState(() {
      nameString = preferences.getString(firstname)+" "+ preferences.getString(lastname);
      emailString = preferences.getString(savedEmail);
      phoneString = preferences.getString(savedtelephone);
      earningsString = preferences.getString(earnings);
    });
  }

  @override
  void initState() {
    getDriveInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      
      child: Container(
        color: drawerColor,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
                  child: ListView(
            children: <Widget>[
              SizedBox(height: 20,),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //SizedBox(width: 10,),
                  Expanded(
                    flex: 3,
                    child: Icon(Icons.account_circle, size: 40, color: white,)),
                 // SizedBox(width: 10,),
                  Expanded(
                    flex:6,
                                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(nameString,
                         style: TextStyle(
                           color: white,
                           fontSize: 18,
                           fontWeight: FontWeight.bold

                         ),),
                         SizedBox(height: 3,),
                         Text(emailString,
                         style: TextStyle(
                           color: lightGrey,
                           fontSize: 13
                         ),),
                         SizedBox(height: 3,),
                         Text(phoneString,
                         style: TextStyle(
                           color: lightGrey,
                           fontSize: 13
                         ),),
                        /* SizedBox(height: 3,),
                         Text("Earnings: "+inr+earningsString,
                         style: TextStyle(
                           color: tealColor,
                           fontSize: 13
                         ),),*/

                         
                      ],
                    ),
                  ),
                  /*isLoading ? Container(
                    margin: EdgeInsets.only(right: 10),
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(white),
                        ),
                  ) :Expanded(
                    flex: 2,
                                      child: IconButton(
                      onPressed: ()
                      {
                        getToken();
                      },
                      icon: Icon(Icons.refresh, color: white),
                    ),
                  )*/
                ],
                
              ),
              SizedBox(height: 15,),
              Divider(color: lightText),
               ListTile(
                
                leading: Icon(Icons.list, size: 20, color: tealColor),
                title: Text('Order History',
                  style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),),
                onTap: () => {
                  Navigator.of(context).pop(),
                     Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderHistory(),
            ))
                },
              ),
               //SizedBox(height: 15,),
             /* Divider(color: lightText),
               ListTile(
                
                leading: Icon(Icons.monetization_on, size: 20, color: tealColor),
                title: Text('Earnings',
                  style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),),
                onTap: () => {
                  Navigator.of(context).pop(),
                     Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Earnings(),
            ))
                },
              ),
              Divider(color: lightText),
              ListTile(
                
                leading: Icon(Icons.list, size: 20, color: white),
                title: Text('Location',
                  style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),),
                onTap: () => {
                  Navigator.of(context).pop(),
                     Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyLocation(), 
            ))
                },
              ),*/
              Divider(color: lightText),
               ListTile(
                
                leading: Icon(Icons.exit_to_app, size: 20, color: tealColor),
                title: Text('Logout',
                  style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),),
                onTap: () => {
                  logoutDialog()
                   
                },
              ),
              Divider(color: lightText),
              
            ],
          ),
        ),
      ),
    );
  }


 void logoutDialog() {
   // Navigator.pop(context);
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Logout!"),
          content: new Text("Are you sure, you want to logout?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes",
              style: TextStyle(
                color: darkText
              ),),
              onPressed: () {

                Navigator.of(context).pop();
                logout();
              },
            ),
            new FlatButton(
              child: new Text("Cancel",
                style: TextStyle(
                    color: primaryColor
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

          ],
        );
      },
    );
  }


  void logout() async
  {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString(username, '');
    preferences.setString(password, '');
    preferences.setInt(id, 0);
    preferences.setString(firstname, '');
    preferences.setString(savedEmail, '');
    preferences.setString(lastname, '');
    preferences.setBool(is_logged_in, false);
     Navigator.pushAndRemoveUntil(context, 
            MaterialPageRoute(
              builder: (context) => SignIn("finish"),
            ), (route) => false);
    //Navigator.of(context).pushNamedAndRemoveUntil('/signin', (Route<dynamic> route) => false);
  }







  bool isLoading = false;

  Future<void> getToken() async {
    try {


     
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
          body: {"email": preferences.getString(username), "password": preferences.getString(password)});
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

  

  void saveData(dynamic data) async {
    try {
      var preferences = await SharedPreferences.getInstance();

      print(data);
      print(data['data']['firstname']);
      //return;
      // preferences.setInt(store_id, data['store_id']);
     
      double totalEarning = double.parse(data['data']["earnings"]['commission_amount']) ;//+ double.parse(data['data']["earnings"]['order_amount']);
      preferences.setString(earnings, totalEarning.toString());
      
      getDriveInfo();
      setState(() {
        isLoading = false;
      });
      //preferences.commit();
     // splashTimer();

      
    } catch (e) {
      print(e);
      showToast("Wrong username or password");
    }

    // loginRequest();

    //print(preferences.getString(user_token));
    // var savedValue = preferences.getString('value_key');
  }

}