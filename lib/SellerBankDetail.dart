import 'dart:convert';
import 'dart:io';

import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/SellerdocUpload.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class SellerBankDetail extends StatefulWidget {
  @override
  _SellerBankDetail createState() => _SellerBankDetail();
}

class _SellerBankDetail extends State<SellerBankDetail> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController bankController = TextEditingController();
  TextEditingController accountHolderController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  var state, city, fulladdress, lat, lon;
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
      state = first.adminArea;
      city = first.locality;
      fulladdress = first.addressLine;
      //print("${first.adminArea} : ${first.}");
      print(state);
      print(fulladdress);
      print(city);
      if (mounted) setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: Color(0xFFFFFFFF),
            appBar: AppBar(
              title: Text("Account Settings",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  )),
              automaticallyImplyLeading: false,
            ),
            body: Form(
                key: _formKey,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: ListView(
                      children: <Widget>[
                        Text("Account Information Progress",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600))),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: LinearProgressIndicator(
                            backgroundColor: Color(0xFFF0F0F0),
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Color(0xFF408BFF)),
                            value: 0.7,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("3/4 Steps",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xFF454545),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400))),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: [
                              Text("Bank Details",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Color(0xFF000000),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600))),
                            ],
                          ),
                        ),

                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Bank",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFFAFAFAF),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400))),
                              ],
                            ),
                            TextFormField(
                              validator: (value) {
                                Pattern pattern = r'^[a-zA-Z]';
                                RegExp regex = new RegExp(pattern);
                                if (value.isEmpty) {
                                  return 'Please enter bank name';
                                } else if (!regex.hasMatch(value))
                                  return 'Invalid bank name';
                                else
                                  return null;
                              },
                              controller: bankController,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400)),
                              decoration: InputDecoration(
                                labelStyle: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF1C1C1C),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Account Holder",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFFAFAFAF),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400))),
                              ],
                            ),
                            TextFormField(
                              validator: (value) {
                                Pattern pattern = r'^[a-zA-Z]';
                                RegExp regex = new RegExp(pattern);
                                if (value.isEmpty) {
                                  return 'Please enter account holder name';
                                } else if (!regex.hasMatch(value))
                                  return 'Invalid name';
                                else
                                  return null;
                              },
                              controller: accountHolderController,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400)),
                              decoration: InputDecoration(
                                labelStyle: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF1C1C1C),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Account Number",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFFAFAFAF),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400))),
                              ],
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter account number';
                                } else
                                  return null;
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ], //
                              controller: accountNoController,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400)),
                              decoration: InputDecoration(
                                labelStyle: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF1C1C1C),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("IFSC",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFFAFAFAF),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400))),
                              ],
                            ),
                            TextFormField(
                              validator: (value) {
                                Pattern pattern = r'^[A-Z]{4}0[A-Z0-9]{6}$';
                                RegExp regex = new RegExp(pattern);
                                if (value.isEmpty) {
                                  return 'Please enter IFSC';
                                } else if (!regex.hasMatch(value))
                                  return 'Invalid IFSC';
                                else
                                  return null;
                              },
                              controller: ifscController,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400)),
                              decoration: InputDecoration(
                                labelStyle: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF1C1C1C),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Branch",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFFAFAFAF),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400))),
                              ],
                            ),
                            TextFormField(
                              validator: (value) {
                                Pattern pattern = r'^[a-zA-Z]';
                                RegExp regex = new RegExp(pattern);
                                if (value.isEmpty) {
                                  return 'Please enter branch';
                                } else if (!regex.hasMatch(value))
                                  return 'Invalid branch';
                                else
                                  return null;
                              },
                              controller: branchController,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400)),
                              decoration: InputDecoration(
                                labelStyle: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF1C1C1C),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ]),
                        ),
                        //SizedBox(height: 150,),
                        progress1
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container(
                                height: 50,
                                width: 80,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: FlatButton(
                                  textColor: Colors.white,
                                  color: Color(0xFFFC4B4B),
                                  shape: RoundedRectangleBorder(
                                      side:
                                          BorderSide(color: Color(0xFFD2D2D2)),
                                      borderRadius: BorderRadius.circular(7.0)),
                                  child: Text('Next',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700),
                                      )),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      senddata();
                                    }
                                  },
                                )),
                      ],
                    )))));
  }

  bool progress1 = false;
  void senddata() async {
    setState(() {
      progress1 = true;
    });
    try {
      String token = await Prefmanager.getToken();
      var url = Prefmanager.baseurl + '/seller/profile/level3';
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': token
      };

      Map data = {
        'bank': bankController.text,
        'accountHolder': accountHolderController.text,
        'accountNo': accountNoController.text,
        'ifsc': ifscController.text,
        'branch': branchController.text,
      };
      print(data);
      var body = json.encode(data);
      var response = await http.post(url, headers: requestHeaders, body: body);
      //print(response);
      //print("yyu"+response.statusCode.toString());
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)['status']) {
          await Prefmanager.setLevel(json.decode(response.body)['level']);
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new SellerdocUpload()));
        }
        // else if(json.decode(response.body)['status']&&json.decode(response.body)['profileStatus']=='incomplete'&&json.decode(response.body)['role']=='seller')
        // {
        //   await Prefmanager.setToken(json.decode(response.body)['token']);
        //   // Navigator.push(
        //   //     context, new MaterialPageRoute(
        //   //     builder: (context) => new WorkingHour()));
        // }

        else {
          // Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SearchProduct(keyword.text,searchMsg))).then((value) {
          //   //This makes sure the textfield is cleared after page is pushed.
          //
          // });

          Fluttertoast.showToast(
            msg:json.decode(response.body)['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,

          );
          setState(() {
            progress1=false;
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
      progress1=false;
    });

  }
}
