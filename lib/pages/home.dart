import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_shop/pages/login.dart';
import 'package:lets_shop/service/auth.dart';

// MY OWN PACKAGE
import 'package:lets_shop/components/home_body.dart';
import 'package:lets_shop/pages/shopping_cart.dart';

class HomePage extends StatefulWidget {
/*  //KONTRUKTOR BUAT GET VALUES YANG DIKIRIM DARI CLASS LOGIN
  const HomePage({Key key, User user})
      : _user = user,
        super(key: key);
  //TAMPUNG VALUESNYA DISINI
  final User _user;*/
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User _user = FirebaseAuth.instance.currentUser;
  bool _isSigningOut = false;

  //FUNGSINYA BUAT MANGGIL NAMA USER, EMAIL, DAN PHOTONYA
/*  @override
  void initState() {
    _user = widget._user;
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.deepOrangeAccent[700]),
        elevation: 0.1,
        backgroundColor: Colors.white,
        title: Text('Lets Shop', style: TextStyle(color: Colors.deepOrangeAccent[700])),
        actions: <Widget> [
          new IconButton(
              icon: Icon(
                Icons.search_outlined,
              ),
              onPressed: (){}),
          new IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
              ),

//             ===PASSING PAGE NO VALUES WITH NAVIGATOR.PUSH====
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => new shoppingCart()));
              })
        ],
      ),

      drawer: new Drawer(
        child : new ListView(
          children: <Widget>[

//        =====HEADER PART OF DRAWER A.K.A DASHBOARD======

            new UserAccountsDrawerHeader(
              //_user.photoURL != null ? VALIDASI HARUSNYA TAPI MASIH BINGUNG NTAR AJA
              accountName: Text(_user.displayName),
              accountEmail: Text(_user.email),
              currentAccountPicture: GestureDetector(
                child: new ClipOval(
                  child: Material(
                    color: Colors.grey,
                    child: Image.network(
                      _user.photoURL,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              decoration: new BoxDecoration(
                  color: Colors.deepOrangeAccent[700]
              ),
            ),

//        ====BODY PART OF DRAWER A.K.A DASHBOARD=====

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Home Page'),
                leading: Icon(Icons.home_outlined, color: Colors.red),
              ),
            ),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Orders History'),
                leading: Icon(Icons.shopping_basket_outlined, color: Colors.red),
              ),
            ),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Shopping cart'),
                leading: Icon(Icons.shopping_cart_outlined, color: Colors.red),
              ),
            ),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Favourites'),
                leading: Icon(Icons.favorite_outline, color: Colors.red),
              ),
            ),

            Divider(),
            InkWell(
              onTap: () async {
/*                setState(() {
                  _isSigningOut = true;
                });
                await Authentication.signOut(context: context);
                setState(() {
                  _isSigningOut = false;
                });
                *//*Navigator.of(context)
                    .pushReplacement(_routeToLogin());*//*
                Navigator.push(context, MaterialPageRoute(builder: (context) => new Login()));*/
              },
              child: ListTile(
                title: Text('My Account'),
                leading: Icon(Icons.person),
              ),
            ),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Setting'),
                leading: Icon(Icons.settings),
              ),
            ),

            Divider(),
            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Help and feedback'),
                //leading: Icon(Icons.help),
              ),
            ),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('About Lets Shop'),
                //leading: Icon(Icons.help),
              ),
            ),
          ],
        ),
      ),
      body: homeBody(),
/*      pages[_selectedIndex]*/
    );
  }
}