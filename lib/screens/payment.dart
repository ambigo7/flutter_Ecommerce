import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/commons/common.dart';
import 'package:lets_shop/components/custom_text.dart';
import 'package:lets_shop/provider/user_provider.dart';
import 'package:lets_shop/screens/order.dart';
import 'package:provider/provider.dart';


class PaymentScreen extends StatefulWidget {
  final String orderId;

  const PaymentScreen({Key key, this.orderId}) : super(key: key);
  
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
  
  final _key = GlobalKey<ScaffoldState>();
  
  String _orderId;
  
  @override
  void initState() {
    _orderId = widget.orderId;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: white,
        title: CustomText(
            text: 'Payment',
            size: 23, color: blue,
            weigth: FontWeight.bold),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: blue,),
            onPressed: () {
              userProvider.reloadUserModel();
              changeScreen(context, OrdersScreen());
            }),
      ),
      body: ListView(
          children: <Widget>[
            Container(
              height: 100,
              color: orange.withOpacity(0.5),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 10,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Icon(Icons.notifications_active_outlined),
                  ),
                  SizedBox(width: 20,),
                  CustomText(text: "ATTENTION: For now only supports direct bank \n"
                      "transfers to the bank account of the owner's \n"
                      "Optik Citra Abadi and will be checked manually \nby the admin")
                ],
              ),
            )

          ]
      ),
    );
  }
}
