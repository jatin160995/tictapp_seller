import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictapp_seller/screens/dashboard.dart';
import 'package:tictapp_seller/utils/common.dart';
import 'package:http/http.dart' as http;

class UserOrderDetail extends StatefulWidget {
  dynamic orderData;
  UserOrderDetail(this.orderData);
  @override
  _UserOrderDetailState createState() => _UserOrderDetailState();
}

class _UserOrderDetailState extends State<UserOrderDetail> {
  @override
  void initState() {
    orderDoneItem = new List();
    orderDeleteItem = new List();
    getOrderDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              onPressed: () {
                MapsLauncher.launchQuery(orderObject['shipping_address']
                        .toString()
                        .replaceAll(
                            "<br />", ", ") //orderObject['shipping_address']
                    );
              },
              icon: Icon(Icons.map))
        ],
        // iconTheme: IconThemeData(color: darkText),
        title: Text(
          "Order Detail",
          //style: TextStyle(color: darkText),
        ),
        //backgroundColor: white,
        centerTitle: true,
      ),
      body: isLoading
          ? Image.asset("assets/images/loading.gif")
          : Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: ListView(
                    children: <Widget>[
                      Container(
                          color: white,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(
                              left: 16, right: 16, top: 16, bottom: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "ORDER ID: #" + orderObject['order_id'],
                                    style: TextStyle(
                                        color: darkText,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    orderObject['order_status'],
                                    style: TextStyle(
                                      color: orderObject['order_status'] ==
                                              "Pending"
                                          ? orange
                                          : orderObject['order_status'] ==
                                                  "Complete"
                                              ? greenButton
                                              : orderObject['order_status'] ==
                                                      "Cancel"
                                                  ? Colors.red
                                                  : Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    orderObject['firstname'] +
                                        " " +
                                        orderObject['lastname'],
                                    style: TextStyle(
                                        color: darkText,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "",
                                    //inr +
                                    //double.parse(widget.orderData['total'])
                                    //.toStringAsFixed(2),
                                    style: TextStyle(
                                        color: blueColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 3),
                              Text(
                                orderObject['email'],
                                style: TextStyle(
                                    color: lightText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal),
                              ),
                              SizedBox(height: 3),
                              Text(
                                orderObject['shipping_address']
                                    .toString()
                                    .replaceAll("<br />", ", "),
                                style: TextStyle(
                                    color: lightestText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal),
                              ),
                              SizedBox(height: 5),
                              Text(
                                orderObject['payment_method']
                                    .toString()
                                    .toUpperCase(),
                                style: TextStyle(
                                    color: blueColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal),
                              ),
                              SizedBox(height: 5),
                              Divider(),
                              SizedBox(height: 5),
                              Text(
                                "ITEMS",
                                style: TextStyle(
                                    color: iconColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 7),
                              Column(
                                children: getItems(),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
                /*orderObject['order_status'] != "Complete"
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: double.infinity,
                          child: Container(
                            height: 45,
                            child: FlatButton(
                              color: primaryColor,
                              onPressed: () {
                                getToken();
                              },
                              child: isLoading
                                  ? CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              white),
                                    )
                                  : Text(
                                      "FINISH JOB",
                                      style: TextStyle(color: white),
                                    ),
                            ),
                          ),
                        ),
                      )
                    : Container()*/
              ],
            ),
    );
  }

  List<Widget> getItems() {
    List<Widget> itemsList = new List();
    List items = orderObject["products"] as List;
    for (int i = 0; i < items.length; i++) {
      itemsList.add(
        SizedBox(height: 5),
      );
      itemsList.add(GestureDetector(
        onTap: () {
         // showItemDialog(items[i]);
        },
        child: Container(
          color: white,
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 80,
                    width: 80,
                    child: FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80,
                        placeholder: 'assets/images/logo_grey.png',
                        image: items[i]["thumb"]),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          items[i]['name'],
                          maxLines: 2,
                          style: TextStyle(
                              color: lightText,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              //flex: 1,
                              child: Text(
                                items[i]['quantity'] + " x",
                                style: TextStyle(
                                    color: lightText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              //flex: 3,
                              child: Text(
                                items[i]['total'],
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: lightText,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            /*Expanded(
                                //flex: 3,
                                child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: orderDoneItem
                                        .contains(items[i]['product_id'])
                                    ? blueColor
                                    : orderDeleteItem
                                            .contains(items[i]['product_id'])
                                        ? Colors.red
                                        : white,
                                border: Border.all(
                                    color: orderDoneItem
                                            .contains(items[i]['product_id'])
                                        ? blueColor
                                        : orderDeleteItem.contains(
                                                items[i]['product_id'])
                                            ? Colors.red
                                            : blueColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Text(
                                  orderDoneItem.contains(items[i]['product_id'])
                                      ? "DONE ✓"
                                      : orderDeleteItem
                                              .contains(items[i]['product_id'])
                                          ? "DELETED ✗"
                                          : "TODO",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: orderDoneItem
                                              .contains(items[i]['product_id'])
                                          ? white
                                          : orderDeleteItem.contains(
                                                  items[i]['product_id'])
                                              ? white
                                              : blueColor,
                                      fontSize: 12)),
                            ))*/
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider()
            ],
          ),
        ),
      ));
      itemsList.add(
        SizedBox(height: 5),
      );
    }

    return itemsList;
  }

  showItemDialog(dynamic itemData) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          int quantity = int.parse(itemData["quantity"].toString());

          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setCouponState /*You can rename this!*/) {
            bool isDialogLoading = false;

            Future<void> editItem(bool isAdd) async {
              var preferences = await SharedPreferences.getInstance();
              try {
                setCouponState(() {
                  isDialogLoading = true;
                });
                final response = await http.post(orderEditUrl, body: {
                  "order_id": widget.orderData.toString(),
                  "token": preferences.getString(token),
                  "product_id": itemData['product_id'],
                  "quantity": isAdd ? quantity.toString() : "0"
                });
                //response.add(utf8.encode(json.encode(itemInfo)));

                if (response.statusCode == 200) {
                  final responseJson = json.decode(response.body);
                  if (responseJson['status']) {
                    if (isAdd) {
                      orderDoneItem.add(itemData['product_id']);
                      itemData["quantity"] = quantity.toString();
                    } else {
                      orderDeleteItem.add(itemData['product_id']);
                    }
                  }
                  setState(() {
                    isDialogLoading = false;
                  });
                  Navigator.pop(context);
                  
                  //print(responseJson);

                } else {
                  final responseJson = json.decode(response.body);
                  showToast("Something went wrong");
                  print(responseJson);
                  setCouponState(() {
                    isDialogLoading = false;
                  });
                }
              } catch (e) {
                setCouponState(() {
                  isDialogLoading = false;
                });
                showToast("Something went wrong");
                print(e);
              }
            }

            return Container(
                height: 300,
                color: white,
                child: Stack(
                  children: <Widget>[
                    isDialogLoading
                        ? Image.asset("assets/images/loading.gif")
                        : Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              width: double.infinity,
                              child: Container(
                                color: blueColor,
                                height: 50,
                                child: Center(
                                    child: Text(
                                  "Product Detail",
                                  style: TextStyle(
                                      color: white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(top: 60),
                        child: Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 15),
                                    child: FadeInImage.assetNetwork(
                                        fit: BoxFit.contain,
                                        height: 140,
                                        //width: 150,
                                        placeholder:
                                            'assets/images/logo_grey.png',
                                        image: itemData["thumb"]),
                                  ),
                                ),
                                //SizedBox(width: 10),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 10, right: 15, left: 15),
                                        child: Text(
                                          itemData["name"],
                                          maxLines: 4,
                                          style: TextStyle(
                                              color: lightText,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 10, right: 15, left: 15),
                                        child: Text(
                                          itemData["total"],
                                          style: TextStyle(
                                              color: blueColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    if (quantity > 1) {
                                      setCouponState(() {
                                        quantity--;
                                      });
                                    }
                                  },
                                ),
                                SizedBox(width: 30),
                                Text(quantity.toString(),
                                    style: TextStyle(
                                        color: darkText, fontSize: 20)),
                                SizedBox(width: 30),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    if (quantity <
                                        int.parse(itemData["quantity"])) {
                                      setCouponState(() {
                                        quantity++;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                color: iconColor,
                                child: FlatButton(
                                    onPressed: () {
                                      //orderDeleteItem
                                      editItem(false);
                                    },
                                    child: Text("Not Found",
                                        style: TextStyle(color: white))),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                color: blueColor,
                                child: FlatButton(
                                    onPressed: () {
                                      editItem(true);
                                    },
                                    child: Text("Found Item",
                                        style: TextStyle(color: white))),
                              ),
                            )
                          ],
                        )))
                  ],
                ));
          });
        });
  }

  dynamic orderObject;
  Future<void> getOrderDetail() async {
    var preferences = await SharedPreferences.getInstance();
    try {
      setState(() {
        isLoading = true;
      });
      final response = await http.post(orderDetailUrl, body: {
        "order_id": widget.orderData,
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

  bool isLoading = false;
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
        finishOrder();
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

  Future<void> finishOrder() async {
    setState(() {
      isLoading = true;
    });
    var preferences = await SharedPreferences.getInstance();
    try {
      //print(getProductUrl);
      //print(widget.catInfo['category_id']);
      final response = await http.post(
          finishOrderUrl + "&api_token=" + preferences.getString(api_token),
          body: {
            "order_id": widget.orderData.toString(),
            "order_status_id": "5"
          });
      //print(json.decode(response.body));
      final responseJson = json.decode(response.body);
        print(responseJson);
      if (response.statusCode == 200) {
        
        if (responseJson['status']) {
          print(responseJson);
          Navigator.pop(context);
         
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
