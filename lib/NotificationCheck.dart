import 'package:eram_app/FirstPage.dart';
import 'package:eram_app/BottomNavigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationCheck extends StatefulWidget {
  @override
  _NotificationCheck createState() => new _NotificationCheck();
}

class _NotificationCheck extends State<NotificationCheck> {
  // Future<bool>_onWillPop() async{
  //   Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SellerBottomBar()));
  // }
  Future<bool>_onWillPop() async{
    Navigator.push(context,new MaterialPageRoute(builder: (context)=>new MyNavigationBar()));
    return false;
  }
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        //backgroundColor:  Color(0xFFFFFFFF),

          body: Center(
            child: SingleChildScrollView(
              child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Please Signin",style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Color(0xFF4E4E4E),
                          fontSize: 14,
                          fontWeight: FontWeight.w600))),
                      Container(
                          height: 50,
                           width:MediaQuery.of(context).size.width,
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
                  )),
            ),
          )),
    );
  }
}
