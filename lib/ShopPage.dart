import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eram_app/AllProductsSearch.dart';
import 'package:eram_app/AllstoresSearch.dart';
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
import 'package:shimmer/shimmer.dart';
class ShopPage extends StatefulWidget {
  final keyword, userid, serviceid, subid;
  ShopPage(this.keyword, this.userid, this.serviceid, this.subid);
  @override
  _ShopPage createState() => new _ShopPage();
}

class _ShopPage extends State<ShopPage> {
  void initState() {
    super.initState();
    keyword.text = widget.keyword;
    sample();
  }

  Future sample() async {
    await _getCurrentLocation();
    await searchProduct();
    if (widget.userid == null || widget.subid == null) await searchSeller();
  }

  bool progress = true;
  List product = [];
  int page = 1, limit = 5;
  var totallength;
  Future<void> searchProduct() async {
    var url = Prefmanager.baseurl + '/product/search';
    var token = await Prefmanager.getToken();
    Map data = {
      'keyword': widget.keyword,
      'userid': widget.userid,
      'categoryId': widget.serviceid,
      'subcategoryId': widget.subid,
      'limit': limit.toString(),
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
  int page1 = 1, limit1 = 3;
  var totallength1;
  Future<void> searchSeller() async {
    var url = Prefmanager.baseurl + '/seller/search';
    var token = await Prefmanager.getToken();
    Map data = {
      'keyword': widget.keyword,
      'categoryId': widget.serviceid,
      'limit': limit1.toString(),
      'page': page1.toString(),
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
      totallength1 = json.decode(response.body)['totalLength'];
      print(totallength1);
      for (int i = 0; i < json.decode(response.body)['data'].length; i++)
        seller.add(json.decode(response.body)['data'][i]);
    } else
      print("Somjj");
    loading1 = false;
    progress1 = false;
    //loading=false;
    setState(() {});
  }

  bool loading1 = false;
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
  bool check1=false;
  displayClose(String q){
    setState(() {
      check1=true;
    });

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
        senddata();
        senddata1();

        setState(() {});
      });
      check1=false;
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
        body: //progress1 || progress ? Center(child: CircularProgressIndicator(),)
        progress||progress1?Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Column(
            //mainAxisSize: MainAxisSize.max,

              children: <Widget>[
                SizedBox(height:20),
                Container(
                  width: double.infinity,
                  height: 50.0,
                  color: Colors.white,
                ),
                SizedBox(height:20),
                Container(
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ),
                SizedBox(height:20),
                Container(
                  //height: MediaQuery.of(context).size.height / 5.75,
                  height: 120,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder:
                          (BuildContext context, int index) {
                        return Row(
                          children: [
                            new Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Padding(
                                          padding:
                                          const EdgeInsets
                                              .all(5.0),
                                          child:Container(
                                              height:100,
                                              width:100,
                                              color:Colors.white
                                          )
                                      ),
                                    ]),
                              ],
                            ),
                          ],
                        );
                      }),
                ),
                Container(
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ),
                SizedBox(height:20),
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    enabled: progress,
                    child: ListView.builder(
                      itemBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left:10),
                              child: Container(
                                width: 48.0,
                                height: 48.0,
                                color: Colors.white,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 20,)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      itemCount: 10,
                    ),
                  ),
                )
              ]),
        ):
             SingleChildScrollView(
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
                                  color: Colors.grey[300],
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  prefixIcon:
                                      Icon(Icons.search, color: Colors.red),
                                  suffixIcon: check1?IconButton(
                                    onPressed: () => keyword.clear(),
                                    icon: Icon(Icons.clear,color: Colors.red),
                                  ):SizedBox.shrink(),
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
                              onChanged: displayClose,
                              onFieldSubmitted: callSearch,
                            ),
                          ),
                          SizedBox(height: 20),
                          seller.isEmpty && product.isEmpty
                              ? Text("No search results found",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ))
                              : SizedBox.shrink(),
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
                                            Spacer(),
                                            InkWell(
                                              child: Text(
                                                  totallength1 > 3
                                                      ? "View All"
                                                      : "",
                                                  style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          color:
                                                              Color(0xFF1D1D1D),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight
                                                              .w500))),
                                              onTap: () {
                                                print(widget.serviceid);
                                                Navigator.push(
                                                    context,
                                                    new MaterialPageRoute(
                                                        builder: (context) =>
                                                            new AllstoresSearch(
                                                                keyword.text,
                                                                widget
                                                                    .serviceid)));
                                              },
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          height: 150,
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
                                                                      if (seller[index][
                                                                      'sellerid']
                                                                      [
                                                                      'isOffer'] ==
                                                                          true)
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
                                                                          'city'],
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
                                        )
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
                                              )),
                                          Spacer(),
                                          InkWell(
                                            child: Text(
                                                totallength > 3
                                                    ? "View All"
                                                    : "",
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color:
                                                            Color(0xFF1D1D1D),
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500))),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (context) =>
                                                          new AllproductsSearch(
                                                              keyword.text,
                                                              widget.userid,
                                                              widget.serviceid,
                                                              widget.subid)));
                                            },
                                          )
                                        ],
                                      ),
                                      progress
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : Expanded(
                                              child: ListView.builder(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  padding: const EdgeInsets.all(
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
                                                                          image: product[index]['photos'] == null || product[index]['photos'].isEmpty
                                                                              ? NetworkImage(Prefmanager.baseurl + "/file/get/noimage.jpg")
                                                                              : NetworkImage(Prefmanager.baseurl + "/file/get/" + product[index]['photos'][0]),
                                                                          height: 85,
                                                                          width: 85,
                                                                          fit: BoxFit.fill),
                                                                      Expanded(
                                                                          child:
                                                                              Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 10.0),
                                                                        child: Column(
                                                                            children: [
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
                                                                            ]),
                                                                      )),
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
                                                                      new ProductDetail(
                                                                          product[index]
                                                                              [
                                                                              '_id'])));
                                                        });
                                                  }),
                                            ),
                                      Container(
                                        height: loading ? 20 : 0,
                                        width: double.infinity,
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      ),
                                    ],
                                  )
                                : SizedBox.shrink(),
                          ),
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
        'categoryId': widget.serviceid,
        'limit': limit1.toString(),
        'page': page1.toString(),
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
                builder: (context) => new ShopPage(keyword.text, widget.userid,
                    widget.serviceid, widget.subid),
              )).then((value) {
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
        'userid': widget.userid,
        'categoryId': widget.serviceid,
        'subcategoryId': widget.subid,
        'limit1': limit.toString(),
        'page1': page.toString(),
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
                builder: (context) => new ShopPage(keyword.text, widget.userid,
                    widget.serviceid, widget.subid),
              )).then((value) {
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
