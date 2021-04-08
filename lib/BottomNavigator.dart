import 'dart:convert';
import 'package:eram_app/ComingSoon.dart';
import 'package:eram_app/CustomerNotification.dart';
import 'package:eram_app/FirstPage.dart';
import 'package:eram_app/HomePage.dart';
import 'package:eram_app/NotificationCheck.dart';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/ProductDetail.dart';
import 'package:eram_app/TrackPackage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
class MyNavigationBar extends StatefulWidget {
  MyNavigationBar({Key key}) : super(key: key);
  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {

  final FirebaseMessaging _fcm = FirebaseMessaging();
  int _selectedIndex = 0;
  List<Widget> _children;
  //  List<Widget> _children = <Widget>[ HomePage(),
  // ComingSoon(),
  // ComingSoon(),
  // CustomerNotification(),
  //    token!=null||token==''? CustomerNotification():NotificationCheck()
  //  ];
  //List<Widget> _children=<Widget>[];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    //Prefmanager.rem();
    sample();

    super.initState();
    _cloudNotification();
    _saveDeviceToken();
    //addDevice();
  }
  String token,role;
  bool loading=true;
  void sample()async{
    token= await Prefmanager.getToken();
    role= await Prefmanager.getRole();
    print(role);
     _children = [
      HomePage(),
      ComingSoon(),
      ComingSoon(),
      //CustomerNotification(),
      token!=null||token==''? CustomerNotification():NotificationCheck()
    ];
   // print("token"+token);
    setState(() {
      loading=false;
    });

  }
  Future<void> addDevice() async{
    var url=Prefmanager.baseurl+'/devicetoken/add/edit';
    var token=await Prefmanager.getToken();

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    Map data = {
      'deviceToken':fcmToken
    };

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

       if(role==message['data']['role']&&message['data']['routetype']=='orderProductStatusChange'){
         print(message['data']['role']);
         Navigator.push(
             context, new MaterialPageRoute(
             builder: (context) => new TrackPackage(message['data']['routeId2'],message['data']['routeId1'])));
      }
       if(role==message['data']['role']&&message['data']['routetype']=='productDiscount'){
         print(message['data']['role']);
         Navigator.push(
             context, new MaterialPageRoute(
             builder: (context) => new ProductDetail(message['data']['routeId1'])));
       }
       if(role==message['data']['role']&&message['data']['routetype']=='newOffer'){
         print(message['data']['role']);
         Navigator.push(
             context, new MaterialPageRoute(
             builder: (context) => new MyNavigationBar()));
       }
       },
      onResume: (Map<String, dynamic> message) async {
        if(role==message['data']['role']&&message['data']['routetype']=='orderProductStatusChange'){
          print(message['data']['role']);
          Navigator.push(
              context, new MaterialPageRoute(
              builder: (context) => new TrackPackage(message['data']['routeId2'],message['data']['routeId1'])));
        }
        if(role==message['data']['role']&&message['data']['routetype']=='productDiscount'){
          print(message['data']['role']);
          Navigator.push(
              context, new MaterialPageRoute(
              builder: (context) => new ProductDetail(message['data']['routeId1'])));
        }
        if(role==message['data']['role']&&message['data']['routetype']=='newOffer'){
          print(message['data']['role']);
          Navigator.push(
              context, new MaterialPageRoute(
              builder: (context) => new MyNavigationBar()));
        }
        print("onResume: $message");
      },
    );

  }
  String fcmToken;
  _saveDeviceToken() async {
    fcmToken= await _fcm.getToken();
    if(token!=null)await addDevice();
  }
  Widget navigator(){
    return Center(
      child: Column(
        children: [
          // SizedBox(
          //     height:MediaQuery.of(context).size.height
          // ),
          Text("Please login",style: GoogleFonts.poppins(
          textStyle: TextStyle(
              color: Color(0xFF4E4E4E),
              fontSize: 14,
              fontWeight: FontWeight.w600))),
          Container(
              height: 50,
             // width:MediaQuery.of(context).size.width,
              padding:EdgeInsets.symmetric(horizontal: 15),
              child: FlatButton(
                textColor: Colors.white,
                color: Color(0xFFFC4B4B),
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color(0xFFD2D2D2)),
                    borderRadius: BorderRadius.circular(7.0)),
                child: Text('Signin',style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.white,fontSize:10,fontWeight: FontWeight.w700),)),
                onPressed: () {
                  Navigator.push(
                      context, new MaterialPageRoute(
                      builder: (context) => new FirstPage()));
                },
              )),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: //loading?Center(child:CircularProgressIndicator(),):
      Center(
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
