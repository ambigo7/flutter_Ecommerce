import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/components/custom_text.dart';
import 'package:intl/intl.dart';
import 'package:lets_shop/provider/user_provider.dart';
import 'package:line_icons/line_icons.dart';
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
  final _key = GlobalKey<ScaffoldState>();
  final dateTomorrow = DateTime.now().add(Duration(days: 1));
  int _selectedShippingCharged;
  int _totalPayment;
  bool _checkExpress = false;
  bool _checkPick = false;
  bool _fromTop = true;

  final _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();


  TextEditingController _message = TextEditingController();

  getShippingCharge(int charges){
    setState(() {
      _selectedShippingCharged = charges;
    });
  }
  getTotalPayment(int shipping, int product){
    setState(() {
      _totalPayment = shipping+product;
    });
  }


  @override
  void initState() {
    getShippingCharge(0);
    getTotalPayment(0, widget.total);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');

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
                shippingOptionPayment()
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
                    borderRadius: BorderRadius.circular(10), color: blue),
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
          shippingDialog();
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
            child: userProvider.userModel.phone == 0
                ? Row(
                    children: <Widget>[
                      CustomText(text: userProvider.userModel.name+' '),
                      InkWell(
                        onTap: (){
                          _key.currentState.showSnackBar(
                              SnackBar(content: Text("Please, add your shipping address", style: TextStyle(color: blue)),
                                  backgroundColor: white
                              ));
                        },
                        child: Icon(LineIcons.exclamationCircle, color: grey, size: 18,),
                      ),
                    ],
                  )
                : CustomText(
                      text: userProvider.userModel.name+' | (+'+userProvider.userModel.phone.toString()+')\n'
                            +userProvider.userModel.address,)
          ),
          trailing: Icon(Icons.arrow_forward_ios_outlined),
        ),
      ),
    );
  }

  void shippingDialog(){
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var dialog = Align(
      alignment: _fromTop ? Alignment.topCenter : Alignment.bottomCenter,
      child: Container(
        height: 350,
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Material(
                    elevation: 0.0,
                    color: white,
                    borderRadius: BorderRadius.circular(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(width: 25,),
                        userProvider.userModel.phone == 0
                            ? CustomText(text: 'Add Shipping Address \t\t\t ', weigth: FontWeight.bold, size: 21, color: blue)
                            : CustomText(text: 'Edit Shipping Address \t\t\t ', weigth: FontWeight.bold, size: 21, color: blue),
                        InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.cancel_outlined,
                              color: grey, size: 30,)
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.black.withOpacity(0.1),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: ListTile(
                                    title: TextFormField(
                                      controller: _phoneController,
                                      decoration: InputDecoration(
                                          hintText: 'Phone Number',
                                          icon: Icon(Icons.local_phone_outlined),
                                          border: InputBorder.none),
                                      keyboardType: TextInputType.phone,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'You must enter the phone number';
                                        }
                                        return null;
                                      },
                                    )
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.black.withOpacity(0.1),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: ListTile(
                                  title: TextFormField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    controller: _addressController,
                                    decoration: InputDecoration(
                                        hintText: 'Address',
                                        icon: Padding(
                                          padding: const EdgeInsets.only(bottom: 80),
                                          child: Icon(Icons.home_outlined),
                                        ),
                                        border: InputBorder.none
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'You must enter the address';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                            child: Material(
                                borderRadius: BorderRadius.circular(10.0),
                                color: blue,
                                elevation: 0.0,
                                child: MaterialButton(
                                    onPressed: (){
                                      //TODO: buat fungsi di provider sama service update user, abis itu di reload user biar realtime datanya
                                    },
                                    minWidth: MediaQuery.of(context).size.width,
                                    child:  userProvider.userModel.phone == 0
                                        ? CustomText(text: 'Add', weigth: FontWeight.bold, color: white,)
                                        : CustomText(text: 'Update', weigth: FontWeight.bold, color: white,)
                                )
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        margin: EdgeInsets.only(top: 200, left: 30, right: 30, bottom: 50),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );

    showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 700),
        context: context,
        pageBuilder: (context, anim1, anim2){
          return dialog;
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position: Tween(begin: Offset(0, _fromTop ? -1 : 1), end: Offset(0, 0)).animate(anim1),
            child: child,
            );
    });
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

  Widget shippingOptionPayment(){
    final userProvider = Provider.of<UserProvider>(context);
    return Column(
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
                  title: Row(
                    children: <Widget>[
                      Icon(LineIcons.shippingFast, color: blue,),
                      CustomText(text: '  Shipping Options')
                    ],
                  ),
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        InkWell(
                          onTap: (){
                            getShippingCharge(10000);
                            _checkExpress = true;
                            _checkPick = false;
                            getTotalPayment(_selectedShippingCharged, userProvider.userModel.totalCartPrice);
                            print('total payment : $_totalPayment');
                            print('ceklist : $_checkExpress');
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
                            trailing: _checkExpress ? Icon(Icons.check_outlined, color: blue) : null,
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            getShippingCharge(2500);
                            _checkExpress = false;
                            _checkPick = true;
                            getTotalPayment(_selectedShippingCharged, userProvider.userModel.totalCartPrice);
                            print('total payment : $_totalPayment');
                            print('ceklist express : $_checkExpress');
                            print('ceklist pick : $_checkPick');
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
                            trailing: _checkPick ? Icon(Icons.check_outlined, color: blue) : null,
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
                  CustomText(text: '  Payment Method'),
                  GestureDetector(
                    onTap: (){
                      _key.currentState.showSnackBar(
                          SnackBar(content: Text("Sorry, for now only support direct bank transfer", style: TextStyle(color: blue)),
                              backgroundColor: white
                          ));
                    },
                    child: Icon(LineIcons.questionCircle, color: grey, size: 18,),
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
                    CustomText(text: 'Subtotal for products ',
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
                    CustomText(text: 'Subtotal for shipping ',
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
                    CustomText(text: 'Total payment ', size: 18,),
                    CustomText(
                      text: '${formatCurrency.format(_totalPayment)}', size: 18,)
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}