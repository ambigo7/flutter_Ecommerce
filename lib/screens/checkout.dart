import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/components/custom_text.dart';
import 'package:intl/intl.dart';
import 'package:lets_shop/provider/user_provider.dart';
import 'package:provider/provider.dart';

class CheckOut extends StatefulWidget {
  final int total;

  const CheckOut({Key key, this.total}) : super(key: key);

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {

  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
  final formatDate = new DateFormat.MMMMd();

  final _formKey = GlobalKey<FormState>();
  final dateTomorrow = DateTime.now().add(Duration(days: 1));
  int _selectedShippingCharged;
  int _totalPayment;
  bool checkListExpress = false;
  bool checkListPick = false;
  bool expansionDown = false;


  TextEditingController _message = TextEditingController();

  _getShippingCharge(int charges){
    setState(() {
      _selectedShippingCharged = charges;
    });
  }
  _getTotalPayment(int shipping, int product){
    setState(() {
      _totalPayment = shipping+product;
    });
  }


  @override
  void initState() {
    _getShippingCharge(0);
    _getTotalPayment(0, widget.total);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
    final _key = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _key,
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        title: CustomText(
            text: 'Check Out',
            size: 23, color: blue,
            weigth: FontWeight.bold),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: blue,),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 7, 0, 12),
          child: ListView(
              children: <Widget>[
                shippingAddress(),
                dashedHorizontalLine(),
                Column(
                  children: <Widget>[
                    Container(
                      height: 50,
                      color: white,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 15, bottom: 2.5),
                            child: Icon(
                              Icons.storefront_outlined,
                              color: blue,
                              size: 19,),
                          ),
                          CustomText(text: '  Optik Citra Abadi', weigth: FontWeight.bold,)
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              color: blue,
                              width: 80,
                              child: Center(
                                  child:
                                  CustomText(
                                    text: userProvider.userModel.countCart.toString()+'x',
                                    color: white,
                                  )
                              )
                          )
                      ),
                      title: userProvider.userModel.countCart == 1
                          ? CustomText(
                          text: 'Purchase of '+userProvider.userModel.countCart.toString()+' item',
                          size: 18)
                          : CustomText(
                          text: 'Purchase of '+userProvider.userModel.countCart.toString()+' items',
                          size: 18),
                      subtitle: CustomText(text: '${formatCurrency.format(userProvider.userModel.totalCartPrice)}',),
                    ),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: greenAccent)),
                      child: Material(
                        color: greenAccent.withOpacity(0.2),
                        child: Column(
                          children: <Widget>[
                            ExpansionTile(
                              title: CustomText(text: 'Shipping Options'),
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: (){
                                        _getShippingCharge(10000);
                                        checkListExpress = true;
                                        checkListPick = false;
                                        _getTotalPayment(_selectedShippingCharged, userProvider.userModel.totalCartPrice);
                                        print('total payment : $_totalPayment');
                                        print('ceklist : $checkListExpress');
                                        print('shipping value : $_selectedShippingCharged');
                                      },
                                      child: ListTile(
                                        title: CustomText(text: 'MyOptik Express', weigth: FontWeight.bold,),
                                        subtitle: Padding(
                                            padding: const EdgeInsets.only(bottom: 13),
                                            child: CustomText(
                                              text: 'Estimated arrival one working day - ${formatDate.format(dateTomorrow)}',
                                              color: grey,
                                              size: 14,
                                            )
                                        ),
                                        trailing: checkListExpress ? Icon(Icons.check_outlined, color: blue) : null,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        _getShippingCharge(2500);
                                        checkListExpress = false;
                                        checkListPick = true;
                                        _getTotalPayment(_selectedShippingCharged, userProvider.userModel.totalCartPrice);
                                        print('total payment : $_totalPayment');
                                        print('ceklist express : $checkListExpress');
                                        print('ceklist pick : $checkListPick');
                                        print('shipping value : $_selectedShippingCharged');
                                      },
                                      child: ListTile(
                                        title: CustomText(text: 'Pick up by yourself', weigth: FontWeight.bold,),
                                        subtitle: Padding(
                                            padding: const EdgeInsets.only(bottom: 13),
                                            child: CustomText(
                                              text: 'Anytime you want - Working hour and day',
                                              color: grey,
                                              size: 14,
                                            )
                                        ),
                                        trailing: checkListPick ? Icon(Icons.check_outlined, color: blue) : null,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Divider(color: greenAccent),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 12, 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CustomText(text: 'Shipping charges :'),
                                    CustomText(text: '${formatCurrency.format(_selectedShippingCharged)}')
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      color: white,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 12),
                        child: Row(
                          children: <Widget>[
                            CustomText(text: 'Message : '),
                            Expanded(
                              child: TextFormField(
                                textAlign: TextAlign.end,
                                controller: _message,
                                decoration: InputDecoration(
                                    hintText: 'Message for admin...',
                                    border: InputBorder.none),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8,),
                    Container(
                      color: white,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 15, bottom: 2.5),
                                child: Icon(
                                  Icons.monetization_on_outlined,
                                  color: blue,
                                  size: 19,),
                              ),
                              CustomText(text: '  Payment Method '),
                              GestureDetector(
                                onTap: (){
                                  _key.currentState.showSnackBar(
                                      SnackBar(content: Text("Currently only supports direct bank transfer payment method", style: TextStyle(color: blue)),
                                          backgroundColor: white
                                      ));
                                },
                                child: Icon(Icons.contact_support_outlined, color: grey, size: 15,),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: CustomText(text: 'Direct Bank Transfer - Bank\nBRI(Check Manually)'),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CustomText(text: 'Subtotal for products : ',
                                  size: 14, color: grey,),
                                CustomText(
                                  text: '${formatCurrency.format(userProvider.userModel.totalCartPrice)}',
                                  size: 14, color: grey,)
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CustomText(text: 'Subtotal for shipping : ',
                                  size: 14, color: grey,),
                                CustomText(
                                  text: '${formatCurrency.format(_selectedShippingCharged)}',
                                  size: 14, color: grey,)
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CustomText(text: 'Total payment : ', size: 18,),
                                CustomText(
                                  text: '${formatCurrency.format(_totalPayment)}', size: 18,)
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ]
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: white,
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomText(text: 'Total Payment', color: grey, size: 18,),
                  CustomText(text: '${formatCurrency.format(_totalPayment)}', size: 22,),
                ],
              ),
              Container(
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: blue),
                child: FlatButton(
                    onPressed: () {

                    },
                    child: CustomText(
                      text: 'Order',
                      size: 20,
                      color: white,
                      weigth: FontWeight.normal,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget shippingAddress(){
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Container(
      color: grey.withOpacity(0.1),
      child: GestureDetector(
        onTap: (){

        },
        child: ListTile(
          title: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Icon(
                  Icons.location_on_outlined,
                  color: blue,
                  size: 19,),
              ),
              CustomText(text: 'Shipping Address',)
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 20, top: 3),
            child: CustomText(text: userProvider.userModel.name+' | (+'+userProvider.userModel.phone.toString()+')\n'
                +userProvider.userModel.address,),
          ),
          trailing: Icon(Icons.arrow_forward_ios_outlined),
        ),
      ),
    );
  }
  Widget dashedHorizontalLine(){
    return Container(
      color: grey.withOpacity(0.1),
      child: Row(
        children: [
          for (int i = 0; i < 20; i++)
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: blue,
                      thickness: 2,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
