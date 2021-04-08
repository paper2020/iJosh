import 'dart:async';
import 'package:eram_app/FirstPage1.dart';
import 'package:eram_app/SellerProductSearch.dart';
import 'package:eram_app/SellerratingAll.dart';
import 'package:eram_app/ShopMoreImage.dart';
import 'package:eram_app/SubcategoryProductsSeller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:eram_app/Prefmanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:eram_app/utils/helper.dart';
class ShopDetail extends StatefulWidget {
  final name, sellerid;
  ShopDetail(this.name, this.sellerid);
  @override
  _ShopDetail createState() => new _ShopDetail();
}

class _ShopDetail extends State<ShopDetail> {
  bool onpress = false;
  final dataKey = new GlobalKey();
  final reviewKey = new GlobalKey();
  void initState() {
    super.initState();
    sample();
  }

  Future sample() async {
    String token = await Prefmanager.getToken();
    await sellerview();
    await ratingList();
    if (token != null) {
      await ratingView();
    }
    await setInitalValues();
  }

  var sid, seller, is24;
  List sub = [];
  bool progress1 = true;
  Future<void> sellerview() async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token != null ? token : null
    };
    var url = Prefmanager.baseurl + '/seller/view/' + widget.sellerid;
    var response = await http.get(url, headers: requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      seller = json.decode(response.body)['data'];
      is24 = json.decode(response.body)['data']['sellerid']['is24x7'];
      sid = json.decode(response.body)['data']['sellerid']['_id'];
      lon = json.decode(response.body)['data']['sellerid']['location'][0];
      lat = json.decode(response.body)['data']['sellerid']['location'][1];
      for (int i = 0;
          i <
              json
                  .decode(response.body)['data']['sellerid']['subcategory']
                  .length;
          i++)
        sub = json.decode(response.body)['data']['sellerid']['subcategory'];
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
      'token': token != null ? token : null
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

  var myrate, review, myrating;
  Future<void> ratingView() async {
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
    var url = Prefmanager.baseurl + '/my/rating/view';
    var response = await http.post(url, headers: requestHeaders, body: body);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      myrate = json.decode(response.body)['data'];
      if (myrate != null) {
        myrating = json.decode(response.body)['data']['rating'].toDouble();
        _rating = json.decode(response.body)['data']['rating'].toDouble();
        review = json.decode(response.body)['data']['review'];
        reviewController.text = review;
      }
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );

    setState(() {});
  }

  void deleteReview(var id) async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    Map data = {
      'ratingType': 'seller',
      'sellerId': id,
    };
    print(data);
    var body = json.encode(data);
    var url = Prefmanager.baseurl + '/rating/delete';
    var response = await http.post(url, headers: requestHeaders, body: body);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      Fluttertoast.showToast(
          msg: json.decode(response.body)['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 20.0);
      if (token != null) await ratingView();
      await ratingList();
      await sellerview();
      reviewController.clear();
      _rating = null;
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    setState(() {});
  }

  void _showDialog(var id) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete this review",
              style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 12))),
          //content: new Text("This will delete your review"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Delete"),
              onPressed: () {
                deleteReview(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  var searchOnStopTyping;
  callSearch(String query) {
    const duration = Duration(milliseconds: 800);

    if (searchOnStopTyping != null) {
      setState(() {
        searchOnStopTyping.cancel();
      });
    }
    setState(() {
      searchOnStopTyping = new Timer(duration, () async {
        await senddata1();
        await Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) =>
                        new SellerProductSearch(keyword.text, widget.sellerid)))
            .then((value) {
          //This makes sure the textfield is cleared after page is pushed.
          keyword.clear();
        });
        setState(() {});
      });
    });
    //keyword.clear();
  }

  Set<Marker> _markers = {};
  BitmapDescriptor pinLocationIcon;
  LatLng postion;
  setInitalValues() {
    print(lat);
    print(lon);
    progress1
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _markers.add(Marker(
            position: LatLng(lat, lon),
            markerId: MarkerId("selected-location"),
            onTap: () {
              //CommonFunction.openMap(postion);
            }));

    loading = false;
    setState(() {});
  }

  TextEditingController keyword = TextEditingController();
  bool loading = false;
  var city, lat, lon;
  List name = ['Neha Alex', 'Amy Rex', 'Neha Alex', 'Amy Rex'];
  List count = ['102', '102', '102', '102'];
  List rated = ['4.5', '4.5', '4.5', '4.5'];
  List days = ['2 days ago', '2 days ago', '2 days ago', '2 days ago'];
  List star = ['1 Star', '2 Star', '3 Star', '4 Star', '5 Star'];
  double _rating;
  TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Text(widget.name,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              )),
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, true),
          ),
        ),
        body: //progress1 ? Center(child: CircularProgressIndicator(),)
        progress1?CameraHelper.productdetailLoader(context)
            : SingleChildScrollView(
                physics: ScrollPhysics(),
                child: SafeArea(
                  child: Container(
                    //height: MediaQuery.of(context).size.height,
                    child: Column(children: [
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
                            bottom: 40,
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
                          Positioned(
                            top: 110,
                            right: 0.5,
                            child: Container(
                              width: 180,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(9.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
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
                                                Text(
                                                    seller['sellerid']['rating']
                                                        .toString(),
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
                                                        seller['sellerid']
                                                                ['totalReviews']
                                                            .toString(),
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
                      Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(children: [
                              InkWell(
                                child: Container(
                                    height: 30,
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    // color:Color(0xFFFFFF),
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
                                    // color:Color(0xFFF8F8F8),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xFFF0F0F0))),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.location_on_outlined,
                                                color: Colors.black54),
                                            Text("Map",
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color:
                                                            Color(0xFF000000),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400))),
                                          ]),
                                    )),
                                onTap: () {
                                  Scrollable.ensureVisible(
                                      dataKey.currentContext);
                                  setState(() {});
                                },
                              )
                            ]),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Card(
                              elevation: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      Text(widget.name,
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.w600))),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on_outlined,
                                              color: Color(0xFF908989)),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                                seller['sellerid']['place'] +
                                                    "," +
                                                    seller['sellerid']['city'],
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color: Color(0xFF464646),
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w400))),
                                          ),
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
                                                      fontSize: 11,
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
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w400))),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Text("Working Hours",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontSize: 11,
                                                  fontWeight:
                                                      FontWeight.w600))),
                                      SizedBox(height: 10),
                                      is24 == true
                                          ? Text("24 Hour's  Working",
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF464646),
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w400)))
                                          : Column(
                                              children: workinglist(context)),
                                      SizedBox(height: 20),
                                    ]),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Store Location",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF373737),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600))),
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
                              elevation: 0,
                              key: dataKey,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Container(
                                  //width:double.infinity,
                                  height: 300,
                                  child: GoogleMap(
                                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                                      new Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
                                    ].toSet(),
                                    //myLocationEnabled: true,
                                    mapType: MapType.normal,
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(lat ?? 0, lon ?? 0),
                                      zoom: 14.4746,
                                    ),
                                    markers: _markers,
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(height: 15),
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
                            // childAspectRatio: 0.8,
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
                                        child: Container(
                                          height: 35,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                new BorderRadius.circular(50.0),
                                            color: Colors.red,
                                          ),
                                          child: Center(
                                              child: Text(sub[index]['name'],
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          color:
                                                              Color(0xFFFFFFFF),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight
                                                              .w300)))),
                                        ),
                                      )
                                    ]),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              SubcategoryProductsSeller(
                                                  widget.sellerid,
                                                  sub[index]["_id"],
                                                  sub[index]['name'])));
                                  //Navigator.pop(context);
                                },
                              );
                            },
                            gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 2.1, crossAxisCount: 4)),
                      ),
                      SizedBox(height: 15),
                      seller['sellerid']['shopImages'].isEmpty
                          ? SizedBox.shrink()
                          : Column(
                              children: [
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
                                SizedBox(height: 15),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 5.5,
                                  padding: EdgeInsets.all(12),
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      //itemCount: files.isEmpty?shops.length+1:shops.length,,
                                      //itemCount:seller['sellerid']['shopImages'].length,
                                      itemCount: seller['sellerid']
                                                      ['shopImages']
                                                  .length >
                                              3
                                          ? 4
                                          : seller['sellerid']['shopImages']
                                              .length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (index == 3) {
                                          return Row(
                                            children: <Widget>[
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                height: 100,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Color(0xffFFFFFF),
                                                ),
                                                child: SizedBox(
                                                  width: 70,
                                                  height: 70,
                                                  child: FlatButton(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Icon(Icons.collections),
                                                        Text("View More",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Color(
                                                                      0xFF373737)),
                                                            )),
                                                      ],
                                                    ),
                                                    // color: Colors.green[600],
                                                    textColor: Colors.black,
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          new MaterialPageRoute(
                                                              builder: (context) =>
                                                                  new ShopMoreImage(
                                                                      seller['sellerid']
                                                                          [
                                                                          'shopImages'],
                                                                      0)));
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
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                new Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              child: Image(
                                                                image: NetworkImage(Prefmanager
                                                                        .baseurl +
                                                                    "/file/get/" +
                                                                    seller['sellerid']
                                                                            [
                                                                            'shopImages']
                                                                        [
                                                                        index]),
                                                                height: 100,
                                                                width: 100,
                                                                fit:
                                                                    BoxFit.fill,
                                                              )),
                                                        ]),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (context) =>
                                                          new ShopMoreImage(
                                                              seller['sellerid']
                                                                  [
                                                                  'shopImages'],
                                                              index)));
                                            });
                                      }),
                                ),
                              ],
                            ),
                      Card(
                        key: reviewKey,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Text("Reviews",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF373737),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600))),
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
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     RatingBarIndicator(
                            //       rating: 5,
                            //       itemBuilder: (context, index) => Icon(
                            //         Icons.star,
                            //         color: Colors.amber,
                            //       ),
                            //       itemCount: 5,
                            //       itemPadding: EdgeInsets.symmetric(horizontal:20.0),
                            //       itemSize: 15.0,
                            //       direction: Axis.horizontal,
                            //     ),
                            //   ],
                            //
                            // ),
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
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      myrate == null
                                          ? 'Write a Review'
                                          : 'Your Review',
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Color(0xFF444444),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600))),
                                  Spacer(),
                                  myrate != null
                                      ? InkWell(
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.grey,
                                          ),
                                          // iconSize: 20,

                                          onTap: () {
                                            _showDialog(sid);
                                          },
                                        )
                                      : SizedBox.shrink()
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            // RatingBarIndicator(
                            //  rating:0,
                            //   //direction: _isVertical ? Axis.vertical : Axis.horizontal,
                            //
                            //   unratedColor: Colors.amber.withAlpha(50),
                            //   itemCount: 5,
                            //   itemSize: 50.0,
                            //   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            //   // itemBuilder: (context, _) => Icon(
                            //   //   _selectedIcon ?? Icons.star,
                            //   //   color: Colors.amber,
                            //   // ),
                            //   // onRatingUpdate: (rating) async{
                            //   //   setState(() {
                            //   //     _rating = rating;
                            //   //     print(_rating);
                            //   //   });
                            //   //},
                            // ),
                            RatingBar.builder(
                              unratedColor: Color(0xFFE3E3E3),
                              initialRating: myrate == null ? 0 : myrating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20.0,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 20.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                _rating = rating;
                                print(_rating);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter review';
                                  } else {
                                    return null;
                                  }
                                },
                                controller: reviewController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.edit)),
                              ),
                            ),
                            SizedBox(height: 10),
                            progress2
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : FlatButton(
                                    //width:114,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Color(0xFFD2D2D2)),
                                        borderRadius:
                                            BorderRadius.circular(7.0)),

                                    height: 36,
                                    minWidth: 152,
                                    color: Color(0xFFFC4B4B),
                                    child: Text(
                                        myrate == null
                                            ? 'Add Your Review'
                                            : 'Edit Your Review',
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600))),
                                    onPressed: () async {
                                      String token =
                                          await Prefmanager.getToken();
                                      if (token == null)
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    new FirstPage1()));
                                      else if (token != null && _rating == null)
                                        Fluttertoast.showToast(
                                          msg: "Please select rating",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                        );
                                      else
                                        senddata();
                                    },
                                  ),
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
                                                horizontal: 20.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text("Reviews",
                                                    style: GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            color: Color(
                                                                0xFF444444),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
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
                                          Column(
                                              //padding: const EdgeInsets.all(10.0),
                                              //   physics: NeverScrollableScrollPhysics(),
                                              //   shrinkWrap: true,
                                              //   itemCount: rate.length,
                                              //   itemBuilder: (BuildContext context,int index){
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
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
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
                                                                    radius: 18,
                                                                    backgroundImage: rate[index]['uid']['customerid']['photo'] ==
                                                                            null
                                                                        ? AssetImage(
                                                                            'assets/user.jpg')
                                                                        : NetworkImage(
                                                                            Prefmanager.baseurl +
                                                                                "/file/get/" +
                                                                                rate[index]['uid']['customerid']['photo'],
                                                                          ),
                                                                  )),
                                                              //Image(image: AssetImage('assets/fishimage2.jpg'),height:200,width:double.infinity ,fit:BoxFit.fill),
                                                              Expanded(
                                                                  child: Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                    // SizedBox(
                                                                    //   height: 10,
                                                                    // ),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                            rate[index]['uid']['customerid']['firstName'] +
                                                                                " " +
                                                                                rate[index]['uid']['customerid']['lastName'],
                                                                            style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF373737), fontSize: 13, fontWeight: FontWeight.w600))),
                                                                      ],
                                                                    ),

                                                                    Row(
                                                                        children: [
                                                                          Text(
                                                                              rate[index]['review'] != null ? rate[index]['review'] : " ",
                                                                              style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF828282), fontSize: 9, fontWeight: FontWeight.w400))),
                                                                        ]),
                                                                  ])),
                                                              SizedBox(
                                                                height: 10,
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
                                                                  width: 60),
                                                              Expanded(
                                                                flex: 2,
                                                                child: RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        'RATED ',
                                                                    style: GoogleFonts.poppins(
                                                                        textStyle: TextStyle(
                                                                            color: Color(
                                                                                0xFF3A3636),
                                                                            fontSize:
                                                                                11,
                                                                            fontWeight:
                                                                                FontWeight.w400)),
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                          text: rate[index]['rating']
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold)),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  flex: 0,
                                                                  child: Text(
                                                                      timeago
                                                                          .format(
                                                                        DateTime.now().subtract(new Duration(
                                                                            minutes:
                                                                                DateTime.now().difference(DateTime.parse(rate[index]['update_date'])).inMinutes)),
                                                                      ),
                                                                      style: GoogleFonts.poppins(
                                                                          textStyle: TextStyle(
                                                                              color: Color(0xFF828282),
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w400)))),
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
                                          })),
                                        ],
                                      ),
                          ],
                        ),
                      )
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
          if (token != null) ratingView();
          ratingList();
          sellerview();
          // reviewController.clear();
        } else {
          print(json.decode(response.body)['msg']);
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } on SocketException catch (e) {
      Fluttertoast.showToast(
          msg: "No internet",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 20.0);
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      progress2 = false;
    });

  }

  var searchMsg;
  Future<void> senddata1() async {
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
