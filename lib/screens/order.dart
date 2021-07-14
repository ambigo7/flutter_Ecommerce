import 'package:flutter/material.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/commons/common.dart';
import 'package:lets_shop/components/column_builder.dart';
import 'package:lets_shop/components/custom_text.dart';
import 'package:lets_shop/models/order.dart';
import 'package:lets_shop/provider/user_provider.dart';
import 'package:lets_shop/screens/home.dart';
import 'package:lets_shop/screens/payment.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

//PACKAGE MONEY FORMATTER
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:transparent_image/transparent_image.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');

  DateFormat dateFormat;
  /*final formatDate = new DateFormat('yMd', 'id_ID').add_Hm();*/

  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    initializeDateFormatting();
    dateFormat = new DateFormat.yMMMd('id_ID').add_Hm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  ====CREATE MONEY CURRENCY FORMATTER====

    final userProvider = Provider.of<UserProvider>(context);
    //TODO: Redesign UI Orders History!!!

    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: blue),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(text: "Orders History", size: 20, color: blue, weigth: FontWeight.bold,),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              changeScreen(context, HomePage());
            }),
      ),
      backgroundColor: white,
      body: Container(
        color: grey.withOpacity(0.1),
        child: ListView.builder(
            itemCount: userProvider.orders.length,
            itemBuilder: (_, index){
              OrderModel _order = userProvider.orders[index];
              return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Container(
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CustomText(text: 'Order Status'),
                              _order.status == "Completed"
                                  ? CustomText(text: _order.status, color: green)
                                  : _order.status == "Incomplete"
                                  ? CustomText(text: _order.status, color: redAccent)
                                  : CustomText(text: _order.status, color: Colors.yellow)
                            ],
                          ),
                          SizedBox(height: 10,),
                          ExpansionTile(
                            title: Row(
                              children: <Widget>[
                                Container(
                                  color: blue,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        height: 40,
                                        width: 80,
                                        child: Center(child: CustomText(text: "${_order.cart.length.toString()}""x", color: white, size: 20,))
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    CustomText(text: _order.description),
                                    CustomText(text: _order.service),
                                    CustomText(text:'${formatCurrency.format(_order.totalPrice)}'),
                                  ],
                                )
                              ],
                            ),
                            expandedCrossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CustomText(
                                        text: 'Message order '),
                                    _order.message.isEmpty
                                        ? CustomText(text: '---')
                                        : CustomText(text: _order.message)
                                  ],
                                ),
                              ),
                              ColumnBuilder(
                                itemCount: _order.cart.length,
                                  itemBuilder: (_, index){
                                  return ListTile(
                                    leading: Container(
                                      height: 80,
                                      width: 80,
                                      child: FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: _order.cart[index].image,
                                        fit: BoxFit.fill,
                                        height: 120,
                                        width: 140,
                                      ),
                                    ),
                                    title: CustomText(text: _order.cart[index].name),
                                    subtitle: CustomText(text: '${formatCurrency.format(_order.cart[index].price)}',),
                                  );
                                }),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CustomText(text: 'Service Charges '),
                                    CustomText(text: '${formatCurrency.format(_order.charges)}')
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(color: blue),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: (){
                                        showDialog(
                                            context: context,
                                            builder: (_){
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.0)),
                                                child: Container(
                                                  height: 200,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(12.0),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        SizedBox(height: 5,),
                                                        CustomText(text: 'MyOptik Guarantee', weigth: FontWeight.bold,),
                                                        SizedBox(height: 15,),
                                                        CustomText(text: 'MyOptik Guarantee'), //TODO: buat pesan garansi!!
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                        child: Icon(
                                          Icons.security_rounded,
                                          color: blue,)
                                    ),
                                    CustomText(text: '  Amount Payable ')
                                  ],
                                ),
                              ),
                              CustomText(text: '${formatCurrency.format(_order.totalPayment)}')
                            ],
                          ),
                          Divider(color: blue),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CustomText(text: 'Server time when order is made\n'
                                  '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.createdAt))}',
                                color: grey,),
                              _order.status == "Incomplete"
                                  ? Container(
                                    height: 35,
                                    child: Material(
                                        borderRadius: BorderRadius.circular(5.0),
                                        color: blue,
                                        elevation: 0.0,
                                        child: MaterialButton(
                                          onPressed: (){
                                            changeScreen(context, PaymentScreen(orderId: _order.id, totalPrice: _order.totalPayment,));
                                          },
                                          child: CustomText(text: 'Pay Now', color: white,),
                                        )
                                    ),
                                  ) : Container()
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}