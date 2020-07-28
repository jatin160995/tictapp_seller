import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictapp_seller/sidemenu/drawer.dart';
import 'package:tictapp_seller/utils/common.dart';
import 'package:http/http.dart' as http;
import 'package:tictapp_seller/widgets/order_list_cell.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isSwitched = true;
  @override
  void initState() {
    //splashTimer();
    getOrders();
    //getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(actions: <Widget>[
        IconButton(
          icon: Icon(Icons.replay),
          onPressed: () {
            getOrders();
          },
        )
      ], centerTitle: true, title: Text("Dashboard")),
      body: isLoading
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child: Center(child: CircularProgressIndicator()),
            )
          : Stack(
              children: <Widget>[
                ListView(
                  children: createOrderCell(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      // margin: EdgeInsets.only(bottom: 50),
                      child: Divider(
                        height: 5,
                      )),
                ),
                /*Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: white,
                    height: 50,
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      children: <Widget>[
                        Switch(
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                              onlineOfflineStatus(isSwitched);
                              print(isSwitched);
                            });
                          },
                          activeTrackColor: lightGrey,
                          activeColor: Colors.green,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          isSwitched ? "You are Online" : "You are Offline",
                          style: TextStyle(
                              color: darkText,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                )*/
              ],
            ),
    );
  }

  Future<void> onlineOfflineStatus(bool isOnline) async {
    setState(() {
      isLoading = true;
    });
    var preferences = await SharedPreferences.getInstance();
    try {
      //print(widget.catInfo['category_id']);
      String tokenString = preferences.getString(token).toString();
      Map mapToSend = {
        "token": tokenString,
        "accepting_orders": isOnline ? "1" : "0"
      };
      final response = await http.post(acceptingOrderUrl, body: mapToSend);
      final responseJson = json.decode(response.body);
      print(responseJson);
      if (response.statusCode == 200) {
        if (responseJson['status']) {
          getOrders();
        } else {
          setState(() {
            isLoading = false;
          });
          //showToast("Something went wrong");
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      //showToast('Something went wrong');
    }
  }

  Future<void> acceptOrder(String orderID) async {
    setState(() {
      isLoading = true;
    });
    var preferences = await SharedPreferences.getInstance();
    try {
      //print(widget.catInfo['category_id']);
      String tokenString = preferences.getString(token).toString();
      Map mapToSend = {
        "order_id": orderID,
        "token": tokenString,
        "status": "1"
      };
      final response = await http.post(acceptOrderUrl, body: mapToSend);
      final responseJson = json.decode(response.body);
      print(responseJson);
      if (response.statusCode == 200) {
        if (responseJson['status']) {
          getOrders();
        } else {
          setState(() {
            isLoading = false;
          });
          //showToast("Something went wrong");
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      //showToast('Something went wrong');
    }
  }

  Future<void> declineOrder(String orderID) async {
    setState(() {
      isLoading = true;
    });
    var preferences = await SharedPreferences.getInstance();
    try {
      //print(widget.catInfo['category_id']);
      String tokenString = preferences.getString(token).toString();
      Map mapToSend = {
        "order_id": orderID,
        "token": tokenString,
        "status": "0"
      };
      final response = await http.post(acceptOrderUrl, body: mapToSend);
      final responseJson = json.decode(response.body);
      print(responseJson);
      if (response.statusCode == 200) {
        if (responseJson['status']) {
          getOrders();
        } else {
          setState(() {
            isLoading = false;
          });
          //showToast("Something went wrong");
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      //showToast('Something went wrong');
    }
  }

  List<Widget> createOrderCell() {
    List<Widget> orderCellList = new List();
    for (int i = 0; i < orderList.length; i++) {
      if (orderList[i]['order_status'] == "Pending")
        orderCellList.add(OrderListCell(orderList[i], true, () {
          acceptOrder(orderList[i]['order_id']);
        }, () {
          declineOrder(orderList[i]['order_id']);
        }));
    }

    if (orderCellList.length == 0) {
      orderCellList.add(Container(
          margin: EdgeInsets.only(top: 50),
          child: Center(
              child: Text(
            "NO ORDERS",
            style: TextStyle(
                color: iconColor, fontSize: 18, fontWeight: FontWeight.bold),
          ))));
    }
    orderCellList.add(Container(height: 50));

    return orderCellList;
  }

  Future<void> getToken() async {
    try {
      setState(() {
        isLoading = true;
      });
      var preferences = await SharedPreferences.getInstance();
      // preferences.setString(api_token, responseJson["api_token"]);
      final response = await http.post(
          login + "&api_token=" + preferences.getString(api_token),
          body: {
            "email": preferences.getString(username),
            "password": preferences.getString(password)
          });
      //response.add(utf8.encode(json.encode(itemInfo)));

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        //print(responseJson);
        if (responseJson['status']) {
          setState(() {
            isLoading = false;
          });
          //preferences.setString(token, responseJson['token']);

          //saveData(responseJson);

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

  bool isLoading = true;
  dynamic orderList;
  dynamic orderUserObject;
  Future<void> getOrders() async {
    orderList = new List();
    setState(() {
      isLoading = true;
    });
    var preferences = await SharedPreferences.getInstance();
    try {
      print(driverOrders);

      //print(widget.catInfo['category_id']);
      String tokenString = preferences.getString(token).toString();
      print(tokenString);
      Map mapToSend = {
        "filter_driver_id": preferences.getInt(id).toString(),
        "token": tokenString
      };
      print(mapToSend);
      final response = await http.post(driverOrders, body: mapToSend);
      print(response.body.toString());
      final responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        print(responseJson.toString());
        if (responseJson['status']) {
          print(responseJson);
          orderUserObject = responseJson["data"]['user'];
          orderUserObject['accepting_orders'] == "1"
              ? isSwitched = true
              : isSwitched = false;
          if (responseJson["data"]['orders'].toString() == "null") {
            orderList = new List();
          } else {
            orderList = responseJson["data"]['orders'] as List;
          }
          //getOrdersBackgorund();
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          //showToast("Something went wrong");
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      //showToast('Something went wrong');
    }
  }

  Future<void> getOrdersBackgorund() async {
    var preferences = await SharedPreferences.getInstance();
    try {
      print(driverOrders+" recursion");

      //print(widget.catInfo['category_id']);
      String tokenString = preferences.getString(token).toString();
      Map mapToSend = {
        "filter_driver_id": preferences.getInt(id).toString(),
        "token": tokenString
      };

      final response = await http.post(driverOrders, body: mapToSend);
      final responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        print(responseJson.toString());
        if (responseJson['status']) {
          orderUserObject = responseJson["data"]['user'];
          orderUserObject['accepting_orders'] == "1"
              ? isSwitched = true
              : isSwitched = false;
         
            if (responseJson["data"]['orders'].toString() == "null") {
              setState(() {
              orderList = new List();
            });
            
          } else {
            setState(() {
               orderList = responseJson["data"]['orders'] as List;
            });
            }
          //getOrdersBackgorund();
        } else {
          //showToast("Something went wrong");
        }
      } else {}
    } catch (e) {
      print(e);
      //showToast('Something went wrong');
    }
  }
}
