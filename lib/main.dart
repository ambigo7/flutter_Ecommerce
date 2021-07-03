

import 'package:flutter/material.dart';

//FIREBASE CORE
import 'package:firebase_core/firebase_core.dart';
import 'package:lets_shop/commons/loading.dart';
import 'package:lets_shop/provider/app_provider.dart';
import 'package:lets_shop/provider/connectivity_provider.dart';
import 'package:lets_shop/provider/product_provider.dart';
import 'package:lets_shop/screens/nointernet.dart';
import 'package:provider/provider.dart';

// MY OWN PACKAGE
import 'package:lets_shop/screens/splash.dart';
import 'package:lets_shop/commons/color.dart';
import 'package:lets_shop/screens/home.dart';
import 'package:lets_shop/provider/user_provider.dart';
import 'package:lets_shop/screens/login_regist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ConnectivityProvider(),
          child: CheckConnection(),
        ),
        ChangeNotifierProvider.value(value: UserProvider.initialize()),
        ChangeNotifierProvider.value(value: ProductProvider.initialize()),
        ChangeNotifierProvider.value(value: AppProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: blue),
        home: CheckConnection(),
      )));
}


class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    switch(user.status){
      case Status.Uninitialized:
        return Splash();
      case Status.Unauthenticated:
        return Login();
      case Status.Authenticating:
        return Login();
      case Status.Authenticated:
        return HomePage();
      default: return Login();
    }
  }
}

class CheckConnection extends StatefulWidget {
  @override
  _CheckConnectionState createState() => _CheckConnectionState();
}

class _CheckConnectionState extends State<CheckConnection> {

  @override
  void initState(){
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    return PageUI();
  }

  Widget PageUI(){
      return Consumer<ConnectivityProvider>(
          builder: (context, model, child){
            if(model.isOnline != null){
              return model.isOnline
                  ? ScreensController()
                  : NoInternet();
            }
            return Center(child: Loading());
          }
      );
  }
}

