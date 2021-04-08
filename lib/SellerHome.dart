import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eram_app/AddOffer.dart';
import 'package:eram_app/AddProduct.dart';
import 'package:eram_app/FirstPage.dart';
import 'package:eram_app/SellerBottomBar.dart';
import 'package:eram_app/SellerEachOrderView.dart';
import 'package:eram_app/SellerOfferslist.dart';
import 'package:eram_app/TabController.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:eram_app/SellerProfile.dart';
import 'package:eram_app/StocksPage.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/SellerProductlist.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class SellerHome extends StatefulWidget {
  @override
  _SellerHome createState() => _SellerHome();
}

class _SellerHome extends State<SellerHome> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  static var now = DateTime.now().year;
  static var year1=DateTime.now().year-1;
  static var year2=DateTime.now().year-2;
  static var year3=DateTime.now().year-3;
  static var year4=DateTime.now().year-4;
  static var year5=DateTime.now().year-5;
  List firstYear=[now,year1,year2,year3,year4,year5];
  List secondYear=[now,year1,year2,year3,year4,year5];

  bool clicked = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    await profile();
    await count();
    await recentOrders();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  DateTime currentBackPressedTime;
  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressedTime == null ||
        now.difference(currentBackPressedTime) > Duration(seconds: 2)) {
      currentBackPressedTime = now;
      Fluttertoast.showToast(
          msg: "Press again to exit the app",
          backgroundColor: Colors.black,
          gravity: ToastGravity.BOTTOM);
      return Future.value(false);
    } else
      exit(0);
  }

  final _formKey = GlobalKey<FormState>();
  void initState() {
    super.initState();
    sample();
   print(firstYear);
  }

  Future<void> sample() async {
    selectedvalue = year1.toString();
    selectedvalue1 = now.toString();
    await profile();
    await recentOrders();
    await count();
    await chart();
    await _saveDeviceToken();
    print(now);

  }

  bool progress = true;
  var listprofile, catname;
  var uid;
  var statustype, remarks;

  Future<void> profile() async {
    var url = Prefmanager.baseurl + '/user/me';
    var token = await Prefmanager.getToken();
    print("Profile");
    print(token);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token,
    };
    var response = await http.post(url, headers: requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      statustype = json.decode(response.body)['profileStatus'];
      remarks = json.decode(response.body)['data']['remarks'];
      print(remarks);
      listprofile = json.decode(response.body)['data'];
      uid = json.decode(response.body)['data']['_id'];
      print(uid);
      for (int i = 0;
          i < json.decode(response.body)['data']['sellerid']['category'].length;
          i++) {
        catname = listprofile['sellerid']['category'][i]['name'];
        print(catname);
      }
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['msg'],
      );
    progress = false;
    setState(() {});
  }

  bool progress1 = true;
  List recent = [];
  var pending;
  Future<void> recentOrders() async {
    var url = Prefmanager.baseurl + '/seller/ordered/products/list';
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token,
    };
    Map data = {'filterType': null,'productOrderStatus':'ordered'};
    var body = json.encode(data);
    var response = await http.post(url, headers: requestHeaders, body: body);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      pending = json.decode(response.body)['orderStatusPending'];
      // for (int i = 0; i < json.decode(response.body)['data'].length; i++) {
      //   recent=json.decode(response.body)['data'];
      // }
      recent=json.decode(response.body)['data'];
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['msg'],
      );
    progress1 = false;
    setState(() {});
  }

  bool progress2 = true;
  var c, out, statisticscount;
  Future<void> count() async {
    var url = Prefmanager.baseurl + '/seller/dashboard';
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token,
    };
    var response = await http.post(url, headers: requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      c = json.decode(response.body)['stockCount'];
      statisticscount = json.decode(response.body)['statisticsCount'];
      out = json.decode(response.body)['stockCount']['outofStockProducts'];
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['msg'],
      );
    progress2 = false;
    setState(() {});
  }

  bool progress3 = true;
  var graphvalue;
  var selectedvalue;
  var selectedvalue1;

  Future<void> chart() async {

    var url = Prefmanager.baseurl + '/seller/dashboard/graph';
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token,
    };
    Map data = {
      'year1': selectedvalue.toString(),
      'year2': selectedvalue1.toString()
    };
    print("dashboard");
    print(data);
    var body = json.encode(data);
    var response = await http.post(url, headers: requestHeaders, body: body);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      print("graph");
      graphvalue = json.decode(response.body)['data'];
      print("values");
      print(graphvalue);
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['msg'],
      );
    progress3 = false;
    setState(() {});
  }

  String fcmToken;
  _saveDeviceToken() async {
    fcmToken = await _fcm.getToken();
    print(fcmToken);
  }
  bool progress4=false;
  Future<void> deleteDevice() async {
    setState(() {
      progress4=true;
    });
    var url = Prefmanager.baseurl + '/user/logout';
    var token = await Prefmanager.getToken();
    print("Profile");
    print(token);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    Map data = {'deviceToken': fcmToken};
    print(data);
    var body = json.encode(data);
    var response = await http.post(url, headers: requestHeaders, body: body);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      setState(() {
        progress4=false;
      });
      //Fluttertoast.showToast(msg:json.decode(response.body)['msg'],);
    } else {setState(() {
      progress4=false;
    });}
    //Fluttertoast.showToast(msg:json.decode(response.body)['msg'],);
  }

  // void drawHorizontalBar() {
  //   Map<String, dynamic> options = <String, dynamic>{
  //     'chart': {
  //       'type': 'bar',
  //     },
  //     'plotOptions': {
  //       'bar': {
  //         'horizontal': true,
  //       }
  //     },
  //     'dataLabels': {'enabled': false},
  //     'series': [
  //       {
  //         'data': [400, 430, 448, 470, 540, 580, 690, 1100, 1200, 1380]
  //       }
  //     ],
  //     'xaxis': {
  //       'categories': [
  //         'South Korea',
  //         'Canada',
  //         'United Kingdom',
  //         'Netherlands',
  //         'Italy',
  //         'France',
  //         'Japan',
  //         'United States',
  //         'China',
  //         'Germany'
  //       ],
  //     },
  //     'yaxis': <String, dynamic>{},
  //     'tooltip': <String, dynamic>{}
  //   };
  //   ApexCharts chart = ApexCharts(
  //       '#horizontalBar', options);
  //   chart.render();
  // }
  List<charts.Series<dynamic, String>> _createSampleData() {
    final year1Data = [
      new OrdinalSales('JA', graphvalue[0]['year1_orders'].toDouble()),
      new OrdinalSales('FE', graphvalue[1]['year1_orders'].toDouble()),
      new OrdinalSales('MA', graphvalue[2]['year1_orders'].toDouble()),
      new OrdinalSales('AP', graphvalue[3]['year1_orders'].toDouble()),
      new OrdinalSales('MY', graphvalue[4]['year1_orders'].toDouble()),
      new OrdinalSales('JU', graphvalue[5]['year1_orders'].toDouble()),
      new OrdinalSales('JL', graphvalue[6]['year1_orders'].toDouble()),
      new OrdinalSales('AU', graphvalue[7]['year1_orders'].toDouble()),
      new OrdinalSales('SE', graphvalue[8]['year1_orders'].toDouble()),
      new OrdinalSales('OC', graphvalue[9]['year1_orders'].toDouble()),
      new OrdinalSales('NO', graphvalue[10]['year1_orders'].toDouble()),
      new OrdinalSales('DE', graphvalue[11]['year1_orders'].toDouble()),
    ];

    final year2Data = [
      new OrdinalSales('JA', graphvalue[0]['year2_orders'].toDouble()),
      new OrdinalSales('FE', graphvalue[1]['year2_orders'].toDouble()),
      new OrdinalSales('MA', graphvalue[2]['year2_orders'].toDouble()),
      new OrdinalSales('AP', graphvalue[3]['year2_orders'].toDouble()),
      new OrdinalSales('MY', graphvalue[4]['year2_orders'].toDouble()),
      new OrdinalSales('JU', graphvalue[5]['year2_orders'].toDouble()),
      new OrdinalSales('JL', graphvalue[6]['year2_orders'].toDouble()),
      new OrdinalSales('AU', graphvalue[7]['year2_orders'].toDouble()),
      new OrdinalSales('SE', graphvalue[8]['year2_orders'].toDouble()),
      new OrdinalSales('OC', graphvalue[9]['year2_orders'].toDouble()),
      new OrdinalSales('NO', graphvalue[10]['year2_orders'].toDouble()),
      new OrdinalSales('DE', graphvalue[11]['year2_orders'].toDouble()),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Year1',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: year1Data,
        colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
        fillColorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
        labelAccessorFn: (OrdinalSales sales, _) => (sales.sales).toString(),
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Year2',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: year2Data,
        colorFn: (_, __) => charts.MaterialPalette.indigo.shadeDefault,
        fillColorFn: (_, __) => charts.MaterialPalette.indigo.shadeDefault,
        labelAccessorFn: (OrdinalSales sales, _) => (sales.sales).toString(),
      ),
    ];
  }

  /// Sample time series data type.

  @override
  Widget build(BuildContext context) {
    List f = [];
    FlutterMoneyFormatter fmf;
    MoneyFormatterOutput fo;
    for (int i = 0; i < recent.length; i++) {
      fmf = FlutterMoneyFormatter(amount: recent[i]['productTotalAmount'].toDouble());
      fo = fmf.output;
      f.add(fo);
      print(fo.nonSymbol);
    }
    // void displayBottomSheet(var value) {
    //   showModalBottomSheet(
    //       context: context,
    //       builder: (ctx) {
    //         return Container(
    //           height:MediaQuery.of(context).size.height/2,
    //           child: Padding(
    //             padding: const EdgeInsets.symmetric(horizontal:20.0),
    //             child: Center(
    //               child: Column(
    //                   children: [
    //                     SizedBox(height:10),
    //                     Row(
    //                       children: [
    //                         Text(selectedvalue),
    //                         Text(value.first.datum.sales.toString()),
    //                       ],
    //                     ),
    //                     SizedBox(height:10),
    //                     Container(
    //                         height: 50,
    //                         width:MediaQuery.of(context).size.width,
    //                         // padding:EdgeInsets.symmetric(horizontal: 15),
    //                         child: FlatButton(
    //                           textColor: Colors.white,
    //                           color: Color(0xFFFC4B4B),
    //                           shape: RoundedRectangleBorder(
    //                               side: BorderSide(color: Color(0xFFD2D2D2)),
    //                               borderRadius: BorderRadius.circular(7.0)),
    //                           child: Text('Submit',style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.white,fontSize:10,fontWeight: FontWeight.w700),)),
    //                           onPressed: () {
    //                             if (_formKey.currentState.validate()) {
    //                               _formKey.currentState.save();
    //                               //addSinglePhoto();
    //                             }
    //
    //                           },
    //                         )),
    //
    //                   ]),
    //             ),
    //           ),
    //         );
    //       });
    // }

    // Widget graphValue(){
    //
    // }
    Widget sellerInfo() {
      return Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                        Icon(Icons.add, size: 20, color: Color(0xFF29D089)),
                        Text('  Add new Product',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600),
                            )),
                      ],
                    ),
                    onPressed: () async {

                      await Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => AddProduct()));
                      //Navigator.push(context, new MaterialPageRoute(builder: (context) => SellerworkHour()));
                      await count();
                    }

                    ),
              ),
            ),
            SizedBox(height:10),
            //progress2 ? Center(child: CircularProgressIndicator(),)
            progress2?Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Container(
                height: 50,
                width: 20,
                decoration:
                BoxDecoration(
                  color:Colors.white,
                  shape: BoxShape
                      .circle,
                ),
              ),
            )
            :c['allProducts']>0?
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                        Icon(Icons.add, size: 20, color: Color(0xFF29D089)),
                        Text('  Add offer',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600),
                            )),
                      ],
                    ),
                    onPressed: () async {

                      await Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => AddOffer()));

                    }

                ),
              ),
            ):SizedBox.shrink(),
            //progress2 ? Center(child: CircularProgressIndicator(),)
            progress2?Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Container(
                height: 50,
                width: 20,
                decoration:
                BoxDecoration(
                  color:Colors.white,
                  shape: BoxShape
                      .circle,
                ),
              ),
            )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Color(0xFFFFFFFF),
                                      border:
                                          Border.all(color: Color(0xFFF0F0F0))),
                                  margin: EdgeInsets.all(3),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1.0, horizontal: 10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5),
                                        Image(
                                          image: AssetImage('assets/store.png'),
                                          width: 30,
                                          height: 30,
                                        ),
                                        SizedBox(height: 10),
                                        Text("Daily Visitors",
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 8,
                                                    color: Color(0xFF959595)))),
                                        Row(
                                          children: [
                                            Text(
                                                statisticscount['dailyVisitors']
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 14,
                                                        color: Color(
                                                            0xFF000000)))),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            int.parse(statisticscount[
                                                            'dailyVisitors_percent']
                                                        .toString()) >=
                                                    0
                                                ? Icon(
                                                    Icons.arrow_upward,
                                                    size: 10,
                                                    color: Color(0xFF3DC131),
                                                  )
                                                : Icon(
                                                    Icons.arrow_downward,
                                                    size: 10,
                                                    color: Color(0xFFFC4B4B),
                                                  ),
                                            SizedBox(width: 5),
                                            Text(
                                                (statisticscount[
                                                                'dailyVisitors_percent']
                                                            .abs())
                                                        .toString() +
                                                    "%",
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 10,
                                                        color: int.parse(statisticscount[
                                                                        'dailyVisitors_percent']
                                                                    .toString()) >=
                                                                0
                                                            ? Color(0xFF3DC131)
                                                            : Color(
                                                                0xFFFC4B4B)))),
                                          ],
                                        ),

                                        // SizedBox(
                                        //     height:5
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Color(0xFFFFFFFF),
                                      border:
                                          Border.all(color: Color(0xFFF0F0F0))),
                                  margin: EdgeInsets.all(3),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1.0, horizontal: 10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5),
                                        Image(
                                          image:
                                              AssetImage('assets/basket1.png'),
                                          width: 30,
                                          height: 30,
                                        ),
                                        SizedBox(height: 10),
                                        Text("This Month Orders",
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 8,
                                                    color: Color(0xFF959595)))),
                                        Row(
                                          children: [
                                            Text(
                                                statisticscount[
                                                        'thisMonthOrders']
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 14,
                                                        color: Color(
                                                            0xFF000000)))),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            int.parse(statisticscount[
                                                            'thisMonthOrders_percent']
                                                        .toString()) >=
                                                    0
                                                ? Icon(
                                                    Icons.arrow_upward,
                                                    size: 10,
                                                    color: Color(0xFF3DC131),
                                                  )
                                                : Icon(
                                                    Icons.arrow_downward,
                                                    size: 10,
                                                    color: Color(0xFFFC4B4B),
                                                  ),
                                            SizedBox(width: 5),
                                            Text(
                                                (statisticscount[
                                                                'thisMonthOrders_percent']
                                                            .abs())
                                                        .toString() +
                                                    "%",
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 10,
                                                  color: int.parse(statisticscount[
                                                                  'thisMonthOrders_percent']
                                                              .toString()) >=
                                                          0
                                                      ? Color(0xFF3DC131)
                                                      : Color(0xFFFC4B4B),
                                                ))),
                                          ],
                                        ),

                                        // SizedBox(
                                        //     height:5
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Color(0xFFFFFFFF),
                                      border:
                                          Border.all(color: Color(0xFFF0F0F0))),
                                  margin: EdgeInsets.all(3),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1.0, horizontal: 10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5),
                                        Image(
                                          image:
                                              AssetImage('assets/basket2.png'),
                                          width: 30,
                                          height: 30,
                                        ),
                                        SizedBox(height: 10),
                                        Text("Avg. Order / Day",
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 8,
                                                    color: Color(0xFF959595)))),
                                        Row(
                                          children: [
                                            Text(
                                                statisticscount['averageOrders']
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 14,
                                                        color: Color(
                                                            0xFF000000)))),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            int.parse(statisticscount[
                                                            'averageOrders_percent']
                                                        .toString()) >=
                                                    0
                                                ? Icon(
                                                    Icons.arrow_upward,
                                                    size: 10,
                                                    color: Color(0xFF3DC131),
                                                  )
                                                : Icon(
                                                    Icons.arrow_downward,
                                                    size: 10,
                                                    color: Color(0xFFFC4B4B),
                                                  ),
                                            SizedBox(width: 5),
                                            Text(
                                                (statisticscount[
                                                                'averageOrders_percent']
                                                            .abs())
                                                        .toString() +
                                                    "%",
                                                style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 10,
                                                        color: int.parse(statisticscount[
                                                                        'averageOrders_percent']
                                                                    .toString()) >=
                                                                0
                                                            ? Color(0xFF3DC131)
                                                            : Color(
                                                                0xFFFC4B4B)))),
                                          ],
                                        ),

                                        // SizedBox(
                                        //     height:5
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 50,
                    //height: MediaQuery.of(context).size.width/6,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        // color: Colors.white,
                        color: Color(0xFFFCB912)),
                    margin: EdgeInsets.all(4),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 80),
                          Image(
                            image: AssetImage('assets/monitor1.png'),
                            width: 35,
                            height: 35,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    SizedBox(width: 6),
                                    Text(catname,
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 11,
                                                color: Color(0xFFFFFFFF)))),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 6),
                                    Text("View All Products",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10,
                                                color: Color(0xFFFFFFFF)))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () async {
                    await Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new SellerProductlist()));
                    await count();
                  },
                ),
              ]),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("   Recent Orders",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(pending.toString() + " Order Status Pending",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Color(0xFFCE1616),
                                fontSize: 11,
                                fontWeight: FontWeight.w600),
                          )),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 10),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Color(0xFFD6D6D6), width: 1)),
                    height: 45,
                    minWidth: MediaQuery.of(context).size.width - 60,
                    child: Text('View All Orders',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 11,
                              fontWeight: FontWeight.w500),
                        )),
                    textColor: Color(0xFF000000),
                    onPressed: () async{
                      await Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new TabBarDemo(
                                  listprofile['sellerid']["photo"])));
                      await recentOrders();
                    },
                  ),
                ),
              ]),
            ),
            SizedBox(
              height: 5,
            ),
            recent.isEmpty
                ? Center(
                    child: Text("No recent orders",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        )))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: List.generate(
                          recent.length > 3 ? 3 : recent.length, (index) {
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
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image(
                                              image: recent[index]['productId']
                                                              ['photos'] ==
                                                          null ||
                                                      recent[index]['productId']
                                                              ['photos']
                                                          .isEmpty
                                                  ? NetworkImage(Prefmanager
                                                          .baseurl +
                                                      "/file/get/noimage.jpg")
                                                  : NetworkImage(Prefmanager
                                                          .baseurl +
                                                      "/file/get/" +
                                                      recent[index]['productId']
                                                          ['photos'][0]),
                                              height: 75,
                                              width: 95,
                                              fit: BoxFit.fill),
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(children: [
                                              SizedBox(height: 7),
                                              Row(
                                                children: [
                                                  Text(recent[index]['name'],
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            color: Color(
                                                                0xFF808080),
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      )),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 1,
                                              ),
                                              Row(children: [
                                                Text("Price: ₹ " + f[index].nonSymbol,
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          color:
                                                              Color(0xFF000000),
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    )),
                                              ]),
                                              // SizedBox(
                                              //   height:5,
                                              // ),

                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(children: [
                                                Text(
                                                    "Qty: " +
                                                        recent[index]
                                                                [
                                                                'quantity']
                                                            .toString() +
                                                        " Pieces",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          color:
                                                              Color(0xFF188320),
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    )),
                                                Spacer(),
                                                Text(
                                                    timeago.format(
                                                      DateTime.now().subtract(new Duration(
                                                          minutes: DateTime
                                                                  .now()
                                                              .difference(DateTime
                                                                  .parse(recent[
                                                                          index]
                                                                      [
                                                                      'order_date']))
                                                              .inMinutes)),
                                                    ),
                                                    style: GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            color: Color(
                                                                0xFF000000),
                                                            fontSize: 9,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300))),
                                              ]),
                                              // SizedBox(
                                              //   height:50
                                              // ),
                                            ]),
                                          )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 20,
                                  thickness: 1,
                                  indent: 1,
                                ),
                              ],
                            ),
                            onTap: ()async {
                              await Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          new SellerEachOrderview(recent[index]['_id'],recent[index]['order_id'])));
                              await recentOrders();
                            });
                      }),
                    ),
                  ),
            SizedBox(height: 20),
            Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      20.0,
                    ),
                    topRight: Radius.circular(
                      20.0,
                    )),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300].withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 4,
                    offset: Offset(2, 5), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Image(
                            image: AssetImage('assets/basket1.png'),
                            width: 30,
                            height: 25),
                        SizedBox(width: 5),
                        Text("Stocks",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            )),
                      ],
                    ),
                    SizedBox(height: 10),
                    //progress2 ? Center(child: CircularProgressIndicator(),)
                    progress2?Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: Container(
                        height: 50,
                        width: 20,
                        decoration:
                        BoxDecoration(
                          color:Colors.white,
                          shape: BoxShape
                              .circle,
                        ),
                      ),
                    )
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.4,
                                      //height: MediaQuery.of(context).size.width/4,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: Color(0xFFFFFFFF),
                                          border: Border.all(
                                              color: Color(0xFFF0F0F0))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 20),
                                          Row(
                                            //mainAxisAlignment:MainAxisAlignment.center,
                                            children: [
                                              Spacer(),
                                              Image(
                                                  image: AssetImage(
                                                      'assets/basket1.png'),
                                                  width: 20,
                                                  height: 20),
                                              Spacer(),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  c['outofStockProducts']
                                                          .toString() +
                                                      " Products",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color:
                                                            Color(0xFF000000),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("Out of Stock",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color:
                                                            Color(0xFFD62F2F),
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  )),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),

                                          // Image(image:AssetImage('assets/basket1.png'),width:20,height:18), Spacer(),
                                          //Image(image:AssetImage('assets/basket1.png'),width:20,height:18),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) => StocksPage(
                                                  'Out of Stock', uid)));
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  InkWell(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.4,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: Color(0xFFFFFFFF),
                                          border: Border.all(
                                              color: Color(0xFFF0F0F0))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 20),
                                          Row(
                                            //mainAxisAlignment:MainAxisAlignment.center,
                                            children: [
                                              Spacer(),
                                              Image(
                                                  image: AssetImage(
                                                      'assets/basket1.png'),
                                                  width: 20,
                                                  height: 20),
                                              Spacer(),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  c['limitedStockProducts']
                                                          .toString() +
                                                      " Products",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color:
                                                            Color(0xFF000000),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("Limited Stock",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color:
                                                            Color(0xFF127EFC),
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  )),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),

                                          // Image(image:AssetImage('assets/basket1.png'),width:20,height:18), Spacer(),
                                          //Image(image:AssetImage('assets/basket1.png'),width:20,height:18),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) => StocksPage(
                                                  'Limited Stock', uid)));
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    child: Container(
                                      // width:MediaQuery.of(context).size.width/2.5,
                                      width: MediaQuery.of(context).size.width /
                                          2.4,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: Color(0xFFFFFFFF),
                                          border: Border.all(
                                              color: Color(0xFFF0F0F0))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 20),
                                          Row(
                                            //mainAxisAlignment:MainAxisAlignment.center,
                                            children: [
                                              Spacer(),
                                              Image(
                                                  image: AssetImage(
                                                      'assets/basket1.png'),
                                                  width: 20,
                                                  height: 20),
                                              Spacer(),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  c['bestSellingProducts']
                                                          .toString() +
                                                      " Products",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color:
                                                            Color(0xFF000000),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("Best Selling",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color:
                                                            Color(0xFFFCB912),
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  )),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),

                                          // Image(image:AssetImage('assets/basket1.png'),width:20,height:18), Spacer(),
                                          //Image(image:AssetImage('assets/basket1.png'),width:20,height:18),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) => StocksPage(
                                                  'Best Selling', uid)));
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  InkWell(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.4,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: Color(0xFFFFFFFF),
                                          border: Border.all(
                                              color: Color(0xFFF0F0F0))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 20),
                                          Row(
                                            //mainAxisAlignment:MainAxisAlignment.center,
                                            children: [
                                              Spacer(),
                                              Image(
                                                  image: AssetImage(
                                                      'assets/basket1.png'),
                                                  width: 20,
                                                  height: 20),
                                              Spacer(),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  c['allProducts'].toString() +
                                                      " Products",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color:
                                                            Color(0xFF000000),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("All Products",
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color:
                                                            Color(0xFF29D089),
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  )),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),

                                          // Image(image:AssetImage('assets/basket1.png'),width:20,height:18), Spacer(),
                                          //Image(image:AssetImage('assets/basket1.png'),width:20,height:18),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) => StocksPage(
                                                  'All Products', uid)));
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            if (progress3)
              Center(
                child: CircularProgressIndicator(),
              )
            else
              Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        20.0,
                      ),
                      topRight: Radius.circular(
                        20.0,
                      )),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300].withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 4,
                      offset: Offset(2, 5), // changes position of shadow
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height / 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Image(
                              image: AssetImage('assets/basket1.png'),
                              width: 30,
                              height: 30),
                          SizedBox(
                            width: 3,
                          ),
                          Text("Sales Statistics",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              )),
                          SizedBox(
                            width: 25,
                          ),
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                alignment: Alignment.center,
                                height: 50,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xFFF0F0F0))),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      new DropdownButton<String>(
                                        underline: SizedBox(),
                                        isExpanded: true,
                                        hint: new Text(
                                          year1.toString(),
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF6E6E6E)),
                                        ),
                                        // items: <String>[
                                        //   '2020',
                                        //   '2021',
                                        //   '2022',
                                        //   '2023',
                                        //   '2024',
                                        //   '2025',
                                        //   '2026',
                                        //   '2027',
                                        //   '2028',
                                        //   '2029',
                                        //   '2030'
                                        // ].map((String value) {
      items:firstYear.map((value){
                                          return new DropdownMenuItem<String>(
                                            value: value.toString(),
                                            child: new Text(
                                              value.toString(),
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF6E6E6E)),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) async {
                                          setState(() {
                                            selectedvalue = newValue;
                                          });
                                          await chart();
                                          print(selectedvalue);
                                        },
                                        value: selectedvalue,
                                      ),
                                    ])),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                height: 50,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xFFF0F0F0))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    new DropdownButton<String>(
                                      isExpanded: true,
                                      underline: SizedBox(),
                                      hint: new Text(
                                        now.toString(),
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      // items:<String>[
                                      //   '2020',
                                      //   '2021',
                                      //   '2022',
                                      //   '2023',
                                      //   '2024',
                                      //   '2025',
                                      //   '2026',
                                      //   '2027',
                                      //   '2028',
                                      //   '2029',
                                      //   '2030'
                                      // ].map((String value){
                                      items:secondYear.map((value){
                                        return new DropdownMenuItem<String>(
                                          value: value.toString(),
                                          child: new Text(
                                            value.toString(),
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF2D42DD)),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) async {
                                        setState(() {
                                          selectedvalue1 = newValue;
                                        });
                                        await chart();
                                        print(selectedvalue1);
                                      },
                                      value: selectedvalue1,
                                    ),
                                  ],
                                )),
                          ),
                        ]),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: EdgeInsets.all(0.5),
                          height: 250,
                          width: MediaQuery.of(context).size.height,
                          child: new charts.BarChart(
                            _createSampleData(),
                            defaultRenderer: new charts.BarRendererConfig(
                              strokeWidthPx: 1,
                              groupingType: charts.BarGroupingType.grouped,
                            ),
                            selectionModels: [
                              new charts.SelectionModelConfig(
                                type: charts.SelectionModelType.info,
                                changedListener: (model) {
                                  final selectedDatum = model.selectedDatum;
                                  //displayBottomSheet(selectedDatum);
                                  print(selectedDatum.first.datum.sales);
                                },
                              )
                            ],
                            barRendererDecorator:
                                new charts.BarLabelDecorator<String>(),
                            domainAxis: new charts.OrdinalAxisSpec(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ]);
    }

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            backgroundColor: Color(0xFFFFFFFF),
            appBar: AppBar(
              title: Text("Seller Analytics",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  )),
              actions: [
                //progress ? Center(child: CircularProgressIndicator(strokeWidth:0.0,backgroundColor: Colors.white,))
                  progress?Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                   child: Container(
                      height: 50,
                      width: 20,
                      decoration:
                      BoxDecoration(
                        color:Colors.white,
                        shape: BoxShape
                            .circle,
                      ),
                    ),
                  )
                    : Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: InkWell(
                          child: Image(
                            image: NetworkImage(Prefmanager.baseurl +
                                "/file/get/" +
                                listprofile['sellerid']["photo"]),
                            width: 30,
                            height: 30,
                          ),
                          onTap: () async {
                            await Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => SellerProfile(uid,
                                        listprofile['sellerid']['shopName'])));
                            await profile();
                          },
                        ),
                      )
              ],
            ),
            drawer: Drawer(
                child: ListView(
                    // Important: Remove any padding from the ListView.
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      progress?Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: Container(
                          height: 50,
                          width: 20,
                          decoration:
                          BoxDecoration(
                            color:Colors.white,
                            shape: BoxShape
                                .circle,
                          ),
                        ),
                      )
                      : Container(
                          color: Colors.red,
                          child: DrawerHeader(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 40.0,
                                          backgroundColor: Colors.blue,
                                          backgroundImage: NetworkImage(
                                              Prefmanager.baseurl +
                                                  "/file/get/" +
                                                  listprofile['sellerid']
                                                      ["photo"]),
                                        ),
                                      ]),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: new EdgeInsets.all(10.0),
                                        child: Text(
                                          listprofile['sellerid']['shopName'],
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        ),
                  ListTile(
                    leading: Icon(
                      Icons.home,
                      color: Colors.black,
                    ),
                    title: Text('Home',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        )),
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new SellerBottomBar()));
                      //Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.supervised_user_circle,
                      color: Colors.black,
                    ),
                    title: Text('Your Account',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        )),
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new SellerProfile(
                                  uid, listprofile['sellerid']['shopName'])));
                    },
                  ),
                      if(statustype=='active')
                      ListTile(
                        leading: Icon(
                          Icons.supervised_user_circle,
                          color: Colors.black,
                        ),
                        title: Text('Your Offers',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            )),
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new SellerOfferslist()));
                        },
                      ),
                      progress4?Center(child:CircularProgressIndicator(),):
                  ListTile(
                    leading: Icon(
                      Icons.supervised_user_circle,
                      color: Colors.black,
                    ),
                    title: Text('Logout',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        )),
                    onTap: () async{
                      await deleteDevice();
                      await Prefmanager.clear();
                      await Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new FirstPage()));
                    },
                  ),
                ])),
            body: //progress ? Center(child: CircularProgressIndicator())
            progress?SingleChildScrollView(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  //enabled: progress,
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SizedBox(height:10),
                        Row(
                            mainAxisAlignment:MainAxisAlignment.start,
                          children: [
                            Container(height:10,width:70,color:Colors.white),
                          ],
                        ),
                        SizedBox(height:10),
                        Row(
                            mainAxisAlignment:MainAxisAlignment.start,
                          children: [
                            Container(height:10,width:70,color:Colors.white),
                          ],
                        ),
                        SizedBox(height:10),
                        Container(
                            width: double.infinity,
                            height: 50.0,
                            color:Colors.white
                        ),
                        SizedBox(height:10),
                        Container(
                            width: double.infinity,
                            height: 50.0,
                            color:Colors.white
                        ),
                        SizedBox(height:10),
                        Container(height:150,width:double.infinity,color:Colors.white),
                        SizedBox(height:10),
                        Container(height:50,width:double.infinity,color:Colors.white),
                        SizedBox(height:10),
                        Container(height:200,width:double.infinity,color:Colors.white),
                        SizedBox(height:10),
                        Container(height:150,width:double.infinity,color:Colors.white),
                        SizedBox(height:10),
                      ]),
                ))
                : SmartRefresher(
                    enablePullDown: true,
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    //onLoading: _onLoading,
                    // child: ListView.builder(
                    //   itemBuilder: (c, i) => Card(child: Center(child: Text(items[i]))),
                    //   itemExtent: 100.0,
                    //   itemCount: items.length,
                    // ),
                    child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            listprofile['sellerid']['shopName'],
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFF000000),
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600))),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(listprofile['sellerid']['place'],
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFF898989),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400))),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              Stack(
                                children: [
                                  statustype == 'active'
                                      ? sellerInfo()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey[100]
                                                            .withOpacity(0.5),
                                                        spreadRadius: 5,
                                                        blurRadius: 4,
                                                        offset: Offset(2,
                                                            5), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: FlatButton(
                                                    height: 50,
                                                    minWidth:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    color: Color(0xFFFFFFFF),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        side: BorderSide(
                                                            color: Color(
                                                                0xFFE8E8E8))),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons.add,
                                                            size: 20,
                                                            color: Color(
                                                                0xFF29D089)),
                                                        Text(
                                                            '  Add new Product',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle: TextStyle(
                                                                  color: Color(
                                                                      0xFF000000),
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            )),
                                                      ],
                                                    ),
                                                    onPressed: () {
                                                      // setState(() {
                                                      //   Navigator.push(context, new MaterialPageRoute(builder: (context) => AddProduct()));
                                                      //   //Navigator.push(context, new MaterialPageRoute(builder: (context) => SellerInformation()));
                                                      //   //Navigator.push(context, new MaterialPageRoute(builder: (context) => TabBarDemo()));
                                                      // });
                                                    },
                                                  ),
                                                ),
                                              ),

                                            progress2?Shimmer.fromColors(
                                              baseColor: Colors.grey[300],
                                              highlightColor: Colors.grey[100],
                                              child: Container(
                                                height: 50,
                                                width: 20,
                                                decoration:
                                                BoxDecoration(
                                                  color:Colors.white,
                                                  shape: BoxShape
                                                      .circle,
                                                ),
                                              ),
                                            )
                                                  :
                                                  //     Padding(
                                                  //       padding: const EdgeInsets.symmetric(horizontal:20.0,vertical:10),
                                                  //       child: Column(
                                                  //           children: [
                                                  //             Container(
                                                  //               height: MediaQuery.of(context).size.height/6,
                                                  //               child: Row(
                                                  //                 mainAxisAlignment: MainAxisAlignment.start,
                                                  //                 children: [
                                                  //                   Container(
                                                  //                     width:MediaQuery.of(context).size.width/3.5,
                                                  //                     height:MediaQuery.of(context).size.width,
                                                  //                     decoration: BoxDecoration(
                                                  //                         borderRadius: BorderRadius.circular(8.0),
                                                  //                         color:Color(0xFFFFFFFF) ,
                                                  //                         border: Border.all(color: Color(0xFFF0F0F0))
                                                  //
                                                  //                     ),
                                                  //
                                                  //                     margin: EdgeInsets.all(3),
                                                  //                     child: Padding(
                                                  //                       padding:EdgeInsets.symmetric(vertical:1.0,horizontal:10.0),
                                                  //                       child: Column(
                                                  //                         mainAxisAlignment: MainAxisAlignment.start,
                                                  //                         crossAxisAlignment: CrossAxisAlignment.start,
                                                  //                         children: [
                                                  //                           SizedBox(
                                                  //                             height:10
                                                  //                           ),
                                                  //                           Image(image:AssetImage('assets/store.png'),width:30,height: 30,),
                                                  //                           SizedBox(
                                                  //                               height:5
                                                  //                           ),
                                                  //                           Text("Daily Visitors",style:GoogleFonts.poppins(textStyle:TextStyle(fontWeight:FontWeight.w600,fontSize:8,color:Color(0xFF959595)))),
                                                  //                           Row(
                                                  //                             children: [
                                                  //                               Text(statisticscount['dailyVisitors'].toString(),style:GoogleFonts.poppins(textStyle:TextStyle(fontWeight:FontWeight.w700,fontSize:14,color:Color(0xFF000000)))),
                                                  //                             ],
                                                  //                           ),
                                                  //                             Row(
                                                  //                               children: [
                                                  //                                 int.parse(statisticscount['dailyVisitors_percent'].toString())>=0?Icon(Icons.arrow_upward,size: 10,color: Color(0xFF3DC131),):Icon(Icons.arrow_downward,size: 10,color: Color(0xFFFC4B4B),),
                                                  //                                 SizedBox(width:5),Text(statisticscount['dailyVisitors_percent'].toString()+"%",style:GoogleFonts.poppins(textStyle:TextStyle(fontWeight:FontWeight.w700,fontSize:10,color: int.parse(statisticscount['dailyVisitors_percent'].toString())>=0?Color(0xFF3DC131):Color(0xFFFC4B4B)))),
                                                  //                               ],
                                                  //                             ),
                                                  //
                                                  //                           // SizedBox(
                                                  //                           //     height:5
                                                  //                           // ),
                                                  //
                                                  //                         ],
                                                  //                       ),
                                                  //                     ),
                                                  //                   ),
                                                  //                   Container(
                                                  //                     width:MediaQuery.of(context).size.width/3.5,
                                                  //                     height:MediaQuery.of(context).size.width,
                                                  //                     decoration: BoxDecoration(
                                                  //                         borderRadius: BorderRadius.circular(8.0),
                                                  //                         color:Color(0xFFFFFFFF) ,
                                                  //                         border: Border.all(color: Color(0xFFF0F0F0))
                                                  //                     ),
                                                  //                     margin: EdgeInsets.all(3),
                                                  //                     child: Padding(
                                                  //                       padding:EdgeInsets.symmetric(vertical:1.0,horizontal:10.0),
                                                  //                       child: Column(
                                                  //                         mainAxisAlignment: MainAxisAlignment.start,
                                                  //                         crossAxisAlignment: CrossAxisAlignment.start,
                                                  //                         children: [
                                                  //                           Image(image:AssetImage('assets/basket1.png'),width:30,height: 30,),
                                                  //                           SizedBox(
                                                  //                               height:5
                                                  //                           ),
                                                  //                           Text("This Month Orders",style:GoogleFonts.poppins(textStyle:TextStyle(fontWeight:FontWeight.w600,fontSize:8,color:Color(0xFF959595)))),
                                                  //                           Row(
                                                  //                             children: [
                                                  //                               Text(statisticscount['thisMonthOrders'].toString(),style:GoogleFonts.poppins(textStyle:TextStyle(fontWeight:FontWeight.w700,fontSize:14,color:Color(0xFF000000)))),
                                                  //                             ],
                                                  //                           ),
                                                  //                           Row(
                                                  //                             children: [
                                                  //                               int.parse(statisticscount['thisMonthOrders_percent'].toString())>=0?Icon(Icons.arrow_upward,size: 10,color: Color(0xFF3DC131),):Icon(Icons.arrow_downward,size: 10,color: Color(0xFFFC4B4B),),
                                                  //                               SizedBox(width:5),Text(statisticscount['thisMonthOrders_percent'].toString()+"%",style:GoogleFonts.poppins(textStyle:TextStyle(fontWeight:FontWeight.w700,fontSize:10,color: int.parse(statisticscount['thisMonthOrders_percent'].toString())>=0?Color(0xFF3DC131):Color(0xFFFC4B4B),))),
                                                  //                             ],
                                                  //                           ),
                                                  //
                                                  //
                                                  //                           // SizedBox(
                                                  //                           //     height:5
                                                  //                           // ),
                                                  //
                                                  //                         ],
                                                  //                       ),
                                                  //                     ),
                                                  //                   ),
                                                  //                   Container(
                                                  //                     width:MediaQuery.of(context).size.width/3.5,
                                                  //                     height:MediaQuery.of(context).size.width,
                                                  //                     decoration: BoxDecoration(
                                                  //                         borderRadius: BorderRadius.circular(8.0),
                                                  //                         color:Color(0xFFFFFFFF) ,
                                                  //                         border: Border.all(color: Color(0xFFF0F0F0))
                                                  //                     ),
                                                  //                     margin: EdgeInsets.all(3),
                                                  //                     child: Padding(
                                                  //                       padding:EdgeInsets.symmetric(vertical:1.0,horizontal:10.0),
                                                  //                       child: Column(
                                                  //                         mainAxisAlignment: MainAxisAlignment.start,
                                                  //                         crossAxisAlignment: CrossAxisAlignment.start,
                                                  //                         children: [
                                                  //                           SizedBox(
                                                  //                               height:5
                                                  //                           ),
                                                  //                           Image(image:AssetImage('assets/basket2.png'),width:30,height: 30,),
                                                  //                           SizedBox(
                                                  //                               height:10
                                                  //                           ),
                                                  //                           Text("Avg. Order / Day",style:GoogleFonts.poppins(textStyle:TextStyle(fontWeight:FontWeight.w600,fontSize:8,color:Color(0xFF959595)))),
                                                  //                           Row(
                                                  //                             children: [
                                                  //                               Text(statisticscount['averageOrders'].toString(),style:GoogleFonts.poppins(textStyle:TextStyle(fontWeight:FontWeight.w700,fontSize:14,color:Color(0xFF000000)))),
                                                  //                             ],
                                                  //                           ),
                                                  //                           Row(
                                                  //                             children: [
                                                  //                               int.parse(statisticscount['averageOrders_percent'].toString())>=0?Icon(Icons.arrow_upward,size: 10,color: Color(0xFF3DC131),):Icon(Icons.arrow_downward,size: 10,color: Color(0xFFFC4B4B),),
                                                  //                               SizedBox(width:5),Text(statisticscount['averageOrders_percent'].toString()+"%",style:GoogleFonts.poppins(textStyle:TextStyle(fontWeight:FontWeight.w700,fontSize:10,color:int.parse(statisticscount['averageOrders_percent'].toString())>=0?Color(0xFF3DC131):Color(0xFFFC4B4B)))),
                                                  //                             ],
                                                  //                           ),
                                                  //
                                                  //
                                                  //                           // SizedBox(
                                                  //                           //     height:5
                                                  //                           // ),
                                                  //
                                                  //                         ],
                                                  //                       ),
                                                  //                     ),
                                                  //                   ),
                                                  //                 ],
                                                  //               ),
                                                  //             ),
                                                  //   ],
                                                  // ),
                                                  //     ),
                                                  Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20,
                                                          vertical: 10),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                6,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                8.0),
                                                                        color: Color(
                                                                            0xFFFFFFFF),
                                                                        border: Border.all(
                                                                            color:
                                                                                Color(0xFFF0F0F0))),
                                                                    margin: EdgeInsets
                                                                        .all(3),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              1.0,
                                                                          horizontal:
                                                                              10.0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                              height: 5),
                                                                          Image(
                                                                            image:
                                                                                AssetImage('assets/store.png'),
                                                                            width:
                                                                                30,
                                                                            height:
                                                                                30,
                                                                          ),
                                                                          SizedBox(
                                                                              height: 10),
                                                                          Text(
                                                                              "Daily Visitors",
                                                                              style: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 8, color: Color(0xFF959595)))),
                                                                          Row(
                                                                            children: [
                                                                              Text(statisticscount['dailyVisitors'].toString(), style: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF000000)))),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              int.parse(statisticscount['dailyVisitors_percent'].toString()) >= 0
                                                                                  ? Icon(
                                                                                      Icons.arrow_upward,
                                                                                      size: 10,
                                                                                      color: Color(0xFF3DC131),
                                                                                    )
                                                                                  : Icon(
                                                                                      Icons.arrow_downward,
                                                                                      size: 10,
                                                                                      color: Color(0xFFFC4B4B),
                                                                                    ),
                                                                              SizedBox(width: 5),
                                                                              Text((statisticscount['dailyVisitors_percent'].abs()).toString() + "%", style: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 10, color: int.parse(statisticscount['dailyVisitors_percent'].toString()) >= 0 ? Color(0xFF3DC131) : Color(0xFFFC4B4B)))),
                                                                            ],
                                                                          ),

                                                                          // SizedBox(
                                                                          //     height:5
                                                                          // ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                8.0),
                                                                        color: Color(
                                                                            0xFFFFFFFF),
                                                                        border: Border.all(
                                                                            color:
                                                                                Color(0xFFF0F0F0))),
                                                                    margin: EdgeInsets
                                                                        .all(3),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              1.0,
                                                                          horizontal:
                                                                              10.0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                              height: 5),
                                                                          Image(
                                                                            image:
                                                                                AssetImage('assets/basket1.png'),
                                                                            width:
                                                                                30,
                                                                            height:
                                                                                30,
                                                                          ),
                                                                          SizedBox(
                                                                              height: 10),
                                                                          Text(
                                                                              "This Month Orders",
                                                                              style: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 8, color: Color(0xFF959595)))),
                                                                          Row(
                                                                            children: [
                                                                              Text(statisticscount['thisMonthOrders'].toString(), style: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF000000)))),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              int.parse(statisticscount['thisMonthOrders_percent'].toString()) >= 0
                                                                                  ? Icon(
                                                                                      Icons.arrow_upward,
                                                                                      size: 10,
                                                                                      color: Color(0xFF3DC131),
                                                                                    )
                                                                                  : Icon(
                                                                                      Icons.arrow_downward,
                                                                                      size: 10,
                                                                                      color: Color(0xFFFC4B4B),
                                                                                    ),
                                                                              SizedBox(width: 5),
                                                                              Text((statisticscount['thisMonthOrders_percent'].abs()).toString() + "%",
                                                                                  style: GoogleFonts.poppins(
                                                                                      textStyle: TextStyle(
                                                                                    fontWeight: FontWeight.w700,
                                                                                    fontSize: 10,
                                                                                    color: int.parse(statisticscount['thisMonthOrders_percent'].toString()) >= 0 ? Color(0xFF3DC131) : Color(0xFFFC4B4B),
                                                                                  ))),
                                                                            ],
                                                                          ),

                                                                          // SizedBox(
                                                                          //     height:5
                                                                          // ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                8.0),
                                                                        color: Color(
                                                                            0xFFFFFFFF),
                                                                        border: Border.all(
                                                                            color:
                                                                                Color(0xFFF0F0F0))),
                                                                    margin: EdgeInsets
                                                                        .all(3),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              1.0,
                                                                          horizontal:
                                                                              10.0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                              height: 5),
                                                                          Image(
                                                                            image:
                                                                                AssetImage('assets/basket2.png'),
                                                                            width:
                                                                                30,
                                                                            height:
                                                                                30,
                                                                          ),
                                                                          SizedBox(
                                                                              height: 10),
                                                                          Text(
                                                                              "Avg. Order / Day",
                                                                              style: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 8, color: Color(0xFF959595)))),
                                                                          Row(
                                                                            children: [
                                                                              Text(statisticscount['averageOrders'].toString(), style: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF000000)))),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              int.parse(statisticscount['averageOrders_percent'].toString()) >= 0
                                                                                  ? Icon(
                                                                                      Icons.arrow_upward,
                                                                                      size: 10,
                                                                                      color: Color(0xFF3DC131),
                                                                                    )
                                                                                  : Icon(
                                                                                      Icons.arrow_downward,
                                                                                      size: 10,
                                                                                      color: Color(0xFFFC4B4B),
                                                                                    ),
                                                                              SizedBox(width: 5),
                                                                              Text((statisticscount['averageOrders_percent'].abs()).toString() + "%", style: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 10, color: int.parse(statisticscount['averageOrders_percent'].toString()) >= 0 ? Color(0xFF3DC131) : Color(0xFFFC4B4B)))),
                                                                            ],
                                                                          ),

                                                                          // SizedBox(
                                                                          //     height:5
                                                                          // ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0),
                                                child: Row(children: [
                                                  InkWell(
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              50,
                                                      //height: MediaQuery.of(context).size.width/6,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          // color: Colors.white,
                                                          color: Color(
                                                              0xFFFCB912)),
                                                      margin: EdgeInsets.all(4),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Row(
                                                          //mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            SizedBox(width: 80),
                                                            Image(
                                                              image: AssetImage(
                                                                  'assets/monitor1.png'),
                                                              width: 35,
                                                              height: 35,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                      height:
                                                                          4),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(
                                                                          width:
                                                                              6),
                                                                      Text(
                                                                          catname,
                                                                          style:
                                                                              GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: Color(0xFFFFFFFF)))),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(
                                                                          width:
                                                                              6),
                                                                      Text(
                                                                          "View All Products",
                                                                          style:
                                                                              GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Color(0xFFFFFFFF)))),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    // onTap: (){
                                                    //   Navigator.push(
                                                    //       context, new MaterialPageRoute(
                                                    //       builder: (context) => new SellerProductlist()));
                                                    // },
                                                  ),
                                                ]),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              // Row(
                                              //   children: [
                                              //     Text("   Recent Orders",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w600),)),
                                              //     Spacer(),
                                              //     // Text("Today",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF8B8B8B),fontSize:12,fontWeight: FontWeight.w500),)),
                                              //     //IconButton(icon:Icon(Icons.keyboard_arrow_down_outlined), onPressed: null)
                                              //     //Icon(Icons.keyboard_arrow_down_outlined,color:Color(0xFF8B8B8B)),
                                              //     InkWell(child: Text(recent.isNotEmpty?"View All":"",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF8B8B8B),fontSize:12,fontWeight: FontWeight.w500),)),
                                              //       onTap: (){
                                              //         Navigator.push(
                                              //             context, new MaterialPageRoute(
                                              //             builder: (context) => new RecentOrders()));
                                              //       },
                                              //     ),
                                              //   ],
                                              // ),
                                              // recent.isEmpty?
                                              // Center(child: Text("No recent Orders ",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w500),)))
                                              //     :Column(
                                              //   children:List.generate(recent.length>3?3:recent.length,(index){
                                              //     return
                                              //       InkWell(
                                              //           child: Column(
                                              //             children: [
                                              //
                                              //               Row(
                                              //                 children: [
                                              //                   SizedBox(
                                              //                     width: 5,
                                              //                   ),
                                              //
                                              //                   Expanded(
                                              //                     child: new Row(
                                              //                       crossAxisAlignment: CrossAxisAlignment.center,
                                              //                       children:[
                                              //                         Image(image:recent[index]['productId']['photos']==null||recent[index]['productId']['photos'].isEmpty?AssetImage('assets/oxygen.png'):NetworkImage(Prefmanager.baseurl+"/file/get/"+recent[index]['productId']['photos'][0]),height:75,width:95 ,fit:BoxFit.fill),
                                              //                         Expanded(
                                              //                             child:Padding(
                                              //                               padding: const EdgeInsets.all(8.0),
                                              //                               child: Column(
                                              //                                   children:[
                                              //                                     SizedBox(height:7),
                                              //                                     Row(
                                              //                                       children:[
                                              //                                         Text(recent[index]['name'],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF808080),fontSize:12,fontWeight: FontWeight.w700),)),
                                              //
                                              //                                       ],
                                              //                                     ),
                                              //                                     SizedBox(
                                              //                                       height:1,
                                              //                                     ),
                                              //                                     Row(
                                              //                                         children:[
                                              //                                           Text("Price: ₹ "+fo.nonSymbol,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:11,fontWeight: FontWeight.w700),)),
                                              //                                         ]
                                              //
                                              //                                     ),
                                              //                                     // SizedBox(
                                              //                                     //   height:5,
                                              //                                     // ),
                                              //                                     Row(
                                              //                                         children:[
                                              //                                           Text("Shipped",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:11,fontWeight: FontWeight.w600),)),
                                              //                                           //SizedBox(width:100),
                                              //                                           Spacer(),
                                              //                                           Text(timeago.format(
                                              //                                             DateTime.now().subtract(new Duration(minutes:DateTime.now().difference(DateTime.parse(recent[index]['order_date'])).inMinutes)),),style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:9,fontWeight: FontWeight.w300))),
                                              //                                         ]
                                              //                                     ),
                                              //                                     SizedBox(
                                              //                                       height:5,
                                              //                                     ),
                                              //                                     Row(
                                              //                                         children:[
                                              //                                           Text("Stock: "+recent[index]['productId']['stockQuantity'].toString()+" Pieces",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF188320),fontSize:9,fontWeight: FontWeight.w400),)),
                                              //                                         ]
                                              //                                     ),
                                              //                                     // SizedBox(
                                              //                                     //   height:50
                                              //                                     // ),
                                              //
                                              //                                   ]
                                              //                               ),
                                              //                             )
                                              //                         ),
                                              //                         SizedBox(
                                              //                           height: 10,
                                              //                         ),
                                              //                       ],
                                              //                     ),
                                              //                   ),
                                              //                 ],
                                              //               ),
                                              //               Divider(
                                              //                 height: 20,
                                              //                 thickness: 1,
                                              //                 indent: 1,
                                              //               ),
                                              //             ],
                                              //           ),
                                              //           onTap:() {
                                              //             //Navigator.push(context,new MaterialPageRoute(builder: (context)=>new VieweachProduct(profile[index]['_id'],profile[index]['seller']['_id'],widget.deldate)));
                                              //           }
                                              //       );
                                              //   }
                                              //   ),
                                              // ),

                                              Container(
                                                decoration: new BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                            20.0,
                                                          ),
                                                          topRight:
                                                              Radius.circular(
                                                            20.0,
                                                          )),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey[500]
                                                          .withOpacity(0.5),
                                                      spreadRadius: 5,
                                                      blurRadius: 4,
                                                      offset: Offset(2,
                                                          5), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 20.0,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 15),
                                                      Row(
                                                        children: [
                                                          Image(
                                                              image: AssetImage(
                                                                  'assets/basket1.png'),
                                                              width: 30,
                                                              height: 25),
                                                          SizedBox(width: 5),
                                                          Text("Stocks",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                textStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFF000000),
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              )),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                     // progress2? Center(child: CircularProgressIndicator(),)
                                                      progress2?Shimmer.fromColors(
                                                        baseColor: Colors.grey[300],
                                                        highlightColor: Colors.grey[100],
                                                        child: Container(
                                                          height: 50,
                                                          width: 20,
                                                          decoration:
                                                          BoxDecoration(
                                                            color:Colors.white,
                                                            shape: BoxShape
                                                                .circle,
                                                          ),
                                                        ),
                                                      )
                                                          : Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    InkWell(
                                                                      child:
                                                                          Container(
                                                                        // width:MediaQuery.of(context).size.width/2.5,
                                                                        width: MediaQuery.of(context).size.width /
                                                                            2.5,
                                                                        //height: MediaQuery.of(context).size.width/4,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            color: Color(0xFFFFFFFF),
                                                                            border: Border.all(color: Color(0xFFF0F0F0))),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            SizedBox(height: 20),
                                                                            Row(
                                                                              //mainAxisAlignment:MainAxisAlignment.center,
                                                                              children: [
                                                                                Spacer(),
                                                                                Image(image: AssetImage('assets/basket1.png'), width: 20, height: 20),
                                                                                Spacer(),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text(c['outofStockProducts'].toString() + " Products",
                                                                                    style: GoogleFonts.poppins(
                                                                                      textStyle: TextStyle(color: Color(0xFF000000), fontSize: 12, fontWeight: FontWeight.w600),
                                                                                    )),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text("Out of Stock",
                                                                                    style: GoogleFonts.poppins(
                                                                                      textStyle: TextStyle(color: Color(0xFFD62F2F), fontSize: 11, fontWeight: FontWeight.w300),
                                                                                    )),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),

                                                                            // Image(image:AssetImage('assets/basket1.png'),width:20,height:18), Spacer(),
                                                                            //Image(image:AssetImage('assets/basket1.png'),width:20,height:18),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      //onTap: (){Navigator.push(context, new MaterialPageRoute(builder: (context) => StocksPage('Out of Stock',uid)));},
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            10),
                                                                    InkWell(
                                                                      child:
                                                                          Container(
                                                                        width: MediaQuery.of(context).size.width /
                                                                            2.5,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            color: Color(0xFFFFFFFF),
                                                                            border: Border.all(color: Color(0xFFF0F0F0))),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            SizedBox(height: 20),
                                                                            Row(
                                                                              //mainAxisAlignment:MainAxisAlignment.center,
                                                                              children: [
                                                                                Spacer(),
                                                                                Image(image: AssetImage('assets/basket1.png'), width: 20, height: 20),
                                                                                Spacer(),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text(c['limitedStockProducts'].toString() + " Products",
                                                                                    style: GoogleFonts.poppins(
                                                                                      textStyle: TextStyle(color: Color(0xFF000000), fontSize: 12, fontWeight: FontWeight.w600),
                                                                                    )),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text("Limited Stock",
                                                                                    style: GoogleFonts.poppins(
                                                                                      textStyle: TextStyle(color: Color(0xFF127EFC), fontSize: 11, fontWeight: FontWeight.w300),
                                                                                    )),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 20,
                                                                            ),

                                                                            // Image(image:AssetImage('assets/basket1.png'),width:20,height:18), Spacer(),
                                                                            //Image(image:AssetImage('assets/basket1.png'),width:20,height:18),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      // onTap: (){Navigator.push(context, new MaterialPageRoute(builder: (context) => StocksPage('Limited Stock',uid)));},
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: 20),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    InkWell(
                                                                      child:
                                                                          Container(
                                                                        // width:MediaQuery.of(context).size.width/2.5,
                                                                        width: MediaQuery.of(context).size.width /
                                                                            2.5,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            color: Color(0xFFFFFFFF),
                                                                            border: Border.all(color: Color(0xFFF0F0F0))),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            SizedBox(height: 20),
                                                                            Row(
                                                                              //mainAxisAlignment:MainAxisAlignment.center,
                                                                              children: [
                                                                                Spacer(),
                                                                                Image(image: AssetImage('assets/basket1.png'), width: 20, height: 20),
                                                                                Spacer(),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text(c['bestSellingProducts'].toString() + " Products",
                                                                                    style: GoogleFonts.poppins(
                                                                                      textStyle: TextStyle(color: Color(0xFF000000), fontSize: 12, fontWeight: FontWeight.w600),
                                                                                    )),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text("Best Selling",
                                                                                    style: GoogleFonts.poppins(
                                                                                      textStyle: TextStyle(color: Color(0xFFFCB912), fontSize: 11, fontWeight: FontWeight.w300),
                                                                                    )),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),

                                                                            // Image(image:AssetImage('assets/basket1.png'),width:20,height:18), Spacer(),
                                                                            //Image(image:AssetImage('assets/basket1.png'),width:20,height:18),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      //onTap: (){Navigator.push(context, new MaterialPageRoute(builder: (context) => StocksPage('Best Selling',uid)));},
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            10),
                                                                    InkWell(
                                                                      child:
                                                                          Container(
                                                                        width: MediaQuery.of(context).size.width /
                                                                            2.5,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            color: Color(0xFFFFFFFF),
                                                                            border: Border.all(color: Color(0xFFF0F0F0))),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            SizedBox(height: 20),
                                                                            Row(
                                                                              //mainAxisAlignment:MainAxisAlignment.center,
                                                                              children: [
                                                                                Spacer(),
                                                                                Image(image: AssetImage('assets/basket1.png'), width: 20, height: 20),
                                                                                Spacer(),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text(c['allProducts'].toString() + " Products",
                                                                                    style: GoogleFonts.poppins(
                                                                                      textStyle: TextStyle(color: Color(0xFF000000), fontSize: 12, fontWeight: FontWeight.w600),
                                                                                    )),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text("All Products",
                                                                                    style: GoogleFonts.poppins(
                                                                                      textStyle: TextStyle(color: Color(0xFF29D089), fontSize: 11, fontWeight: FontWeight.w300),
                                                                                    )),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 20,
                                                                            ),

                                                                            // Image(image:AssetImage('assets/basket1.png'),width:20,height:18), Spacer(),
                                                                            //Image(image:AssetImage('assets/basket1.png'),width:20,height:18),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      //onTap: (){Navigator.push(context, new MaterialPageRoute(builder: (context) => StocksPage('All Products',uid)));},
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                      SizedBox(
                                                        height: 20,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]),
                                  statustype == 'pending'
                                      ? Container(
                                          padding: EdgeInsets.fromLTRB(
                                              5, 100, 0, 0),
                                          alignment: Alignment.center,
                                          height: 350,
                                          child: Card(
                                              elevation: 5.0,
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 50),
                                                  Stack(children: [
                                                    Image(
                                                        image: AssetImage(
                                                            'assets/verifyPend.png'),
                                                        height: 100,
                                                        width: 300),
                                                    Positioned(
                                                        left: 55,
                                                        child: Image(
                                                            image: AssetImage(
                                                                'assets/c.png'),
                                                            height: 40,
                                                            width: 40)),
                                                  ]),
                                                  SizedBox(height: 10),
                                                  Text(
                                                      "Please Wait and refresh the page",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            color: Color(
                                                                0xFFFF4B4B),
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )),
                                                  Text("Verification Pending",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            color: Color(
                                                                0xFF191919),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )),
                                                ],
                                              )),
                                        )
                                      : SizedBox.shrink(),
                                  statustype == 'reject'
                                      ? Container(
                                          padding: EdgeInsets.fromLTRB(
                                              25, 100, 0, 0),
                                          alignment: Alignment.center,
                                          height: 350,
                                          child: Card(
                                              elevation: 5.0,
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 50),
                                                  Stack(children: [
                                                    Image(
                                                        image: AssetImage(
                                                            'assets/verifyPend.png'),
                                                        height: 100,
                                                        width: 300),
                                                    Positioned(
                                                        left: 55,
                                                        child: Image(
                                                            image: AssetImage(
                                                                'assets/c.png'),
                                                            height: 40,
                                                            width: 40)),
                                                  ]),
                                                  SizedBox(height: 10),
                                                  Text(
                                                      "Please check profile and refresh the page",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            color: Color(
                                                                0xFFFF4B4B),
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )),
                                                  Text("Rejected",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            color: Color(
                                                                0xFF191919),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )),
                                                  remarks != null
                                                      ? Expanded(
                                                          child: InkWell(
                                                          child: Text(
                                                              "Reason: " +
                                                                  remarks,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                textStyle: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              )),
                                                          onTap: () async {
                                                            await Navigator.push(
                                                                context,
                                                                new MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        SellerProfile(
                                                                            uid,
                                                                            listprofile['sellerid']['shopName'])));
                                                            await profile();
                                                          },
                                                        ))
                                                      : SizedBox.shrink()
                                                ],
                                              )),
                                        )
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ],
                          ),
                        )),
                  )));
  }
}

class OrdinalSales {
  final String year;
  final double sales;

  OrdinalSales(this.year, this.sales);
}
