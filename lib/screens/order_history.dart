import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictapp_seller/sidemenu/drawer.dart';
import 'package:tictapp_seller/utils/common.dart';
import 'package:http/http.dart' as http;
import 'package:tictapp_seller/widgets/order_list_cell.dart';

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {

  @override
  void initState() {
    getOrders();
    //getToken();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: DrawerMenu(),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Order History")
      ),
      body: isLoading?
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: Center(child: CircularProgressIndicator()),
      )
      : ListView(
        children:createOrderCell(),
      ),
    );
  }


 List<Widget> createOrderCell(){
    List<Widget> orderCellList = new List();
    for (int i= 0; i < orderList.length; i ++)
    {
      orderCellList.add(OrderListCell(orderList[i], false, (){}, (){}));
    }
    if(orderList.length == 0)
    {
       orderCellList.add(Container(
         margin: EdgeInsets.only(top: 50),
         child: Center(child: Text("NO ORDERS",
         style: TextStyle(
           color: iconColor,
           fontSize: 18,
           fontWeight: FontWeight.bold

         ),))));
    }

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
          body: {"email": preferences.getString(username), "password": preferences.getString(password)});
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



  bool isLoading = false;
  dynamic orderList;
  Future<void> getOrders() async {
    
    setState(() {
      isLoading = true;
    });
    var preferences = await SharedPreferences.getInstance();
    try {
      print(driverOrders);
      
      //print(widget.catInfo['category_id']);
      String tokenString = preferences.getString(token).toString();
      print(tokenString);
      Map mapToSend = {"filter_driver_id": preferences.getInt(id).toString(), "token": tokenString};
      print(mapToSend);
      final response = await http.post(driverOrders,
      body: mapToSend);
      
      final responseJson = json.decode(response.body);
        
      if (response.statusCode == 200) {
        print(responseJson.toString());
        if (responseJson['status']) {
          print(responseJson);
          if(responseJson["data"]['orders'].toString() == "null")
          {
            orderList = new List();
          }
          else
          {
            orderList = responseJson["data"]['orders'] as List;
          }
          
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