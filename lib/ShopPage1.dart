import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eram_app/AllProductsSearch.dart';
import 'package:eram_app/ProductDetail.dart';
import 'package:eram_app/SellerOfferview.dart';
import 'package:eram_app/ShopDetail.dart';
import 'package:eram_app/SubcategoryProductsSeller.dart';
import 'package:eram_app/utils/helper.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:eram_app/Prefmanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopPage1 extends StatefulWidget {
  final check,check1, userid, name, sellerid;
  ShopPage1(this.check, this.check1,this.name, this.userid, this.sellerid);
  @override
  _ShopPage1 createState() => new _ShopPage1();
}

//State is information of the application that can change over time or when some actions are taken.
class _ShopPage1 extends State<ShopPage1> {
  void initState() {
    super.initState();
    widget.check ? _hasBeenPressed3 = true : _hasBeenPressed3 = false;
    widget.check1 ? _hasBeenPressed2 = true : _hasBeenPressed2 = false;
      productlist();
      sellerview();
     offerNear1();
  }
  List offernear1 = [];
  var length1,categoryicon;
  Future<void> offerNear1() async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token != null ? token : null
    };
    Map data;
      data = {'userid': widget.userid};

    var body = json.encode(data);
    print(token);
    var url = Prefmanager.baseurl + '/seller/offer/list';
    var response = await http.post(url, headers: requestHeaders, body: body);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      offernear1 = json.decode(response.body)['data'];
      length1 = json.decode(response.body)['totalLength'];

    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    setState(() {});
  }
  List product = [];
  bool progress = true;
  var length, totallength;
  int page = 1, limit = 10;
  void productlist() async {
    // if(_hasBeenPressed2)
    //   offerNear1();
    setState(() {
      progress = true;
    });
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token != null ? token : null
    };
    Map data = {
      'userid': widget.userid,
      'limit': 0,
      'page': 0,
      'productType': _hasBeenPressed1
          ? 'bestselling'
          // : _hasBeenPressed2
          //     ? 'todaysdeal'
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
      totallength = json.decode(response.body)['totalLength'];
      // page++;

    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress = false;
    loading = false;
    setState(() {});
  }

  var seller;
  List sub = [];
  //var sub;
  bool progress1 = true;
  Future<void> sellerview() async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    var url = Prefmanager.baseurl + '/seller/view/' + widget.sellerid;
    var response = await http.get(url, headers: requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      seller = json.decode(response.body)['data'];
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
        // await Navigator.push(context,new MaterialPageRoute(builder: (context)=>new ShopPage(keyword.text,widget.userid,null,null,null))).then((value) {
        //    //This makes sure the textfield is cleared after page is pushed.
        //    //keyword.clear();
        //  });
        await Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new AllproductsSearch(
                    keyword.text, widget.userid, null, null))).then((value) {
          //This makes sure the textfield is cleared after page is pushed.
          //keyword.clear();
        });
        setState(() {});
      });
      check1=false;
    });
    //keyword.clear();
  }

  TextEditingController keyword = TextEditingController();
  bool loading = false;
  var city, lat, lon;
  bool _hasBeenPressed1 = false;
  bool _hasBeenPressed2 = false;
  bool _hasBeenPressed3 = false;
  List rs = ['Rs. 1,50,000', 'Rs. 1,50,000', 'Rs. 1,50,000', 'Rs. 1,50,000'];
  List imagesp = [
    'assets/mac.jpg',
    'assets/mac.jpg',
    'assets/mac.jpg',
    'assets/mac.jpg'
  ];
  List pronames = [
    'Macbook Pro 16inch',
    'Macbook Pro 16inch',
    'Macbook Pro 16inch',
    'Macbook Pro 16inch'
  ];
  List offer = [
    'Today (Rs. 1500, 50% Off)',
    'Today (Rs. 1500, 50% Off)',
    'Today (Rs. 1500, 50% Off)',
    'Today (Rs. 1500, 50% Off)'
  ];
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
          title: Text(widget.name,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              )),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, true),
          ),
          // actions: [
          //   IconButton (icon:Icon(Icons.search,size:20,color: Color(0xFFEC7777)),
          //     //onPressed:() => Navigator.pop(context,true),
          //   ),
          // ],
        ),
        body: progress1
            ?CameraHelper.productlistLoader(context)
       : SingleChildScrollView(
                // physics: ScrollPhysics(),
                child: SafeArea(
                  child: Container(
                    //height: MediaQuery.of(context).size.height,
                    child: Column(children: [
                      progress1
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(
                              height: 220,
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
                                  bottom: 85,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(3.0),
                                      child: InkWell(
                                        child: Image(
                                            image: NetworkImage(Prefmanager
                                                    .baseurl +
                                                "/file/get/" +
                                                seller['sellerid']['photo']),
                                            height: 80,
                                            width: 60),
                                        onTap: () async {
                                          await Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      new ShopDetail(
                                                          widget.name,
                                                          widget.sellerid)));
                                          await sellerview();
                                        },
                                      )),
                                ),
                                //Positioned(right:22,top:40,child: Image(image:AssetImage('assets/googlemaps.png'),height: 35,width:35,)),
                                Positioned(
                                  right: 0,
                                  top: 80,
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
                                                        color:
                                                            Color(0xFFFFC107),
                                                      ),
                                                      SizedBox(width: 3),
                                                      Text(
                                                          seller['sellerid']
                                                                  ['rating']
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle: TextStyle(
                                                                color: Color(
                                                                    0xFF9B9B9B),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          )),
                                                      Spacer(),
                                                      Column(
                                                        children: [
                                                          SizedBox(height: 5),
                                                          Text(
                                                              seller['sellerid']
                                                                      [
                                                                      'totalReviews']
                                                                  .toString(),
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                textStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFF000000),
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              )),
                                                          Text("REVIEWS",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                textStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFF9A9A9A),
                                                                    fontSize:
                                                                        10,
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
                                Positioned(
                                  bottom: 30,
                                  left: 20,
                                  right: 20,
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
                                          prefixIcon: Icon(Icons.search,
                                              color: Colors.red),
                                          suffixIcon: check1?IconButton(
                                            onPressed: () => keyword.clear(),
                                            icon: Icon(Icons.clear,color: Colors.red),
                                          ):SizedBox.shrink(),
                                          hintText: 'Search items',
                                          hintStyle: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  color: Color(0xFFB8B8B8))),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            // borderRadius: const BorderRadius.all(
                                            //   const Radius.circular(30.0),
                                            // ),
                                          )),
                                      controller: keyword,
                                      onChanged: displayClose,
                                      onFieldSubmitted: callSearch,
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                                child: Container(
                                    //height: 50,
                                    child: Column(
                                  children: [
                                    //Image(image: NetworkImage(sub[index]['icon']!=null?Prefmanager.baseurl+"/file/get/"+sub[index]['icon']):AssetImage('assets/oxygen.png'),height: 30,width: 30,),
                                    Image(
                                        image: sub[index]['icon'] != null
                                            ? NetworkImage(Prefmanager.baseurl +
                                                "/file/get/" +
                                                sub[index]['icon'])
                                            : AssetImage('assets/oxygen.png'),
                                        width: 30,
                                        height: 30),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Expanded(
                                        child: Text(sub[index]['name'],
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFF848484),
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w300)))),
                                  ],
                                )),
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
                                    crossAxisCount: 4, childAspectRatio: 1.4)),
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: FlatButton(
                                //width:114,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                  color: _hasBeenPressed1
                                      ? Color(0xFFE50019)
                                      : Color(0xFFD2D2D2),
                                )),

                                height: 26,
                                minWidth: 114,
                                color: Color(0xFFFFFFFF),
                                child: Text('Best Selling',maxLines:1,overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: _hasBeenPressed1
                                                ? Color(0xFFE50019)
                                                : Color(0xFF000000),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500))),
                                onPressed: () {
                                  setState(() {
                                    _hasBeenPressed1 = !_hasBeenPressed1;
                                    _hasBeenPressed1 = true;
                                    _hasBeenPressed2 = false;
                                    _hasBeenPressed3 = false;
                                    productlist();
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 8),

                            Expanded(
                              child: FlatButton(
                                //width:114,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                  color: _hasBeenPressed2
                                      ? Color(0xFFE50019)
                                      : Color(0xFFD2D2D2),
                                )),

                                height: 26,
                                minWidth: 114,
                                color: Color(0xFFFFFFFF),
                                child: Text('Todays Deal',maxLines:1,overflow:TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: _hasBeenPressed2
                                                ? Color(0xFFE50019)
                                                : Color(0xFF000000),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500))),
                                onPressed: () {
                                  setState(() {
                                    _hasBeenPressed2 = !_hasBeenPressed2;
                                    _hasBeenPressed2 = true;
                                    _hasBeenPressed1 = false;
                                    _hasBeenPressed3 = false;
                                   // productlist();
                                     //product.clear();
                                     offerNear1();
                                     //todaysDeal();
                                   // await todaysDeal();
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: FlatButton(
                                //width:114,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                  color: _hasBeenPressed3
                                      ? Color(0xFFE50019)
                                      : Color(0xFFD2D2D2),
                                )),

                                height: 26,
                                minWidth: 110,
                                // color: Color(0xFFD2D2D2),
                                child: Text('Offers',maxLines:1,overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: _hasBeenPressed3
                                                ? Color(0xFFE50019)
                                                : Color(0xFF000000),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500))),
                                onPressed: () {
                                  setState(() {
                                    _hasBeenPressed3 = !_hasBeenPressed3;
                                    _hasBeenPressed3 = true;
                                    _hasBeenPressed1 = false;
                                    _hasBeenPressed2 = false;
                                    productlist();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    if(_hasBeenPressed2)
                      todaysDeal()
                    else
                      product.isEmpty || length == 0
                          ? Text("No proucts are available",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400)))
                          : progress
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
                                  child: Container(
                                    child: GridView.builder(
                                        itemCount: product.length,
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        //crossAxisCount: 2,
                                        //children: List.generate(4,(index)
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            child: Container(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                // mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Stack(children: [
                                                    ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6.0),
                                                        child: Image(
                                                          image: product[index][
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
                                                          fit: BoxFit.cover,
                                                          height: 175,
                                                          width: 175,
                                                        )),
                                                    //Image(image:AssetImage(imagesp[index]),height: 110,width: 175,),
                                                    product[index]
                                                                ['discount'] !=
                                                            0
                                                        ? Positioned(
                                                            top: 10,
                                                            right: 10,
                                                            child: Image(
                                                                image: AssetImage(
                                                                    'assets/discount.png')))
                                                        : SizedBox.shrink()
                                                  ]),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                          product[index]
                                                              ['name'],
                                                          style: GoogleFonts.poppins(
                                                              textStyle: TextStyle(
                                                                  color: Color(
                                                                      0xFF000000),
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600))),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                          flex: 1,
                                                          child: Text(
                                                              "Rs. " +
                                                                  f[index]
                                                                      .nonSymbol,
                                                              style: GoogleFonts.poppins(
                                                                  textStyle: TextStyle(
                                                                      color: Color(
                                                                          0xFF000000),
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)))),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                          product[index][
                                                                      'discount'] ==
                                                                  0
                                                              ? ""
                                                              : "Today",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle: TextStyle(
                                                                color: Color(
                                                                    0xFFF44336),
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          )),
                                                      Expanded(
                                                        child: Text(
                                                            product[
                                                                            index]
                                                                        [
                                                                        'discount'] ==
                                                                    0
                                                                ? ""
                                                                : " (Rs. " +
                                                                    product[index]
                                                                            [
                                                                            'offerPrice']
                                                                        .toStringAsFixed(2) +
                                                                    ", " +
                                                                    product[index]
                                                                            [
                                                                            'discount']
                                                                        .toString() +
                                                                    ' % Off)',
                                                            maxLines: 1,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle: TextStyle(
                                                                  color: Color(
                                                                      0xFFF43636),
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            )),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductDetail(
                                                              product[index]
                                                                  ["_id"])));
                                              //Navigator.pop(context);
                                            },
                                          );
                                        },
                                        gridDelegate:
                                            new SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: 0.7)),
                                  ),
                                ),
                      // if(_hasBeenPressed2)
                      //   todaysDeal(),
                      // offer.isEmpty || length1 == 0
                      //     ? Text("No proucts are available",
                      //     style: GoogleFonts.poppins(
                      //         textStyle: TextStyle(
                      //             color: Color(0xFF000000),
                      //             fontSize: 14,
                      //             fontWeight: FontWeight.w400)))
                      //     : progress
                      //     ? Center(
                      //   child: CircularProgressIndicator(),
                      // )
                      //     :

                      Container(
                        height: loading ? 20 : 0,
                        width: double.infinity,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ]),
                  ),
                ),
              ));
  }
Widget todaysDeal(){
    return Column(
      children:[
    offernear1.isEmpty?
    Text("No offers are available",
        style: GoogleFonts.poppins(
            textStyle: TextStyle(
                color: Color(0xFF000000),
                fontSize: 14,
                fontWeight: FontWeight.w400)))
      :NotificationListener<ScrollNotification>(
  onNotification:
  (ScrollNotification scrollInfo) {
  if (!loading &&
  scrollInfo.metrics.pixels ==
  scrollInfo
      .metrics.maxScrollExtent) {
  if (length1 > offernear1.length) {
  offerNear1();
  setState(() {
  loading = true;
  });
  } else {}
  } else {}
  //  setState(() =>loading = false);
  return true;
  },
  child: Container(
  child: GridView.builder(
  itemCount: offernear1.length,
  scrollDirection: Axis.vertical,
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  //crossAxisCount: 2,
  //children: List.generate(4,(index)
  itemBuilder:
  (BuildContext context, int index) {
  return GestureDetector(
  child: Container(
  child: Padding(
  padding:
  const EdgeInsets.symmetric(
  horizontal: 20,
  vertical: 0),
  child: Column(
  crossAxisAlignment:
  CrossAxisAlignment.center,
  // mainAxisSize: MainAxisSize.max,
  mainAxisAlignment:
  MainAxisAlignment.center,
  children: [
  SizedBox(
  height: 3,
  ),
  Stack(children: [
  ClipRRect(
  borderRadius:
  BorderRadius
      .circular(6.0),
  child: Image(
  image: offernear1[index][
  'photo'] ==
  null ||
  offernear1[index]
  [
  'photo']
      .isEmpty
  ? NetworkImage(Prefmanager
      .baseurl +
  "/file/get/noimage.jpg")
      : NetworkImage(Prefmanager
      .baseurl +
  "/file/get/" +
  offernear1[index]
  [
  'photo']
  ),
  fit: BoxFit.cover,
  height: 175,
  width: 175,
  )),
  // Image(image:AssetImage(imagesp[index]),height: 110,width: 175,),
  // offernear1[index]
  // ['discount'] !=
  //     0
  //     ? Positioned(
  //     top: 10,
  //     right: 10,
  //     child: Image(
  //         image: AssetImage(
  //             'assets/discount.png')))
  //     : SizedBox.shrink()
  ]),
  Row(
  mainAxisAlignment:
  MainAxisAlignment.start,
  children: [
  Expanded(
    child: Text(
    offernear1[index]
    ['name'],
    style: GoogleFonts.poppins(
    textStyle: TextStyle(
    color: Color(
    0xFF000000),
    fontSize: 14,
    fontWeight:
    FontWeight
        .w600))),
  ),
  ],
  ),

  Row(
  mainAxisAlignment:
  MainAxisAlignment.start,
  children: [

  Expanded(
  child: Text(
  offernear1[index]['description'],
  maxLines: 1,
  overflow: TextOverflow
      .ellipsis,
  style: GoogleFonts
      .poppins(
  textStyle: TextStyle(
  color: Color(
  0xFFF43636),
  fontSize: 10,
  fontWeight:
  FontWeight
      .w400),
  )),
  ),
  ],
  )
  ],
  ),
  )),
  onTap: () {
  Navigator.push(
  context,
  new MaterialPageRoute(
  builder: (context) =>
  SellerOfferview(true,
  offernear1[index]
  ["_id"])));
  //Navigator.pop(context);
  },
  );
  },
  gridDelegate:
  new SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  childAspectRatio: 0.7)),
  ),
  )
      ]
    );

}
  var searchMsg;
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
