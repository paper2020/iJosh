import 'package:eram_app/SellerBottomBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPage createState() => new _NavigationPage();
}

class _NavigationPage extends State<NavigationPage> {
  Future<bool>_onWillPop() async{
    Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SellerBottomBar()));
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
              onPressed: () =>  Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SellerBottomBar() )),
            ),
            title: Text("Coming Soon",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 16,
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
