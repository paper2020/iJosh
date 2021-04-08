import 'dart:async';
import 'package:eram_app/CustomerInformation.dart';
import 'package:eram_app/BottomNavigator.dart';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/SellerBankDetail.dart';
import 'package:eram_app/SellerInformation.dart';
import 'package:eram_app/SellerdocUpload.dart';
import 'package:eram_app/SellerworkHour.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'SellerBottomBar.dart';

void main() async {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarBrightness: Brightness.dark, //status bar brigtness
    statusBarIconBrightness: Brightness.dark,
  ));
  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iJOSH',
      theme: ThemeData(
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
        appBarTheme: AppBarTheme(
          elevation: 1.0,
          color: Color(0xFFFFFFFF),
          brightness: Brightness.light,
          textTheme: TextTheme(
            headline6: TextStyle(
                color: Color(0XFF000000),
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          iconTheme: new IconThemeData(color: Color(0xFF828282)),
        ),
        primarySwatch: Colors.red,
        cursorColor: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    //SharedPreferences.setMockInitialValues({});
    super.initState();

    Timer(
      Duration(seconds: 3),
      () => direct(),
    );
  }

  //direct();
  void direct() async {
    var token = await Prefmanager.getToken();
    var role = await Prefmanager.getRole();
    String status = await Prefmanager.getStatus();
    var level = await Prefmanager.getLevel();

    if (token != null && role == 'customer') {
      if (status == 'active') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MyNavigationBar()));
      } else if (status == 'incomplete') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CustomerInformation()));
      }
    } else if (token != null && role == 'seller') {
      if (status == 'active' || status == 'pending' || status == 'reject') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SellerBottomBar()));
      } else if (status == 'incomplete' && level == 0) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SellerInformation()));
      } else if (status == 'incomplete' && level == 1) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SellerworkHour()));
      } else if (status == 'incomplete' && level == 2) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SellerBankDetail()));
      } else if (status == 'incomplete' && level == 3) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SellerdocUpload()));
      }
    } else {
      print("token not exists");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyNavigationBar()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Center(
        child: Image.asset(
          'assets/ijosh.png',
          height: 250,
          width: 250,
        ),
      )),
    );
  }
}
