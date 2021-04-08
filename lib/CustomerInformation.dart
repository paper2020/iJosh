import 'dart:convert';
import 'dart:io';
import 'package:eram_app/BottomNavigator.dart';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/utils/helper.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';

class CustomerInformation extends StatefulWidget {
  @override
  _CustomerInformation createState() => _CustomerInformation();
}

class _CustomerInformation extends State<CustomerInformation> {
  String radioItem = '';
  PickedFile _image;
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () async {
                        _image = await CameraHelper.getImage(0);
                        setState(() {});
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () async {
                      _image = await CameraHelper.getImage(1);
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
                title: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text("Account Settings",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      )),
                ),
                automaticallyImplyLeading: false,
                actions: [
                  Row(
                    children: [
                      Divider(
                        height: 20,
                        thickness: 1,
                        indent: 1,
                      ),
                    ],
                  ),
                ]),
            body: Form(
                key: _formKey,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: [
                              Text("Complete Profile",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Color(0xFF000000),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600))),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          padding: new EdgeInsets.all(20.0),
                          //padding:EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Stack(
                            children: [
                              // Container(
                              //   padding: EdgeInsets.all(10),
                              //   alignment: Alignment.bottomCenter,
                              //   child: CircleAvatar(
                              //     radius: 80.0,
                              //     backgroundColor: Colors.blue,
                              //     backgroundImage:AssetImage('assets/userlogo.jpg'),
                              //
                              //
                              //   ),
                              // ),

                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Color(0xFFE3F2FD),
                                backgroundImage: _image == null
                                    ? AssetImage('assets/userlogo.jpg')
                                    : FileImage(File(_image.path)),
                              ),
                              new Positioned(
                                  bottom: 1,
                                  right: 2,
                                  child: ClipOval(
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      color: Color(0xFFF4F4F4),
                                      child: IconButton(
                                        icon: Icon(Icons.edit_outlined,
                                            size: 15, color: Color(0xFF000000)),
                                        onPressed: () {
                                          _showPicker(context);
                                        },
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                                Text(
                                  " *",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red),
                                )
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
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700)),
                                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),

                                  //labelText: 'Name',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
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
                                Text(
                                  " *",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red),
                                )
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
                                  //labelText: 'Name',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
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
                                  if (value.length == 0) {
                                    return null;
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
                                decoration: InputDecoration(),
                              ),
                            ),
                            SizedBox(
                              height: 20,
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
                                controller: addressController,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400)),
                                decoration: InputDecoration(
                                    //border: OutlineInputBorder(),
                                    ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Gender",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF8D8D8D),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400))),
                              ],
                            ),
                            Column(
                              children: [
                                RadioListTile(
                                  groupValue: radioItem,
                                  title: Text('Male'),
                                  value: 'Male',
                                  onChanged: (val) {
                                    setState(() {
                                      radioItem = val;
                                    });
                                  },
                                ),
                                RadioListTile(
                                  groupValue: radioItem,
                                  title: Text('Female'),
                                  value: 'Female',
                                  onChanged: (val) {
                                    setState(() {
                                      radioItem = val;
                                    });
                                  },
                                ),

                                //Text('$radioItem', style: TextStyle(fontSize: 23),),
                              ],
                            ),
                            Divider(
                              height: 10,
                              color: Color(0xFF8D8D8D),
                              thickness: 1,
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Date of Birth",
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
                                // validator: (value) {
                                //   if (value.isEmpty) {
                                //     return 'Please enter date of birth';
                                //   }1
                                //   else
                                //     return null;
                                // },
                                controller: dobController,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400)),
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.calendar_today,
                                      color: Colors.black,
                                    ),
                                    onPressed: () async {
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      final DateTime date =
                                          await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2010),
                                              lastDate: DateTime(2100));
                                      dobController.text =
                                          new DateFormat('dd.MM.yyyy')
                                              .format(date.toLocal());
                                      print(dobController.text);
                                    },
                                  ),
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
                            SizedBox(height: 20),
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
                                  if (value.length == 0) {
                                    return null;
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
                              height: 30,
                              width: 50,
                            ),
                          ]),
                        ),
                        progress
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container(
                                height: 50,
                                width: 80,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: RaisedButton(
                                  textColor: Colors.white,
                                  color: Color(0xFFFC4B4B),
                                  shape: RoundedRectangleBorder(
                                      side:
                                          BorderSide(color: Color(0xFFD2D2D2)),
                                      borderRadius: BorderRadius.circular(7.0)),
                                  child: Text('Submit',
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
                                      CameraHelper.addSinglePhoto(
                                          '/customer/profile/update',
                                          File(_image.path),
                                          null);
                                    }
                                  },
                                )),
                      ],
                    )))));
  }

  bool progress = false;
  void senddata() async {
    setState(() {
      progress = true;
    });
    try {
      var url = Prefmanager.baseurl + '/customer/profile/update';
      var token = await Prefmanager.getToken();
      Map data = {
        "token": token,
        "firstName": firstnameController.text,
        "lastName": lastnameController.text,
        "email": emailController.text,
        "address": addressController.text,
        "gender": radioItem,
        "dob": dobController.text,
        "pincode": pinController.text,
        "lat": lat.toString(),
        "lon": lon.toString(),
      };
      print(data.toString());
      var response = await http.post(url, body: data);
      print("yyu" + response.statusCode.toString());
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)['status']) {
          await Prefmanager.setStatus(
              json.decode(response.body)['profileStatus']);
          Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                  builder: (context) => new MyNavigationBar()));
        } else {
          print(json.decode(response.body)['message']);
          Fluttertoast.showToast(
            msg: json.decode(response.body)['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
          setState(() {
            progress = false;
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
      progress = false;
    });

  }
}
