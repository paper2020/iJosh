import 'dart:convert';
import 'dart:io';
import 'package:eram_app/BottomNavigator.dart';
import 'package:eram_app/CartPage.dart';
import 'package:eram_app/CustomerProfile.dart';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/WishlistPage.dart';
import 'package:eram_app/utils/helper.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditcustomerProfile extends StatefulWidget {
  @override
  _EditcustomerProfile createState() => _EditcustomerProfile();
}

class _EditcustomerProfile extends State<EditcustomerProfile> {
  PickedFile  _image;
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
                      onTap: () async{
                        _image= await CameraHelper.getImage(0);
                        setState(() {

                        });
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: ()async {
                      _image= await CameraHelper.getImage(1);
                      setState(() {

                      });
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
    profile();
  }

  var listprofile, listsignup;
  bool progress = true;
  void profile() async {
    var url = Prefmanager.baseurl + '/user/me';
    var token = await Prefmanager.getToken();
    Map data = {
      "token": token,
    };
    var response = await http.post(url, body: data);
    if (json.decode(response.body)['status']) {
      listprofile = json.decode(response.body)['data'];
      firstnameController.text = listprofile['customerid']['firstName'];
      lastnameController.text = listprofile['customerid']['lastName'];
      emailController.text = listprofile['customerid']['email'];
      addressController.text = listprofile['customerid']['address'];
      mobileController.text = "+91 " + listprofile['phone'];
      genderController.text = listprofile['customerid']['gender'];
      dobController.text = listprofile['customerid']['dob'];
      pinController.text = listprofile['customerid']['pincode'];
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress = false;
    setState(() {});
  }

  var state, city, fulladdress, lat, lon;
  _getCurrentLocation() async {}

  TextEditingController keyword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Text("Account",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              )),
          actions: [
            IconButton(
              icon: Icon(Icons.favorite_outline,
                  size: 20, color: Color(0xFF7A7A7A)),
              onPressed: () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new WishlistPage())),
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart_outlined,
                  size: 20, color: Color(0xFF7A7A7A)),
              onPressed: () => Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new CartPage())),
            ),
          ],
        ),
        drawer: Drawer(
            child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
              progress
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      color: Colors.red,
                      child: DrawerHeader(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 40.0,
                                      backgroundColor: Colors.blue,
                                      backgroundImage: listprofile['customerid']
                                                  ['photo'] ==
                                              null
                                          ? AssetImage('assets/userlogo.jpg')
                                          : NetworkImage(
                                              Prefmanager.baseurl +
                                                  "/file/get/" +
                                                  listprofile['customerid']
                                                      ['photo'],
                                            ),
                                    ),
                                  ]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: new EdgeInsets.all(10.0),
                                    child: Text(
                                      listprofile['customerid']['firstName'] +
                                          " " +
                                          listprofile['customerid']['lastName'],
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                                //   width:40,
                              ),
                            ]),
                      ),
                    ),
              ListTile(
                leading: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                title: Text('Home',
                    style: GoogleFonts.poppins(
                      textStyle:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    )),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new MyNavigationBar()));
                  //Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.supervised_user_circle,
                  color: Colors.black,
                ),
                title: Text('Your Account',
                    style: GoogleFonts.poppins(
                      textStyle:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    )),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new CustomerProfile()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.supervised_user_circle,
                  color: Colors.black,
                ),
                title: Text('Your Wishlist',
                    style: GoogleFonts.poppins(
                      textStyle:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    )),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new WishlistPage()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                ),
                title: Text('Your Orders',
                    style: GoogleFonts.poppins(
                      textStyle:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    )),
                onTap: () {
                  // Navigator.push(
                  //     context, new MaterialPageRoute(
                  //     builder: (context) => new MyOrders()));
                },
              ),
            ])),
        body: progress
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: [
                              Text("Edit Profile",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Color(0xFF000000),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700))),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Stack(children: [
                            SizedBox(
                              height: 15,
                            ),
                            Positioned(
                              top: 13,
                              child: Container(
                                height: 3,
                                width: 120,
                                color: Color(0xFFFF4A4A),

                                // indent: 1,
                              ),
                            ),
                            Divider(
                              height: 30,
                              thickness: 1,
                              indent: 1,
                            ),
                          ]),
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
                                  // backgroundImage:_image==null?AssetImage('assets/userlogo.jpg'):
                                  // FileImage(_image),
                                  backgroundImage: _image != null
                                      ? FileImage(File(_image.path))
                                      : listprofile['customerid']['photo'] ==
                                              null
                                          ? FileImage(File(_image.path))
                                          : NetworkImage(Prefmanager.baseurl +
                                              "/file/get/" +
                                              listprofile['customerid']
                                                  ['photo'])),
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
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("First Name",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF8D8D8D),
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600))),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              alignment: Alignment.center,
                              height: 35,
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
                                keyboardType: TextInputType.text,
                                controller: firstnameController,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700)),
                                decoration: InputDecoration(
                                  labelStyle: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Color(0xFF1C1C1C),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700)),
                                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Color(0xFFD6D6D6),
                                    ),
                                  ),
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
                                Text("Last Name",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF8D8D8D),
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600))),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 35,
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
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700)),
                                decoration: InputDecoration(
                                  labelStyle: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Color(0xFF1C1C1C),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700)),
                                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Color(0xFFD6D6D6),
                                    ),
                                  ),
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
                                Text("Email Id",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF8D8D8D),
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600))),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 35,
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
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700)),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Color(0xFFD6D6D6),
                                    ),
                                  ),
                                ),
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
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600))),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 35,
                              child: TextFormField(
                                controller: addressController,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700)),
                                decoration: InputDecoration(
                                  //border: OutlineInputBorder(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Color(0xFFD6D6D6),
                                    ),
                                  ),
                                ),
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
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600))),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 35,
                              child: TextFormField(
                                // validator: (value) {
                                //   Pattern pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
                                //   RegExp regex = new RegExp(pattern);
                                //   if (value.length==0) {
                                //     return null;
                                //   }
                                //   else if (!regex.hasMatch(value))
                                //     return 'Invalid Mobilenumber';
                                //   else
                                //     return null;
                                // },
                                enabled: false,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ], //
                                controller: mobileController,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700)),
                                decoration: InputDecoration(
                                  labelStyle: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Color(0xFF1C1C1C),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700)),
                                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Color(0xFFD6D6D6),
                                    ),
                                  ),
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
                                Text("Gender",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF8D8D8D),
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600))),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 35,
                              child: TextFormField(
                                // validator: (value) {
                                //   if (value.isEmpty) {
                                //     return 'Please enter gender';
                                //   }
                                //   else
                                //     return null;
                                // },

                                controller: genderController,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700)),
                                decoration: InputDecoration(
                                  labelStyle: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Color(0xFF1C1C1C),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700)),
                                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Color(0xFFD6D6D6),
                                    ),
                                  ),
                                  //labelText: 'Name',
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Date of Birth",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF8D8D8D),
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600))),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 35,
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
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700)),
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.calendar_today,
                                      color: Colors.black,
                                      size: 20,
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
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Color(0xFFD6D6D6),
                                    ),
                                  ),

                                  //labelText: 'Name',
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
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600))),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 35,
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
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700)),
                                decoration: InputDecoration(
                                  labelStyle: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Color(0xFF1C1C1C),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700)),
                                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Color(0xFFD6D6D6),
                                    ),
                                  ),
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
                        progress1
                            ? Center(
                          child: CircularProgressIndicator(),
                        )
                        :Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: RaisedButton(
                              textColor: Colors.white,
                              color: Color(0xFFFC4B4B),
                              shape: RoundedRectangleBorder(
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
                                  CameraHelper.addSinglePhoto('/customer/profile/update',File(_image.path),null);
                                }
                              },
                            )),
                        // SizedBox(height: 80),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        //   child: Row(children: [
                        //     Text("My List",
                        //         style: GoogleFonts.poppins(
                        //             textStyle: TextStyle(
                        //                 color: Color(0xFFAEAEAE),
                        //                 fontSize: 10,
                        //                 fontWeight: FontWeight.w600))),
                        //     SizedBox(width: 50),
                        //     Text("Legal Information",
                        //         style: GoogleFonts.poppins(
                        //             textStyle: TextStyle(
                        //                 color: Color(0xFFAEAEAE),
                        //                 fontSize: 10,
                        //                 fontWeight: FontWeight.w600))),
                        //     SizedBox(width: 50),
                        //     Text("FAQ's",
                        //         style: GoogleFonts.poppins(
                        //             textStyle: TextStyle(
                        //                 color: Color(0xFFAEAEAE),
                        //                 fontSize: 10,
                        //                 fontWeight: FontWeight.w600))),
                        //   ]),
                        // ),
                        // SizedBox(height: 10),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        //   child: Row(children: [
                        //     Text("Contact us",
                        //         style: GoogleFonts.poppins(
                        //             textStyle: TextStyle(
                        //                 color: Color(0xFFAEAEAE),
                        //                 fontSize: 10,
                        //                 fontWeight: FontWeight.w600))),
                        //     SizedBox(width: 30),
                        //     InkWell(
                        //         child: Text("Logout",
                        //             style: GoogleFonts.poppins(
                        //                 textStyle: TextStyle(
                        //                     color: Color(0xFFAEAEAE),
                        //                     fontSize: 10,
                        //                     fontWeight: FontWeight.w600))),
                        //         onTap: () {
                        //           Prefmanager.clear();
                        //           Navigator.pushReplacement(
                        //               context,
                        //               new MaterialPageRoute(
                        //                   builder: (context) =>
                        //                       new MyHomePage()));
                        //         })
                        //   ]),
                        // )
                      ],
                    ))));
  }


  bool progress1 = false;

  void senddata() async {
    setState(() {
      progress1 = true;
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
        "gender": genderController.text,
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
          Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                  builder: (context) => new CustomerProfile()));
        } else {
          print(json.decode(response.body)['message']);
          Fluttertoast.showToast(
            msg: json.decode(response.body)['message'],
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

  var searchMsg;
  void senddata1() async {
    try {
      var url = Prefmanager.baseurl + '/seller/search';
      var token = await Prefmanager.getToken();
      Map data = {
        'keyword': keyword.text,
      };
      print(data.toString());
      var body = json.encode(data);
      var response = await http.post(url,
          headers: {"Content-Type": "application/json", "token": token},
          body: body);
      print("yyu" + response.statusCode.toString());
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)['status']) {}

        // else{
        //   searchMsg=json.decode(response.body)['msg'];
        //   Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SearchProduct(keyword.text,searchMsg))).then((value) {
        //     //This makes sure the textfield is cleared after page is pushed.
        //     keyword.clear();
        //   });
        // print(json.decode(response.body)['msg']);
        // Fluttertoast.showToast(
        //   msg:json.decode(response.body)['msg'],
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.CENTER,
        //
        // );
        //}
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } on SocketException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  void senddata2() async {
    try {
      var url = Prefmanager.baseurl + '/product/search';
      var token = await Prefmanager.getToken();
      Map data = {
        'keyword': keyword.text,
      };
      print(data.toString());
      var body = json.encode(data);
      var response = await http.post(url,
          headers: {"Content-Type": "application/json", "token": token},
          body: body);
      print("yyu" + response.statusCode.toString());
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)['status']) {
          // Navigator.push(context,new MaterialPageRoute(builder: (context)=>new ShopPage(keyword.text))).then((value) {
          //   //This makes sure the textfield is cleared after page is pushed.
          //   keyword.clear();
          // });
        }

        // else{
        //   searchMsg=json.decode(response.body)['msg'];
        //   Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SearchProduct(keyword.text,searchMsg))).then((value) {
        //     //This makes sure the textfield is cleared after page is pushed.
        //     keyword.clear();
        //   });
        // print(json.decode(response.body)['msg']);
        // Fluttertoast.showToast(
        //   msg:json.decode(response.body)['msg'],
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.CENTER,
        //
        // );
        //}
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } on SocketException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
  }
}
