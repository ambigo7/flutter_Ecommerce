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
import 'package:map_launcher/map_launcher.dart';
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
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: blue),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(text: "Orders History", size: 20, color: blue, weight: FontWeight.bold,),
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
        child: userProvider.orders.length < 1? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.shopping_basket_outlined, color: grey, size: 30,),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomText(text: "No order history found", color: grey, weight: FontWeight.w300, size: 22,),
              ],
            )
          ],
        ) : ListView.builder(
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
                              CustomText(
                                  text: _order.status,
                                  weight: FontWeight.bold,
                                  color: _order.status == "Completed"
                                      ? green
                                      : _order.status == "Delivery" || _order.status == "Ready to pick up"
                                      ? yellow
                                      : redAccent
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                          //PRODUCT LIST
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
                                    CustomText(text: _order.id.toUpperCase(), weight: FontWeight.bold,),
                                    CustomText(text: _order.description),
                                    CustomText(text: _order.service),
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
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        CustomText(text: 'Subtotal for product'),
                                        CustomText(text: '${formatCurrency.format(_order.totalPrice)}')
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        CustomText(text: 'Subtotal for shipping '),
                                        CustomText(text: '${formatCurrency.format(_order.charges)}'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(color: blue),
                          //Amount Payable
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    InkWell(
                                        onTap: (){
                                          dialogGuarantee();
                                        },
                                        child: Icon(
                                          Icons.security_rounded,
                                          color: blue,)
                                    ),
                                    CustomText(text: '  Amount Payable ')
                                  ],
                                ),
                              ),
                              CustomText(text: '${formatCurrency.format(_order.totalPayment)}', weight: FontWeight.bold,)
                            ],
                          ),
                          Divider(color: blue),
                          //TimeRecod & Button Pay Now/Completed Order
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      CustomText(text: 'Order Time              '
                                          '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.orderTime))}',
                                        color: grey,),
                                      Visibility(
                                        visible: _order.paymentTime != 0 ? true : false,
                                        child: CustomText(text: 'Payment Time        '
                                            '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.paymentTime))}',
                                          color: grey,),
                                      ),
                                      Visibility(
                                        visible: _order.shipTime != 0 ? true : false,
                                        child: CustomText(text: 'Ship Time                '
                                            '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.shipTime))}',
                                          color: grey,),
                                      ),
                                      Visibility(
                                        visible: _order.completedTime != 0 ? true : false,
                                        child: CustomText(text: 'Completed Time    '
                                            '${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_order.shipTime))}',
                                          color: grey,),
                                      ),
                                    ],
                                  ),
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
                              ) :  _order.status == "Ready to pick up"
                              ? Container(
                                height: 35,
                                child: Material(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: blue,
                                    elevation: 0.0,
                                    child: MaterialButton(
                                      onPressed: () async{
                                        try{
                                          final _destination = Coords(-6.435016, 106.796727);
                                          final _destinationTitle = "Optik Citra Abadi";
                                          final availableMaps = await MapLauncher.installedMaps;
                                          print(availableMaps);

                                          for (var map in availableMaps)
                                            map.showDirections(
                                                destination: _destination,
                                                destinationTitle: _destinationTitle,
                                            );
                                        }catch(e){
                                          print(e);
                                        }
                                      },
                                      child: CustomText(text: 'Pick up', color: white,),
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

  void dialogGuarantee(){
    var dialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        height: 350,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 5,),
              CustomText(
                text: 'MyOptik Guarantee',
                weight: FontWeight.bold, size: 20,
                color: blue,
              ),
              SizedBox(height: 15,),
              CustomText(
                text: "MyOptik Guarantee is a guarantee for buyers if the order that has been ordered and paid for "
                    "does not arrive or the item ordered was damaged during shipping. Then the buyer can submit a "
                    "complaint to myoptic@gmail.com with complete evidence so that an investigation can be carried "
                    "out by the Admin team and the order will be re-send immediately according to the ordered items"
                    "or a refund can be given according to the buyer's agreement and MyOptik conditions.",
                align: TextAlign.center,
              ),
              SizedBox(height: 15,),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                    color: blue,
                    borderRadius: BorderRadius.all(
                        Radius.circular(5.0)
                    ),
                  ),
                  child: Center(child: CustomText(text: "Ok, i'm understand", color: white,)),
                ),
              )
            ],
          ),
        ),
      ),
    );
    showDialog(context: context, builder: (_) => dialog);
  }
}