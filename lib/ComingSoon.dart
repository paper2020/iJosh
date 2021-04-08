import 'package:eram_app/BottomNavigator.dart';
import 'package:eram_app/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class ComingSoon extends StatefulWidget {
  @override
  _ComingSoon createState() => new _ComingSoon();
}

class _ComingSoon extends State<ComingSoon> {
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
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () =>  Navigator.push(context,new MaterialPageRoute(builder: (context)=>new MyNavigationBar() )),
            ),
            title: Text("Coming Soon",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: AppFontSizes.heading,
                      fontWeight: FontWeight.w600),
                )),
            elevation: 0.0,
          ),
          body: SingleChildScrollView(
            child: SafeArea(
                child: Container(
              height: MediaQuery.of(context).size.height,
              child: Center(child: Text("Coming Soon")),
            )),
          )),
    );
  }
}
