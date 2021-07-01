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
    String _length = userProvider.orders.length.toString();

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
          itemCount: userProvider.orders.length, // TODO: masih salah, harusnya cart yg dihitung bukan doc orders
          itemBuilder: (_, index){
            OrderModel _order = userProvider.orders[index];
            return ListTile(
              leading: Container(
                color: redAccent,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 80,
                    child: Center(child: CustomText(text: "$_length""x", color: white, size: 20,))
                  ),
                ),
              ),
/*              CustomText(
                text: "${formatCurrency.format(_order.total)}",
                weigth: FontWeight.bold,
              ),*/
              title: Text(_order.description),
              subtitle: Text(DateTime.fromMillisecondsSinceEpoch(_order.createdAt).toString()),
              trailing: _order.status == "Completed"
                  ? CustomText(text: _order.status, color: Colors.green)
                  : _order.status == "Incomplete"
                ? CustomText(text: _order.status, color: Colors.redAccent)
                  : CustomText(text: _order.status, color: Colors.yellow)
            );
          }),
    );
  }
}