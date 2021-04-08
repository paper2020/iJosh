import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
class SellerEachOrderview extends StatefulWidget {
  final productid, orderid;
  SellerEachOrderview(this.productid, this.orderid);
  @override
  _SellerEachOrderview createState() => _SellerEachOrderview();
}

class _SellerEachOrderview extends State<SellerEachOrderview> {
  List<String> ordered = [
    'Packed',
    'Shipped',
    'Cancelledbyseller',
    'Outfordelivery',
    'Delivered'
  ];
  var selectedvalue;
  List image = [];
  List colors = [];
  bool accept = false;
  bool progress = false;
  bool progress2 = false;
  @override
  void initState() {
    super.initState();
    print("vh");
    // print(widget.details);
    recentOrders();
    //ratingList();
  }
  var d1 = new DateFormat('dd-MMM-yyyy');
  bool progress1 = true;
  var orderstatus;
  int page = 1, limit = 10;
  List recent = [];
  var item, order;
  void recentOrders() async {
    var url = Prefmanager.baseurl + '/seller/ordered/product/view';
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token,
    };
    Map data = {
      'productid': widget.productid,
      'orderid': widget.orderid,
    };
    var body = json.encode(data);
    print(data);
    var response = await http.post(url, headers: requestHeaders, body: body);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      orderstatus = json.decode(response.body)['product']['productOrderStatus'];
      print(orderstatus);
      item = json.decode(response.body)['product'];
      order = json.decode(response.body)['orderDetails'];
      image = json.decode(response.body)['product']['productId']['photos'];
      colors =
          json.decode(response.body)['product']['productId']['colorDetails'];
      if (orderstatus == 'packed') {
        ordered = [
          'Shipped',
          'Cancelledbyseller',
          'Outfordelivery',
          'Delivered'
        ];
      } else if (orderstatus == 'shipped') {
        ordered = ['Cancelledbyseller', 'Outfordelivery', 'Delivered'];
      } else if (orderstatus == 'outfordelivery') {
        ordered = ['Delivered'];
      } else if (orderstatus == 'delivered' ||
          orderstatus == 'cancelled' ||
          orderstatus == 'return' ||
          orderstatus == 'cancelledbyseller') {
        ordered = [];
      } else {}
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['msg'],
      );
    progress1 = false;
    setState(() {});
  }

  var length, rating, review;
  List rate = [];

  void ratingList() async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    Map data = {
      'ratingType': 'product',
      //'productId':widget.productrid,
    };
    print(data);
    print("hjhj");
    var body = json.encode(data);
    var url = Prefmanager.baseurl + '/rating/list/';
    var response = await http.post(url, headers: requestHeaders, body: body);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      print("true");
      length = json.decode(response.body)['totalLength'];
      rating = json.decode(response.body)['rating'];
      review = json.decode(response.body)['totalReviews'];
      // for (int i = 0; i < json.decode(response.body)['data'].length; i++)
      rate = json.decode(response.body)['data'];
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    loading = false;
    setState(() {});
  }
  static Future<String> createFolderInAppDocDir() async {
    //Get this App Document Directory
    //final Directory _appDocDir = await getApplicationDocumentsDirectory();
    //App Document Directory + folder name
    final Directory _appDocDirFolder = Directory('/storage/emulated/0/iJosh/');

    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
      return _appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
      await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }

  Future<void> downloadSinglePdf(id) async {
    String dir = await createFolderInAppDocDir();
    File file = new File('$dir/$id.pdf');
    if (file.existsSync()) {
      await OpenFile.open(file.path);
    } else {
      var request = await http.get(Prefmanager.baseurl +
          '/order/invoice/pdf?orderid=' +
          widget.orderid +
          '&productid=' +
          widget.productid);

      var bytes = request.bodyBytes; //close();
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    }
  }
  FlutterMoneyFormatter fmf;
  MoneyFormatterOutput fo;
  List images = ['assets/mac.jpg', 'assets/slider1.jpg'];
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    FlutterMoneyFormatter fmf;
    MoneyFormatterOutput fo;
    fmf = FlutterMoneyFormatter(
        amount: progress1 ? 0 : item['offerPrice'].toDouble());
    fo = fmf.output;
    FlutterMoneyFormatter fmf1;
    MoneyFormatterOutput fo1;
    fmf1 = FlutterMoneyFormatter(
        amount: progress1 ? 0 : item['productSubTotal'].toDouble());
    fo1 = fmf1.output;
    FlutterMoneyFormatter fmf2;
    MoneyFormatterOutput fo2;
    fmf2 = FlutterMoneyFormatter(
        amount: progress1 ? 0 : item['productTotalAmount'].toDouble());
    fo2 = fmf2.output;
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ),
      body: accept == true
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: Colors.black.withOpacity(0)),
            )
          : SafeArea(
              child: progress1
                  ? CameraHelper.productdetailLoader(context)
                  : SingleChildScrollView(
                      child: Container(
                        //height: MediaQuery.of(context).size.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 300,
                              child: Carousel(
                                dotSize: 5,
                                dotSpacing: 15,
                                dotBgColor: Colors.transparent,
                                dotColor: Color(0xFFBCBCBC),
                                dotIncreasedColor: Color(0xFFBCBCBC),
                                images: image.isEmpty
                                    ? images
                                        .map((item) => Image(
                                            image: AssetImage(item),
                                            width: 300,
                                            height: 400,
                                            fit: BoxFit.fill))
                                        .toList()
                                    : image
                                        .map((item) => Image(
                                            image: NetworkImage(
                                                Prefmanager.baseurl +
                                                    "/file/get/" +
                                                    item),
                                            width: 300,
                                            height: 400,
                                            fit: BoxFit.cover))
                                        .toList(),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  child: Container(
                                    // height: 55,
                                    width: 190,

                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Card(
                                          elevation: 0.0,
                                          shape: RoundedRectangleBorder(
                                              side: new BorderSide(
                                                  color: Colors.grey[400]),
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
                                                      Text(
                                                          item['rating']
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
                                                              item['totalReviews']
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
                                  onTap: () async {},
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                //height: 110,
                                //width: 364,
                                child: Card(
                                    elevation: 4.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(item['name'],
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          color:
                                                              Color(0xFF000000),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )),
                                                Spacer(),
                                                //Image(image:AssetImage('assets/heart.png'),width:18,height: 16,),
                                                Icon(
                                                  Icons.favorite_outline,
                                                  color: Color(0xff8D8D8D),
                                                  size: 20,
                                                ),
                                                Text(
                                                    " " +
                                                        item['wishlistCount']
                                                            .toString(),
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          color:
                                                              Color(0xFF828282),
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    )),
                                              ]),
                                          Text(item['description'],
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFF989898),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                          Row(
                                            children: [
                                              Text(
                                                  "Rs." +
                                                      item['price'].toString(),
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color:
                                                            Color(0xFF000000),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )),
                                            ],
                                          ),
                                          item['discount'] == 0
                                              ? SizedBox.shrink()
                                              : Row(
                                                  children: [
                                                    Text(
                                                        item['discount'] == 0
                                                            ? ""
                                                            : "Today",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                              color: Color(
                                                                  0xFFF43636),
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        )),
                                                    Expanded(
                                                        child: Text(
                                                            item['discount'] ==
                                                                    0
                                                                ? ""
                                                                : " (Rs. " +
                                                                    item['offerPrice']
                                                                        .toStringAsFixed(2) +
                                                                    ", " +
                                                                    item['discount']
                                                                        .toString() +
                                                                    ' % Off)',
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle: TextStyle(
                                                                  color: Color(
                                                                      0xFFF43636),
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ))),
                                                  ],
                                                ),
                                          Row(children: [
                                            Text(
                                                "Stock: " +
                                                    item['productId']
                                                            ['stockQuantity']
                                                        .toString() +
                                                    " Pieces",
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF188320),
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                          ]),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          orderstatus == "returned" &&
                                                  item['returnDetails']
                                                          ['reason'] !=
                                                      null
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Reason for return",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                              color: Color(
                                                                  0xFF000000),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        )),
                                                    Text(
                                                        item['returnDetails']
                                                            ['reason'],
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                              color: Color(
                                                                  0xFF989898),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        )),
                                                  ],
                                                )
                                              : SizedBox.shrink(),
                                          orderstatus == "returned" &&
                                                  item['returnDetails']
                                                          ['comments'] !=
                                                      null
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Comments for return",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                              color: Color(
                                                                  0xFF000000),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        )),
                                                    Text(
                                                        item['returnDetails']
                                                            ['comments'],
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                              color: Color(
                                                                  0xFF989898),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        )),
                                                  ],
                                                )
                                              : SizedBox.shrink(),
                                          SizedBox(height: 20),
                                          orderstatus == 'delivered' ||
                                                  orderstatus == 'cancelled' ||
                                                  orderstatus == 'returned' ||
                                                  orderstatus ==
                                                      'cancelledbyseller'
                                              ? Column(
                                                  children: [
                                                    Row(children: [
                                                      Text("Order Status",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle: TextStyle(
                                                                color: Color(
                                                                    0xFF000000),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          )),
                                                    ]),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                        height: 50,
                                                        width: double.infinity,
                                                        //padding:EdgeInsets.symmetric(horizontal: 15),
                                                        child: FlatButton(
                                                          textColor:
                                                              Colors.white,
                                                          color:
                                                              Color(0xFFFC4B4B),
                                                          shape: RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                  color: Color(
                                                                      0xFFD2D2D2)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7.0)),
                                                          child: Text(
                                                              orderstatus,
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                textStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFFFFFFFF),
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              )),
                                                          onPressed: () {},
                                                        )),
                                                  ],
                                                )
                                              : Column(
                                                  children: [
                                                    Row(children: [
                                                      Text(
                                                          "Change Order Status",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle: TextStyle(
                                                                color: Color(
                                                                    0xFF000000),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          )),
                                                    ]),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    progress2
                                                        ? Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          )
                                                        : Container(
                                                            height: 50,
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xFFFC4B4B),
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .white,
                                                                width: 1,
                                                              ), //
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        25),
                                                            child:
                                                                new DropdownButton<
                                                                    String>(
                                                              iconEnabledColor:
                                                                  Color(
                                                                      0xFFFFFFFF),
                                                              underline:
                                                                  SizedBox(),
                                                              isExpanded: true,
                                                              hint: new Text(
                                                                  orderstatus,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    textStyle: TextStyle(
                                                                        color: Color(
                                                                            0xFFFFFFFF),
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  )),
                                                              items: ordered
                                                                  .map((String
                                                                      value) {
                                                                return new DropdownMenuItem<
                                                                    String>(
                                                                  value: value,
                                                                  child:
                                                                      new Text(
                                                                    value,
                                                                    style: GoogleFonts.poppins(textStyle:TextStyle(
                                                                        fontSize:
                                                                        12,
                                                                        fontWeight:
                                                                        FontWeight.w500,
                                                                        color: Color(
                                                                            0xFF000000)), )
                                                                  ),
                                                                );
                                                              }).toList(),
                                                              onChanged:
                                                                  (newValue) async {
                                                                setState(() {
                                                                  selectedvalue =
                                                                      newValue;
                                                                  sentData();
                                                                });
                                                                print(
                                                                    selectedvalue);
                                                              },
                                                              value:
                                                                  selectedvalue,
                                                            )),
                                                  ],
                                                ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                //height: 350,
                                //width: 364,
                                child: Card(
                                  elevation: 4.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        colors.isEmpty
                                            ? SizedBox.shrink()
                                            : Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text("Avaliable color",
                                                style:
                                                GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(
                                                          0xFF000000),
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight
                                                          .w600),
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection:
                                              Axis.horizontal,
                                              child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    for (int i = 0;
                                                    i < colors.length;
                                                    i++)
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                              width: 5),
                                                          Container(
                                                            height: 25,
                                                            width: 25,
                                                            decoration: BoxDecoration(
                                                                color: Color(int.parse(
                                                                    colors[i]
                                                                    [
                                                                    'color'])),
                                                                shape: BoxShape
                                                                    .circle),
                                                          ),
                                                          SizedBox(
                                                            width: 30,
                                                          ),
                                                        ],
                                                      ),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("Specification",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                    item['productId'][
                                                    'specification'] !=
                                                        null
                                                        ? item['productId']
                                                    ['specification']
                                                        : "",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          color:
                                                          Color(0xFF464646),
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight.w400),
                                                    ))),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                children: [
                                  Text('Order Details',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 15),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Order Date',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF393939),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400),
                                                )),
                                            Spacer(),
                                            Text(
                                                d1.format(DateTime.parse(
                                                    order['create_date'])),
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF000000),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400),
                                                )),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Order ID',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF393939),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400),
                                                )),
                                            Spacer(),
                                            Text(order['orderID'],
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF000000),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400),
                                                )),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Total Amount',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF393939),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400),
                                                )),
                                            Spacer(),
                                            Text(
                                                '₹ ' +
                                                    fo1.nonSymbol +
                                                    " (" +
                                                    item['quantity'].toString() +
                                                    " Item)",
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF000000),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400),
                                                )),
                                          ],
                                        ),
                                        SizedBox(height: 15)
                                      ],
                                    ),
                                  )),
                            ),
                            SizedBox(height: 5),
                            Divider(
                              height: 20,
                              thickness: 1,
                              indent: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                children: [
                                  Text('Payment Information',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 15),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Payment Method',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF393939),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600),
                                                )),
                                            Spacer(),
                                            Text('HDFC Debit Card',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF000000),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400),
                                                )),
                                          ],
                                        ),
                                        SizedBox(height: 15)
                                      ],
                                    ),
                                  )),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                //height: 350,
                                //width: 364,
                                child: Card(
                                  elevation: 4.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("Shipping Address",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(children: [
                                          Text(
                                              order['deliveryAddress']
                                                      ['firstName'] +
                                                  order['deliveryAddress']
                                                      ['lastName'],
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFF000000),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                        ]),
                                        Row(
                                          children: [
                                            Text(
                                                order['deliveryAddress']
                                                    ['address'],
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF000000),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                                order['deliveryAddress']
                                                        ['city'] +
                                                    ',' +
                                                    order["deliveryAddress"]
                                                        ['state'],
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF000000),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                                order['deliveryAddress']
                                                    ['pincode'],
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF000000),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Text("Contact",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                        Text(order['deliveryAddress']['mobile'],
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 15),
                                        Text('Price Details',
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(item['name'],
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF393939),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400),
                                                )),
                                            Spacer(),
                                            Text('₹ ' + fo1.nonSymbol,
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF000000),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400),
                                                )),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Delivery Fee',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF393939),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400),
                                                )),
                                            Spacer(),
                                            Text(
                                                '₹ ' +
                                                    item['productDeliveryCharge']
                                                        .toStringAsFixed(2),
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF000000),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400),
                                                )),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Tax',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF393939),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400),
                                                )),
                                            Spacer(),
                                            Text(
                                                '₹ ' + item['productTax'].toStringAsFixed(2),
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF000000),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400),
                                                )),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Order Total',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF393939),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400),
                                                )),
                                            Spacer(),
                                            Text('₹ ' + fo2.nonSymbol,
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF474747),
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w600),
                                                )),
                                          ],
                                        ),
                                        SizedBox(height: 15)
                                      ],
                                    ),
                                  )),
                            ),
                            SizedBox(height: 5),
                            // product['productOrderStatus'] == 'cancelled' ||
                            //     product['productOrderStatus'] == 'cancelledbyseller'
                            //     ? SizedBox.shrink()
                            //     :
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  child: FlatButton(
                                    color: Color(0xFFFFFFFF),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(color: Color(0xFFF0F0F0)),
                                        borderRadius: BorderRadius.circular(3.0)),
                                    child: Text('Download Invoice',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Color(0xFF000000),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        )),
                                    onPressed: () {
                                      downloadSinglePdf(widget.productid);
                                    },
                                  )),
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
            ),
    );
  }

  bool progress3 = false;
  void sentData() async {
    setState(() {
      progress3 = true;
    });
    print("hi");
    try {
      String token = await Prefmanager.getToken();
      var url = Prefmanager.baseurl + '/seller/ordered/product/status/change';
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': token
      };

      Map data = {
        'orderid': widget.orderid,
        'productid': widget.productid,
        'productOrderStatus': selectedvalue
      };
      print(data);
      var body = json.encode(data);
      var response = await http.post(url, headers: requestHeaders, body: body);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)['status']) {
          print("updated");
          Navigator.of(context).pop();
        } else {
          print(json.decode(response.body)['msg']);

          // Fluttertoast.showToast(
          //   msg:json.decode(response.body)['msg'],
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.CENTER,
          //
          // );
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } on SocketException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
    progress3 = false;
  }
}
