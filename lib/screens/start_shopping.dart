import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictapp_seller/screens/order_detail.dart';
import 'package:tictapp_seller/screens/start_delivery.dart';
import 'package:tictapp_seller/utils/common.dart';
import 'package:http/http.dart' as http;

class Shopping extends StatefulWidget {
  dynamic data;
  Shopping({this.data});
  @override
  _ShoppingState createState() => _ShoppingState();
}

class _ShoppingState extends State<Shopping> {
  bool isLoading = false;

  @override
  void initState() {
    getOrderDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = new DateTime.now();
    var parsedDate = DateTime.parse( isLoading ? "1970-01-01" : orderObject['delivery_date']);
    int diffDays = parsedDate.difference(currentDate).inDays;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Order Info",
            textAlign: TextAlign.center,
          ),
          backgroundColor: primaryColor),
      body: isLoading
          ? Image.asset("assets/images/loading.gif")
          : ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Store Name",
                                    textAlign: TextAlign.center,
                                  ),
                                  Container(
                                    child: Text(orderObject['seller_name'],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                    //  MapsLauncher.launchQuery();
                                    MapsLauncher.launchCoordinates(double.parse(orderObject['latitude']), double.parse(orderObject['longitude']),);
                                    },
                                                                      child: Container(
                                      child: Text(orderObject['store_address']+ " >",
                                          
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              decoration: TextDecoration.underline,
                                              color: lightestText,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              child: Container(
                                  height: 75,
                                  width: 75,

                                  //color: white,
                                  padding: EdgeInsets.all(5),
                                  child: FadeInImage.assetNetwork(
                                      //fit: BoxFit.cover,
                                      height: 80,
                                      width: 80,
                                      placeholder: "assets/images/loading.gif",
                                      image: url_string +
                                          "image/" +
                                          orderObject[
                                              'store_logo'] //widget.productData['custom_attributes'][0]['value'],
                                      )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text("User Information",
                          textAlign: TextAlign.left,
                          style:
                              TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                     Container(
                        margin: EdgeInsets.only(right: 15),
                       child: Row(
                         children: <Widget>[
                           Text("Order Id:  ",
                               textAlign: TextAlign.left,
                               style:
                                   TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                    Text("#"+orderObject['order_id'],
                               textAlign: TextAlign.left,
                               style:
                                   TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                                   color: blueColor
                                   )),
                         ],
                       ),
                     ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    //height: 350,
                    padding: EdgeInsets.all(15),
                    //margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      // boxShadow: [BoxShadow(offset: Offset(0,8),blurRadius: 24
                      //   ,color: darkText)]
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                orderObject['firstname'] +
                                    " " +
                                    orderObject['lastname'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                orderObject['products'].length.toString() +
                                    " total items",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "ADDRESS : " +
                                    orderObject['shipping_address']
                                        .toString()
                                        .replaceAll("<br />", ", "),
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Email",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                orderObject['email'],
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Telephone",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                orderObject['telephone'],
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.lightBlueAccent),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Instructions",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                orderObject['comment'] == ""
                                    ? "N/A"
                                    : orderObject['comment'],
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Delivery Date",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                orderObject['delivery_date']+ "   "+orderObject['time_slot'] ,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14),
                              )
                            ],
                          ),
                        )
                      ],
                    )),
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 50,
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: RaisedButton(
                      textColor: Colors.white,
                      color: primaryColor,
                      child: GestureDetector(
                          child: Text(
                        orderObject['store_type'] == "shopping" ? "Start Shopping" : "Pickup Order",
                        style: TextStyle(fontSize: 18),
                      )),
                      onPressed: () {
                        diffDays == 0 ?
                        getToken() : dateWarningDialog();
                        //changeStatus();
                        //Navigator.push(context, MaterialPageRoute(builder: (context){return DetailPage();},),);
                      }),
                ),
              ],
            ),
    );
  }


  dateWarningDialog() async
  {
    showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content:  Wrap(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.warning,color: Colors.yellow[600], size: 40),
                          SizedBox(height: 20,),
                          Text('Delivery is scheduled on\n'+orderObject['delivery_date']+ " at "+orderObject['time_slot']+
                  ".\nAre you sure you want to proceed ?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: lightestText
                      ),
                      textAlign: TextAlign.center,
                      ),
                        ],
                      ),
                      
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text('Yes proceed'),
                      onPressed: () {
                        // clearCartFromServer();
                        getToken();
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              });
  }


  dynamic orderObject;

  Future<void> getOrderDetail() async {
    var preferences = await SharedPreferences.getInstance();
    try {
      setState(() {
        isLoading = true;
      });
      print({
        "order_id": widget.data['order_id'],
        "token": preferences.getString(token)
      });
      final response = await http.post(orderDetailUrl, body: {
        "order_id": widget.data['order_id'],
        "token": preferences.getString(token)
      });
      //response.add(utf8.encode(json.encode(itemInfo)));

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        orderObject = responseJson['data'];
        print(orderObject);
        setState(() {
          isLoading = false;
        });

        //print(responseJson);

      } else {
        final responseJson = json.decode(response.body);
        showToast("Something went wrong");
        print(responseJson);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showToast("Something went wrong");
      print(e);
    }
  }

  Future<void> getToken() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await http.post(getTokenUrl,
          body: {"key": apiKey, "username": website_username});
      //response.add(utf8.encode(json.encode(itemInfo)));

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        print(responseJson);
        var preferences = await SharedPreferences.getInstance();
        preferences.setString(api_token, responseJson["api_token"]);
        // signIn() ;
        changeStatus();
      } else {
        final responseJson = json.decode(response.body);
        showToast("Something went wrong");
        print(responseJson);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showToast("Something went wrong");
      print(e);
    }
  }

  Future<void> changeStatus() async {
    setState(() {
      isLoading = true;
    });
    var preferences = await SharedPreferences.getInstance();
    try {
      //print(getProductUrl);
      //print(widget.catInfo['category_id']);
      print({
        "order_id": widget.data['order_id'],
        "order_status_id": "3",
        "token": preferences.getString(token)
      });
      final response = await http.post(
          finishOrderUrl + "&api_token=" + preferences.getString(api_token),
          body: {
            "order_id": widget.data['order_id'],
            "order_status_id": "18",
            "token": preferences.getString(token)
          });
      print(finishOrderUrl);
      print(response.body.toString());
      //print(json.decode(response.body));
      final responseJson = json.decode(response.body);
      print(responseJson);
      if (response.statusCode == 200) {
        if (responseJson['status']) {
          print(responseJson);
          //Navigator.pop(context);
          orderObject['store_type'] == "shopping" ? 
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetail(widget.data['order_id']),
                //builder: (context) => Shopping(data: widget.orderData),
              )) : Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => StartDelivery(data:widget.data['order_id']),
              ));
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          showToast("Something went wrong");
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
      showToast('Something went wrong');
    }
  }
}
