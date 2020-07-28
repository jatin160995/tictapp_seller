import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictapp_seller/screens/detail_earning.dart';
import 'package:tictapp_seller/utils/common.dart';
import 'package:http/http.dart' as http;

class Earnings extends StatefulWidget {
  @override
  _EarningsState createState() => _EarningsState();
}

class _EarningsState extends State<Earnings> {
  bool isLoading = true;

  @override
  void initState() {
    getEarnings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: isLoading
          ? Container(height: 0)
          : BorromBarForEarnings(totalEarningsObject),
      appBar: AppBar(centerTitle: true, title: Text("Earnings")),
      body: isLoading
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child: Center(child: CircularProgressIndicator()),
            )
          : ListView(
              children: createEarningCell(),
            ),
    );
  }

  List<Widget> createEarningCell() {
    List<Widget> earningCells = new List();
    for (var earning in earningsList) {
      earningCells.add(EarningCell(earning));
    }

    return earningCells;
  }

  List<dynamic> earningsList = new List();
  dynamic totalEarningsObject;
  Future<void> getEarnings() async {
    earningsList = new List();
    setState(() {
      isLoading = true;
    });
    var preferences = await SharedPreferences.getInstance();
    try {
      print(earningUrl);
      String tokenString = preferences.getString(token).toString();
      Map mapToSend = {"token": tokenString};
      final response = await http.post(earningUrl, body: mapToSend);
      final responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseJson['status']) {
          print(responseJson);
          earningsList = responseJson["earnings"] as List;
          totalEarningsObject = responseJson['totals'];
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
}

class BorromBarForEarnings extends StatelessWidget {
  dynamic totalEarning;
  BorromBarForEarnings(this.totalEarning);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
     // padding: EdgeInsets.only(left: 15, right: 15, top: 15),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
         
          
        
           Expanded(
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.only(top:5),
                            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Total Earnings",
                  style: TextStyle(
                      color: iconColor,
                      fontSize: 11,
                      fontWeight: FontWeight.normal),
                ),
                Text(
                 totalEarning['driverTotalEarnings'],
                  style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
          ),
                          ),
                        ),
           ),

          Expanded(
                      child: Container(
                        height: 50,
                        color: primaryColor,
                        child: FlatButton(
              onPressed: ()
              {
                Navigator.of(context).pushReplacement(
                      CupertinoPageRoute(builder: (context) => DetailEarning(totalEarning)));
              },
              child: Text("View Details >",
              style: TextStyle(
                color: white,
                fontWeight: FontWeight.bold
              ),)
            ),
                      ),
          )
        ],
      ),
    );
  }
}

class EarningCell extends StatelessWidget {
  dynamic earningObject;
  EarningCell(this.earningObject);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
        padding: EdgeInsets.all(10),
        color: white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Order id: #" + earningObject['order_id'],
                  style: TextStyle(
                      color: darkText,
                      fontSize: 13,
                      fontWeight: FontWeight.normal),
                ),
                Text(
                  earningObject['added_at'],
                  style: TextStyle(
                      color: darkText,
                      fontSize: 13,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
           // SizedBox(height: 10),
           Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Order Commission",
                          style: TextStyle(
                              color: iconColor,
                              fontSize: 11,
                              fontWeight: FontWeight.normal),
                        ),
                        Text(
                          earningObject['commission_amount'],
                          style: TextStyle(
                              color: tealColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.add, color: iconColor),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Order Tip",
                          style: TextStyle(
                              color: iconColor,
                              fontSize: 11,
                              fontWeight: FontWeight.normal),
                        ),
                        Text(
                          earningObject['tip'],
                          style: TextStyle(
                              color: tealColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "Total Earning",
                      style: TextStyle(
                          color: iconColor,
                          fontSize: 11,
                          fontWeight: FontWeight.normal),
                    ),
                    Text(
                      inr +
                          (double.parse(earningObject['tip']
                                      .toString()
                                      .replaceAll("\$", "")
                                      .replaceAll(",", "")) +
                                  double.parse(
                                      earningObject['commission_amount']
                                          .toString()
                                          .replaceAll("\$", "")
                                          .replaceAll(",", "")))
                              .toStringAsFixed(2),
                      style: TextStyle(
                          color: blueColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
             Divider(),
           // SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Order Total",
                      style: TextStyle(
                          color: iconColor,
                          fontSize: 11,
                          fontWeight: FontWeight.normal),
                    ),
                    Text(
                      earningObject['order_amount'],
                      style: TextStyle(
                          color: orange,
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                Text(
                  earningObject['type'],
                  style: TextStyle(
                      color: darkText,
                      fontSize: 13,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ],
        ));
  }
}
