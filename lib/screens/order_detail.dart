import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictapp_seller/chats/order_chat.dart';
import 'package:tictapp_seller/screens/dashboard.dart';
import 'package:tictapp_seller/screens/my_location.dart';
import 'package:tictapp_seller/screens/start_delivery.dart';
import 'package:tictapp_seller/utils/common.dart';
import 'package:http/http.dart' as http;

class OrderDetail extends StatefulWidget {
  dynamic orderData;
  OrderDetail(this.orderData);
  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {

  bool isSearchVisible = false;
  TextEditingController textEditingController = new TextEditingController();
  String query;
  @override
  void initState() {
    orderDoneItem = new List();
    orderDeleteItem = new List();
    getToken1();
    super.initState();
  }



   Future<void> getToken1() async {
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
         getOrderDetail();
        //changeStatus();
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




    Future<bool> _onWillPop() async {
    if (isSearchVisible) {
      setState(() {
        isSearchVisible = !isSearchVisible;
        return false;
      });
    } else {
      return true;
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
          child: Scaffold(
            floatingActionButton: FloatingActionButton(onPressed: ()
            {
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Chat(widget.orderData),
              ));
            },
            child: Icon(Icons.chat),
            ),
        backgroundColor: background,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                    icon: Icon(isSearchVisible? Icons.close : Icons.add_shopping_cart),
                    onPressed: () {
                      setState(() {
                        isSearchVisible = !isSearchVisible;
                      });
                    }),
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
                  orderObject['order_status'] != "Complete"
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
                                  //Navigator.of(context).pop(),
                                },
                                child: isLoading
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                white),
                                      )
                                    : Text(
                                        "DONE",
                                        style: TextStyle(color: white),
                                      ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                      isSearchVisible
                    ? Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          color: background,
                          margin: EdgeInsets.only(top: 70),
                          child: ListView(
                            children: getSearchedChildren(),
                          ),
                        ),
                      )
                    : Container(),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Visibility(
                          visible: isSearchVisible,
                          child: Container(
                            color: statusBarColor,
                            padding: EdgeInsets.all(8),
                            child: Card(
                              child: Container(
                                  //padding: EdgeInsets.only(left: 10, right: 10),
                                  color: white,
                                  margin: EdgeInsets.only(left: 10),
                                  child: Row(
                                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 10,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: TextField(
                                            controller: textEditingController,
                                            enabled: true,
                                            //textCapitalization: TextCapitalization.characters,
                                            onChanged: (text) {
                                              query = text;
                                            },
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Search...',
                                            ),
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            height: 50,
                                            decoration: new BoxDecoration(
                                              color: primaryColor,
                                              borderRadius: new BorderRadius.only(
                                                bottomRight:
                                                    const Radius.circular(4.0),
                                                topRight:
                                                    const Radius.circular(4.0),
                                              ),
                                            ),
                                            child: Center(
                                                child: IconButton(
                                              onPressed: () {
                                                //print(textEditingController.text);
                                                productFromServer = new List();
                                                currentPage = 1;
                                                getProducts();
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                              },
                                              icon: Icon(Icons.search),
                                              color: white,
                                            ))),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ),
                    )
                ],
              ),
      ),
    );
  }



void productDialog(dynamic itemData) async {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          int quantity = 1;
          bool isDialogLoading = false;

          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setCouponState /*You can rename this!*/) {
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
                      orderItemsList.add(itemData);
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
                child: isDialogLoading
                    ? Image.asset("assets/images/loading.gif")
                    : Stack(
                        children: <Widget>[
                          Align(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              image: itemData["thumb"].toString()),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                          
                                            setCouponState(() {
                                              quantity++;
                                            });
                                          
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
                                 /* Expanded(
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
                                  ),*/
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      color: blueColor,
                                      child: FlatButton(
                                          onPressed: () {
                                            editItem(true);
                                          },
                                          child: Text("Add to order",
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




   List<Widget> getSearchedChildren() {
    List<Widget> productList = new List();
    for (int i = 0; i < productFromServer.length; i++) {
      productList.add(new SearchedItem(productFromServer[i], () {
        dynamic productObject = 
        {
        "order_product_id": "0",
        "product_id": productFromServer[i]['product_id'],
        "thumb": productFromServer[i]['image'],
        "name":productFromServer[i]['name'],
        "model": productFromServer[i]['name'],
        "option": [],
        "quantity": "1",
        "price": inr+productFromServer[i]['price'],
        "total": inr+productFromServer[i]['price'],
        "href": ""
      };
        setState(() {
          isSearchVisible = false;
          productDialog(productObject);
         // saveCartToLocal(productFromServer[i]);
        });
      }));
    }
    if (productList.length > 0) {
      productList.add(new FlatButton(
          onPressed: isLoading
              ? () {}
              : () {
                  currentPage++;
                  productList.remove(productList.length - 1);
                  productList.add(CircularProgressIndicator());
                  setState(() {});
                  getProducts();
                },
          child: isLoading
              ? Container(
                  height: 40, width: 40, child: CircularProgressIndicator())
              : Text('Load More')));
    }
    if (isLoading) {
      productList.add(Container(
          height: 160,
          width: 160,
          child: Center(child: CircularProgressIndicator())));
    }

    return productList;
  }



  List<dynamic> orderItemsList = new List();

  List<Widget> getItems() {
    List<Widget> itemsList = new List();
    //List items = orderObject["products"] as List;
    for (int i = 0; i < orderItemsList.length; i++) {
      itemsList.add(
        SizedBox(height: 5),
      );
      itemsList.add(GestureDetector(
        onTap: () {
          showItemDialog(orderItemsList[i]);
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
                        image: orderItemsList[i]["thumb"].toString()),
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
                          orderItemsList[i]['name'],
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
                                orderItemsList[i]['quantity'] + " x",
                                style: TextStyle(
                                    color: lightText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              //flex: 3,
                              child: Text(
                                orderItemsList[i]['total'],
                                //textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: lightText,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Expanded(
                                //flex: 3,
                                child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: orderDoneItem
                                        .contains(orderItemsList[i]['product_id'])
                                    ? blueColor
                                    : orderDeleteItem
                                            .contains(orderItemsList[i]['product_id'])
                                        ? Colors.red
                                        : white,
                                border: Border.all(
                                    color: orderDoneItem
                                            .contains(orderItemsList[i]['product_id'])
                                        ? blueColor
                                        : orderDeleteItem.contains(
                                                orderItemsList[i]['product_id'])
                                            ? Colors.red
                                            : blueColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Text(
                                  orderDoneItem.contains(orderItemsList[i]['product_id'])
                                      ? "DONE ✓"
                                      : orderDeleteItem
                                              .contains(orderItemsList[i]['product_id'])
                                          ? "DELETED ✗"
                                          : "TODO",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: orderDoneItem
                                              .contains(orderItemsList[i]['product_id'])
                                          ? white
                                          : orderDeleteItem.contains(
                                                  orderItemsList[i]['product_id'])
                                              ? white
                                              : blueColor,
                                      fontSize: 12)),
                            )),
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
          bool isDialogLoading = false;

          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setCouponState /*You can rename this!*/) {
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
                child: isDialogLoading
                    ? Image.asset("assets/images/loading.gif")
                    : Stack(
                        children: <Widget>[
                          Align(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              image: itemData["thumb"].toString()),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
        orderItemsList = orderObject['products'] as List;
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
            "order_status_id": "20",
            "token": preferences.getString(token)
          });
      print(finishOrderUrl);
      print(response.statusCode);
      //print(json.decode(response.body));
      final responseJson = json.decode(response.body);
      print(responseJson);
      if (response.statusCode == 200) {
        if (responseJson['status']) {
          print(responseJson);
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard(),
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












  dynamic productFromServer = new List();
  int currentPage = 1;

  Future<void> getProducts() async {
    setState(() {
      isLoading = true;
    });

    var preferences = await SharedPreferences.getInstance();

    print(textEditingController.text);
    try {
      //print(getProductUrl);
      print(searchUrl+"&api_token="+preferences.getString(api_token));
      final response = await http.post(searchUrl+"&api_token="+preferences.getString(api_token), body: {
        "key": apiKey,
        "page": currentPage.toString(),
        'keyword': textEditingController.text,
      });
      //print(json.decode(response.body));
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        print(responseJson);
        if (responseJson['status']) {
          // print(responseJson);
          if (currentPage > 1) {
            // productFromServer.removeAt(productFromServer.length -1);
          }
          //print(responseJson['items']);
          productFromServer.addAll(responseJson['data'] as List); //;
          // productFromServer.add({'isLast':'1'});
          setState(() {
            isLoading = false;
            //createProduct();
            print('setstate');
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





class SearchedItem extends StatefulWidget {
  dynamic productData;
  Function openDialog;
  SearchedItem(this.productData, this.openDialog);
  @override
  _SearchedItemState createState() => _SearchedItemState();
}

class _SearchedItemState extends State<SearchedItem> {
  @override
  Widget build(BuildContext context) {
    // print(widget.productData['custom_attributes'][0]['value']);
    return GestureDetector(
      //onTap: widget.openDialog,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              FadeInImage.assetNetwork(
                height: 70,
                width: 70,
                placeholder: 'assets/images/loading.gif',
                image: widget.productData['image'],
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.productData['name'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          color: lightestText,
                          fontSize: 14,
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                        inr +
                            double.parse(widget.productData['price'])
                                .toStringAsFixed(2),
                        style: TextStyle(
                          color: tealColor,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
              FlatButton(
                onPressed: widget.openDialog,
                child: Icon(Icons.add_shopping_cart, color: blueColor),
              )
            ],
          ),
        ),
      ),
    );
  }

}
