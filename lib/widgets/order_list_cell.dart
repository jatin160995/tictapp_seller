import 'package:flutter/material.dart';
import 'package:tictapp_seller/screens/order_detail.dart';
import 'package:tictapp_seller/screens/start_delivery.dart';
import 'package:tictapp_seller/screens/start_shopping.dart';
import 'package:tictapp_seller/screens/user/user_order_detail.dart';
import 'package:tictapp_seller/utils/common.dart';

class OrderListCell extends StatefulWidget {
  dynamic orderData;
  bool isEditable;
  Function acceptOrder;
  Function declineOrder;
  OrderListCell(
      this.orderData, this.isEditable, this.acceptOrder, this.declineOrder);

  @override
  _OrderListCellState createState() => _OrderListCellState();
}

class _OrderListCellState extends State<OrderListCell> {
  /* Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => StartDelivery(data:widget.orderData.toString()),
              ));*/
  @override
  Widget build(BuildContext context) {
    DateTime currentDate = new DateTime.now();
    var parsedDate = DateTime.parse( widget.orderData['delivery_date'].toString());
    int diffDays = parsedDate.difference(currentDate).inDays;
    //print(currentDate.toString());
    return GestureDetector(
      onTap: (){
        widget.isEditable
                
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrderDetail(widget.orderData['order_id']),
                            //builder: (context) => Shopping(data: widget.orderData),
                          )) : print(""); 
      },
      child: Container(
          color: white,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 7.5, bottom: 7.5, right: 15, left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "ORDER ID: #" + widget.orderData['order_id'].toString(),
                    style: TextStyle(
                        color: darkText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.orderData['order_status'].toString(),
                    style: TextStyle(
                        color: widget.orderData['order_status'] == "Pending"
                            ? orange
                            : widget.orderData['order_status'] == "Complete"
                                ? greenButton
                                : widget.orderData['order_status'] == "Cancel"
                                    ? Colors.red
                                    : Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.orderData['customer'].toString(),
                    style: TextStyle(
                        color: darkText,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.orderData['total'].toString(),
                    style: TextStyle(
                        color: blueColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 3),
              Text(
                widget.orderData['email'].toString(),
                style: TextStyle(
                    color: lightText,
                    fontSize: 13,
                    fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 3),
              Text(
                widget.orderData['shipping']['shipping_address_1'].toString() +
                    ", " +
                    widget.orderData['shipping']['shipping_city'].toString(),
                style: TextStyle(
                    color: lightestText,
                    fontSize: 13,
                    fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.calendar_today,
                        size: 15,
                      ),
                      SizedBox(width: 8),
                      Text(
                        diffDays == 0 ? "TODAY" :widget.orderData['delivery_date'].toString() ,
                        style: TextStyle(
                            color: diffDays == 0 ? transparentREd : lightestText,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        size: 15,
                      ),
                      SizedBox(width: 8),
                      Text(
                        widget.orderData['time_slot'].toString(),
                        style: TextStyle(
                            color:  diffDays == 0 ? transparentREd : lightestText,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Store: ",
                        style: TextStyle(
                            color: lightestText,
                            fontSize: 12,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        widget.orderData['store_name'].toString(),
                        style: TextStyle(
                            color: tealColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Order Type: ",
                        style: TextStyle(
                            color: lightestText,
                            fontSize: 12,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        widget.orderData['store_type'].toString().toUpperCase(),
                        style: TextStyle(
                            color: tealColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      
                    ],
                  ),
                 // diffDays == 0 ? Icon(Icons.stars, color: Colors.pink) : Container(),
                ],
              ),
              /*SizedBox(height: 5),
              Divider(),
              SizedBox(height: 5),
              Text(
                "ITEMS",
                style: TextStyle(
                    color: iconColor, fontSize: 13, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 7),
              Column(
                children: <Widget>[], //getItems(),
              )*/
              widget.orderData['order_accepted'].toString() == "0"
                  ? SizedBox(
                      height: 10,
                    )
                  : Container(),
              widget.orderData['order_accepted'].toString() == "0" && widget.isEditable
                  ? Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            height: 30,
                            color: Colors.red[800],
                            child: FlatButton(
                              onPressed: widget.declineOrder,
                              child: Text(
                                "Decline",
                                style: TextStyle(color: white),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            height: 30,
                            color: blueColor,
                            child: FlatButton(
                              onPressed: widget.acceptOrder,
                              child: Text(
                                "Accept",
                                style: TextStyle(color: white),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  : Container()
            ],
          )),
    );
  }

  List<Widget> getItems() {
    List<Widget> itemsList = new List();
    List items = widget.orderData["items"] as List;
    //print(widget.orderData['name']);
    for (int i = 0; i < items.length; i++) {
      itemsList.add(new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 10,
            child: Text(
              "•  " + items[i]['name'],
              style: TextStyle(
                  color: lightText,
                  fontSize: 11.5,
                  fontWeight: FontWeight.normal),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              items[i]['quantity'] + "x",
              style: TextStyle(
                  color: lightText,
                  fontSize: 11.5,
                  fontWeight: FontWeight.normal),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              inr + double.parse(items[i]['total']).toStringAsFixed(2),
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: lightText,
                  fontSize: 11.5,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ));
      itemsList.add(
        SizedBox(height: 5),
      );
    }

    return itemsList;
  }
}
