import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eram_app/BottomNavigator.dart';
import 'package:eram_app/CustomerInformation.dart';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/RegisterCongratsPage.dart';
import 'package:eram_app/SellerBankDetail.dart';
import 'package:eram_app/SellerInformation.dart';
import 'package:eram_app/SellerdocUpload.dart';
import 'package:eram_app/SellerworkHour.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'SellerBottomBar.dart';

class VerificationPage extends StatefulWidget {
  final phone, role, acessType;
  VerificationPage(this.phone, this.role, this.acessType);
  _VerificationPage createState() => _VerificationPage();
}

class _VerificationPage extends State<VerificationPage> {
  void initState() {
    super.initState();
    startTimer();
  }

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var otp;
  Timer _timer;
  int _start = 110;
  bool progress;
  void resendOtp() async {
    var url = Prefmanager.baseurl +
        '/user/signup/signin/send/otp?phone=' +
        widget.phone +
        '&accessType=' +
        widget.acessType;
    var response = await http.get(url);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress = false;
    setState(() {});
  }

  void startTimer() {
    _start = 110;

    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start == 0) {
            timer.cancel();
            //Fluttertoast.showToast(msg: "Sorry OTP Expires!");

          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: false,
            //     leading: IconButton (icon:Icon(Icons.arrow_back_ios,color: Color(0xFF000000),),
            // onPressed:() => Navigator.pop(context,true),),
          ),
          key: _scaffoldKey,
          backgroundColor: Color(0xFFFFFFFF),
          body: Form(
            key: _formKey,
            child: loginSession(context),
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
            SizedBox(
              height: 50,
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
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Verify.png',
                  height: 100,
                  width: 300,
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              "Verification",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1),
            Text(
              "Enter 4 digit number send to",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6A6A6A),
                      fontWeight: FontWeight.w300)),
              textAlign: TextAlign.center,
            ),
            Text(
              "+91 " + widget.phone,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6A6A6A),
                      fontWeight: FontWeight.w300)),
              textAlign: TextAlign.center,
            ),

            SizedBox(
              height: 30,
            ),
            Container(
              height: 35,
              child: OtpTextField(
                fieldWidth: 50,
                textStyle: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w500)),
                focusedBorderColor: Color(0xFFD6D6D6),
                numberOfFields: 4,
                cursorColor: Color(0xFFD6D6D6),
                enabledBorderColor: Color(0xFFD6D6D6),
                borderWidth: 0.5,
                keyboardType: TextInputType.number,
                //decoration: InputDecoration(),
                showFieldAsBox:
                    true, //set to true to show as box or false to show as dash
                onCodeChanged: (String code) {},
                onSubmit: (verificationCode) {
                  otp = verificationCode;
                }, // end onSubmit
              ),
            ),
            SizedBox(
              height: 30,
            ),
            progress1
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        height: 45,
                        minWidth: MediaQuery.of(context).size.width / 1.6,
                        color: Color(0xFFFC4B4B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text("Continue",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400),
                            )),
                        onPressed: () {
                          senddata();
                        },
                      ),
                    ],
                  ),
            //],
            //),
            SizedBox(height: 50),
            Text("Didn't receive code? ",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Color(0xFF505050),
                      fontSize: 11,
                      fontWeight: FontWeight.w300),
                )),
            if (_start == 0)
              InkWell(
                onTap: () {
                  setState(() {
                    _start = 110;
                    startTimer();
                    resendOtp();
                  });
                },
                child: Text(
                  'Resend code',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Color(0xFF505050),
                        fontSize: 11,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              )
            else
              Text('Resend code in ' + _start.toString() + ' Sec',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Color(0xFF505050),
                        fontSize: 11,
                        fontWeight: FontWeight.w500),
                  )),
            SizedBox(
              height: 80.0,
            ),
          ],
        ),
      ),
    );
  }

  var role;
  bool progress1 = false;
  void senddata() async {
    setState(() {
      progress1 = true;
    });
    try {
      var url = Prefmanager.baseurl + '/user/signup/signin';
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        //'x-auth-token': token
      };

      Map data = {
        'accessType': widget.acessType,
        'role': widget.role,
        'phone': widget.phone,
        'otp': otp,
      };
      print(data);
      var body = json.encode(data);
      var response = await http.post(url, headers: requestHeaders, body: body);
      //print(response);
      //print("yyu"+response.statusCode.toString());
      role = json.decode(response.body)['role'];
      print(role);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)['status'] &&
            widget.acessType == 'signup') {
          await Prefmanager.setToken(json.decode(response.body)['token']);
          await Prefmanager.setRole(json.decode(response.body)['role']);
          await Prefmanager.setStatus(
              json.decode(response.body)['profileStatus']);
          await Prefmanager.setLevel(json.decode(response.body)['level']);
          print((json.decode(response.body)['token']));
          String token = await Prefmanager.getToken();
          print(token);
          print(await Prefmanager.getStatus());
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new RegisterCongratsPage(widget.role)));
        } else if (json.decode(response.body)['status'] &&
            widget.acessType == 'signin' &&
            role == 'customer' &&
            json.decode(response.body)['profileStatus'] == 'active') {
          await Prefmanager.setToken(json.decode(response.body)['token']);
          await Prefmanager.setRole(json.decode(response.body)['role']);
          await Prefmanager.setStatus(
              json.decode(response.body)['profileStatus']);
          await Prefmanager.setLevel(json.decode(response.body)['level']);
          print((json.decode(response.body)['token']));
          String token = await Prefmanager.getToken();
          print(token);
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new MyNavigationBar()));
        } else if (json.decode(response.body)['status'] &&
            widget.acessType == 'signin' &&
            role == 'customer' &&
            json.decode(response.body)['profileStatus'] == 'incomplete' &&
            json.decode(response.body)['level'] == 0) {
          await Prefmanager.setToken(json.decode(response.body)['token']);
          await Prefmanager.setRole(json.decode(response.body)['role']);
          await Prefmanager.setStatus(
              json.decode(response.body)['profileStatus']);
          await Prefmanager.setLevel(json.decode(response.body)['level']);
          print(await Prefmanager.getStatus());
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new CustomerInformation()));
        } else if (json.decode(response.body)['status'] &&
            widget.acessType == 'signin' &&
            role == 'seller' &&
            json.decode(response.body)['profileStatus'] == 'active') {
          await Prefmanager.setToken(json.decode(response.body)['token']);
          await Prefmanager.setRole(json.decode(response.body)['role']);
          await Prefmanager.setStatus(
              json.decode(response.body)['profileStatus']);
          await Prefmanager.setLevel(json.decode(response.body)['level']);
          print((json.decode(response.body)['token']));
          String token = await Prefmanager.getToken();
          print(token);
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new SellerBottomBar()));
        } else if (json.decode(response.body)['status'] &&
                widget.acessType == 'signin' &&
                role == 'seller' &&
                json.decode(response.body)['profileStatus'] == 'pending' ||
            json.decode(response.body)['profileStatus'] == 'reject') {
          await Prefmanager.setToken(json.decode(response.body)['token']);
          await Prefmanager.setRole(json.decode(response.body)['role']);
          await Prefmanager.setStatus(
              json.decode(response.body)['profileStatus']);
          await Prefmanager.setLevel(json.decode(response.body)['level']);
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new SellerBottomBar()));
        } else if (json.decode(response.body)['status'] &&
            widget.acessType == 'signin' &&
            role == 'seller' &&
            json.decode(response.body)['profileStatus'] == 'incomplete' &&
            json.decode(response.body)['level'] == 0) {
          await Prefmanager.setToken(json.decode(response.body)['token']);
          await Prefmanager.setRole(json.decode(response.body)['role']);
          await Prefmanager.setStatus(
              json.decode(response.body)['profileStatus']);
          await Prefmanager.setLevel(json.decode(response.body)['level']);
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new SellerInformation()));
        } else if (json.decode(response.body)['status'] &&
            widget.acessType == 'signin' &&
            role == 'seller' &&
            json.decode(response.body)['profileStatus'] == 'incomplete' &&
            json.decode(response.body)['level'] == 1) {
          await Prefmanager.setToken(json.decode(response.body)['token']);
          await Prefmanager.setRole(json.decode(response.body)['role']);
          await Prefmanager.setStatus(
              json.decode(response.body)['profileStatus']);
          await Prefmanager.setLevel(json.decode(response.body)['level']);
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new SellerworkHour()));
        } else if (json.decode(response.body)['status'] &&
            widget.acessType == 'signin' &&
            role == 'seller' &&
            json.decode(response.body)['profileStatus'] == 'incomplete' &&
            json.decode(response.body)['level'] == 2) {
          await Prefmanager.setToken(json.decode(response.body)['token']);
          await Prefmanager.setRole(json.decode(response.body)['role']);
          await Prefmanager.setStatus(
              json.decode(response.body)['profileStatus']);
          await Prefmanager.setLevel(json.decode(response.body)['level']);
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new SellerBankDetail()));
        } else if (json.decode(response.body)['status'] &&
            widget.acessType == 'signin' &&
            role == 'seller' &&
            json.decode(response.body)['profileStatus'] == 'incomplete' &&
            json.decode(response.body)['level'] == 3) {
          await Prefmanager.setToken(json.decode(response.body)['token']);
          await Prefmanager.setRole(json.decode(response.body)['role']);
          await Prefmanager.setStatus(
              json.decode(response.body)['profileStatus']);
          await Prefmanager.setLevel(json.decode(response.body)['level']);
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new SellerdocUpload()));
        } else {
          // Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SearchProduct(keyword.text,searchMsg))).then((value) {
          //   //This makes sure the textfield is cleared after page is pushed.
          //
          // });
          print(json.decode(response.body)['msg']);
          print(widget.role);
          Fluttertoast.showToast(
            msg: "Invalid OTP",
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
