import 'dart:convert';
import 'dart:io';
import 'package:eram_app/Prefmanager.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class EditdeliveryAddress1 extends StatefulWidget {
  final data, delid;
  EditdeliveryAddress1(this.data, this.delid);
  @override
  _EditdeliveryAddress1 createState() => _EditdeliveryAddress1();
}

class _EditdeliveryAddress1 extends State<EditdeliveryAddress1> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void initState() {
    super.initState();
    deliveryaddressList();
  }

  List address = [];
  bool progress = true;
  void deliveryaddressList() async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };

    var url = Prefmanager.baseurl + '/deliveryAddress/list';
    var response = await http.post(url, headers: requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      firstnameController.text = widget.data['firstName'];
      lastnameController.text = widget.data['lastName'];
      emailController.text = widget.data['email'];
      addressController.text = widget.data['address'];
      mobileController.text = widget.data['mobile'];
      pinController.text = widget.data['pincode'];
      cityController.text = widget.data['city'];
      stateController.text = widget.data['state'];
      landmarkController.text = widget.data['landmark'];
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Text("Edit Delivery Address",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              )),
          automaticallyImplyLeading: true,
        ),
        body: Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("First Name",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF8D8D8D),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))),
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 50,
                          child: TextFormField(
                            validator: (value) {
                              Pattern pattern = r'^[a-zA-Z]';
                              RegExp regex = new RegExp(pattern);
                              if (value.isEmpty) {
                                return 'Please enter first name';
                              } else if (!regex.hasMatch(value))
                                return 'Invalid first name';
                              else
                                return null;
                            },
                            controller: firstnameController,
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
                              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Last Name",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF8D8D8D),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))),
                          ],
                        ),
                        Container(
                          height: 50,
                          child: TextFormField(
                            validator: (value) {
                              Pattern pattern = r'^[a-zA-Z]';
                              RegExp regex = new RegExp(pattern);
                              if (value.isEmpty) {
                                return 'Please enter last name';
                              } else if (!regex.hasMatch(value))
                                return 'Invalid last name';
                              else
                                return null;
                            },
                            controller: lastnameController,
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
                              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Email Id",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF8D8D8D),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))),
                          ],
                        ),
                        Container(
                          height: 50,
                          child: TextFormField(
                            validator: (value) {
                              Pattern pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regex = new RegExp(pattern);
                              if (value.isEmpty) {
                                return 'Please enter email';
                              } else if (!regex.hasMatch(value))
                                return 'Invalid Email';
                              else
                                return null;
                            },
                            controller: emailController,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Address",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF8D8D8D),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))),
                          ],
                        ),
                        Container(
                          height: 50,
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter address';
                              } else
                                return null;
                            },
                            controller: addressController,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Mobile Number",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF8D8D8D),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))),
                          ],
                        ),
                        Container(
                          height: 50,
                          child: TextFormField(
                            validator: (value) {
                              Pattern pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
                              RegExp regex = new RegExp(pattern);
                              if (value.isEmpty) {
                                return 'Please enter mobile number';
                              } else if (!regex.hasMatch(value))
                                return 'Invalid Mobilenumber';
                              else
                                return null;
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ], //
                            controller: mobileController,
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
                              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Pincode",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF8D8D8D),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))),
                          ],
                        ),
                        Container(
                          height: 50,
                          child: TextFormField(
                            validator: (value) {
                              Pattern pattern = r'^[1-9][0-9]{5}$';
                              RegExp regex = new RegExp(pattern);
                              if (value.isEmpty) {
                                return 'Please enter pincode';
                              } else if (!regex.hasMatch(value))
                                return 'Please enter 6 digit pincode';
                              else
                                return null;
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ], //
                            controller: pinController,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("City",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF8D8D8D),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))),
                          ],
                        ),
                        Container(
                          height: 50,
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter city';
                              } else
                                return null;
                            },
                            controller: cityController,
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
                              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("State",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF8D8D8D),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))),
                          ],
                        ),
                        Container(
                          height: 50,
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter state';
                              } else
                                return null;
                            },
                            controller: stateController,
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
                              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),

                              //labelText: 'Name',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Landmark",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF8D8D8D),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))),
                          ],
                        ),
                        Container(
                          height: 50,
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter landmark';
                              } else
                                return null;
                            },
                            controller: landmarkController,
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
                              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          width: 50,
                        ),
                      ]),
                    ),
                    SizedBox(height: 80),
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
                                  side: BorderSide(color: Color(0xFFD2D2D2)),
                                  borderRadius: BorderRadius.circular(7.0)),
                              child: Text('Save Address',
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
                ))));
  }

  bool progress1 = false;
  void senddata() async {
    setState(() {
      progress1 = true;
    });
    print("hi");
    try {
      String token = await Prefmanager.getToken();
      var url = Prefmanager.baseurl + '/deliveryAddress/edit/' + widget.delid;
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': token
      };

      Map data = {
        'firstName': firstnameController.text,
        'lastName': lastnameController.text,
        'email': emailController.text,
        'address': addressController.text,
        'mobile': mobileController.text,
        'pincode': pinController.text,
        'city': cityController.text,
        'state': stateController.text,
        'landmark': landmarkController.text
      };
      print(data);
      var body = json.encode(data);
      var response = await http.post(url, headers: requestHeaders, body: body);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)['status']) {
          print((json.decode(response.body)['token']));
          String token = await Prefmanager.getToken();
          print(token);
          // Navigator.pushReplacement(
          //     context,
          //     new MaterialPageRoute(
          //         builder: (context) => new DeliveryAddress()));
          Navigator.of(context).pop();
        } else {
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
