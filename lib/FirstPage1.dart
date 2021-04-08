import 'package:eram_app/LoginPage.dart';
import 'package:eram_app/SignupScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FirstPage1 extends StatefulWidget {
  _FirstPage1 createState() => _FirstPage1();
}

class _FirstPage1 extends State<FirstPage1> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _hasBeenPressed1 = true;
  bool _hasBeenPressed2 = false;
  var accessType;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFFFFFFF),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                //height: MediaQuery.of(context).size.height,
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      //height: 120,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("iJOSH",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Color(0xFFFC4B4B),
                                  fontSize: 40,
                                  fontWeight: FontWeight.w400),
                            )),
                      ],
                    ),
                    Image.asset(
                      'assets/logo.jpg',
                      height: 300,
                      width: 300,
                    ),
                    // SizedBox(
                    //   height: 100,
                    // ),
                    loginSession(context)
                    // Container(color: Colors.blue.withOpacity(0.1),height:50, width: double.infinity,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
              children: [],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[100].withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 4,
                      offset: Offset(2, 5), // changes position of shadow
                    ),
                  ],
                ),
                child: FlatButton(
                  height: 45,
                  minWidth: MediaQuery.of(context).size.width,
                  color:
                  _hasBeenPressed1 ? Color(0xFFFC4B4B) : Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    // side: BorderSide(color: _hasBeenPressed1?Color(0xFFD6D6D6):Color(0xFF707070))
                  ),
                  child: Text('Log In',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: _hasBeenPressed1
                                ? Color(0xFFFFFFFF)
                                : Color(0xFF363636),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      )),
                  onPressed: () {
                    setState(() {
                      accessType = 'signin';
                      _hasBeenPressed1 = true;
                      _hasBeenPressed2 = false;
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => LoginPage(accessType)));
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[100].withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 4,
                      offset: Offset(2, 5), // changes position of shadow
                    ),
                  ],
                ),
                child: FlatButton(
                  height: 45,
                  minWidth: MediaQuery.of(context).size.width,
                  color:
                  _hasBeenPressed2 ? Color(0xFFFC4B4B) : Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    //side: BorderSide(color: _hasBeenPressed2?Color(0xFFD6D6D6):Color(0xFF707070))
                  ),
                  child: Text('Sign Up',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: _hasBeenPressed2
                                ? Color(0xFFFFFFFF)
                                : Color(0xFF363636),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      )),
                  onPressed: () {
                    setState(() {
                      accessType = 'signup';
                      _hasBeenPressed2 = true;
                      _hasBeenPressed1 = false;
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => SignupScreen(accessType)));
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don’t have an account?     ',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Color(0xFF505050),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  InkWell(
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Color(0xFF5C5C5C),
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => SignupScreen(accessType)));
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
