import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eram_app/ProductDetail.dart';
import 'package:eram_app/ShopPage1.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:eram_app/Prefmanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class SubcategorySearch extends StatefulWidget {
  final subid, keyword;
  SubcategorySearch(this.subid, this.keyword);
  @override
  _SubcategorySearch createState() => new _SubcategorySearch();
}

class _SubcategorySearch extends State<SubcategorySearch> {
  void initState() {
    super.initState();
    keyword.text = widget.keyword;
    sample();
  }

  Future sample() async {
    await _getCurrentLocation();
    await searchProduct();
    // await searchSeller();
  }

  bool progress = true;
  List product = [];
  int page = 1, limit = 4;
  var totallength;
  Future<void> searchProduct() async {
    var url = Prefmanager.baseurl + '/product/search';
    var token = await Prefmanager.getToken();
    Map data = {
      'keyword': widget.keyword,
      'limit': limit.toString(),
      'subcategoryId': widget.subid,
      'page': page.toString(),
      'lat': lat.toString(),
      'lon': lon.toString()
    };
    print(data);
    var body = json.encode(data);
    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "token": token,
        },
        body: body);
    print(json.encode(response.body));
    if (json.decode(response.body)['status']) {
      totallength = json.decode(response.body)['totalLength'];
      for (int i = 0; i < json.decode(response.body)['data'].length; i++)
        product.add(json.decode(response.body)['data'][i]);
      page++;
    } else
      print("Somjj");

    progress = false;
    loading = false;
    setState(() {});
  }

  bool loading = false;
  bool progress1 = true;
  List seller = [];
  int page1 = 1, limit1 = 5;
  void searchSeller() async {
    var url = Prefmanager.baseurl + '/seller/search';
    var token = await Prefmanager.getToken();
    Map data = {
      'keyword': widget.keyword,
      //'limit':limit1.toString(),
      //'page':page1.toString(),
      'lat': lat.toString(),
      'lon': lon.toString()
    };
    print(data);
    var body = json.encode(data);
    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "token": token,
        },
        body: body);
    print(json.encode(response.body));
    if (json.decode(response.body)['status']) {
      for (int i = 0; i < json.decode(response.body)['data'].length; i++)
        seller.add(json.decode(response.body)['data'][i]);
      page1++;
    } else
      print("Somjj");

    progress1 = false;
    //loading=false;
    setState(() {});
  }

  var city, lat, lon;
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        lat = position.latitude;
        lon = position.longitude;
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
      print(lat);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      city = first.locality;
      print(city);
      if (mounted) setState(() {});
    } catch (e) {
      print(e);
    }
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
      searchOnStopTyping = new Timer(duration, () {
        //senddata();
        senddata1();
        setState(() {});
      });
    });
    //keyword.clear();
  }

  TextEditingController keyword = TextEditingController();
  List cat = ['Eranakulam', 'Kadavantara', 'Kalloor'];
  List km = ['0.6 Km', '2.5 Km', '0.6 Km', '2.5 Km'];
  List review = ['4.5', '4.5', '4.0', '4.0'];
  List pro = ['My GMobile', 'My GMobile', 'My GMobile'];
  List sho = ['My G', 'My G', 'My G'];
  List p = ['0.6 km kalloor', '0.6 km kalloor', '0.6 km kalloor'];
  List rs = ['Rs. 10,000.00', 'Rs. 10,000.00', 'Rs. 10,000.00'];
  @override
  Widget build(BuildContext context) {
    List f = [];
    FlutterMoneyFormatter fmf;
    MoneyFormatterOutput fo;
    for (int i = 0; i < product.length; i++) {
      fmf = FlutterMoneyFormatter(amount: product[i]['price'].toDouble());
      fo = fmf.output;
      f.add(fo);
    }
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Text(widget.keyword,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              )),
          automaticallyImplyLeading: true,
        ),
        body: progress
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                physics: ScrollPhysics(),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          SizedBox(height: 3),
                          Container(
                            height: 50,
                            //color: Color(0xFFFFFFFF),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[200].withOpacity(0.7),
                                  spreadRadius: 5,
                                  blurRadius: 4,
                                  offset: Offset(
                                      2, 5), // changes position of shadow
                                ),
                              ],
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  prefixIcon:
                                      Icon(Icons.search, color: Colors.red),
                                  hintText: ' What are you looking for?',
                                  hintStyle: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Color(0xFFB8B8B8))),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(30.0),
                                    ),
                                  )),
                              controller: keyword,
                              onFieldSubmitted: callSearch,
                            ),
                          ),
                          SizedBox(height: 20),
                          seller.isEmpty
                              ? SizedBox.shrink()
                              : progress1
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text("Stores",
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color:
                                                            Color(0xFF1D1D1D),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600))),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          height: 150,
                                          //padding: EdgeInsets.all(10),
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: seller.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return InkWell(
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        new Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Stack(
                                                                    children: [
                                                                      ClipRRect(
                                                                          borderRadius: BorderRadius.circular(
                                                                              10.0),
                                                                          child:
                                                                              Image(
                                                                            image: NetworkImage(Prefmanager.baseurl +
                                                                                "/file/get/" +
                                                                                seller[index]['sellerid']["photo"]),
                                                                            height:
                                                                                120,
                                                                            width:
                                                                                120,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          )),
                                                                      Positioned(
                                                                          top:
                                                                              10,
                                                                          left:
                                                                              90,
                                                                          child:
                                                                              Image(image: AssetImage('assets/discount.png'))),
                                                                    ],
                                                                  ),
                                                                  Text(
                                                                      seller[index]
                                                                              [
                                                                              'sellerid']
                                                                          [
                                                                          'place'],
                                                                      style: GoogleFonts.poppins(
                                                                          textStyle: TextStyle(
                                                                              color: Color(0xFF000000),
                                                                              fontSize: 9,
                                                                              fontWeight: FontWeight.w600))),
                                                                  Row(
                                                                    children: [
                                                                      Image(
                                                                        image: AssetImage(
                                                                            'assets/googlemaps.png'),
                                                                        height:
                                                                            14,
                                                                        width:
                                                                            14,
                                                                      ),
                                                                      Text(
                                                                          seller[index]['sellerid']['distance'] != null
                                                                              ? "  " + seller[index]['sellerid']['distance'] + " km"
                                                                              : " ",
                                                                          style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF000000), fontSize: 8, fontWeight: FontWeight.w500))),
                                                                      SizedBox(
                                                                          width:
                                                                              50),
                                                                      Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: Color(
                                                                            0xFFFFBF00),
                                                                        size: 6,
                                                                      ),
                                                                      Text(
                                                                          seller[index]['sellerid']['rating']
                                                                              .toString(),
                                                                          style:
                                                                              GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF000000), fontSize: 8, fontWeight: FontWeight.w500))),
                                                                    ],
                                                                  )
                                                                ]),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          new MaterialPageRoute(
                                                              builder: (context) => new ShopPage1(
                                                                  false,false,
                                                                  seller[index][
                                                                          'sellerid']
                                                                      [
                                                                      'shopName'],
                                                                  seller[index][
                                                                          'sellerid']
                                                                      ['uid'],
                                                                  seller[index][
                                                                      '_id'])));
                                                    });
                                              }),
                                        ),
                                        SizedBox(height: 20),
                                      ],
                                    ),
                          Expanded(
                              child: product.isNotEmpty
                                  ? Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text("Products",
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF1D1D1D),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ))
                                          ],
                                        ),
                                        progress
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : Expanded(
                                                child: NotificationListener<
                                                    ScrollNotification>(
                                                  onNotification:
                                                      (ScrollNotification
                                                          scrollInfo) {
                                                    if (!loading &&
                                                        scrollInfo.metrics
                                                                .pixels ==
                                                            scrollInfo.metrics
                                                                .maxScrollExtent) {
                                                      if (totallength >
                                                          product.length) {
                                                        searchProduct();
                                                        setState(() {
                                                          loading = true;
                                                        });
                                                      } else {}
                                                    } else {}
                                                    //  setState(() =>loading = false);
                                                    return true;
                                                  },
                                                  child: ListView.builder(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemCount: product.length,
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return InkWell(
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          new Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          // Container(
                                                                          //   padding: EdgeInsets.all(10),
                                                                          //   child: ClipRRect(
                                                                          //     borderRadius:BorderRadius.circular(65.0),
                                                                          //     child:FadeInImage(
                                                                          //       //   image:NetworkImage(
                                                                          //       //       Prefmanager.baseurl+"/u/"+profile[index]['seller']["photo"]) ,
                                                                          //       image: AssetImage('assets/vegetables.jpg'),
                                                                          //       placeholder: AssetImage("assets/userlogo.jpg"),
                                                                          //       fit: BoxFit.cover,
                                                                          //       width:90,
                                                                          //       height:90,
                                                                          //     ),
                                                                          //
                                                                          //   ),
                                                                          // ),
                                                                          Image(
                                                                              image: AssetImage('assets/phone.jpeg'),
                                                                              height: 95,
                                                                              width: 95,
                                                                              fit: BoxFit.fill),
                                                                          Expanded(
                                                                              child: Column(children: [
                                                                            Row(
                                                                              children: [
                                                                                Text(product[index]['name'],
                                                                                    style: GoogleFonts.poppins(
                                                                                      textStyle: TextStyle(color: Color(0xFF373737), fontSize: 13, fontWeight: FontWeight.w600),
                                                                                    )),
                                                                              ],
                                                                            ),
                                                                            // SizedBox(
                                                                            //   height:5,
                                                                            // ),
                                                                            Row(children: [
                                                                              Text(product[index]['sellerId']['shopName'],
                                                                                  style: GoogleFonts.poppins(
                                                                                    textStyle: TextStyle(color: Color(0xFF828282), fontSize: 11, fontWeight: FontWeight.w400),
                                                                                  )),
                                                                            ]),
                                                                            // SizedBox(
                                                                            //   height:5,
                                                                            // ),
                                                                            Row(children: [
                                                                              Text(product[index]['sellerId']['distance'].toString() + " km  " + product[index]['sellerId']['city'],
                                                                                  style: GoogleFonts.poppins(
                                                                                    textStyle: TextStyle(color: Color(0xFF828282), fontSize: 11, fontWeight: FontWeight.w400),
                                                                                  )),
                                                                              //SizedBox(width:100),
                                                                              Spacer(),
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Color(0xFFFFBF00),
                                                                                size: 7,
                                                                              ),
                                                                              SizedBox(width: 2),
                                                                              Text(product[index]['rating'].toString(), style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF9B9B9B), fontSize: 11, fontWeight: FontWeight.w400))),
                                                                            ]),
                                                                            // SizedBox(
                                                                            //   height:5,
                                                                            // ),
                                                                            Row(children: [
                                                                              Text("Rs. " + f[index].nonSymbol,
                                                                                  style: GoogleFonts.poppins(
                                                                                    textStyle: TextStyle(color: Color(0xFF1C1C1C), fontSize: 11, fontWeight: FontWeight.w600),
                                                                                  )),
                                                                            ]),
                                                                            // SizedBox(
                                                                            //   height:50
                                                                            // ),
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
                                                                Divider(
                                                                  height: 30,
                                                                  thickness: 1,
                                                                  indent: 1,
                                                                ),
                                                              ],
                                                            ),
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  new MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          new ProductDetail(product[index]
                                                                              [
                                                                              '_id'])));
                                                            });
                                                      }),
                                                ),
                                              ),
                                        Container(
                                          height: loading ? 20 : 0,
                                          width: double.infinity,
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        ),
                                      ],
                                    )
                                  : Text("No search results found",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ))),
                          // seller.isEmpty&&product.isEmpty?
                          // Text("No search results found",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:16,fontWeight: FontWeight.w500),))
                          //     :SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
  }

  var searchMsg;
  void senddata() async {
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
        if (json.decode(response.body)['status']) {
          Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                          new SubcategorySearch(widget.subid, keyword.text)))
              .then((value) {
            //This makes sure the textfield is cleared after page is pushed.
            // keyword.clear();
          });
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } on SocketException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  void senddata1() async {
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
          Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                          new SubcategorySearch(widget.subid, keyword.text)))
              .then((value) {
            //This makes sure the textfield is cleared after page is pushed.
            // keyword.clear();
          });
        }
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
