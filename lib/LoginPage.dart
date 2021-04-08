import 'dart:convert';
import 'dart:io';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/SignupScreen.dart';
import 'package:eram_app/VerificationPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  final acessType;
  LoginPage(this.acessType);
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var val1, val2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.acessType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFFFFFFF),
      body: Form(
        key: _formKey,
        child: loginSession(context),
      ),
    );
  }

  TextEditingController mobileController = TextEditingController();

  Widget loginSession(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 80,
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
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  height: 40,
                  minWidth: MediaQuery.of(context).size.width / 2.9,
                  color: Color(0xFFFC4B4B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    //side: BorderSide(color: _hasBeenPressed2?Color(0xFFD6D6D6):Color(0xFF707070))
                  ),
                  child: Text('Log In',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      )),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              "Welcome",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Color(0xFF191919),
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500)),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 30,
            ),
            Text('Enter your mobile number, we will sent',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Color(0xFF505050),
                      fontSize: 11,
                      fontWeight: FontWeight.w300),
                )),
            Text('you OTP to verify later.',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Color(0xFF505050),
                      fontSize: 11,
                      fontWeight: FontWeight.w300),
                )),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                padding: EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFD6D6D6)),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text("+91", style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    // VerticalDivider(
                    //  // color: Color(0xFFC2C2C2),
                    //   color: Colors.white,
                    //   thickness: 2.0,
                    //   width:10,
                    // ),
                    Container(
                      width: 1,
                      height: 50,
                      color: Color(0xFFD6D6D6),
                    ),

                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          validator: (value) {
                            Pattern pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
                            RegExp regex = new RegExp(pattern);
                            if (value.isEmpty) {
                              setState(() {
                                val1 = 'Please enter mobile number';
                              });
                              return null;
                            } else if (!regex.hasMatch(value)) {
                              setState(() {
                                val1 = 'Invalid Mobilenumber';
                              });
                              return null;
                            } else {
                              val1 = null;
                              return null;
                            }
                          },
                          controller: mobileController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: TextStyle(fontSize: 15, color: Colors.black),
                          cursorColor: Color(0xFFC2C2C2),
                          decoration: InputDecoration(
                            hintText: " Mobile number",
                            hintStyle: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFFC2C2C2),
                                    fontWeight: FontWeight.w300)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(val1 == null ? "" : val1,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Color(0xFFFF3B30),
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                )),
            SizedBox(
              height: 30.0,
            ),
            progress1
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlatButton(
                          height: 45,
                          minWidth: MediaQuery.of(context).size.width / 2.5,
                          textColor: Colors.white,
                          color: Color(0xFFFC4B4B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Icon(Icons.arrow_forward,
                              color: Color(0xFFFFFFFF)),
                          onPressed: () {
                            //Navigator.push(context, new MaterialPageRoute(builder: (context) => VerificationPage()));
                            if (_formKey.currentState.validate() &&
                                val1 == null) {
                              _formKey.currentState.save();
                              senddata();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
            SizedBox(
              height: 50,
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
                              builder: (context) => SignupScreen('signup')));
                      //Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  bool progress1 = false;
  var role;
  void senddata() async {
    setState(() {
      progress1 = true;
    });
    try {
      var url = Prefmanager.baseurl +
          '/user/signup/signin/send/otp?phone=' +
          mobileController.text +
          '&accessType=' +
          widget.acessType;

      // Map data={
      //   'phone':mobileController.text,
      // };
      //var body=json.encode(data);
      var response = await http.get(url);
      print("yyu" + response.statusCode.toString());
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)['status']) {
          role = json.decode(response.body)['role'];
          print(role);
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new VerificationPage(
                      mobileController.text, null, widget.acessType)));
        } else {
          // Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SearchProduct(keyword.text,searchMsg))).then((value) {
          //   //This makes sure the textfield is cleared after page is pushed.
          //
          // });
          // print(json.decode(response.body)['msg']);
          Fluttertoast.showToast(
            msg: json.decode(response.body)['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
          setState(() {
            progress1 = false;
          });
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: "No internet",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      progress1 = false;
    });

  }
}
