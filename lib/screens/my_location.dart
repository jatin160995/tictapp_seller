import 'dart:async';
import 'dart:convert';

//import 'package:badges/badges.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictapp_seller/chats/order_chat.dart';
import 'package:tictapp_seller/screens/dashboard.dart';
//import 'package:tampee_driver/sidemenu/drawer.dart';
import 'package:tictapp_seller/utils/common.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

class MyLocation extends StatefulWidget {
  dynamic orderObject;
  MyLocation(this.orderObject);
  @override
  _MyLocationState createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation>
    with AutomaticKeepAliveClientMixin<MyLocation> {
  @override
  bool get wantKeepAlive => true;
  String _mapStyle;

  GoogleMapController _controller;
  Set<Marker> markers = new Set();

  double lat = 0.0;
  double lng = 0.0;
  double heading = 0.0;
  BitmapDescriptor bitmapDescriptor;
  Position currentPosition;
  Geolocator geolocator = new Geolocator();

  int cameraLoadCount = 0;
  StreamSubscription geolocatorStream;
  getCurrentPosition() {
    //getUserRequests();
    print("Get Location");
    geolocatorStream = geolocator
        .getPositionStream(LocationOptions(
            accuracy: LocationAccuracy.best, timeInterval: 1000))
        .listen((position) {
    //  saveLAtLng(position);
      //print(position.latitude);
      //print(position.longitude);
      setState(() {
        lat = position.latitude;
        lng = position.longitude;
        heading = position.heading;
      });
    });
  }

  String currentLocationString = "";
  //final databaseReference = Firestore.instance;
  String vanIDSaved = "";
  int loadCount = 0;
  
  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }

  getCustomerLocation() async {
    



    if(widget.orderObject['shipping_latitude'].toString() == "" || widget.orderObject['shipping_latitude'].toString() == "null")
        {
          List address =
        widget.orderObject['shipping_address'].toString().split("<br />");
    String queryString = "";
    for (int i = 1; i < address.length; i++) {
      queryString = queryString + ", " + address[i];
    }
    final query = queryString;
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    double lat1 = first.coordinates.latitude;
    double lng1 = first.coordinates.longitude;
 markers.add(Marker(
            markerId: MarkerId("Van1"),
            position: LatLng(lat, lng),
            //rotation: heading,
            infoWindow: InfoWindow(
              title: "User Location",
            ),
            draggable: true,
            //icon: bitmapDescriptor1
            ));

        _controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(lat, lng), zoom: 16),
          ),
        );
         setState(() {
      latLngList.add(LatLng(lat1, lng1));
    });
        }
        else
        {
         // showToast("here");
          double shippingLat = double.parse(widget.orderObject['shipping_latitude'].toString());
          double shippingLng = double.parse(widget.orderObject['shipping_longitude'].toString());
           markers.add(Marker(
            markerId: MarkerId("Van1"),
            position: LatLng(shippingLat, shippingLng),
            //rotation: heading,
            infoWindow: InfoWindow(
              title: "User Location",
            ),
            draggable: true,
            //icon: bitmapDescriptor
            ));
setState(() {
      latLngList.add(LatLng(double.parse(widget.orderObject['shipping_latitude'].toString()), 
      double.parse(widget.orderObject['shipping_longitude'].toString())));
    });
        _controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(shippingLat, shippingLng), zoom: 16),
          ),
        );
        }

    /*markers.add(Marker(
      markerId: MarkerId("Van1"),
      position: LatLng(lat1, lng1),
      //rotation: heading,
      infoWindow: InfoWindow(
        title: "",
      ),
      //draggable: true,
      //icon: bitmapDescriptor1
    ));
    print(lat1);*/
  }

  List<dynamic> requestList = new List();
  List<dynamic> requestIdList = new List();
  List<LatLng> latLngList = new List();
  /* getUserRequests() async {
    //print("getUserRe");

    BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 1),
        'assets/images/user_location.png');
    BitmapDescriptor bitmapDescriptor1 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 1), 'assets/images/van1.png');
    await databaseReference
        .collection("user_requests")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      requestList.clear();
      requestIdList.clear();
      markers.clear();
      latLngList.clear();
      latLngList.add(LatLng(lat, lng));
      markers.add(Marker(
          markerId: MarkerId("Van1"),
          position: LatLng(lat, lng),
          //rotation: heading,
          infoWindow: InfoWindow(
            title: "Van Location",
          ),
          draggable: true,
          //icon: bitmapDescriptor1
          ));

      snapshot.documents.forEach((f) {
        //print(f.data['requests'].toString());
        if (f.data['requests']['isAccepted'] && !f.data['requests']['isFinished']) {
          latLngList.add(
              LatLng(f.data['requests']['lat'], f.data['requests']['lng']));

          
          requestList.add(f.data['requests']);
          requestIdList.add(f.documentID);
        }

       
      });
    });

    //getCustomerLocation();
     //if(cameraLoadCount < 3)
        //{
         
            cameraLoadCount++;
       // }
  }*/

  void currentLocation() async {}

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    // _controller.setMapStyle(_mapStyle);

    // _controller.add
  }

  askPermission() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.location].request();

    setState(() {});
  }

  @override
  void initState() {
    askPermission();

    //currentLocation();
    getCurrentPosition();
getCustomerLocation();
    //rootBundle.loadString('assets/map_style.txt').then((string) {
    //_mapStyle = string;
    //});
    super.initState();
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
        "order_id": widget.orderObject['order_id'],
        "order_status_id": "3",
        "token": preferences.getString(token)
      });
      final response = await http.post(
          finishOrderUrl + "&api_token=" + preferences.getString(api_token),
          body: {
            "order_id": widget.orderObject['order_id'],
            "order_status_id": "5",
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
          //Navigator.pop(context);
          Navigator.pop(context);
          //Navigator.pop(context);
          Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (context) => Dashboard()));
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

  bool notificationViewState = false;
  @override
  Widget build(BuildContext context) {
    askPermission();
    return Scaffold(
      /*drawer: DrawerMenu(),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Badge(
                  badgeContent: Text(
                    cartCount.toString(),
                    style: TextStyle(color: white),
                  ),
                  child: Icon(Icons.notifications)),
              onPressed: () {
                setState(() {
                  notificationViewState = !notificationViewState;
                });
              })
        ],
        iconTheme: IconThemeData(color: darkText),
        title: Text(
          "Dashboard",
          style: TextStyle(color: darkText),
        ),
        backgroundColor: white,
        centerTitle: true,
      ),*/
      //drawer: DrawerMenu(),
      
      appBar: AppBar(
        actions: <Widget>[
            IconButton(
                onPressed: () {
                 // Share.share(
                   //   "Glad to place this order from this app. Got an amazing offer.");
                    Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => Chat(widget.orderObject['order_id'])));
                },
                icon: Icon(
                  Icons.chat
                )),
          ],
        iconTheme: IconThemeData(color: white),
        title: Text(
          "Customer\'s Location",
          style: TextStyle(color: white),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: FlatButton(
          color: darkText,
          onPressed: () {
            getToken();
          },
          child: isLoading
              ? CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(white),
                )
              : Text(
                  "Complete Order",
                  style: TextStyle(color: white),
                ),
        ),
      ),
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          /*Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 50,
                color: white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 50,
                        child: FlatButton(
                          color: isMoving ? primaryColor : white,
                          onPressed: () {
                            setState(() {
                              isMoving = true;
                            });
                          },
                          child: Text(
                            "Move",
                            style: TextStyle(
                                color: darkText,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 50,
                        child: FlatButton(
                          color: isMoving ? white : primaryColor,
                          onPressed: () {
                            setState(() {
                              isMoving = false;
                            });
                          },
                          child: Text(
                            "Halt",
                            style: TextStyle(
                                color: darkText,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),*/
          Align(
            alignment: Alignment.topCenter,
            child: Container(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "ORDER ID: #" + widget.orderObject['order_id'],
                                style: TextStyle(
                                    color: darkText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.orderObject['order_status'],
                                style: TextStyle(
                                  color: widget.orderObject['order_status'] ==
                                          "Pending"
                                      ? orange
                                      : widget.orderObject['order_status'] ==
                                              "Complete"
                                          ? greenButton
                                          : widget.orderObject[
                                                      'order_status'] ==
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                widget.orderObject['firstname'] +
                                    " " +
                                    widget.orderObject['lastname'],
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
                            widget.orderObject['email'],
                            style: TextStyle(
                                color: lightText,
                                fontSize: 13,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(height: 3),
                          Text(
                            widget.orderObject['shipping_address']
                                .toString()
                                .replaceAll("<br />", ", "),
                            style: TextStyle(
                                color: lightestText,
                                fontSize: 13,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(height: 5),
                          Text(
                            widget.orderObject['payment_method']
                                .toString()
                                .toUpperCase(),
                            style: TextStyle(
                                color: blueColor,
                                fontSize: 13,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(height: 5),
                          Divider(),
                          // SizedBox(height: 5),
                          FlatButton(
                            child: Text(
                                "Get directions to " +
                                    widget.orderObject['firstname'] +
                                    " " +
                                    widget.orderObject['lastname'] +
                                    "\'s place >",
                                style: TextStyle(
                                    color: blueColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () {
                              List address = widget
                                  .orderObject['shipping_address']
                                  .toString()
                                  .split("<br />");
                              String queryString = "";
                              for (int i = 1; i < address.length; i++) {
                                queryString = queryString + ", " + address[i];
                              }
                              final query = queryString;
                              MapsLauncher.launchQuery(query);
                            },
                          ),
                          SizedBox(height: 15),
                        ],
                      )),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 0, top: 210),
              child: latLngList.length == 0
                  ? Column(
                      children: <Widget>[
                        Image.asset("assets/images/loading.gif"),
                        Text("Loading " +
                            widget.orderObject['firstname'] +
                            " " +
                            widget.orderObject['lastname'] +
                            "\'s Location")
                      ],
                    )
                  : GoogleMap(
                      markers: markers,
                      onMapCreated: _onMapCreated,
                      initialCameraPosition:
                          CameraPosition(target: LatLng(lat, lng), zoom: 16.0),
                      onCameraMove: ((pinPosition) {
                        // print(pinPosition.target.latitude);
                        // print(pinPosition.target.longitude);
                      }),
                      //myLocationEnabled: true,
                    ),
            ),
          ),
          /*Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.all(15),
              child: Card(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  color: white,
                  height: 40,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.my_location,
                        color: greenButton,
                        size: 15,
                      ),
                      SizedBox(width: 15),
                      Text(currentLocationString,
                          style: TextStyle(color: lightestText, fontSize: 15)),
                    ],
                  ),
                ),
              ),
            ),
          ),*/
          /* Align(
              alignment: Alignment.topCenter,
              child: Visibility(
                maintainAnimation: true,
                maintainState: true,
                visible: notificationViewState,
                child: Card(
                  child: Container(
                    height: 300,
                    color: white,
                    child: ListView(
                      children: getNotifications(),
                    ),
                  ),
                ),
              )),*/
          /*Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                margin: EdgeInsets.only(top: 40, left: 0, bottom: 15),
                padding: EdgeInsets.all(5),
                decoration: new BoxDecoration(
                    color: isMoving ? primaryColor : Colors.red[700],
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(40.0),
                      topRight: const Radius.circular(40.0),
                      bottomRight: const Radius.circular(40.0),
                      bottomLeft: const Radius.circular(40.0),
                    )),
                child: isMoving
                    ? Container(
                        height: 70,
                        width: 70,
                        child: Image.asset("assets/images/source.gif"))
                    : Container(
                        height: 70,
                        width: 70,
                        child: Center(
                          child: Text(
                            "ON HALT",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
          ),*/
        ],
      )),
    );
  }

  bool isMoving = true;

  int cartCount = 0;
  List<Widget> getNotifications() {
    // notificationCount = 0;
    List<Widget> notiList = new List();

    for (int i = 0; i < requestList.length; i++) {
      if (!requestList[i]['isAccepted']) {
        //notificationCount++;
      }
      notiList.add(
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("🙋🏻‍♂️", style: TextStyle(fontSize: 18)),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            requestList[i]['customer_name'],
                            style: TextStyle(
                                color: darkText, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            requestList[i]['address'],
                            style: TextStyle(color: lightestText),
                          ),
                        ],
                      ),
                    ],
                  ),
                  FlatButton(
                      onPressed: () {
                      },
                      child: Text(
                        "ACCEPT",
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
            Divider(
              height: 8,
            )
          ],
        ),
      );
    }

    return notiList;
  }

  @override
  void dispose() {
    geolocatorStream.cancel();
    super.dispose();
  }
}
