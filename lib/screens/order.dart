import 'package:flutter/material.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/components/custom_text.dart';
import 'package:lets_shop/models/order.dart';
import 'package:lets_shop/provider/user_provider.dart';
import 'package:provider/provider.dart';

//PACKAGE MONEY FORMATTER
import 'package:intl/intl.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //  ====CREATE MONEY CURRENCY FORMATTER====
    final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');

    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: redAccent),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(text: "Orders History", size: 20, color: redAccent, weigth: FontWeight.bold,),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: white,
      body: ListView.builder(
          itemCount: userProvider.orders.length,
          itemBuilder: (_, index){
            OrderModel _order = userProvider.orders[index];
            return ListTile(
              leading: CustomText(
                text: "${formatCurrency.format(_order.total)}",
                weigth: FontWeight.bold,
              ),
              title: Text(_order.description),
              subtitle: Text(DateTime.fromMillisecondsSinceEpoch(_order.createdAt).toString()),
              trailing: CustomText(text: _order.status, color: Colors.green,),
            );
          }),
    );
  }
}