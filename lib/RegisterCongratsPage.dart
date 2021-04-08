
import 'package:eram_app/CustomerInformation.dart';
import 'package:eram_app/SellerInformation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class RegisterCongratsPage extends StatefulWidget {
  final role;
  RegisterCongratsPage(this.role);
  _RegisterCongratsPage   createState() => _RegisterCongratsPage();
}

class _RegisterCongratsPage   extends State<RegisterCongratsPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:() async=>false,
    child: Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        ),
      key: _scaffoldKey,
      backgroundColor: Color(0xFFFFFFFF),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height/4,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          "iJOSH",
                          style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFFC4B4B),fontSize:40,fontWeight: FontWeight.w400),)
                      ),

                    ],
                  ),
                  SizedBox(height:30),
                  loginSession(context)
                  // Container(color: Colors.blue.withOpacity(0.1),height:50, width: double.infinity,),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  TextEditingController mobileController = TextEditingController();

  Widget loginSession(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/RegSucess.png',
                  height: 100,
                  width: 300,
                ),
              ],
            ),
            SizedBox(height:30),
            Text(
              "Congratulations",
              style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF2FDF84),fontSize: 13.0, fontWeight: FontWeight.w500)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height:10),
            Text(
              "Now you are registered as "+widget.role,
              style: GoogleFonts.poppins(textStyle:TextStyle(fontSize: 18,
                  color: Color(0xFF191919), fontWeight: FontWeight.w500)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height:10),
            Text(
              "Get ready with BUYMAX",
              style: GoogleFonts.poppins(textStyle:TextStyle(fontSize: 12,
                  color: Color(0xFF6F6F6F), fontWeight: FontWeight.w400)),
              textAlign: TextAlign.center,
            ),

            SizedBox(
              height: 30,
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                FlatButton(
                  height: 45,
                  minWidth:MediaQuery.of(context).size.width/1.6,
                  color: Color(0xFFFC4B4B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),

                  child: Text("Continue", style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFFFFFFF),fontSize:11,fontWeight: FontWeight.w400),)),
                  onPressed: () {
                    if(widget.role=='seller')
                    Navigator.push(context, new MaterialPageRoute(builder: (context) => SellerInformation()));
                    else
                      Navigator.push(context, new MaterialPageRoute(builder: (context) => CustomerInformation()));
                  },
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

}

