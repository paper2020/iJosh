import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:eram_app/EditBankdetails.dart';
import 'package:eram_app/EditSellerinformation.dart';
import 'package:eram_app/EditWorkinghour.dart';
import 'package:eram_app/SellerMoreImage.dart';
import 'package:eram_app/SellerratingAll.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:eram_app/Prefmanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:eram_app/SellerallRating.dart';
import 'package:eram_app/utils/helper.dart';
import 'SellerDoc.dart';

class SellerProfile extends StatefulWidget {
  final id, name;
  SellerProfile(this.id, this.name);
  @override
  _SellerProfile createState() => new _SellerProfile();
}

class _SellerProfile extends State<SellerProfile> {
  final dataKey = new GlobalKey();
  final reviewKey = new GlobalKey();
  FocusNode myFocusNode;
  void initState() {
    super.initState();
    sample();
    myFocusNode = FocusNode();
    //_getCurrentLocation();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Future sample() async {
    await sellerview();
    await ratingList();
    await setInitalValues();
  }

  bool myselection = false;
  var isSelected = false;
  var mycolor = Colors.white;
  var sid, seller, is24;
  List delimg = [];
  List sub = [];
  List shops = [];
  bool progress1 = true;
  var caticon;
  Future<void> sellerview() async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    var url = Prefmanager.baseurl + '/user/me';
    var response = await http.post(url, headers: requestHeaders);
    print(json.decode(response.body));
    print(widget.id);
    print(token);
    if (json.decode(response.body)['status']) {
      seller = json.decode(response.body)['data'];
      shops = json.decode(response.body)['data']['sellerid']['shopImages'];
      print(shops);
      lon = seller['sellerid']['location'][0];
      lat = seller['sellerid']['location'][1];
      setState(() {

      });
      print("hi");
      print(lon);
      print(lat);
      bankController.text = seller['sellerid']['bankDetails']['bank'];
      accountHolderController.text =
          seller['sellerid']['bankDetails']['accountHolder'];
      accountNoController.text = seller['sellerid']['bankDetails']['accountNo'];
      ifscController.text = seller['sellerid']['bankDetails']['ifsc'];
      branchController.text = seller['sellerid']['bankDetails']['branch'];
      shopnameController.text = seller['sellerid']['shopName'];
      descriptionController.text = seller['sellerid']['description'];
      placeController.text = seller['sellerid']['place'];
      cityController.text = seller['sellerid']['city'];
      pinController.text = seller['sellerid']['pincode'];
      contactController.text = seller['sellerid']['contactPerson'];
      emailController.text = seller['sellerid']['email'];
      mobileController.text =
          seller['sellerid']['socialmedialinks']['whatsapp'];
      facebookController.text =
          seller['sellerid']['socialmedialinks']['facebook'];
      instagramController.text =
          seller['sellerid']['socialmedialinks']['instagram'];
      for (int i = 0;
          i < json.decode(response.body)['data']['sellerid']['category'].length;
          i++) {
        caticon = seller['sellerid']['category'][i]['icon'];
        print(caticon);
        categoryController.text = seller['sellerid']['category'][i]['name'];
      }
      is24 = json.decode(response.body)['data']['sellerid']['is24x7'];
      sid = json.decode(response.body)['data']['sellerid']['_id'];
      for (int i = 0;
          i <
              json
                  .decode(response.body)['data']['sellerid']['subcategory']
                  .length;
          i++)
        sub = json.decode(response.body)['data']['sellerid']['subcategory'];
      setState(() {
        progress1 = false;
      });
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress1 = false;
    setState(() {});
  }

  var rate;
  var rating, totalreviews, onestar, twostar, threestar, fourstar, fivestar;
  bool progress = true;
  Future<void> ratingList() async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    Map data = {
      'ratingType': 'seller',
      'sellerId': sid,
    };
    print(data);
    var body = json.encode(data);
    print(sid);
    var url = Prefmanager.baseurl + '/rating/list/';
    var response = await http.post(url, headers: requestHeaders, body: body);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      rating = json.decode(response.body)['rating'];
      totalreviews = json.decode(response.body)['totalReviews'];
      onestar = json.decode(response.body)['ratingPercentage']['oneStar'];
      twostar = json.decode(response.body)['ratingPercentage']['twoStar'];
      threestar = json.decode(response.body)['ratingPercentage']['threeStar'];
      fourstar = json.decode(response.body)['ratingPercentage']['fourStar'];
      fivestar = json.decode(response.body)['ratingPercentage']['fiveStar'];
      rate = json.decode(response.body)['data'];
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );

    progress = false;
    setState(() {});
  }

  bool loading = false;
  var city, lat, lon;
  List name = ['Neha Alex', 'Amy Rex', 'Neha Alex', 'Amy Rex'];
  List count = ['102', '102', '102', '102'];
  List review = [
    'Quality Products',
    'Wide Collections of Sarees',
    'Quality Products',
    'Wide Collections of Sarees'
  ];
  List rated = ['4.5', '4.5', '4.5', '4.5'];
  List days = ['2 days ago', '2 days ago', '2 days ago', '2 days ago'];
  List star = ['1 Star', '2 Star', '3 Star', '4 Star', '5 Star'];
  double _rating;
  TextEditingController reviewController = TextEditingController();
  TextEditingController bankController = TextEditingController();
  TextEditingController accountHolderController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController branchController = TextEditingController();
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
  TextEditingController categoryController = TextEditingController();
  Set<Marker> _markers = {};
  BitmapDescriptor pinLocationIcon;
  LatLng postion;
  Future<void>setInitalValues() {
    print(lat);
    print(lon);
    // progress1
    //     ? Center(
    //         child: CircularProgressIndicator(),
    //       )
    //     :
    _markers.add(Marker(
            position: LatLng(lat, lon),
            markerId: MarkerId("selected-location"),
            onTap: () {
              //CommonFunction.openMap(postion);
            }));

    loading = false;
    setState(() {});
  }

  void onMapTapFun(latlon) {
    // print("gggh");
    // lat=latlon.latitude;
    // print(lat);
    // lon=latlon.longitude;
    // print(lon);
    setState(() {
      // _getAddressFromLatLon();
    });
  }

  var state, city1, fulladdress, lat1, lon1;
  // _getAddressFromLatLng() async {
  //   try {
  //     print("Addresss...");
  //     final coordinates = new Coordinates(lat,lon);
  //     print(coordinates);
  //     var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //     var first = addresses.first;
  //     print(addresses.first.addressLine);
  //     state=first.adminArea;
  //     city=first.locality;
  //     fulladdress=first.addressLine;
  //     //print("${first.adminArea} : ${first.}");
  //     print(state);
  //     print(fulladdress);
  //     print(city);
  //     _kLake = CameraPosition(
  //         bearing: 192.8334901395799,
  //         target: LatLng(lon,lat),
  //         zoom: 17.151926040649414);
  //     loading = false;
  //     if(mounted)
  //       setState(() {});
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  // _getAddressFromLatLon() async {
  //   try {
  //     print("Addresss...");
  //     final coordinates = new Coordinates(lat,lon);
  //     print(coordinates);
  //     var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //     var first = addresses.first;
  //     print(addresses.first.addressLine);
  //     state=first.adminArea;
  //     city=first.locality;
  //     fulladdress=first.addressLine;
  //     //print("${first.adminArea} : ${first.}");
  //     print(state);
  //     print(fulladdress);
  //     print(city);
  //     _kLake = CameraPosition(
  //         bearing: 192.8334901395799,
  //         target: LatLng(lat,lon),
  //         zoom: 17.151926040649414);
  //     loading = false;
  //     if(mounted)
  //       setState(() {});
  //   } catch (e) {
  //     print(e);
  //   }
  //   //Text(fulladdress.text);
  //}
  List<File> files = [];
  var filename, fileslist, filepath;
  bool onPress = false;
  void filePicker() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    // for(int i=0;i<result.paths.length;i++)
    //   files.add(File(result.paths[i]));
    //      setState(() {
    //
    // });
    for (int i = 0; i < result.paths.length; i++) {
      if (files.length < 4) {
        files.add(File(result.paths[i]));
        setState(() {});
      } else
        Fluttertoast.showToast(
          msg: "Only 4 images can be added",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
    }
    print(files);
    print(result.files);
    fileslist = result.files;
    print(fileslist);
    filepath = result.paths;
    print(filepath);
    if (result != null) {
      var imageLen = files.length;
      if (imageLen < 4) {
        //List<File> files = result.paths.map((path) => File(path)).toList();
        filename = result.names.toString();
        print(filename);
      }
    } else {
      Fluttertoast.showToast(
          msg: "You can only select maximum of 4 images",
          backgroundColor: Colors.black);
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: progress1
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Text(seller['sellerid']['shopName'],
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  )),
          elevation: 0.0,
          automaticallyImplyLeading: true,
        ),
        body: //progress1 ? Center(child: CircularProgressIndicator(),)
        progress1?CameraHelper.productdetailLoader(context)
            : SingleChildScrollView(
                physics: ScrollPhysics(),
                child: SafeArea(
                  child: Container(
                    //height: MediaQuery.of(context).size.height,
                    child: Column(children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 180,
                        child: Stack(children: [
                          ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                              child: Image(
                                image: NetworkImage(Prefmanager.baseurl +
                                    "/file/get/" +
                                    seller['sellerid']['coverPhoto']),
                                width: double.infinity,
                                height: 167,
                                fit: BoxFit.cover,
                              )),
                          Positioned(
                            left: 20,
                            bottom: 60,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(3.0),
                                child: Image(
                                    image: NetworkImage(Prefmanager.baseurl +
                                        "/file/get/" +
                                        seller['sellerid']['photo']),
                                    height: 80,
                                    width: 60)),
                          ),
                          //Positioned(left:290,top:40,child: Image(image:AssetImage('assets/googlemaps.png'),height: 35,width:35,)),
                          progress
                              ? Center(
                            child: CircularProgressIndicator(),
                          ):
                          Positioned(
                            top: 100,
                            right: 0.5,
                            child: Container(
                              width: 200,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(9.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        // mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  size: 10,
                                                  color: Color(0xFFFFC107),
                                                ),
                                                SizedBox(width: 3),
                                                Text(rating.toString(),
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          color:
                                                              Color(0xFF9B9B9B),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    )),
                                                Spacer(),
                                                Column(
                                                  children: [
                                                    SizedBox(height: 5),
                                                    Text(
                                                        totalreviews.toString(),
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                              color: Color(
                                                                  0xFF000000),
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        )),
                                                    Text("REVIEWS",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                              color: Color(
                                                                  0xFF9A9A9A),
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        )),
                                                  ],
                                                )
                                              ]),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Column(
                          children: [
                            Row(children: [
                              InkWell(
                                child: Container(
                                    height: 30,
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xFFF0F0F0))),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.edit_outlined),
                                          SizedBox(width: 5),
                                          Text("Reviews",
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF000000),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400))),
                                        ])),
                                onTap: () {
                                  Scrollable.ensureVisible(
                                      reviewKey.currentContext);
                                  setState(() {});
                                },
                              ),
                              SizedBox(width: 6.5),
                              InkWell(
                                child: Container(
                                    height: 30,
                                    width: MediaQuery.of(context).size.width *
                                        0.44,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xFFF0F0F0))),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.location_on_outlined,
                                              color: Colors.black54),
                                          Text("Map",
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF000000),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400))),
                                        ])),
                                onTap: () async {
                                  Scrollable.ensureVisible(
                                      dataKey.currentContext);
                                  //myselection=true;
                                  setState(() {});
                                },
                              )
                            ]),
                            SizedBox(
                              height: 5,
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(seller['sellerid']['shopName'],
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF000000),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                          Spacer(),
                                          Icon(Icons.edit_outlined,
                                              size: 20,
                                              color: Color(0xFF464646)),
                                          InkWell(
                                            child: Text("EDIT",
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color:
                                                            Color(0xFF464646),
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w400))),
                                            onTap: () async {
                                              await Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditWorkinghour(
                                                              widget.name,
                                                              widget.id)));
                                              await sellerview();
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on_outlined,
                                              color: Color(0xFF908989)),
                                          SizedBox(width: 5),
                                          Text(
                                              seller['sellerid']['place'] +
                                                  "," +
                                                  seller['sellerid']['city'],
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF464646),
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w400))),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(width: 30),
                                          Text(
                                              "Pin-" +
                                                  seller['sellerid']['pincode'],
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF464646),
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w400))),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Icon(Icons.phone,
                                              color: Color(0xFF908989)),
                                          SizedBox(width: 5),
                                          Text("+ 91  " + seller['phone'],
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF464646),
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w400))),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Text("Working Hours",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w600))),
                                      SizedBox(height: 10),
                                      is24 == true
                                          ? Text("24 Hour's Working",
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF464646),
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w400)))
                                          : Column(
                                              children: workinglist(context)),
                                      SizedBox(height: 20),
                                    ]),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text("Account Information",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.w600))),
                                      Spacer(),
                                      Icon(Icons.edit_outlined,
                                          size: 20, color: Color(0xFF464646)),
                                      InkWell(
                                        child: Text("EDIT",
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFF464646),
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w400))),
                                        onTap: () async {
                                          await Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditSellerinformation(
                                                        widget.id,
                                                        widget.name,
                                                      )));
                                          await sellerview();
                                          await setInitalValues();
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Shop Name",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFFAFAFAF),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w400))),
                                    ],
                                  ),
                                  TextFormField(
                                    enabled: false,
                                    controller: shopnameController,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 13,
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Description",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFFAFAFAF),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w400))),
                                    ],
                                  ),
                                  TextFormField(
                                    enabled: false,
                                    controller: descriptionController,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 13,
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Category",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFFAFAFAF),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w400))),
                                    ],
                                  ),
                                  TextFormField(
                                    enabled: false,
                                    controller: categoryController,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400)),
                                    decoration: InputDecoration(
                                        labelStyle: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xFF1C1C1C),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700)),
                                        prefixIcon: Container(
                                          height: 10,
                                          width: 10,
                                          color: Colors.black,
                                          child: Image.network(
                                              Prefmanager.baseurl +
                                                  "/file/get/" +
                                                  caticon),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Location",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFFAFAFAF),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w400))),
                                    ],
                                  ),
                                  TextFormField(
                                    enabled: false,
                                    controller: placeController,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 13,
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("City",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFFAFAFAF),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w400))),
                                    ],
                                  ),
                                  TextFormField(
                                    enabled: false,
                                    controller: cityController,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 13,
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Pincode",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFFAFAFAF),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w400))),
                                    ],
                                  ),
                                  TextFormField(
                                    enabled: false,
                                    controller: pinController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ], //
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 13,
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Store Location",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFFAFAFAF),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w400))),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  progress1
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : Card(
                                          key: dataKey,
                                          child: Container(
                                            //width:double.infinity,
                                            height: 300,
                                            child: GoogleMap(
                                              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                                                new Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
                                              ].toSet(),
                                              //myLocationEnabled: true,
                                              mapType: MapType.normal,
                                              initialCameraPosition:
                                                  CameraPosition(
                                                target:
                                                    LatLng(lat ?? 0, lon ?? 0),
                                                zoom: 14.4746,
                                              ),
                                              markers: _markers,
                                              // onTap:(latlon){
                                              //   postion = latlon;
                                              //   onMapTapFun(latlon);
                                              //   setState(() {
                                              //     _markers.clear();
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
                                              // onMapCreated: (GoogleMapController controller) {
                                              //   _controller.complete(controller);
                                              //   setState(() {
                                              //
                                              //   });
                                              // },
                                            ),
                                          ),
                                        ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Email",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFFAFAFAF),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w400))),
                                    ],
                                  ),
                                  TextFormField(
                                    enabled: false,
                                    controller: emailController,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 13,
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

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Whatsapp Number",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFFAFAFAF),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w400))),
                                    ],
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    enabled: false,
                                    controller: mobileController,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 13,
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

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Contact Person",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFFAFAFAF),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w400))),
                                    ],
                                  ),
                                  TextFormField(
                                    enabled: false,
                                    controller: contactController,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 13,
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Instagram URL",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFFAFAFAF),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w400))),
                                    ],
                                  ),
                                  TextFormField(
                                    enabled: false,
                                    controller: instagramController,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 13,
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Facebook URL",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFFAFAFAF),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w400))),
                                    ],
                                  ),
                                  TextFormField(
                                    enabled: false,
                                    controller: facebookController,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400)),
                                    decoration: InputDecoration(
                                      labelStyle: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Color(0xFF1C1C1C),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                  ),
                                  //SizedBox(height: 20,),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ]),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Products avaliable",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF373737),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600))),
                        ],
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        // child:Column(
                        //     children:sublist(context)
                        // ),
                        child: GridView.builder(
                            itemCount: sub.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            //crossAxisCount: 2,
                            //children: List.generate(4,(index)
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 3.0),
                                        child: Center(
                                          child: Container(
                                            height: 30,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      50.0),
                                              color: Colors.red,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3.0),
                                              child: Center(
                                                  child: Text(
                                                      sub[index]['name'],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                              color: Color(
                                                                  0xFFFFFFFF),
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300)))),
                                            ),
                                          ),
                                        ),
                                      )
                                    ]),
                                onTap: () {
                                  // Navigator.push(context, new MaterialPageRoute(builder: (context) => SubCategory(listcat[index]["_id"],listcat[index]['cname'])));
                                  //Navigator.pop(context);
                                },
                              );
                            },
                            gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 2.1, crossAxisCount: 4)),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text("Bank Details",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.w600))),
                                      Spacer(),
                                      Icon(Icons.edit_outlined,
                                          size: 20, color: Color(0xFF464646)),
                                      InkWell(
                                        child: Text("EDIT",
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFF464646),
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w400))),
                                        onTap: () async {
                                          await Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditBankdetails(
                                                          widget.name,
                                                          widget.id)));
                                          await sellerview();
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Bank",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFFAFAFAF),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w400))),
                                    ],
                                  ),
                                  TextFormField(
                                    enabled: false,
                                    controller: bankController,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 13,
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Account Holder",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFFAFAFAF),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w400))),
                                    ],
                                  ),
                                  TextFormField(
                                    enabled: false,
                                    controller: accountHolderController,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 13,
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Account Number",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFFAFAFAF),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w400))),
                                    ],
                                  ),
                                  TextFormField(
                                    enabled: false,
                                    keyboardType: TextInputType.number,
                                    controller: accountNoController,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 13,
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("IFSC",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFFAFAFAF),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w400))),
                                    ],
                                  ),
                                  TextFormField(
                                    enabled: false,
                                    controller: ifscController,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 13,
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Branch",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFFAFAFAF),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w400))),
                                    ],
                                  ),
                                  TextFormField(
                                    enabled: false,
                                    controller: branchController,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 13,
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
                                    height: 30,
                                  ),
                                ]),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: InkWell(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.library_books,
                                            size: 20, color: Color(0xFF464646)),
                                        SizedBox(width: 5),
                                        Text("View Company Documents",
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFF000000),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                  ]),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        SellerDoc(widget.id)));
                          },
                        ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Shop Images",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF373737),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600))),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      shops.isEmpty
                          ? SizedBox.shrink()
                          : shops.length > 3
                              ? Padding(
                                  padding: EdgeInsets.fromLTRB(22, 0, 22, 0),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      Icon(Icons.collections,
                                          size: 20, color: Color(0xFF464646)),
                                      InkWell(
                                          child: Text("View More",
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF464646),
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w400))),
                                          onTap: () async {
                                            await Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        SellerMoreImage(
                                                            seller['sellerid']
                                                                ['shopImages'],
                                                            0,
                                                            sid)));
                                            await sellerview();
                                          }),
                                    ],
                                  ),
                                )
                              : SizedBox.shrink(),
                      progress1
                          ? CircularProgressIndicator()
                          : shops.isEmpty
                              ? files.isEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        filePicker();
                                      },
                                      child: Container(
                                        height: 250,
                                        width: 380,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.photo,
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    size: 80.0,
                                                  ),
                                                  SizedBox(
                                                    height: 8.0,
                                                  ),
                                                  Text(
                                                    "Click here to add image",
                                                    style: TextStyle(
                                                        color: Colors.black54),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(
                                                    height: 8.0,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.add,
                                                        size: 20.0,
                                                      ),
                                                      Text(
                                                        "  Add Image",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ),
                                    )
                                  : SizedBox.shrink()
                              : SizedBox.shrink(),
                      files.isEmpty ? SizedBox.shrink() : imageView(),
                      shops.isEmpty
                          ? SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: MediaQuery.of(context).size.height / 7,
                                width: double.infinity,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: shops.length>3?4:shops.length+1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index==(shops.length>3?3:shops.length)) {
                                      return Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Color(0xfff3f3f4),
                                            ),
                                            child: SizedBox(
                                              width: 70,
                                              height: 70,
                                              child: FlatButton(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(Icons.add)
                                                    //  Text("Photos/Videos", style: TextStyle(fontSize: 10),),
                                                  ],
                                                ),
                                                // color: Colors.green[600],
                                                textColor: Colors.black,
                                                onPressed: () {
                                                  if (files.length == 4)
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "Only 4 images can be added at a time",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                    );
                                                  else
                                                    filePicker();
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    return InkWell(
                                        child: Row(
                                          children: [
                                            new Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                          //height:300,
                                                          child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              child: Image(
                                                                image: NetworkImage(Prefmanager
                                                                        .baseurl +
                                                                    "/file/get/" +
                                                                    shops[
                                                                        index]),
                                                                height: 100,
                                                                width: 100,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ))),
                                                      //Text(shops[index])
                                                    ]),
                                              ],
                                            ),
                                          ],
                                        ),
                                        onTap: () async {
                                          await Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      new SellerMoreImage(
                                                          seller['sellerid']
                                                              ['shopImages'],
                                                          index,
                                                          sid)));
                                          await sellerview();
                                        });
                                  },
                                  //gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio:1.5,crossAxisCount:3),
                                ),
                              ),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        key: reviewKey,
                        child: Column(children: [
                          Column(
                            children: [
                              Text("Reviews",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Color(0xFF373737),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600))),
                              SizedBox(height: 3),
                              Container(
                                height: 2,
                                width: 90,
                                color: Color(0xFFFF4A4A),

                                // indent: 1,
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          progress
                              ? Center(
                            child: CircularProgressIndicator(),
                          ):
                          Text(rating.toString() + " / 5",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF212020),
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600))),
                          progress
                              ? Center(
                            child: CircularProgressIndicator(),
                          ):
                          Text(totalreviews.toString() + " Reviews",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF7D7D7D),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600))),
                          // RatingBar(
                          //  // ratingWidget: ,
                          //   initialRating: 0,
                          //   minRating: 1,
                          //   direction: Axis.horizontal,
                          //   allowHalfRating: true,
                          //   itemCount: 5,
                          //   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          //   itemBuilder: (context, _) => Icon(
                          //     Icons.star,
                          //     color: Colors.amber,
                          //   ),
                          //   onRatingUpdate: (rating) {
                          //     print(rating);
                          //   },
                          // ),
                          SizedBox(
                            height: 10,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 55,
                              ),
                              Column(
                                children: [
                                  Image(image: AssetImage('assets/star.png')),
                                  Text('1 Star',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF9B9B9B),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      )),
                                  Text(onestar.toString() + " %",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF9B9B9B),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      )),
                                ],
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Column(
                                children: [
                                  Image(image: AssetImage('assets/star.png')),
                                  Text('2 Star',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF9B9B9B),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      )),
                                  Text(twostar.toString() + " %",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF9B9B9B),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      )),
                                ],
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Column(
                                children: [
                                  Image(image: AssetImage('assets/star.png')),
                                  Text('3 Star',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF9B9B9B),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      )),
                                  Text(threestar.toString() + " %",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF9B9B9B),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      )),
                                ],
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Column(
                                children: [
                                  Image(image: AssetImage('assets/star.png')),
                                  Text('4 Star',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF9B9B9B),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      )),
                                  Text(fourstar.toString() + " %",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF9B9B9B),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      )),
                                ],
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Column(
                                children: [
                                  Image(image: AssetImage('assets/star.png')),
                                  Text('5 Star',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF9B9B9B),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      )),
                                  Text(fivestar.toString() + " %",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF9B9B9B),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      )),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          progress
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : rate.length == 0
                                  ? SizedBox.shrink()
                                  : Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text("Reviews",
                                                  style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          color:
                                                              Color(0xFF444444),
                                                          fontSize: 16,
                                                          fontWeight: FontWeight
                                                              .w600))),
                                              Spacer(),
                                              InkWell(
                                                child: Text(
                                                    rate.length > 3
                                                        ? "View All"
                                                        : "",
                                                    style: GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            color: Color(
                                                                0xFF1D1D1D),
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500))),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      new MaterialPageRoute(
                                                          builder: (context) =>
                                                              new SellerallRating(
                                                                  sid)));
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        progress
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : Column(
                                                //padding: const EdgeInsets.all(10.0),
                                                children: List.generate(
                                                    rate.length > 3
                                                        ? 3
                                                        : rate.length, (index) {
                                                  return InkWell(
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Expanded(
                                                                child: new Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                        padding:
                                                                            EdgeInsets.all(
                                                                                15),
                                                                        // child: ClipRRect(
                                                                        //   borderRadius:BorderRadius.circular(65.0),
                                                                        //   child:FadeInImage(
                                                                        //     //   image:NetworkImage(
                                                                        //     //       Prefmanager.baseurl+"/u/"+profile[index]['seller']["photo"]) ,
                                                                        //     image: AssetImage('assets/vegetables.jpg'),
                                                                        //     placeholder: AssetImage("assets/userlogo.jpg"),
                                                                        //     fit: BoxFit.cover,
                                                                        //     width:90,
                                                                        //     height:90,
                                                                        //   ),
                                                                        //
                                                                        // ),
                                                                        child:
                                                                            CircleAvatar(
                                                                          radius:
                                                                              18,
                                                                          backgroundImage: rate[index]['uid']['customerid']['photo'] == null
                                                                              ? AssetImage('assets/user.jpg')
                                                                              : NetworkImage(
                                                                                  Prefmanager.baseurl + "/file/get/" + rate[index]['uid']['customerid']['photo'],
                                                                                ),
                                                                        )),
                                                                    //Image(image: AssetImage('assets/fishimage2.jpg'),height:200,width:double.infinity ,fit:BoxFit.fill),
                                                                    Expanded(
                                                                        child: Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                          // SizedBox(
                                                                          //   height: 10,
                                                                          // ),
                                                                          Row(
                                                                            children: [
                                                                              Text(rate[index]['uid']['customerid']['firstName'] + " " + rate[index]['uid']['customerid']['lastName'], style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF373737), fontSize: 13, fontWeight: FontWeight.w600))),
                                                                            ],
                                                                          ),

                                                                          Row(children: [
                                                                            Text(rate[index]['review'] != null ? rate[index]['review'] : " ",
                                                                                style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF828282), fontSize: 9, fontWeight: FontWeight.w400))),
                                                                          ]),
                                                                        ])),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    SizedBox(
                                                                        width:
                                                                            70),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child:
                                                                          RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          text:
                                                                              'RATED ',
                                                                          style:
                                                                              GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF3A3636), fontSize: 11, fontWeight: FontWeight.w400)),
                                                                          children: <
                                                                              TextSpan>[
                                                                            TextSpan(
                                                                                text: rate[index]['rating'].toString(),
                                                                                style: TextStyle(fontWeight: FontWeight.bold)),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    // Expanded(child: Text(days[index],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF828282),fontSize:10,fontWeight: FontWeight.w400)))),
                                                                    Expanded(
                                                                        child: Text(
                                                                            timeago.format(
                                                                              DateTime.now().subtract(new Duration(minutes: DateTime.now().difference(DateTime.parse(rate[index]['update_date'])).inMinutes)),
                                                                            ),
                                                                            style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF828282), fontSize: 10, fontWeight: FontWeight.w400)))),
                                                                  ],
                                                                ),
                                                              ]),
                                                          Divider(
                                                            height: 30,
                                                            thickness: 1,
                                                            indent: 1,
                                                          ),
                                                        ],
                                                      ),
                                                      onTap: () {});
                                                }),
                                              ),
                                      ],
                                    )
                        ]),
                      ),
                    ]),
                  ),
                ),
              ));
  }

  workinglist(BuildContext context) {
    List<Widget> item = [];
    for (int i = 0; i < seller['sellerid']['workingHour'].length; i++)
      item.add(
        Container(
          width: MediaQuery.of(context).size.width / 1.8,
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: Text(
                seller['sellerid']['workingHour'][i]['day'],
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Color(0xFF464646),
                        fontSize: 11,
                        fontWeight: FontWeight.w400)),
              )),
              SizedBox(width: 30),
              !seller['sellerid']['workingHour'][i]['working']
                  ? Text(
                      "Closed",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Color(0xFFFFBB02),
                              fontSize: 11,
                              fontWeight: FontWeight.w400)),
                    )
                  : seller['sellerid']['workingHour'][i]['open'] == null
                      ? Text("--")
                      : Text(
                          DateFormat.jm().format(DateFormat('HH:mm').parse(
                                  seller['sellerid']['workingHour'][i]
                                      ['open'])) +
                              " - ",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Color(0xFF464646),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400)),
                        ),
              !seller['sellerid']['workingHour'][i]['working']
                  ? Text("", style: TextStyle(fontSize: 14))
                  : seller['sellerid']['workingHour'][i]['close'] == null
                      ? Text("--")
                      : Text(
                          DateFormat.jm().format(DateFormat('HH:mm').parse(
                              seller['sellerid']['workingHour'][i]['close'])),
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Color(0xFF464646),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400)),
                        ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      );
    return item;
  }

  sublist(BuildContext context) {
    print("hi");
    List<Widget> item = [];
    for (int i = 0; i < seller['sellerid']['subcategory'].length; i++)
      item.add(
        Container(
          width: 300,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(seller['sellerid']['subcategory'][i]['name'],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 11,
                          fontWeight: FontWeight.w300)))
            ],
          ),
        ),
      );
    print(item);
    return item;
  }

  bool progress2 = false;
  void senddata() async {
    setState(() {
      progress2 = true;
    });
    try {
      String token = await Prefmanager.getToken();
      var url = Prefmanager.baseurl + '/rating/add/update';
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': token
      };

      Map data = {
        'ratingType': 'seller',
        'sellerId': sid,
        'rating': _rating,
        'review': reviewController.text
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
          // Navigator.push(
          //     context, new MaterialPageRoute(
          //     builder: (context) => new SellerworkHour()));
        } else {
          print(json.decode(response.body)['msg']);
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } on SocketException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
    progress2 = false;
  }

  Widget imageView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: files.isNotEmpty
          ? Column(
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: files.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 0.5,
                      mainAxisSpacing: 0.5,
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    if (files.length < 3) if (index == files.length) {
                      return Row(
                        children: <Widget>[
                          SizedBox(
                            width: 70,
                            height: 70,
                            child: FlatButton(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.add),
                                  //  Text("Photos/Videos", style: TextStyle(fontSize: 10),),
                                ],
                              ),
                              // color: Colors.green[600],
                              textColor: Colors.black,
                              onPressed: () {
                                filePicker();
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                files[index],
                                height:80,width:MediaQuery.of(context).size.width/5,
                                //  val1[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                                right: 0,
                                top: 0,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 18,
                                  child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 15,
                                      child: IconButton(
                                        onPressed: () {
                                          files.removeAt(index);
                                          // val1.removeAt(index);
                                          setState(() {});
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                      )),
                                )),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 1.0, vertical: 10),
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
                      height: 50,
                      minWidth: MediaQuery.of(context).size.width,
                      color: Color(0xFFFFFFFF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Color(0xFFE8E8E8))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Upload Image',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600),
                              )),
                        ],
                      ),
                      onPressed: () {
                        setState(() {
                          addSinglePhoto();
                        });
                      },
                    ),
                  ),
                ),
              ],
            )
          : Container(),
    );
  }

  addSinglePhoto() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse(Prefmanager.baseurl + '/seller/profile/level1'));
    String token = await Prefmanager.getToken();
    request.headers
        .addAll({'Content-Type': 'application/form-data', 'token': token});
    if (files != null) {
      files.forEach((File f) {
        request.files.add(http.MultipartFile.fromBytes(
            'shopImages', f.readAsBytesSync(),
            filename: f.path.split('/').last));
      });
    }
    try {
      http.Response response =
          await http.Response.fromStream(await request.send());
      print(json.decode(response.body));
      if (json.decode(response.body)['status']) {
        files.clear();
        sellerview();
        print(json.decode(response.body));
      } else {
        print(json.decode(response.body)['msg']);
      }
    } catch (e) {
      print(e);
    }
  }

  Widget myfunction() {
    return progress1
        ? CircularProgressIndicator()
        : GridView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: shops.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //   ClipRRect(borderRadius: BorderRadius.circular(10.0),child: Image(image:NetworkImage(Prefmanager.baseurl+"/file/get/"+shops[index]),height: 100,width:100,fit: BoxFit.fill,)),
                                  Text(shops[index])
                                ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Navigator.push(context,new MaterialPageRoute(builder: (context)=>new VieweachProduct(profile[index]['_id'],profile[index]['seller']['_id'],widget.deldate)));
                  });
            },
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 2.1, crossAxisCount: 4),
          );
  }
}
