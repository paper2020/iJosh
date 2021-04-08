import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eram_app/BottomNavigator.dart';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/WorkingHour.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:multiselect_formfield/multiselect_formfield.dart';

class SignupPage extends StatefulWidget {
  final mobileNumber, exist;
  SignupPage(this.mobileNumber, this.exist);
  @override
  _SignupPage createState() => _SignupPage();
}

class _SignupPage extends State<SignupPage> {
  void initState() {
    super.initState();
    _getCurrentLocation();
    category();
    startTimer();
    resendOtp();
  }

  var city, lat, lon, _mySelection;
  TextEditingController otpController = TextEditingController();

  Timer _timer;
  int _start = 110;
  String sendPin;
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        lat = position.latitude;
        lon = position.longitude;
        print(lat);
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      print("Addresss...");
      final coordinates = new Coordinates(lat, lon);
      print(coordinates);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      print(addresses.first.addressLine);
      city = first.locality;
      cityController.text = city;
      print(city);
      if (mounted) setState(() {});
    } catch (e) {
      print(e);
    }
  }

  var listcat = [];
  bool progress = true;
  void category() async {
    var url = Prefmanager.baseurl + '/service/list';
    var response = await http.get(url);
    print(json.decode(response.body));
    if (json.decode(response.body)['status'])
      listcat = json.decode(response.body)['data'];
    else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress = false;
    setState(() {});
  }

  void resendOtp() async {
    var url = Prefmanager.baseurl +
        '/user/signup/signin/send/otp?phone=' +
        widget.mobileNumber;
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
            Fluttertoast.showToast(msg: "Sorry OTP Expires!");
            // Navigator.pop(context);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exist == false ? "Sign up" : "Verification",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            )),
      ),
      backgroundColor: Colors.white,
      body: progress
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        height: MediaQuery.of(context).size.height * 1.1 - 20,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0))),
                        child: otpSession(context)),

//             Positioned(
//               top: 0, left: 0,
//               child: IconButton(
//                 onPressed: ()=> Navigator.pop(context),
//                 icon: Icon(Icons.arrow_back),
//               ),
//             ),
                  ],
                ),
              ),
            ),
    );
  }

  bool submitButton = false;
  bool check = false;
  var email, fullName, address, shopName;
  TextEditingController cityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  Widget otpSession(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget.exist == false
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: false,
                        groupValue: check,
                        onChanged: (value) {
                          setState(() {
                            check = value;
                          });
                        },
                      ),
                      Text(
                        "Customer",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey)),
                      ),
                      Radio(
                        value: true,
                        groupValue: check,
                        onChanged: (value) {
                          setState(() {
                            check = value;
                          });
                        },
                      ),
                      Text(
                        "Seller",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Please enter your details",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  check == false
                      ? Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "Full Name",
                                  hintStyle: TextStyle(color: Colors.black45),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 5.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Cannot be empty';
                                  } else
                                    return null;
                                },
                                onSaved: (val) {
                                  fullName = val;
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "Email Id",
                                  hintStyle: TextStyle(color: Colors.black45),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 5.0),
                                  ),
                                ),
                                validator: (value) {
                                  Pattern pattern =
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                  RegExp regex = new RegExp(pattern);
                                  if (!regex.hasMatch(value))
                                    return 'Enter valid email';
                                  else
                                    return null;
                                },
                                onSaved: (val) {
                                  email = val;
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "Address",
                                  hintStyle: TextStyle(color: Colors.black45),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 5.0),
                                  ),
                                ),
                                onSaved: (val) {
                                  address = val;
                                },
                              ),
                            ],
                          ),
                        )
                      : Form(
                          key: _formKey1,
                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "Shop Name",
                                  hintStyle: TextStyle(color: Colors.black45),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 5.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Cannot be empty';
                                  } else
                                    return null;
                                },
                                onSaved: (val) {
                                  shopName = val;
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: cityController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "City",
                                  hintStyle: TextStyle(color: Colors.black45),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 5.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Cannot be empty';
                                  } else
                                    return null;
                                },
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: MultiSelectFormField(
                                    title: Text("Select Category"),
                                    autovalidate: false,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select one or more option(s)';
                                      } else
                                        return null;
                                    },
                                    errorText:
                                        'Please select one or more option(s)',
                                    dataSource: [
                                      for (int i = 0; i < listcat.length; i++)
                                        {
                                          "display": listcat[i]["name"],
                                          "value": listcat[i]["_id"],
                                        }
                                    ],
                                    textField: 'display',
                                    valueField: 'value',
                                    required: true,
                                    onSaved: (value) {
                                      print('The value is $value');
                                      _mySelection = value;
                                    }),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Verify",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "We have sent 6 digit OTP to ",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey)),
                      ),
                      Text(
                        '+91 ' + widget.mobileNumber,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    //maxLength: 6,
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5.0),
                      ),
                      labelText: "Enter your OTP",
                      hintStyle: TextStyle(color: Colors.black45),
                      // border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Cannot be empty';
                      } else
                        return null;
                    },
                    // onSaved: (val) {
                    //   otp = val;
                    // },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  if (_start == 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            setState(() {
                              _start = 110;
                              startTimer();
                              resendOtp();
                            });
                          },
                          child: Text(
                            "Resend OTP",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.green),
                          ),
                        ),
                      ],
                    )
                  else
                    Text('Waiting for OTP... ' + _start.toString() + ' Sec'),
                  SizedBox(
                    height: 20,
                  ),
                  progress1
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : FlatButton(
                          height: 50,
                          minWidth: MediaQuery.of(context).size.width / 1,
                          textColor: Colors.white,
                          color: Colors.green,
                          child: Text('Submit',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              )),
                          onPressed: () {
                            // senddata();

                            if (check == false
                                ? _formKey.currentState.validate()
                                : _formKey1.currentState.validate()) {
                              check == false
                                  ? _formKey.currentState.save()
                                  : _formKey1.currentState.save();
                              senddata();

                              // Navigator.push(
                              //     context, new MaterialPageRoute(
                              //     builder: (context) => new SignupPage(mobileController.text,)));
                            }
                          },
                        ),
                ],
              )
            // : SizedBox.shrink(),
            : Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Verify",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "We have sent 6 digit OTP to ",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey)),
                      ),
                      Text(
                        '+91 ' + widget.mobileNumber,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    //maxLength: 6,
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5.0),
                      ),
                      labelText: "Enter your OTP",
                      hintStyle: TextStyle(color: Colors.black45),
                      // border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Cannot be empty';
                      } else
                        return null;
                    },
                    // onSaved: (val) {
                    //   otp = val;
                    // },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  if (_start == 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            setState(() {
                              _start = 110;
                              startTimer();
                              resendOtp();
                            });
                          },
                          child: Text(
                            "Resend OTP",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.green),
                          ),
                        ),
                      ],
                    )
                  else
                    Text('Waiting for OTP... ' + _start.toString() + ' Sec'),
                  SizedBox(
                    height: 20,
                  ),
                  progress1
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : FlatButton(
                          height: 50,
                          minWidth: MediaQuery.of(context).size.width / 1,
                          textColor: Colors.white,
                          color: Colors.green,
                          child: Text('Submit',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              )),
                          onPressed: () {
                            // senddata();

                            senddata();

                            // Navigator.push(
                            //     context, new MaterialPageRoute(
                            //     builder: (context) => new SignupPage(mobileController.text,)));
                          },
                        ),
                ],
              ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
                child: Text(
                    "By continuing you agree to our Terms of Service and  Privacy & Legal Policy",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins())),
          ],
        ),
      ],
    );
  }

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
        'role': check == false ? 'customer' : 'seller',
        'phone': widget.mobileNumber,
        'otp': otpController.text,
        'fullName': fullName,
        'email': email,
        'address': address,
        'shopName': shopName,
        'city': city,
        'services': _mySelection,
        'lat': lat.toString(),
        'lon': lon.toString(),
      };
      print(data);
      var body = json.encode(data);
      var response = await http.post(url, headers: requestHeaders, body: body);
      //print(response);
      //print("yyu"+response.statusCode.toString());
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)['status'] &&
            json.decode(response.body)['profileStatus'] == 'active' &&
            json.decode(response.body)['role'] == 'customer') {
          await Prefmanager.setToken(json.decode(response.body)['token']);
          print((json.decode(response.body)['token']));
          String token = await Prefmanager.getToken();
          print(token);
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new MyNavigationBar()));
        } else if (json.decode(response.body)['status'] &&
            json.decode(response.body)['profileStatus'] == 'incomplete' &&
            json.decode(response.body)['role'] == 'seller') {
          await Prefmanager.setToken(json.decode(response.body)['token']);
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new WorkingHour()));
        } else {
          // Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SearchProduct(keyword.text,searchMsg))).then((value) {
          //   //This makes sure the textfield is cleared after page is pushed.
          //
          // });
          print(json.decode(response.body)['msg']);
          // Fluttertoast.showToast(
          //   msg:json.decode(response.body)['msg'],
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.CENTER,
          //
          // );
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } on SocketException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
    progress1 = false;
  }
}
