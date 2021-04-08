import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eram_app/SellerProductview.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:eram_app/Prefmanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopproductSearch extends StatefulWidget {
  final keyword, id;
  ShopproductSearch(this.keyword, this.id);
  @override
  _ShopproductSearch createState() => new _ShopproductSearch();
}

class _ShopproductSearch extends State<ShopproductSearch> {
  void initState() {
    super.initState();
    keyword.text = widget.keyword;
    sample();
  }

  Future sample() async {
    await _getCurrentLocation();
    await searchProduct();
  }

  bool progress = true;
  List product = [];
  int page = 1, limit = 3;
  var totallength;
  Future<void> searchProduct() async {
    var url = Prefmanager.baseurl + '/product/search';
    var token = await Prefmanager.getToken();
    Map data = {
      'keyword': widget.keyword,
      'limit': limit.toString(),
      'page': page.toString(),
      'lat': lat.toString(),
      'lon': lon.toString(),
      'userid': widget.id
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
          elevation: 0.0,
          automaticallyImplyLeading: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
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
                        offset: Offset(2, 5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.search, color: Colors.red),
                        suffixIcon: Icon(Icons.keyboard_voice_outlined,
                            color: Colors.red),
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
                    onChanged: callSearch,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: MediaQuery.of(context).size.height - 100,
                  child: product.isEmpty
                      ? Text("No search results found",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ))
                      : Column(
                          children: [
                            Row(
                              children: [
                                Text("Products",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Color(0xFF1D1D1D),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ))
                              ],
                            ),
                            progress
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : NotificationListener<ScrollNotification>(
                                    onNotification:
                                        (ScrollNotification scrollInfo) {
                                      if (!loading &&
                                          scrollInfo.metrics.pixels ==
                                              scrollInfo
                                                  .metrics.maxScrollExtent) {
                                        if (totallength > product.length) {
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
                                        padding: const EdgeInsets.all(10.0),
                                        scrollDirection: Axis.vertical,
                                        itemCount: product.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
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
                                                                image: AssetImage(
                                                                    'assets/phone.jpeg'),
                                                                height: 95,
                                                                width: 95,
                                                                fit: BoxFit
                                                                    .fill),
                                                            Expanded(
                                                                child: Column(
                                                                    children: [
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                          product[index]
                                                                              [
                                                                              'name'],
                                                                          style:
                                                                              GoogleFonts.poppins(
                                                                            textStyle: TextStyle(
                                                                                color: Color(0xFF373737),
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w600),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                  // SizedBox(
                                                                  //   height:5,
                                                                  // ),
                                                                  Row(
                                                                      children: [
                                                                        Text(
                                                                            product[index]['sellerId'][
                                                                                'shopName'],
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              textStyle: TextStyle(color: Color(0xFF828282), fontSize: 11, fontWeight: FontWeight.w400),
                                                                            )),
                                                                      ]),
                                                                  // SizedBox(
                                                                  //   height:5,
                                                                  // ),
                                                                  Row(
                                                                      children: [
                                                                        Text(
                                                                            product[index]['sellerId']['distance'].toString() +
                                                                                " km  " +
                                                                                product[index]['sellerId']['city'],
                                                                            style: GoogleFonts.poppins(
                                                                              textStyle: TextStyle(color: Color(0xFF828282), fontSize: 11, fontWeight: FontWeight.w400),
                                                                            )),
                                                                        //SizedBox(width:100),
                                                                        Spacer(),
                                                                        Icon(
                                                                          Icons
                                                                              .star,
                                                                          color:
                                                                              Color(0xFFFFBF00),
                                                                          size:
                                                                              7,
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                2),
                                                                        Text(
                                                                            product[index]['rating']
                                                                                .toString(),
                                                                            style:
                                                                                GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF9B9B9B), fontSize: 11, fontWeight: FontWeight.w400))),
                                                                      ]),
                                                                  // SizedBox(
                                                                  //   height:5,
                                                                  // ),
                                                                  Row(
                                                                      children: [
                                                                        Text(
                                                                            "Rs. " +
                                                                                f[index].nonSymbol,
                                                                            style: GoogleFonts.poppins(
                                                                              textStyle: TextStyle(color: Color(0xFF1C1C1C), fontSize: 11, fontWeight: FontWeight.w600),
                                                                            )),
                                                                      ]),
                                                                  // SizedBox(
                                                                  //   height:50
                                                                  // ),
                                                                ])),
                                                            SizedBox(
                                                              height: 10,
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
                                                            new SellerProductview(
                                                                product[index]
                                                                    ['_id'])));
                                              });
                                        }),
                                  ),
                          ],
                        ),
                ),
                Container(
                  height: loading ? 20 : 0,
                  width: double.infinity,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
        ));
  }

  void senddata1() async {
    try {
      var url = Prefmanager.baseurl + '/product/search';
      var token = await Prefmanager.getToken();
      Map data = {'keyword': keyword.text, 'userid': widget.id};
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
                          new ShopproductSearch(keyword.text, widget.id)))
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
