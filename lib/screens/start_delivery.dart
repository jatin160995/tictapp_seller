import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictapp_seller/screens/my_location.dart';
import 'package:tictapp_seller/screens/order_detail.dart';
import 'package:tictapp_seller/utils/common.dart';
import 'package:http/http.dart' as http;


class StartDelivery extends StatefulWidget {
  dynamic data;
  StartDelivery({this.data});
  @override
  _StartDeliveryState createState() => _StartDeliveryState();
}
class _StartDeliveryState extends State<StartDelivery> {


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
          title: Text("Delivery",textAlign: TextAlign.center,),
          backgroundColor: primaryColor
      ),
      body:isLoading ? Image.asset("assets/images/loading.gif") : ListView(
        children: <Widget>[
         
          SizedBox(height: 2,),
          Container(
              //height: 350,
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                 // boxShadow: [BoxShadow(offset: Offset(0,8),blurRadius: 24
                   //   ,color: darkText)]
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                                          child: Text("Thanks for shopping",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(orderObject['firstname']+" "+orderObject['lastname'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                    SizedBox(height: 5,),
                    Text(orderObject['products'].length.toString()+" total items",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
                    SizedBox(height: 10,),
                    Text("ADDRESS : "+orderObject['shipping_address'].toString().replaceAll("<br />", ", "),style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
                    SizedBox(height: 20,),
                    Text("Email",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
                    SizedBox(height: 5,),
                    Text(orderObject['email'],style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
                    SizedBox(height: 20,),
                    Text("Telephone",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
                    SizedBox(height: 5,),
                    Text(orderObject['telephone'],style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: Colors.lightBlueAccent),),
                    SizedBox(height: 20,),
                    Text("Instructions",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
                    SizedBox(height: 5,),
                    Text(orderObject['comment'] == "" ? "N/A" : orderObject['comment'],style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
                    SizedBox(height: 20,),
                    Text("Delivery Date",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
                    SizedBox(height: 5,),
                    Text(orderObject['delivery_date']+ "   "+orderObject['time_slot'],style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),)
                  ],
                )
          ),
          SizedBox(height: 15,),
          Container(
            margin: EdgeInsets.only(top: 20),
            height: 50,
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: RaisedButton(
                textColor: Colors.white,
                color: primaryColor,
                child: GestureDetector(
                    child: Text(
                      "Start Delivery",
                      style: TextStyle
                        (fontSize: 18),
                    )
                ),
                onPressed:(){
                  
                  diffDays == 0 ?
                        getToken() : dateWarningDialog();
                  //changeStatus();
                  //Navigator.push(context, MaterialPageRoute(builder: (context){return DetailPage();},),);
                }
            ),
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
                  content: Wrap(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.error,color: Colors.red, size: 40),
                          SizedBox(height: 20,),
                          Text('Delivery is scheduled on\n'+orderObject['delivery_date']+ " at "+orderObject['time_slot']+
                      ".\n You can't deliver it today.",
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
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
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
        "order_id": widget.data,
        "token": preferences.getString(token)
      });
      final response = await http.post(orderDetailUrl, body: {
        "order_id": widget.data,
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
            "order_id": widget.data,
            "order_status_id": "3",
            "token": preferences.getString(token)
          });
      final response = await http.post(
          finishOrderUrl + "&api_token=" + preferences.getString(api_token),
          body: {
            "order_id": widget.data,
            "order_status_id": "19",
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
         Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyLocation(orderObject),
              //builder: (context) => Shopping(data: widget.orderData),
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