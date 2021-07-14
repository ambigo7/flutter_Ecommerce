import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/commons/common.dart';
import 'package:lets_shop/components/custom_text.dart';
import 'package:lets_shop/components/expandable_text.dart';
import 'package:lets_shop/provider/user_provider.dart';
import 'package:lets_shop/screens/order.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';


class PaymentScreen extends StatefulWidget {
  final String orderId;
  final int totalPrice;

  const PaymentScreen({Key key, this.orderId, this.totalPrice}) : super(key: key);
  
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
  
  final _key = GlobalKey<ScaffoldState>();
  
  String _orderId;
  int _totalPrice;
  String _numberAccount = '1543 0100 9224 501';


  
  @override
  void initState() {
    _orderId = widget.orderId;
    _totalPrice = widget.totalPrice;
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
            onPressed: () async{
              await userProvider.getOrders();
              changeScreen(context, OrdersScreen());
            }),
      ),
      body: Container(
        color: grey.withOpacity(0.1),
        child: ListView(
            children: <Widget>[
              attention(),
              Container(
                height: 40,
                color: white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CustomText(text: 'Total Payment'),
                      CustomText(text: '${formatCurrency.format(_totalPrice)}', color: blue, weigth: FontWeight.bold,),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              bankAccount(),
              SizedBox(height: 10,),
              Container(
                color: white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 10,),
                          Icon(
                            Icons.cloud_upload_outlined,
                            color: blue,
                            size: 25,),
/*                          RichText(
                            text: TextSpan(
                                text: 'Proof of payment ',
                                style: TextStyle(fontSize: 16, color: black),
                                children: <TextSpan>[
                                  TextSpan(text: '(Screenshot from mBanking/iBanking, or ATM Receipt)',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 10,
                                          color: green))
                                ]
                            ),
                          ),*/
                          SizedBox(width: 15,),
                          CustomText(text: 'Proof of payment ',),
                          GestureDetector(
                            onTap: (){
                              _key.currentState.showSnackBar(
                                  SnackBar(
                                      content: Text("Screenshot of mBanking/iBanking transaction details, or ATM receipt",
                                          style: TextStyle(color: blue)),
                                      backgroundColor: white
                                  ));
                            },
                            child: Icon(LineIcons.questionCircle, color: grey, size: 20,),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ]
        ),
      ),
    );
  }
  Widget attention(){
    return Container(
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
    );
  }

  Widget bankAccount(){
    return Container(
      color: white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 5,),
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  height: 20,
                  width: 40,
                  child: Image.asset(
                    "images/bri.png",
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10,),
                CustomText(text: 'Bank BRI'),
              ],
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 0, 8),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Divider(color: grey,),
                    SizedBox(height: 10,),
                    CustomText(text: 'Account Number :', size: 14,),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CustomText(text: _numberAccount, size: 25, color: blue,),
                        InkWell(
                            onTap: (){
                              Clipboard.setData(ClipboardData(text: _numberAccount))
                                  .then((value) {
                                _key.currentState.showSnackBar(SnackBar(
                                  backgroundColor: white,
                                  content: Text('Copied to clipboard successfully',
                                      style: TextStyle(color: blue)),
                                ));
                              });
                            },
                            child: CustomText(
                              text: 'COPY',
                              size: 18,
                              color: green,)
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Divider(color: grey,),
                    SizedBox(height: 10,),
                    RichText(
                      text: TextSpan(
                          text: 'Bank account under the name (of) :',
                          style: TextStyle(fontSize: 14, color: black),
                          children: <TextSpan>[
                            TextSpan(text: '\nDendi Rizka Poetra',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: green))
                          ]
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      child: ExpandableText(
                        text: 'Make sure you transfer the money according to the total payment as you see above. '
                            'If you transfer more than the total payment, the remaining money will be returned with your order '
                            'when the order is shipped. However, if the transfer is less than the total payment, the admin has '
                            'the right to immediately cancel the order.',
                        align: TextAlign.justify,
                        size: 14,
                        colorButton: blue,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: <Widget>[
                        CustomText(text: 'Accept transfers from other banks', size: 14,),
                        SizedBox(height: 5,),
                        GestureDetector(
                          onTap: (){
                            _key.currentState.showSnackBar(
                                SnackBar(
                                    content: Text("Admin transfer fees from other banks are charged to the buyer",
                                        style: TextStyle(color: blue)),
                                    backgroundColor: white
                                ));
                          },
                          child: Icon(LineIcons.exclamationCircle, color: grey, size: 18,),
                        ),
                      ],
                    )
                    /*CustomText(text: 'Accept transfers from other banks (No subsidy bank admin fees)', size: 14,)*/
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
