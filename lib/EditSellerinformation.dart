
import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
class EditSellerinformation extends StatefulWidget {
  final id,name;
  EditSellerinformation(this.id,this.name);
  @override
  _EditSellerinformation  createState() => _EditSellerinformation();
}
class _EditSellerinformation  extends State<EditSellerinformation > {
  final _formKey = GlobalKey<FormState>();
  var bank,acholder,acnumber,ifsc,branch;
  bool hasPressed=false;
  bool hasPressed1=false;
  bool checkPress=true;
  bool changeLocation=false;
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
  CameraPosition _kLake ;
  Set<Marker> _markers = {};
  BitmapDescriptor pinLocationIcon;
  // final Marker marker = Marker(markerId:'location',icon: BitmapDescriptor.defaultMarker);
  void initState() {
    super.initState();
    sample();
  }
  Future sample()async{
    //await _getCurrentLocation();

    await sellerview();
    await setInitalValues();
  }
  File _image;
  _imgFromCamera() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );
    setState(() {
      _image = image;
    });
  }
  _imgFromGallery() async {
    // ignore: deprecated_member_use
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    setState(() {
      _image = image;
    });
  }
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
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),

                ],
              ),
            ),

          );
        }
    );
  }
  File _image1;
  _imgFromCamera1() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );
    setState(() {
      _image1 = image;
    });
  }
  _imgFromGallery1() async {
    // ignore: deprecated_member_use
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    setState(() {
      _image1 = image;
    });
  }
  void _showPicker1(context) {
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
                      onTap: () {
                        _imgFromGallery1();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera1();
                      Navigator.of(context).pop();
                    },
                  ),

                ],
              ),
            ),

          );
        }
    );
  }
  setInitalValues() {
    print(lat);
    print(lon);
    _markers.add(Marker(
        position:LatLng(lat,lon),
        markerId: MarkerId("selected-location"),
        onTap: (){
          //CommonFunction.openMap(postion);
        }
    ));

    _kLake = CameraPosition(
      target: LatLng(lat, lon),
      zoom: 14.4746,
    );

    loading = false;
    setState(() {});
  }
  var pin,state,city,fulladdress,lat,lon;
  bool loading = true;
  _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        lat = position.latitude;
        lon = position.longitude;
      });
      _getAddressFromLatLng();
      // _markers.add(Marker(
      //     position:LatLng(lat,lon),
      //     markerId: MarkerId("selected-location"),
      //     onTap: (){
      //       //CommonFunction.openMap(postion);
      //     }
      // ));
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      print("Addresss...");
      final coordinates = new Coordinates(lat,lon);
      print(coordinates);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      print(addresses.first.addressLine);
      state=first.adminArea;
      city=first.locality;
      fulladdress=first.addressLine;
      pin = first.postalCode;
      cityController.text = city;
      pinController.text = pin;
      //print("${first.adminArea} : ${first.}");
      print(state);
      print(fulladdress);
      print(city);
      _kLake = CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(lat,lon),
          zoom: 17.151926040649414);
      loading = false;
      if(mounted)
        setState(() {});
    } catch (e) {
      print(e);
    }
  }
  _getAddressFromLatLon() async {
    try {
      print("Addresss...");
      final coordinates = new Coordinates(lat,lon);
      print(coordinates);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      print(addresses.first.addressLine);
      state=first.adminArea;
      city=first.locality;
      fulladdress=first.addressLine;
      pin = first.postalCode;
      cityController.text = city;
      pinController.text = pin;
      //print("${first.adminArea} : ${first.}");
      print(state);
      print(fulladdress);
      print(city);
      _kLake = CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(lat,lon),
          zoom: 17.151926040649414);
      loading = false;
      if(mounted)
        setState(() {});
    } catch (e) {
      print(e);
    }
    //Text(fulladdress.text);
  }
  LatLng postion ;
  void onMapTapFun(latlon) {
    print("gggh");
    lat=latlon.latitude;
    print(lat);
    lon=latlon.longitude;
    print(lon);
    setState(() {
      _getAddressFromLatLon();
    });
  }
  Widget googlemap(){
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
            onTap:(latlon){
              postion = latlon;
              onMapTapFun(latlon);
              setState(() {
                _markers.clear();
                _markers.add(Marker(
                    position:postion,
                    markerId: MarkerId("selected-location"),
                    onTap: (){
                      //CommonFunction.openMap(postion);
                    }
                ));
              });

            } ,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              setState(() {

              });
            },
          ),
        ),
        SizedBox(height:20),
        Container(
            height: 50,
            width:MediaQuery.of(context).size.width,
            padding:EdgeInsets.symmetric(horizontal: 15),
            child: FlatButton(
              textColor: Colors.white,
              color: Color(0xFFFC4B4B),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color(0xFFD2D2D2)),
                  borderRadius: BorderRadius.circular(7.0)),
              child: Text('Submit',style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.white,fontSize:11,fontWeight: FontWeight.w500),)),
              onPressed: () {
                setState(() {
                  hasPressed1=true;
                  hasPressed=false;
                });

              },
            )),

        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/materialinfo.png'),width: 20,height: 20,),SizedBox(width:10),
            Text("Hold over your store location to mark on map",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF838181),fontSize:11,fontWeight: FontWeight.w500),))
          ],
        )
      ],
    );

  }
  Widget googlemap1(){
    return Column(
        children: [
          Container(
            //width:double.infinity,
            height: 300,
            child: Stack(
                children: [

                  GoogleMap(
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                      new Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
                    ].toSet(),
                    // myLocationEnabled: false,
                    mapType: MapType.normal,
                    initialCameraPosition: _kLake,
                    markers: _markers,
                    onTap:(latlon){
                      postion = latlon;
                      onMapTapFun(latlon);
                      setState(() {
                        //_markers.clear();
                        _markers.add(Marker(
                            position:postion,
                            markerId: MarkerId("selected-location"),
                            onTap: (){
                              //CommonFunction.openMap(postion);
                            }
                        ));
                      });

                    } ,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      setState(() {

                      });
                    },
                  ),
                  Positioned(top:30,right:10,
                    child: Container(
                        height: 45,
                        width:MediaQuery.of(context).size.width/2,
                        padding:EdgeInsets.symmetric(horizontal: 15),
                        child: FlatButton(
                          textColor: Colors.white,
                          color: Color(0xFFFC4B4B),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Color(0xFFD2D2D2)),
                              borderRadius: BorderRadius.circular(7.0)),
                          child: Text('Change Location',style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.white,fontSize:11,fontWeight: FontWeight.w500),)),
                          onPressed: () {
                            setState(() {
                              changeLocation=true;
                              hasPressed1=false;
                              hasPressed=true;
                            });

                          },
                        )),
                  ),
                  //changeLocation?Googlemap():SizedBox.shrink()
                ]
            ),
          ),
        ]);
  }
  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            height: MediaQuery.of(context).size.height  * 0.4,
            child: Center(
              child: Text("Welcome"),
            ),
          );
        });
  }
  var sid,seller,is24;
  List sub=[];
  bool progress1=true;
  var caticon;
  Future<void>sellerview() async{
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    var url=Prefmanager.baseurl+'/user/me';
    var response = await http.post(url,headers: requestHeaders);
    print(json.decode(response.body));
    print(widget.id);
    print(token);
    if(json.decode(response.body)['status']) {
      seller= json.decode(response.body)['data'];
      lon=json.decode(response.body)['data']['sellerid']['location'][0];
      lat=json.decode(response.body)['data']['sellerid']['location'][1];
      print(lon);
      shopnameController.text=seller['sellerid']['shopName'];
      descriptionController.text=seller['sellerid']['description'];
      placeController.text=seller['sellerid']['place'];
      cityController.text=seller['sellerid']['city'];
      pinController.text=seller['sellerid']['pincode'];
      contactController.text=seller['sellerid']['contactPerson'];
      emailController.text=seller['sellerid']['email'];
      mobileController.text=seller['sellerid']['socialmedialinks']['whatsapp'];
      facebookController.text=seller['sellerid']['socialmedialinks']['facebook'];
      instagramController.text=seller['sellerid']['socialmedialinks']['instagram'];


    }
    else
      Fluttertoast.showToast(
        msg:json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress1=false;
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Text("Account Settings",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:16,fontWeight: FontWeight.w600),)),

        ),

        body:  progress1?Center(child:CircularProgressIndicator(),):
        Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Container(
                    //   alignment:Alignment.topCenter,
                    //  // padding: new EdgeInsets.all(20.0),
                    //   //padding:EdgeInsets.fromLTRB(20, 0, 20, 0),
                    //   child:Stack(
                    //     children: [
                    // //       CircleAvatar(
                    // //         radius: 60,
                    // //         backgroundColor: Color(0xFFE3F2FD),
                    // //         backgroundImage:_image!=null?FileImage(
                    // //                     _image):seller['sellerid']['photo']==null? FileImage(
                    // //                     _image)
                    // //                 :NetworkImage(Prefmanager.baseurl+"/file/get/"+seller['sellerid']['photo'])
                    // //       ),
                    // //       new Positioned(
                    // //           bottom: 1,
                    // //           right:2,
                    // //           child:ClipOval(
                    // //             child:Container(
                    // //               height: 30,
                    // //               width:30,
                    // //               color:Color(0xFFF4F4F4),
                    // //               child: IconButton(
                    // //                 icon:Icon(Icons.camera_alt,size:15,color:Color(0xFF000000)),
                    // //                 onPressed: (){
                    // //                   _showPicker(context);
                    // //                 },
                    // //               ),
                    // //             ),
                    // //           )
                    // //       )
                    // //     ],
                    // //   ) ,
                    // // ),
                    // Center(
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       _showPicker(context);
                    //     },
                    //     child: _image!=null||seller['sellerid']['photo']!=null?
                    //     CircleAvatar(
                    //       radius: 60,
                    //       backgroundColor: Color(0xFFE3F2FD),
                    //       backgroundImage:_image!=null?FileImage(
                    //           _image):seller['sellerid']['photo']==null? FileImage(
                    //           _image)
                    //       :NetworkImage(Prefmanager.baseurl+"/file/get/"+seller['sellerid']['photo'])
                    //
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


                    Container(
                      alignment:Alignment.topCenter,
                      //padding: new EdgeInsets.all(20.0),
                      //padding:EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child:Stack(
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

                          // CircleAvatar(
                          //     radius: 60,
                          //     backgroundColor: Color(0xFFE3F2FD),
                          //     backgroundImage:_image1!=null?FileImage(
                          //         _image1):seller['sellerid']['coverPhoto']==null? FileImage(
                          //         _image1)
                          //         :NetworkImage(Prefmanager.baseurl+"/file/get/"+seller['sellerid']['coverPhoto'])
                          // ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 180,
                            child: ClipRRect(borderRadius:BorderRadius.only(bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),),child: Image(image:_image1!=null?FileImage(
                              _image1,
                            ):NetworkImage(Prefmanager.baseurl+"/file/get/"+seller['sellerid']['coverPhoto']),width:double.infinity,fit:BoxFit.cover),),
                          ),
                          new Positioned(
                              bottom: 1,
                              right:2,
                              child:ClipOval(
                                child:Container(
                                  height: 30,
                                  width:30,
                                  color:Color(0xFFF4F4F4),
                                  child: IconButton(
                                    icon:Icon(Icons.camera_alt,size:15,color:Color(0xFF000000)),
                                    onPressed: (){
                                      _showPicker1(context);
                                    },
                                  ),
                                ),
                              )
                          ),
                          Positioned(
                            left:20,bottom: 40,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                //borderRadius: BorderRadius.circular(50)
                              ),
                              width: 80,
                              child: ClipRRect(child: Image(image:_image!=null?FileImage(
                                _image,
                              ):seller['sellerid']['photo']==null? FileImage(
                                  _image)
                                  :NetworkImage(Prefmanager.baseurl+"/file/get/"+seller['sellerid']['photo']),width:double.infinity,fit:BoxFit.cover),),
                            ),
                          ),
                          new Positioned(
                              top: 60,
                              left:25,
                              child:ClipOval(
                                child:Container(
                                  height: 30,
                                  width:30,
                                  color:Color(0xFFF4F4F4),
                                  child: IconButton(
                                    icon:Icon(Icons.camera_alt,size:15,color:Color(0xFF000000)),
                                    onPressed: (){
                                      _showPicker(context);
                                    },
                                  ),
                                ),
                              )
                          )
                        ],
                      ) ,
                    ),
                  ],
                ),
                SizedBox(height:10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Shop Name",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
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
                         // maxLength: 35,
                          controller: shopnameController,
                          style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                          decoration: InputDecoration(
                            labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                          ),
                        ),
                        SizedBox(height: 20,),


                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Description",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
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
                         // maxLength: 35,
                          controller: descriptionController,
                          style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                          decoration: InputDecoration(
                            labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                          ),
                        ),
                        SizedBox(height: 20,),


                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Location",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
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
                          //maxLength: 25,
                          controller: placeController,
                          style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                          decoration: InputDecoration(
                            labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                          ),
                        ),
                        SizedBox(height: 20,),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("City",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
                          ],
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter city';
                            }
                            else
                              return null;
                          },
                          enabled:false,
                          controller: cityController,
                          style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                          decoration: InputDecoration(
                            labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                          ),
                        ),
                        SizedBox(height: 20,),


                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Pincode",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
                          ],
                        ),
                        TextFormField(
                          validator: (value) {
                            Pattern pattern = r'^[1-9][0-9]{5}$';
                            RegExp regex = new RegExp(pattern);
                            if (value.isEmpty) {
                              return 'Please enter pincode';
                            }
                            else if (!regex.hasMatch(value))
                              return 'Please enter 6 digit pincode';
                            else
                              return null;

                          },
                          enabled:false,
                          controller: pinController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ], //
                          style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                          decoration: InputDecoration(
                            labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                          ),
                        ),
                        SizedBox(height: 20,),


                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Choose from Map",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
                    ],
                  ),
                ),
                SizedBox(height:10),
                checkPress?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:10.0),
                  child: Container(
                    width:180,
                    height:70,
                    padding: new EdgeInsets.all(10.0),
                    child:FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Color(0xFFD6D6D6))),

                      textColor: Color(0xFF000000),
                      color: Colors.white,
                      child: Text('Open Map',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:12,fontWeight: FontWeight.w600))),
                      onPressed: ()  {
                        setState(() {
                          hasPressed=true;
                          checkPress=false;
                          //displayBottomSheet(context);
                        });

                      },
                    ),
                  ),
                )
                    :SizedBox.shrink(),
                hasPressed?googlemap():SizedBox.shrink(),
                hasPressed1?googlemap1():SizedBox.shrink(),
                SizedBox(height:20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Email",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
                          ],
                        ),
                        TextFormField(
                          validator: (value) {
                            Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = new RegExp(pattern);
                            if (value.isEmpty) {
                              return 'Please enter email';
                            }

                            else if (!regex.hasMatch(value))
                              return 'Invalid Email';
                            else
                              return null;
                          },
                          controller: emailController,
                          style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                          decoration: InputDecoration(
                            labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                          ),
                        ),
                        SizedBox(height: 20,),


                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Whatsapp Number",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
                          ],
                        ),
                        TextFormField(
                          validator: (value) {

                            Pattern pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
                            RegExp regex = new RegExp(pattern);
                            if (value.length == 0) {
                              return null;
                            }
                            else if (!regex.hasMatch(value))
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
                          style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                          decoration: InputDecoration(
                            labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                          ),
                        ),
                        SizedBox(height: 20,),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Contact Person",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
                          ],
                        ),
                        TextFormField( validator: (value) {
                          Pattern pattern =r'^[a-zA-Z]';
                          RegExp regex = new RegExp(pattern);
                          if (value.isEmpty) {
                            return 'Please enter name of contact person';
                          }

                          else if (!regex.hasMatch(value))
                            return 'Invalid name';
                          else if(value.length>25)
                            return 'Only 25 characters are allowed';
                          else
                            return null;
                        },
                         // maxLength: 25,
                          controller: contactController,
                          style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                          decoration: InputDecoration(
                            labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                          ),
                        ),
                        SizedBox(height: 20,),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Instagram URL",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
                          ],
                        ),
                        TextFormField(
                          controller: instagramController,
                          style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                          decoration: InputDecoration(
                            labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                          ),
                        ),
                        SizedBox(height: 20,),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Facebook URL",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
                          ],
                        ),
                        TextFormField(
                          controller: facebookController,
                          style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                          decoration: InputDecoration(
                            labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                          ),
                        ),
                        SizedBox(height: 20,),
                      ]),
                ),
                SizedBox(height: 20,),
                progress2?Center( child: CircularProgressIndicator(),):
                Container(
                    height: 50,
                    width:80,
                    padding:EdgeInsets.symmetric(horizontal: 15),
                    child: FlatButton(
                      textColor: Colors.white,
                      color: Color(0xFFFC4B4B),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Color(0xFFD2D2D2)),
                          borderRadius: BorderRadius.circular(7.0)),
                      child: Text('Edit',style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.white,fontSize:10,fontWeight: FontWeight.w700),)),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          senddata();
                          addSinglePhoto();
                          addSinglePhoto1();
                        }

                      },
                    )),
              ],
            )));
  }
  addSinglePhoto() async {
    var request = http.MultipartRequest('POST', Uri.parse(Prefmanager.baseurl + '/seller/profile/level1'));
    String token = await Prefmanager.getToken();
    request.headers.addAll({'Content-Type': 'application/form-data', 'token': token});
    if (_image != null) {
      request.files.add(http.MultipartFile.fromBytes(
          'photo', _image.readAsBytesSync(),
          filename: _image.path.split('/').last));
    }
    try {
      http.Response response =
      await http.Response.fromStream(await request.send());
      if(json.decode(response.body)['status'])
      {}
    } catch (e) {
      print(e);
    }
  }
  addSinglePhoto1() async {
    var request = http.MultipartRequest('POST', Uri.parse(Prefmanager.baseurl + '/seller/profile/level1'));
    String token = await Prefmanager.getToken();
    request.headers.addAll({'Content-Type': 'application/form-data', 'token': token});
    if (_image1 != null) {
      request.files.add(http.MultipartFile.fromBytes(
          'coverPhoto', _image1.readAsBytesSync(),
          filename: _image1.path.split('/').last));
    }
    try {
      http.Response response =
      await http.Response.fromStream(await request.send());
      if(json.decode(response.body)['status'])
      {}
    } catch (e) {
      print(e);
    }
  }
  bool progress2=false;
  void senddata() async {
    setState(() {
      progress2=true;
    });
    try{
      String token = await Prefmanager.getToken();
      var url = Prefmanager.baseurl+'/seller/profile/level1';
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': token
      };

      Map data={
        'shopName':shopnameController.text,
        'description':descriptionController.text,
        'place':placeController.text,
        'city':cityController.text,
        'pincode':pinController.text,
        'lat':lat.toString(),
        'lon':lon.toString(),
        'contactPerson':contactController.text,
        'email':emailController.text,
        'whatsapp':mobileController.text,
        'facebook':facebookController.text,
        'instagram':instagramController.text,

      };
      print(data);
      var body=json.encode(data);
      var response = await http.post(url,headers:requestHeaders,body: body);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if(json.decode(response.body)['status'])
        {
          print((json.decode(response.body)['token']));
          String token = await Prefmanager.getToken();
          print(token);
          Navigator.of(context).pop(true);
        }
        // else if(json.decode(response.body)['status']&&json.decode(response.body)['profileStatus']=='incomplete'&&json.decode(response.body)['role']=='seller')
        // {
        //   await Prefmanager.setToken(json.decode(response.body)['token']);
        //   // Navigator.push(
        //   //     context, new MaterialPageRoute(
        //   //     builder: (context) => new WorkingHour()));
        // }

        else{
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
            progress2=false;
          });
        }
      }
      else {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
    on SocketException catch(e){
      Fluttertoast.showToast(
        msg: "No internet",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      print(e.toString());
    }
    catch(e){
      print(e.toString());
    }
    setState(() {
      progress2=false;
    });

  }

}
