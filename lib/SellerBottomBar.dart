import 'dart:convert';
import 'package:eram_app/SellerEachOrderView.dart';
import 'package:eram_app/TabController.dart';
import 'package:http/http.dart' as http;
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/SellerHome.dart';
import 'package:eram_app/SellerNotification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'NavigationPage.dart';

class SellerBottomBar extends StatefulWidget {
  SellerBottomBar({Key key}) : super(key: key);
  @override
  _SellerBottomBar createState() => _SellerBottomBar();
}

class _SellerBottomBar extends State<SellerBottomBar> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  int _selectedIndex = 0;
  List<Widget> _children;
  //static const List<Widget> _widgetOptions = <Widget>[];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    sample();
    print(status);
    _children = [
      SellerHome(),
      //SellerInformation(),
      NavigationPage(),
      NavigationPage(),
      SellerNotification(status)
      // status=="pending"||status=="reject"?
      //   SellerHome()
      // : SellerNotification()

    ];
    super.initState();

  }
  String status,role;
  Future sample()async{
    status= await Prefmanager.getStatus();
    role=await Prefmanager.getRole();
    print(status);
    await _cloudNotification();
   await  _saveDeviceToken();
    await addDevice();
  }
  Future<void>addDevice() async{
    var url=Prefmanager.baseurl+'/devicetoken/add/edit';
    var token=await Prefmanager.getToken();
    print("Profile");
    print(token);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    Map data = {
      'deviceToken':fcmToken
    };
    print(data);
    var body = json.encode(data);
    var response = await http.post(url,headers:requestHeaders,body: body);
    print(json.decode(response.body));
    if(json.decode(response.body)['status'])
    {

    }
    else
     {}

  }
  _cloudNotification()async{
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        if(role==message['data']['role']&&message['data']['routetype']=='newOrder'){
          print(message['data']['role']);
          Navigator.push(
              context, new MaterialPageRoute(
              builder: (context) => new TabBarDemo(null)));
        }
        if(role==message['data']['role']&&message['data']['routetype']=='returnOrder'){
          print(message['data']['role']);
          Navigator.push(
              context, new MaterialPageRoute(
              builder: (context) => new SellerEachOrderview(message['data']['routeId2'],message['data']['routeId1'])));
        }
        if(role==message['data']['role']&&message['data']['routetype']=='cancelOrder'){
          print(message['data']['role']);
          Navigator.push(
              context, new MaterialPageRoute(
              builder: (context) => new SellerEachOrderview(message['data']['routeId2'],message['data']['routeId1'])));
        }
        if(role==message['data']['role']&&message['data']['routetype']=='accountActivation'){
          print(message['data']['role']);
          Navigator.push(
              context, new MaterialPageRoute(
              builder: (context) => new SellerBottomBar()));
        }
        if(role==message['data']['role']&&message['data']['routetype']=='accountRejection'){
          print(message['data']['role']);
          Navigator.push(
              context, new MaterialPageRoute(
              builder: (context) => new SellerBottomBar()));
        }
        print("onLaunch: $message");

      },
      onResume: (Map<String, dynamic> message) async {
        if(role==message['data']['role']&&message['data']['routetype']=='newOrder'){
          print(message['data']['role']);
          Navigator.push(
              context, new MaterialPageRoute(
              builder: (context) => new TabBarDemo(null)));
        }
        if(role==message['data']['role']&&message['data']['routetype']=='returnOrder'){
          print(message['data']['role']);
          Navigator.push(
              context, new MaterialPageRoute(
              builder: (context) => new SellerEachOrderview(message['data']['routeId2'],message['data']['routeId1'])));
        }
        if(role==message['data']['role']&&message['data']['routetype']=='cancelOrder'){
          print(message['data']['role']);
          Navigator.push(
              context, new MaterialPageRoute(
              builder: (context) => new SellerEachOrderview(message['data']['routeId2'],message['data']['routeId1'])));
        }
        if(role==message['data']['role']&&message['data']['routetype']=='accountActivation'){
          print(message['data']['role']);
          Navigator.push(
              context, new MaterialPageRoute(
              builder: (context) => new SellerBottomBar()));
        }
        if(role==message['data']['role']&&message['data']['routetype']=='accountRejection'){
          print(message['data']['role']);
          Navigator.push(
              context, new MaterialPageRoute(
              builder: (context) => new SellerBottomBar()));
        }
        print("onResume: $message");
      },
    );

  }
  String fcmToken;
  _saveDeviceToken() async {
    fcmToken= await _fcm.getToken();
    print(fcmToken);


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _children.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                // ignore: deprecated_member_use
                title: Text('Home',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w400))),
                backgroundColor: Color(0xFFFFF6F6F6)),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmarks_outlined),
                // ignore: deprecated_member_use
                title: Text('Bookmark',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w400))),
                backgroundColor: Color(0xFFFFF6F6F6)),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                // ignore: deprecated_member_use
                title: Text('Settings',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w400))),
                backgroundColor: Color(0xFFFFF6F6F6)),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_none_outlined),
                // ignore: deprecated_member_use
                title: Text('Notification',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w400))),
                backgroundColor: Color(0xFFFFF6F6F6)),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          unselectedItemColor: Color(0xFF878787),
          selectedItemColor: Color(0xFFFF3B30),
          iconSize: 20,
          onTap: _onItemTapped,
          elevation: 5),
    );
  }
}
