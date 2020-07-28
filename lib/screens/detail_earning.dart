import 'package:flutter/material.dart';
import 'package:tictapp_seller/utils/common.dart';

class DetailEarning extends StatefulWidget {
  dynamic earningObject;
  DetailEarning(this.earningObject);
  @override
  _DetailEarningState createState() => _DetailEarningState();
}

class _DetailEarningState extends State<DetailEarning> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(centerTitle: true, title: Text("Driver Report")),

      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
             
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Total Order Processed:",
                style: TextStyle(
                  color: tealColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),),
                Text(widget.earningObject['total_orders'],
                style: TextStyle(
                  color: darkText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),)
              ],
            ),
            Divider(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Total Sales Order:",
                style: TextStyle(
                  color: tealColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),),
                Text(widget.earningObject['orders_amount'],
                style: TextStyle(
                  color: darkText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),)
              ],
            ),
            Divider(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Total Collected Cash:",
                style: TextStyle(
                  color: tealColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),),
                Text(widget.earningObject['cashCollected'],
                style: TextStyle(
                  color: darkText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),)
              ],
            ),
            Divider(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Total Commission for Delivery:",
                style: TextStyle(
                  color: tealColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),),
                Text(widget.earningObject['driverTotalCommissionEarningsPickup'],
                style: TextStyle(
                  color: darkText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),)
              ],
            ),
            Divider(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Total Commission for Shopping:",
                style: TextStyle(
                  color: tealColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),),
                Text(widget.earningObject['driverTotalCommissionEarningsShopping'],
                style: TextStyle(
                  color: darkText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),)
              ],
            ),
            Divider(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Total Tips:",
                style: TextStyle(
                  color: tealColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),),
                Text(widget.earningObject['total_tips'],
                style: TextStyle(
                  color: darkText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),)
              ],
            ),
            Divider(height: 40,),

            //Divider(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Total Earnings:",
                style: TextStyle(
                  color: blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),),
                Text(widget.earningObject['driverTotalEarnings'],
                style: TextStyle(
                  color: darkText,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),)
              ],
            ),
            Divider(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("POS Procesed Amount:",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),),
                Text(widget.earningObject['posCollected'],
                style: TextStyle(
                  color: darkText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),)
              ],
            ),
            Divider(height: 20,),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Bank Deposits:",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),),
                Text(widget.earningObject['totalBankDeposit'],
                style: TextStyle(
                  color: darkText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),)
              ],
            ),
            Divider(height: 20,),

          ],
        ),
      ),
    );
  }
}