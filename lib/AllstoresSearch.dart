import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eram_app/ShopPage1.dart';
import 'package:http/http.dart' as http;
import 'package:eram_app/Prefmanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
class AllstoresSearch extends StatefulWidget {
  final keyword, serviceid;
  AllstoresSearch(this.keyword, this.serviceid);
  @override
  _AllstoresSearch createState() => new _AllstoresSearch();
}

class _AllstoresSearch extends State<AllstoresSearch> {
  void initState() {
    super.initState();
    keyword.text = widget.keyword;
    sample();
  }

  Future sample() async {
    await _getCurrentLocation();
    await searchSeller();
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
      page1++;
    } else
      print("Somjj");

    progress1 = false;
    loading = false;
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

        setState(() {});
      });
      check1=false;
    });
    //keyword.clear();
  }
  final ScrollController scrollController = new ScrollController();
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
      body: //progress1 ? Center(child: CircularProgressIndicator(),)
      progress1?SingleChildScrollView(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            //enabled: progress,
            child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(height:50,width:double.infinity,color:Colors.white),
                  SizedBox(height:20),
                  GridView.builder(
                      itemCount: 4,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics:
                      NeverScrollableScrollPhysics(),
                      itemBuilder:
                          (BuildContext context,
                          int index) {
                        return GestureDetector(
                          child: Container(
                            //height: MediaQuery.of(context).size.height,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                Container(color:Colors.white,height:150,width:double.infinity),
                                SizedBox(
                                  height: 5,
                                ),
                                // Text(cat[index],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w600))),
                                Container(color:Colors.white,height:10,width:double.infinity),
                                SizedBox(height:5),
                                Container(color:Colors.white,height:10,width:double.infinity),
                              ],
                            ),
                          ),

                        );
                      },
                      gridDelegate:
                      new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75)),

                ]),
          ))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300],
                          spreadRadius: 2,
                          blurRadius: 2,
                          //offset: Offset(2, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(Icons.search, color: Colors.red),
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
                      onFieldSubmitted: callSearch,
                      onChanged: displayClose,
                      controller: keyword,
                    ),
                  ),
                ),
                seller.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          children: [
                            Text("Stores",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF1D1D1D),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600))),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
                seller.isEmpty
                    ? Center(
                        child: Text("No search results found",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            )))
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15),
                        child: Expanded(
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scrollInfo) {
                              if (!loading &&
                                  scrollInfo.metrics.pixels ==
                                      scrollInfo.metrics.maxScrollExtent) {
                                if (totallength1 > seller.length) {
                                  searchSeller();
                                  setState(() {
                                    loading = true;
                                  });
                                } else {}
                              } else {}
                              //  setState(() =>loading = false);
                              return true;
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              child: GridView.builder(
                                  itemCount: seller.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                   controller: scrollController,
                                   physics: AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10.0),
                                                  child: Image(
                                                    image: NetworkImage(
                                                        Prefmanager.baseurl +
                                                            "/file/get/" +
                                                            seller[index]
                                                                    ['sellerid']
                                                                ["photo"]),
                                                    height: 150,
                                                    width: double.infinity,
                                                    fit: BoxFit.fill,
                                                  )),
                                              Positioned(
                                                  top: 10,
                                                  left: 90,
                                                  child: Image(
                                                      image: AssetImage(
                                                          'assets/discount.png'))),
                                            ],
                                          ),
                                          Text(seller[index]['sellerid']['city'],
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF000000),
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                          Container(
                                            height: 10,
                                            child: Row(
                                              children: [
                                                Image(
                                                  image: AssetImage(
                                                      'assets/googlemaps.png'),
                                                  height: 14,
                                                  width: 14,
                                                ),
                                                Text(
                                                    seller[index]['sellerid']
                                                                ['distance'] !=
                                                            null
                                                        ? "  " +
                                                            seller[index]
                                                                    ['sellerid']
                                                                ['distance'] +
                                                            " km"
                                                        : " ",
                                                    style: GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            color:
                                                                Color(0xFF000000),
                                                            fontSize: 8,
                                                            fontWeight: FontWeight
                                                                .w500))),
                                                SizedBox(width: 50),
                                                Icon(
                                                  Icons.star,
                                                  color: Color(0xFFFFBF00),
                                                  size: 6,
                                                ),
                                                Text(
                                                    seller[index]['sellerid']
                                                            ['rating']
                                                        .toString(),
                                                    style: GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            color:
                                                                Color(0xFF000000),
                                                            fontSize: 8,
                                                            fontWeight: FontWeight
                                                                .w500))),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) => ShopPage1(
                                                    false,false,
                                                    seller[index]['sellerid']
                                                        ['shopName'],
                                                    seller[index]['sellerid']
                                                        ['uid'],
                                                    seller[index]['_id'])));
                                        //Navigator.pop(context);
                                      },
                                    );
                                  },
                                  gridDelegate:
                                      new SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          childAspectRatio: 0.75)),
                            ),
                          ),
                        ),
                      ),
                Container(
                  height: loading ? 20 : 0,
                  width: double.infinity,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
    );
  }

  var searchMsg;
  void senddata() async {
    try {
      var url = Prefmanager.baseurl + '/seller/search';
      var token = await Prefmanager.getToken();
      Map data = {'keyword': keyword.text, 'categoryId': widget.serviceid};
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
                          new AllstoresSearch(keyword.text, widget.serviceid)))
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
