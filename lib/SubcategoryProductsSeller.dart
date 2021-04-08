import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eram_app/AllProductsSearch.dart';
import 'package:eram_app/ProductDetail.dart';
import 'package:eram_app/utils/helper.dart';
import 'package:http/http.dart' as http;
import 'package:eram_app/Prefmanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class SubcategoryProductsSeller extends StatefulWidget {
  final sellerid, subid, subname;
  SubcategoryProductsSeller(this.sellerid, this.subid, this.subname);
  @override
  _SubcategoryProductsSeller createState() => new _SubcategoryProductsSeller();
}

class _SubcategoryProductsSeller extends State<SubcategoryProductsSeller> {
  void initState() {
    super.initState();
    _getCurrentLocation();
    productlist();
  }

  var city, lat, lon;
  bool _hasBeenPressed1 = false;
  bool _hasBeenPressed2 = false;
  bool _hasBeenPressed3 = false;
  List imagesp = [
    'assets/mac.jpg',
    'assets/ifb.jpg',
    'assets/tv.jpg',
    'assets/earpod.jpg'
  ];
  List pronames = [
    'MacBook Pro',
    'IFB Front Load',
    'One Plus Tv 32',
    'Sony Wireless Earpod'
  ];
  List offer = ['10% Off', '15% Off', '10% Off', '15% Off'];
  List images = [
    'assets/Smartphone.png',
    'assets/tablet.png',
    'assets/laptop.png',
    'assets/monitor.png',
    'assets/washer.png',
    'assets/stove.png',
    'assets/air.png',
    'assets/fridge.png',
  ];
  List catnames = [
    'Mobile',
    'Tablet',
    'Laptop',
    'Television',
    'Washing Machine',
    'Kitchen Accessories',
    'Air Conditiner',
    'Refrigerator'
  ];
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
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      city = first.locality;
      if (mounted) setState(() {});
    } catch (e) {
      print(e);
    }
  }

  List product = [];
  bool progress1 = true;
  var length;
  int page = 1, limit = 10;
  void productlist() async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token != null ? token : null
    };
    Map data = {
      'userid': widget.sellerid,
      'subcategoryId': widget.subid,
      'limit': 0,
      'page': 0,
      'productType': _hasBeenPressed1
          ? 'bestselling'
          : _hasBeenPressed2
              ? 'todaysdeal'
              : _hasBeenPressed3
                  ? 'offers'
                  : null
    };
    print(data);
    var body = json.encode(data);
    var url = Prefmanager.baseurl + '/product/list';
    var response = await http.post(url, headers: requestHeaders, body: body);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      length = json.decode(response.body)['totalLength'];
      for (int i = 0; i < json.decode(response.body)['data'].length; i++)
        product = json.decode(response.body)['data'];
      page++;
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress1 = false;
    loading = false;
    setState(() {});
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
      searchOnStopTyping = new Timer(duration, () async {
        // await senddata1();
        await Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new AllproductsSearch(
                        keyword.text, widget.sellerid, null, widget.subid)))
            .then((value) {
          //This makes sure the textfield is cleared after page is pushed.
        });
        setState(() {});
      });
      check1=false;
    });
    //keyword.clear();
  }

  TextEditingController keyword = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, true),
          ),
          title: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(
              children: [
                Text(widget.subname,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 16,
                            fontWeight: FontWeight.w600))),
              ],
            ),

            // city==null?SizedBox.shrink():Row(
            //   children: [
            //     Text(city,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF373539),fontSize:12,fontWeight: FontWeight.w600))),
            //     Icon(Icons.keyboard_arrow_down,color:Color(0xFF373539))
            //
            //   ],
            // ),
          ]),
        ),
        body: progress1?CameraHelper.subproductsLoader(context):
        SingleChildScrollView(
          physics: ScrollPhysics(),
          child: SafeArea(
            child: Container(
              //height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      height: 50,
                      //color: Colors.grey,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300].withOpacity(0.5),
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
                            )),
                        onFieldSubmitted: callSearch,
                        onChanged: displayClose,
                        controller: keyword,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Image(
                    image: AssetImage('assets/Slider 2.png'),
                    width: double.infinity,
                    height: 212,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       FlatButton(
                  //         //width:114,
                  //         shape: RoundedRectangleBorder(
                  //             side: BorderSide(
                  //           color: _hasBeenPressed1
                  //               ? Color(0xFFE50019)
                  //               : Color(0xFFD2D2D2),
                  //         )),
                  //
                  //         height: 26,
                  //         minWidth: 114,
                  //         color: Color(0xFFFFFFFF),
                  //         child: Text('Best Selling',
                  //             style: GoogleFonts.poppins(
                  //                 textStyle: TextStyle(
                  //                     color: _hasBeenPressed1
                  //                         ? Color(0xFFE50019)
                  //                         : Color(0xFF000000),
                  //                     fontSize: 12,
                  //                     fontWeight: FontWeight.w500))),
                  //         onPressed: () {
                  //           setState(() {
                  //             _hasBeenPressed1 = !_hasBeenPressed1;
                  //             _hasBeenPressed1 = true;
                  //             _hasBeenPressed2 = false;
                  //             _hasBeenPressed3 = false;
                  //             productlist();
                  //           });
                  //         },
                  //       ),
                  //       SizedBox(width: 8),
                  //       FlatButton(
                  //         //width:114,
                  //         shape: RoundedRectangleBorder(
                  //             side: BorderSide(
                  //           color: _hasBeenPressed2
                  //               ? Color(0xFFE50019)
                  //               : Color(0xFFD2D2D2),
                  //         )),
                  //
                  //         height: 26,
                  //         minWidth: 114,
                  //         color: Color(0xFFFFFFFF),
                  //         child: Text('Todays Deal',
                  //             style: GoogleFonts.poppins(
                  //                 textStyle: TextStyle(
                  //                     color: _hasBeenPressed2
                  //                         ? Color(0xFFE50019)
                  //                         : Color(0xFF000000),
                  //                     fontSize: 12,
                  //                     fontWeight: FontWeight.w500))),
                  //         onPressed: () {
                  //           setState(() {
                  //             _hasBeenPressed2 = !_hasBeenPressed2;
                  //             _hasBeenPressed2 = true;
                  //             _hasBeenPressed1 = false;
                  //             _hasBeenPressed3 = false;
                  //             productlist();
                  //           });
                  //         },
                  //       ),
                  //       SizedBox(width: 8),
                  //       Expanded(
                  //         child: FlatButton(
                  //           //width:114,
                  //           shape: RoundedRectangleBorder(
                  //               side: BorderSide(
                  //             color: _hasBeenPressed3
                  //                 ? Color(0xFFE50019)
                  //                 : Color(0xFFD2D2D2),
                  //           )),
                  //
                  //           height: 26,
                  //           minWidth: 110,
                  //           color: Color(0xFFFFFFFF),
                  //           child: Text('Offers',
                  //               style: GoogleFonts.poppins(
                  //                   textStyle: TextStyle(
                  //                       color: _hasBeenPressed3
                  //                           ? Color(0xFFE50019)
                  //                           : Color(0xFF000000),
                  //                       fontSize: 12,
                  //                       fontWeight: FontWeight.w500))),
                  //           onPressed: () {
                  //             setState(() {
                  //               _hasBeenPressed3 = !_hasBeenPressed3;
                  //               _hasBeenPressed3 = true;
                  //               _hasBeenPressed1 = false;
                  //               _hasBeenPressed2 = false;
                  //               productlist();
                  //             });
                  //           },
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  product.isEmpty
                      ? Text("No proucts are available",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)))
                      : progress1
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification scrollInfo) {
                                if (!loading &&
                                    scrollInfo.metrics.pixels ==
                                        scrollInfo.metrics.maxScrollExtent) {
                                  if (length > product.length) {
                                    print(length);
                                    print(product.length);
                                    productlist();
                                    setState(() {
                                      loading = true;
                                    });
                                  } else {}
                                } else {}
                                //  setState(() =>loading = false);
                                return true;
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  // height: 500,
                                 // color: Colors.grey[100],
                                  color: Colors.grey[30],
                                  child: GridView.builder(
                                      // childAspectRatio: 0.8,
                                      itemCount: product.length,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      //crossAxisCount: 2,
                                      //children: List.generate(4,(index)
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                                color: Colors.white60,
                                                //height: 500,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            //Image(image: AssetImage(images[index]),height: 30,width: 30,),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            //Center(child: Image(image: AssetImage(imagesp[index]),height: 100,width: 130,)),
                                                            Center(
                                                                child: Image(
                                                              image: product[index]
                                                                              [
                                                                              'photos'] ==
                                                                          null ||
                                                                      product[index]
                                                                              [
                                                                              'photos']
                                                                          .isEmpty
                                                                  ? NetworkImage(Prefmanager
                                                                  .baseurl +
                                                                  "/file/get/noimage.jpg")
                                                                  : NetworkImage(Prefmanager
                                                                          .baseurl +
                                                                      "/file/get/" +
                                                                      product[index]
                                                                              [
                                                                              'photos']
                                                                          [0]),
                                                              height: 130,width:130,fit:BoxFit.cover
                                                            )),
                                                            Text(
                                                                product[index]
                                                                    ['name'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts.poppins(
                                                                    textStyle: TextStyle(
                                                                        color: Color(
                                                                            0xFF000000),
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w600))),
                                                            Text(
                                                                product[index][
                                                                            'discount'] ==
                                                                        0
                                                                    ? ""
                                                                    : product[index][
                                                                                'discount']
                                                                            .toString() +
                                                                        "% Off",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts.poppins(
                                                                    textStyle: TextStyle(
                                                                        color: Color(
                                                                            0xFFFF4141),
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w300))),
                                                            Divider()
                                                          ],
                                                        ),
                                                        VerticalDivider(
                                                            //   //height: 10,
                                                            //  color:Colors.grey,
                                                            // // width: 20,
                                                            //   thickness: 1,

                                                            ),
                                                      ],
                                                    ),
                                                    //Divider(height: 10,)
                                                  ],
                                                )),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductDetail(
                                                            product[index]
                                                                ['_id'])));
                                            //Navigator.pop(context);
                                          },
                                        );
                                      },
                                      gridDelegate:
                                          new SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 0.85)),
                                ),
                              ),
                            ),
                  Container(
                    height: loading ? 20 : 0,
                    width: double.infinity,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal:12.0),
                  //   child: Container(
                  //     width:450,
                  //     //height:47,
                  //     child: Card(
                  //       child:Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal:25.0),
                  //         child: Column(
                  //           children: [
                  //             SizedBox(
                  //                 height:20
                  //             ),
                  //             Row(
                  //               children: [
                  //                 Image(image:AssetImage('assets/discount.png',)),SizedBox(width:20),
                  //                 Expanded(child: Text("Invite friends to Eram to earn upto 10% cashback",style:GoogleFonts.poppins(textStyle: TextStyle(fontWeight:FontWeight.w500,fontSize:12,color:Color(0xFF373737)),))),
                  //                 Icon(Icons.keyboard_arrow_right,color:Colors.red)
                  //               ],
                  //             ),
                  //             SizedBox(
                  //                 height:13
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
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
