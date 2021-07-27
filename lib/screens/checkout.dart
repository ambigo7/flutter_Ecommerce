import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/commons/common.dart';
import 'package:lets_shop/commons/loading.dart';
import 'package:lets_shop/commons/random_string.dart';
import 'package:lets_shop/components/custom_text.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lets_shop/models/cart_item.dart';
import 'package:lets_shop/provider/user_provider.dart';
import 'package:lets_shop/screens/payment.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class CheckOut extends StatefulWidget {
  final int totalPrice;

  const CheckOut({Key key, this.totalPrice}) : super(key: key);

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> with TickerProviderStateMixin {

  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');

  DateFormat formatDate ;

  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  final dateTomorrow = DateTime.now().add(Duration(days: 1));
  ScrollController _scrollController = ScrollController();
  String _selectedShippingService;
  int _selectedShippingCharged;
  int _totalPayment;

  bool _checkExpress = false;
  bool _checkPick = false;
  bool _shippingDialog = false;
  bool _loading = false;
  bool _fromTop = true;
  bool _onExpansionClicked = false;

  void _scrollToBottom(bool event){
    if(event){
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn);
    }else{
      return null;
    }
  }

  Color active = blue;
  Color noActive = grey;

  AnimationController _animationController;

  TextEditingController _messageController = TextEditingController();

  TextEditingController _phoneInitial = TextEditingController();
  TextEditingController _addressInitial = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

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
    getTotalPayment(0, widget.totalPrice);
    _selectedShippingService = "";
    initializeDateFormatting();
    formatDate = new DateFormat.MMMd('id_ID');
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final formatCurrency = new NumberFormat.simpleCurrency(locale: 'id_ID');
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        title: CustomText(
            text: 'Check Out',
            size: 23, color: blue,
            weight: FontWeight.bold),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: blue,),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: _loading
          ? Loading()
          : Container(
        color: grey.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 7, 0, 12),
          child: ListView(
            controller: _scrollController,
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
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (Widget child, Animation<double> animation){
                      return ScaleTransition(child: child, scale: animation,);
                    },
                    child: Text('${formatCurrency.format(_totalPayment)}',
                      key: ValueKey<int>(_totalPayment),
                      style: TextStyle(fontSize: 18, color: grey),
                    ),
                  ),
                ],
              ),
              Container(
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: blue),
                child: FlatButton(
                    onPressed: () async{
                      setState(() {
                        _loading = true;
                        print('loading value : $_loading');
                      });
                      if(_selectedShippingCharged == 0 || userProvider.userModel.phone == 0){
                        _key.currentState.showSnackBar(
                            SnackBar(content: Text("Please, select shipping options or add your shipping address", style: TextStyle(color: blue)),
                                backgroundColor: white
                            ));
                      }else{
                        String id = generateRandomString(15);

                        bool _createOrder = await userProvider.createOrder(
                            userProvider.user.uid, id, 'Orders '+userProvider.userModel.countCart.toString()+' item',
                            'Incomplete', _messageController.text, _selectedShippingService, _selectedShippingCharged,
                            userProvider.userModel.cart, widget.totalPrice, _totalPayment);
                        for (CartItemModel cartItem in userProvider.userModel.cart) {
                          bool value = await userProvider.removeFromCart(
                              cartItem: cartItem);
                          if (value) {
                            userProvider.reloadUserModel();
                            _key.currentState.showSnackBar(
                                SnackBar(
                                    backgroundColor: white,
                                    content: Text(
                                        "Removed from Cart!",
                                        style: TextStyle(
                                            color: blue))));
                          } else {
                            print("ITEM WAS NOT REMOVED");
                          }
                        }

                        if(_createOrder != true){
                          _key.currentState.showSnackBar(
                              SnackBar(content: Text("Order Failed", style: TextStyle(color: blue)),
                                  backgroundColor: white
                              ));
                        }else{
                          _key.currentState.showSnackBar(
                              SnackBar(content: Text("Order Created! Please, make payment", style: TextStyle(color: blue)),
                                  backgroundColor: white
                              ));
                          changeScreen(context, PaymentScreen(orderId: id, totalPrice: _totalPayment,));
                        }
                      }
                      setState(() {
                        _loading = false;
                      });
                    },
                    child: CustomText(
                      text: 'Order',
                      size: 20,
                      color: white,
                      weight: FontWeight.normal,
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
          setState(() {
            _shippingDialog = !_shippingDialog;
            _shippingDialog
                ? _animationController.forward()
                : _animationController.reverse();
          });
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
            trailing: AnimatedIcon(icon: AnimatedIcons.home_menu, progress: _animationController)
        ),
      ),
    );
  }

  void shippingDialog(){
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    _phoneInitial = TextEditingController(text: userProvider.userModel.phone.toString());
    _addressInitial = TextEditingController(text: userProvider.userModel.address);
    var dialog = Align(
      alignment: _fromTop ? Alignment.topCenter : Alignment.bottomCenter,
      child: Container(
        height: 395,
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
                        userProvider.userModel.phone == 0
                            ? SizedBox(width: 25,)
                            : SizedBox(width: 15,),
                        userProvider.userModel.phone == 0
                            ? CustomText(text: 'Add Shipping Address \t\t\t ', weight: FontWeight.bold, size: 21, color: blue)
                            : CustomText(text: 'Update Shipping Address  ', weight: FontWeight.bold, size: 21, color: blue),
                        InkWell(
                            onTap: (){
                              if(_phoneController != null || _addressController != null){
                                setState(() {
                                  _phoneController.clear();
                                  _addressController.clear();
                                });
                              }
                              setState(() {
                                /*_shippingDialog = false;*/
                                _shippingDialog = !_shippingDialog;
                                _shippingDialog
                                    ? _animationController.forward()
                                    : _animationController.reverse();
                              });
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
                                    title: userProvider.userModel.phone != 0
                                        ? TextFormField(
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      controller: _phoneInitial,
                                      decoration: InputDecoration(
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
                                        : TextFormField(
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      controller: _phoneController,
                                      decoration: InputDecoration(
                                          hintText: 'Ex: 628999992378',
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
                                  title: userProvider.userModel.address != ""
                                      ? TextFormField(
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    controller: _addressInitial,
                                    decoration: InputDecoration(
                                        icon: Padding(
                                          padding: const EdgeInsets.only(bottom: 80),
                                          child: Icon(Icons.home_outlined),
                                        ),
                                        border: InputBorder.none),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'You must enter the address';
                                      }
                                      return null;
                                    },
                                  )
                                      : TextFormField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    controller: _addressController,
                                    decoration: InputDecoration(
                                        hintText: 'Address',
                                        icon: Padding(
                                          padding: const EdgeInsets.only(bottom: 80),
                                          child: Icon(Icons.home_outlined),
                                        ),
                                        border: InputBorder.none),
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
                                    onPressed: () async{
                                      validateAddUpdateShipping(_phoneInitial.text, _addressInitial.text);
                                      setState(() {
                                        /*_shippingDialog = false;*/
                                        _shippingDialog = !_shippingDialog;
                                        _shippingDialog
                                            ? _animationController.forward()
                                            : _animationController.reverse();
                                      });
                                      Navigator.pop(context);
                                    },
                                    minWidth: MediaQuery.of(context).size.width,
                                    child:  userProvider.userModel.phone == 0
                                        ? CustomText(text: 'Add', weight: FontWeight.bold, color: white,)
                                        : CustomText(text: 'Update', weight: FontWeight.bold, color: white,)
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
        margin: EdgeInsets.only(top: 150, left: 30, right: 30, bottom: 50),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );

    showGeneralDialog(
        barrierLabel: "Label",
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 500),
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

  void validateAddUpdateShipping(phoneText,addressText) async{
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    _phoneInitial = TextEditingController(text: phoneText.toString());
    _addressInitial = TextEditingController(text: addressText.toString());

    if (_formKey.currentState.validate()) {
      if(userProvider.userModel.phone != 0) {
        if(_phoneInitial.text == userProvider.userModel.phone.toString()
            && _addressInitial.text == userProvider.userModel.address){
          _key.currentState.showSnackBar(SnackBar(
            backgroundColor: white,
            content: Text('No data has changed',
                style: TextStyle(color: blue)),
          ));
          setState(() {
            _shippingDialog = !_shippingDialog;
            _shippingDialog
                ? _animationController.forward()
                : _animationController.reverse();
          });
        }else{
          bool updateData = await userProvider.updatePhoneAddress(userProvider.userModel.id,
              _phoneInitial.text, _addressInitial.text);
          if(updateData != true){
            _key.currentState.showSnackBar(SnackBar(
              backgroundColor: white,
              content: Text('Update Failed',
                  style: TextStyle(color: blue)),
            ));
            setState(() {
              _shippingDialog = !_shippingDialog;
              _shippingDialog
                  ? _animationController.forward()
                  : _animationController.reverse();
            });
          }else{
            _key.currentState.showSnackBar(SnackBar(
              backgroundColor: white,
              content: Text('Update Success',
                  style: TextStyle(color: blue)),
            ));
            setState(() {
              _shippingDialog = !_shippingDialog;
              _shippingDialog
                  ? _animationController.forward()
                  : _animationController.reverse();
            });
            userProvider.reloadUserModel();
          }
        }
      }else{
        bool addData = await userProvider.updatePhoneAddress(userProvider.userModel.id,
            _phoneController.text, _addressController.text);
        if(addData != true){
          _key.currentState.showSnackBar(SnackBar(
            backgroundColor: white,
            content: Text('Update Failed',
                style: TextStyle(color: blue)),
          ));
          setState(() {
            _shippingDialog = !_shippingDialog;
            _shippingDialog
                ? _animationController.forward()
                : _animationController.reverse();
          });
        }else{
          _key.currentState.showSnackBar(SnackBar(
            backgroundColor: white,
            content: Text('Update Success',
                style: TextStyle(color: blue)),
          ));
          setState(() {
            _shippingDialog = !_shippingDialog;
            _shippingDialog
                ? _animationController.forward()
                : _animationController.reverse();
          });
          userProvider.reloadUserModel();
        }
      }
    }
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
              CustomText(text: '  Optik Citra Abadi', weight: FontWeight.bold,)
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
              text: 'Order '+userProvider.userModel.countCart.toString()+' item',
              size: 18)
              : CustomText(
              text: 'Orders '+userProvider.userModel.countCart.toString()+' items',
              size: 18),
          subtitle: CustomText(text: '${formatCurrency.format(userProvider.userModel.totalCartPrice)}',),
        ),
        Container(
          decoration: BoxDecoration(border: Border.all(color: greenAccent)),
          child: Material(
            color: greenAccent.withOpacity(0.2),
            child: Column(
              children: <Widget>[
                Theme(
                  data: ThemeData(accentColor: _onExpansionClicked ? active : noActive,),
                  child: ExpansionTile(
                    onExpansionChanged: (clicked){
                      setState(() {
                        _onExpansionClicked = clicked;
                      });
                    },
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
                              _scrollToBottom(true);
                              getShippingCharge(10000);
                              _selectedShippingService = "MyOptik Express";
                              _checkExpress = true;
                              _checkPick = false;
                              getTotalPayment(_selectedShippingCharged, userProvider.userModel.totalCartPrice);
                              print('total payment : $_totalPayment');
                              print('ceklist : $_checkExpress');
                              print('shipping value : $_selectedShippingCharged');
                              print('shipping service : $_selectedShippingService');
                            },
                            child: ListTile(
                              title: CustomText(text: 'MyOptik Express', weight: FontWeight.bold,),
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
                              _scrollToBottom(true);
                              getShippingCharge(2500);
                              _selectedShippingService = "Pick up";
                              _checkExpress = false;
                              _checkPick = true;
                              getTotalPayment(_selectedShippingCharged, userProvider.userModel.totalCartPrice);
                              print('total payment : $_totalPayment');
                              print('ceklist express : $_checkExpress');
                              print('ceklist pick : $_checkPick');
                              print('shipping value : $_selectedShippingCharged');
                              print('shipping service : $_selectedShippingService');
                            },
                            child: ListTile(
                              title: CustomText(text: 'Pick up by yourself', weight: FontWeight.bold,),
                              subtitle: Padding(
                                  padding: const EdgeInsets.only(bottom: 13),
                                  child: CustomText(
                                    text: 'When the order is ready - Working hour and day',
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textAlign: TextAlign.end,
                    controller: _messageController,
                    decoration: InputDecoration(
                        hintText: 'Message for admin...',
                        border: InputBorder.none),
                    validator: (value) {
                      if (value.length > 10) {
                        return 'Product name cant have more then 10 letters';
                      }
                      return null;
                    },
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
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (Widget child, Animation<double> animation){
                        return ScaleTransition(child: child, scale: animation,);
                      },
                      child: Text('${formatCurrency.format(_selectedShippingCharged)}',
                        key: ValueKey<int>(_selectedShippingCharged),
                        style: TextStyle(fontSize: 14, color: grey),
                      ),
                    ),
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
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (Widget child, Animation<double> animation){
                        return ScaleTransition(child: child, scale: animation,);
                      },
                      child: Text('${formatCurrency.format(_totalPayment)}',
                        key: ValueKey<int>(_totalPayment),
                        style: TextStyle(fontSize: 18, color: grey),
                      ),
                    ),
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
