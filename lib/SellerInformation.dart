import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eram_app/SellerworkHour.dart';
import 'package:eram_app/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:eram_app/Prefmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';

class SellerInformation extends StatefulWidget {
  @override
  _SellerInformation createState() => _SellerInformation();
}

class _SellerInformation extends State<SellerInformation> {
  final _formKey = GlobalKey<FormState>();
  var bank, acholder, acnumber, ifsc, branch;
  bool hasPressed = false;
  bool hasPressed1 = false;
  bool checkPress = true;
  bool changeLocation = false;
  TextEditingController shopnameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _kLake;
  Set<Marker> _markers = {};
  BitmapDescriptor pinLocationIcon;
  // final Marker marker = Marker(markerId:'location',icon: BitmapDescriptor.defaultMarker);
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  PickedFile _image;
  PickedFile _image1;
  void _showPicker(context, String s) {
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
                        // _imgFromGallery();
                        if (s == 'photo')
                          _image = await CameraHelper.getImage(0);
                        else
                          _image1 = await CameraHelper.getImage(0);
                        setState(() {});
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () async {
                      // _imgFromCamera();
                      if (s == 'photo')
                        _image = await CameraHelper.getImage(1);
                      else
                        _image1 = await CameraHelper.getImage(1);
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

  var state, city, fulladdress, lat, lon, pin;
  bool loading = true;
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        lat = position.latitude;
        lon = position.longitude;
      });
      _getAddressFromLatLng();
      _markers.add(Marker(
          position: LatLng(lat, lon),
          markerId: MarkerId("selected-location"),
          onTap: () {
            //CommonFunction.openMap(postion);
          }));
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
      pin = first.postalCode;
      //print("${first.adminArea} : ${first.}");
      print(city);
      //placeController.text=city;
      cityController.text = city;
      pinController.text = pin;
      _kLake = CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(lat, lon),
          zoom: 17.151926040649414);
      loading = false;
      if (mounted) setState(() {});
    } catch (e) {
      print(e);
    }
  }

  _getAddressFromLatLon() async {
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
      pin = first.postalCode;
      //print("${first.adminArea} : ${first.}");
      print(state);
      print(fulladdress);
      print(city);
      //placeController.text=city;
      cityController.text = city;
      pinController.text = pin;
      _kLake = CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(lat, lon),
          zoom: 17.151926040649414);
      loading = false;
      if (mounted) setState(() {});
    } catch (e) {
      print(e);
    }
    //Text(fulladdress.text);
  }

  LatLng postion;
  void onMapTapFun(latlon) {
    print("gggh");
    lat = latlon.latitude;
    print(lat);
    lon = latlon.longitude;
    print(lon);
    setState(() {
      _getAddressFromLatLon();
    });
  }

  Widget googlemap() {
    return Column(
      children: [
        Container(
          //width:double.infinity,
          height: 300,
          child: GoogleMap(
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              new Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
            ].toSet(),
            //myLocationEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: _kLake,
            markers: _markers,
            onTap: (latlon) {
              postion = latlon;
              onMapTapFun(latlon);
              setState(() {
                _markers.clear();
                _markers.add(Marker(
                    position: postion,
                    markerId: MarkerId("selected-location"),
                    onTap: () {
                      //CommonFunction.openMap(postion);
                    }));
              });
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              setState(() {});
            },
          ),
        ),
        SizedBox(height: 20),
        Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: FlatButton(
              textColor: Colors.white,
              color: Color(0xFFFC4B4B),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color(0xFFD2D2D2)),
                  borderRadius: BorderRadius.circular(7.0)),
              child: Text('Submit',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500),
                  )),
              onPressed: () {
                setState(() {
                  hasPressed1 = true;
                  hasPressed = false;
                });
              },
            )),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/materialinfo.png'),
              width: 20,
              height: 20,
            ),
            SizedBox(width: 10),
            Text("Hold over your store location to mark on map",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Color(0xFF838181),
                      fontSize: 11,
                      fontWeight: FontWeight.w500),
                ))
          ],
        )
      ],
    );
  }

  Widget googlemap1() {
    return Column(children: [
      Container(
        //width:double.infinity,
        height: 300,
        child: Stack(children: [
          GoogleMap(
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              new Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
            ].toSet(),
            // myLocationEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: _kLake,
            markers: _markers,
            // onTap:(latlon){
            //   postion = latlon;
            //   onMapTapFun(latlon);
            //   setState(() {
            //     //_markers.clear();
            //     _markers.add(Marker(
            //         position:postion,
            //         markerId: MarkerId("selected-location"),
            //         onTap: (){
            //           //CommonFunction.openMap(postion);
            //         }
            //     ));
            //   });
            //
            // } ,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              setState(() {});
            },
          ),
          Positioned(
            top: 30,
            right: 10,
            child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width / 2,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: FlatButton(
                  textColor: Colors.white,
                  color: Color(0xFFFC4B4B),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xFFD2D2D2)),
                      borderRadius: BorderRadius.circular(7.0)),
                  child: Text('Change Location',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500),
                      )),
                  onPressed: () {
                    setState(() {
                      changeLocation = true;
                      hasPressed1 = false;
                      hasPressed = true;
                    });
                  },
                )),
          ),
          //changeLocation?Googlemap():SizedBox.shrink()
        ]),
      ),
    ]);
  }

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Center(
              child: Text("Welcome"),
            ),
          );
        });
  }

  bool checkmappress = false;
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
                child: SingleChildScrollView(
                  child: Column(
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
                          value: 0.3,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("1/4 Steps",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Color(0xFF454545),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400))),
                      SizedBox(height: 15),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal:8.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Container(
                      //           alignment: Alignment.center,
                      //           padding: EdgeInsets.all(10),
                      //           child: Text(
                      //             'Upload Shop Icon',
                      //               style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))
                      //           )
                      //       ),
                      //       SizedBox(width:10),
                      //       Container(
                      //           alignment: Alignment.center,
                      //           padding: EdgeInsets.all(10),
                      //           child: Text(
                      //             'Upload Cover Photo',
                      //               style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))
                      //           )
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Center(
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       _showPicker(context);
                          //     },
                          //     child: _image!=null?
                          //     CircleAvatar(
                          //       radius: 60,
                          //       backgroundColor: Color(0xFFE3F2FD),
                          //       backgroundImage:FileImage(
                          //         _image,
                          //       ),
                          //     )
                          //         : Container(
                          //       decoration: BoxDecoration(
                          //           color: Colors.grey[200],
                          //           borderRadius: BorderRadius.circular(100)),
                          //       width: 120,
                          //       height: 120,
                          //       child: Icon(
                          //         Icons.camera_alt,
                          //         color: Colors.grey[800],
                          //       ),
                          //
                          //     ),
                          //   ),),
                          // SizedBox(width:10),
                          Stack(
                              //alignment: Alignment.bottomLeft,
                              children: [
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      _showPicker(context, 'coverphoto');
                                    },
                                    child: _image1 != null
                                        ?
                                        // CircleAvatar(
                                        //   radius: 60,
                                        //   backgroundColor: Color(0xFFE3F2FD),
                                        //   backgroundImage:FileImage(
                                        //     _image1,
                                        //   ),
                                        // )
                                        Container(
                                            width:
                                                MediaQuery.of(context).size.width,
                                            height: 180,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(25),
                                                bottomRight: Radius.circular(25),
                                              ),
                                              child: Image(
                                                  image: FileImage(
                                                    File(_image1.path),
                                                  ),
                                                  width: double.infinity,
                                                  fit: BoxFit.cover),
                                            ),
                                          )
                                        : Container(
                                            width:
                                                MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(25),
                                                  bottomRight:
                                                      Radius.circular(25),
                                                )),
                                            // width: 120,
                                            height: 150,
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _showPicker(context, 'photo');
                                  },
                                  child: _image != null
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 60, 0, 0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                            ),
                                            width: 80,
                                            height: 80,
                                            child: ClipRRect(
                                              child: Image(
                                                  image: FileImage(
                                                    File(_image.path),
                                                  ),
                                                  width: double.infinity,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 60, 0, 0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              //borderRadius: BorderRadius.circular(50)
                                            ),
                                            width: 100,
                                            height: 90,
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                        ),
                                ),
                              ]),
                        ],
                      ),

                      // Container(
                      //   alignment:Alignment.topCenter,
                      //   padding: new EdgeInsets.all(20.0),
                      //   //padding:EdgeInsets.fromLTRB(20, 0, 20, 0),
                      //   child:Stack(
                      //     children: [
                      //       // Container(
                      //       //   padding: EdgeInsets.all(10),
                      //       //   alignment: Alignment.bottomCenter,
                      //       //   child: CircleAvatar(
                      //       //     radius: 80.0,
                      //       //     backgroundColor: Colors.blue,
                      //       //     backgroundImage:AssetImage('assets/userlogo.jpg'),
                      //       //
                      //       //
                      //       //   ),
                      //       // ),
                      //
                      //       CircleAvatar(
                      //         radius: 40,
                      //         backgroundColor: Color(0xFFE3F2FD),
                      //         backgroundImage:_image==null?AssetImage('assets/userlogo.jpg'):
                      //         FileImage(_image),
                      //       ),
                      //       new Positioned(
                      //           bottom: 1,
                      //           right:2,
                      //           child:ClipOval(
                      //             child:Container(
                      //               height: 30,
                      //               width:30,
                      //               color:Color(0xFFF4F4F4),
                      //               child: IconButton(
                      //                 icon:Icon(Icons.edit_outlined,size:15,color:Color(0xFF000000)),
                      //                 onPressed: (){
                      //                   _showPicker(context);
                      //                 },
                      //               ),
                      //             ),
                      //           )
                      //       )
                      //     ],
                      //   ) ,
                      // ),
                      // Container(
                      //   height: 220,
                      //   child: Stack(children:[
                      //     ClipRRect(borderRadius:BorderRadius.only(bottomLeft: Radius.circular(25),
                      //       bottomRight: Radius.circular(25),),child: Image(image:AssetImage('assets/slider1.jpg'),width: double.infinity,height: 167,fit: BoxFit.cover,)),
                      //     Positioned(bottom:55,
                      //       child: Container(
                      //         alignment:Alignment.topCenter,
                      //         padding: new EdgeInsets.all(20.0),
                      //         //padding:EdgeInsets.fromLTRB(20, 0, 20, 0),
                      //         child:Stack(
                      //           children: [
                      //             // CircleAvatar(
                      //             //   radius: 40,
                      //             //   backgroundColor: Color(0xFFE3F2FD),
                      //             //  backgroundImage:_image==null?AssetImage('assets/oxygen.png'):
                      //             //   FileImage(_image),
                      //             // ),
                      //             ClipRRect(
                      //               borderRadius: BorderRadius.circular(3.0),
                      //               child: _image==null?Image.asset('assets/oxygen.png',height: 80,width:70):
                      //               FileImage(_image),
                      //
                      //               ),
                      //
                      //             new Positioned(
                      //
                      //                 left:45,
                      //                 bottom: 0,
                      //                 child:ClipOval(
                      //                   child:Container(
                      //                     height: 25,
                      //                     width:25,
                      //                     color:Color(0xFFF4F4F4),
                      //                     child: IconButton(
                      //                       icon:Icon(Icons.edit_outlined,size:15,color:Color(0xFF408BFF)),
                      //                       onPressed: (){
                      //                         _showPicker(context);
                      //                       },
                      //                     ),
                      //                   ),
                      //                 )
                      //             )
                      //           ],
                      //         ) ,
                      //       ),
                      //     ),
                      //     Positioned(left:150,bottom:30,child: Text("Change Cover Photo",textAlign:TextAlign.center,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF0451CC),fontSize:9,fontWeight: FontWeight.w500),))),
                      //
                      //   ]
                      //   ),
                      // ),
                      SizedBox(height: 30),
                      //Container(child: Card(elevation: 4,)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Shop Name",
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
                                return 'Please enter shop name';
                              }
                              else if(value.length>35)
                                return 'Only 35 characters are allowed';
                              else
                                return null;
                            },
                            //maxLength: 35,
                            //autovalidateMode: AutovalidateMode.always,
                            controller: shopnameController,
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
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Description",
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
                                return 'Please enter description';
                              }
                              else if(value.length>35)
                                return 'Only 35 characters are allowed';
                              else
                                return null;
                            },
                            //autovalidateMode: AutovalidateMode.always,
                           // maxLength: 35,
                            controller: descriptionController,
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
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Location",
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
                                return 'Please enter location';
                              }
                              else if(value.length>25)
                                return 'Only 25 characters are allowed';
                              else
                                return null;
                            },
                            //autovalidateMode: AutovalidateMode.always,
                            maxLength: 25,
                            controller: placeController,
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
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("City",
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
                                return 'Please enter city';
                              } else
                                return null;
                            },
                            //autovalidateMode: AutovalidateMode.always,
                            controller: cityController,
                            enabled: false,
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
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Pincode",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Color(0xFFAFAFAF),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400))),
                            ],
                          ),
                          TextFormField(
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
                            //autovalidateMode: AutovalidateMode.always,
                            controller: pinController,
                            enabled: false,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ], //
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
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Choose from Map",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFFAFAFAF),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      checkPress
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                width: double.infinity,
                                height: 70,
                                padding: new EdgeInsets.all(10.0),
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: BorderSide(color: Color(0xFFD6D6D6))),
                                  textColor: Color(0xFF000000),
                                  color: Colors.white,
                                  child: Text('Open Map',
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Color(0xFF000000),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600))),
                                  onPressed: () {
                                    setState(() {
                                      checkmappress = true;
                                      hasPressed = true;
                                      checkPress = false;
                                      //displayBottomSheet(context);
                                    });
                                  },
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      hasPressed ? googlemap() : SizedBox.shrink(),
                      hasPressed1 ? googlemap1() : SizedBox.shrink(),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Email",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Color(0xFFAFAFAF),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400))),
                            ],
                          ),
                          TextFormField(
                            //autovalidateMode: AutovalidateMode.always,
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
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Whatsapp Number",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Color(0xFFAFAFAF),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400))),
                            ],
                          ),
                          TextFormField(
                            //autovalidateMode: AutovalidateMode.always,
                            validator: (value) {
                              Pattern pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
                              RegExp regex = new RegExp(pattern);
                              if (value.length == 0) {
                                return null;
                              } else if (!regex.hasMatch(value))
                                return 'Invalid Whatsappnumber';
                              else {
                                return null;
                              }
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
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Contact Person",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Color(0xFFAFAFAF),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400))),
                            ],
                          ),
                          TextFormField(
                            //autovalidateMode: AutovalidateMode.always,
                            validator: (value) {
                              Pattern pattern = r'^[a-zA-Z]';
                              RegExp regex = new RegExp(pattern);
                              if (value.isEmpty) {
                                return 'Please enter name of contact person';
                              } else if (!regex.hasMatch(value))
                                return 'Invalid name';
                              else if(value.length>25)
                                return 'Only 25 characters are allowed';
                              else
                                return null;
                            },
                           // maxLength: 25,
                            controller: contactController,
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
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Instagram URL",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Color(0xFFAFAFAF),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400))),
                            ],
                          ),
                          TextFormField(
                            controller: instagramController,
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
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Facebook URL",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Color(0xFFAFAFAF),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400))),
                            ],
                          ),
                          TextFormField(
                            controller: facebookController,
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
                      SizedBox(
                        height: 20,
                      ),
                      progress1
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(
                              height: 50,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: FlatButton(
                                textColor: Colors.white,
                                color: Color(0xFFFC4B4B),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Color(0xFFD2D2D2)),
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
                                    if (_image == null)
                                      Fluttertoast.showToast(
                                        msg: "Please upload shop icon",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                      );
                                    else if (_image1 == null)
                                      Fluttertoast.showToast(
                                        msg: "Please upload cover photo",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                      );
                                    else if (checkmappress == false)
                                      Fluttertoast.showToast(
                                        msg: "Please select location from map",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                      );
                                    else if (hasPressed1 == false)
                                      Fluttertoast.showToast(
                                        msg: "Please submit location from map",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                      );
                                    else {
                                      senddata();
                                      CameraHelper.addSinglePhoto(
                                          '/seller/profile/level1',
                                          File(_image.path),
                                          File(_image1.path));
                                    }
                                  }
                                },
                              )),
                    ],
                  ),
                ))));
  }

  bool progress1 = false;
  void senddata() async {
    setState(() {
      progress1 = true;
    });
    try {
      String token = await Prefmanager.getToken();
      var url = Prefmanager.baseurl + '/seller/profile/level1';
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': token
      };

      Map data = {
        'shopName': shopnameController.text,
        'description': descriptionController.text,
        'place': placeController.text,
        'city': cityController.text,
        'pincode': pinController.text,
        'lat': lat.toString(),
        'lon': lon.toString(),
        'contactPerson': contactController.text,
        'email': emailController.text,
        'whatsapp': mobileController.text,
        'facebook': facebookController.text,
        'instagram': instagramController.text,
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
          await Prefmanager.setLevel(json.decode(response.body)['level']);
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new SellerworkHour()));
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
          setState(() {
            progress1=false;
          });
          print(json.decode(response.body)['msg']);
          Fluttertoast.showToast(
            msg:json.decode(response.body)['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,

          );
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
