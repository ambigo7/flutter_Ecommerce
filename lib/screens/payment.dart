import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/commons/common.dart';
import 'package:lets_shop/components/custom_text.dart';
import 'package:lets_shop/components/expand_image.dart';
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
  final picker = ImagePicker();


  File _image1;
  String _orderId;
  int _totalPrice;
  String _numberAccount = '1543 0100 9224 501';

  ImageSource _imageSource;

  //GET IMAGE
  Future getImage() async {
    final pickedFile = await picker.getImage(source: _imageSource);
    if (pickedFile == null) return;

    File tmpImg = await File(pickedFile.path);
    /*File tmpImg = File(pickedFile.path);*/
    /*tmpImg = await tmpImg.copy(tmpImg.path);*/

    setState(() => _image1 = tmpImg);
  }


  
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
            weight: FontWeight.bold),
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
                      CustomText(text: '${formatCurrency.format(_totalPrice)}', color: blue, weight: FontWeight.bold,),
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
                          SizedBox(width: 15,),
                          CustomText(text: 'Payment validation  ',),
                          GestureDetector(
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
                                              CustomText(text: 'Terms of Payment', weight: FontWeight.bold,),
                                              SizedBox(height: 15,),
                                              CustomText(
                                                  text: 'Screenshot of mBanking/iBanking transaction details, '
                                                      'or ATM receipt for payment validation'), //TODO: buat tombol ok understand sama rapihin tulisan
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
/*                              _key.currentState.showSnackBar(
                                  SnackBar(
                                      content: Text("Screenshot of mBanking/iBanking transaction details, or ATM receipt for payment validation",
                                          style: TextStyle(color: blue)),
                                      backgroundColor: white
                                  ));*/
                            },
                            child: Icon(LineIcons.questionCircle, color: grey, size: 20,),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 0, 8, 8),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Divider(color: grey,),
                            SizedBox(height: 10,),
                            DottedBorder(
                                dashPattern: [8,4],
                                borderType: BorderType.RRect,
                                radius: Radius.circular(10),
                                color: blue,
                                child: GestureDetector(
                                  onTap: (){
                                    if(_image1 != null){
                                      changeScreen(context, ExpandImage(
                                        imageType: 'file',
                                        imageFile: _image1,
                                        enableSlideOutPage: true,
                                        )
                                      );
                                    }else{
                                      _key.currentState.showSnackBar(
                                          SnackBar(
                                              content: Text("You should take or select a photo first!",
                                                  style: TextStyle(color: blue)),
                                              backgroundColor: white
                                          ));
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    height: 300,
                                    width: 400,
                                    child: displayImage(),
                                  ),
                                )
                            ),
                            SizedBox(height: 10,),
                            Container(
                              height: 40,
                              width: 400,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Material(
                                        borderRadius: BorderRadius.circular(5.0),
                                        color: blue,
                                        elevation: 0.0,
                                        child: MaterialButton(
                                          onPressed: (){
                                            setState(() {
                                              _imageSource = ImageSource.camera;
                                            });
                                            getImage();
                                          },
                                          child: CustomText(text: 'Take a Photo', color: white,),
                                        )
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  Expanded(
                                    child: Material(
                                        borderRadius: BorderRadius.circular(5.0),
                                        color: blue,
                                        elevation: 0.0,
                                        child: MaterialButton(
                                          onPressed: (){
                                            setState(() {
                                              _imageSource = ImageSource.gallery;
                                            });
                                            getImage();
                                          },
                                          child: CustomText(text: 'Select Photo', color: white,),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5,),
                            Visibility(
                              visible: true, //Todo: kalo image null uploadnya ga keliatan
                              child: Container(
                                height: 40,
                                width: 400,
                                child: Material(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: blue,
                                    elevation: 0.0,
                                    child: MaterialButton(
                                      onPressed: (){
                                        //TODO: buat fungsi upload, update order tambah imgUrlPayment imgRef(storage), upload image ke storage
                                      },
                                      child: CustomText(text: 'Upload', color: white,),
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget displayImage() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 70, 8.0, 50.0),
        child: Column(
          children: <Widget>[
            Icon(Icons.image_outlined , color: blue, size: 100,),
            SizedBox(height: 20,),
            CustomText(
              text: 'Make sure you choose the correct photo according to the terms of payment validation',
              align: TextAlign.center,)
          ],
        ),
      );
    } else {
      return Image.file(_image1, fit: BoxFit.cover, width: double.infinity);
    }
  }
}
