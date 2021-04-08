import 'package:eram_app/TrackPackage.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:eram_app/Prefmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:shimmer/shimmer.dart';
class OrderDetails extends StatefulWidget {
  final productid, orderid;
  OrderDetails(this.productid, this.orderid);
  @override
  _OrderDetails createState() => _OrderDetails();
}

class _OrderDetails extends State<OrderDetails> {
  void initState() {
    super.initState();
    getPermission();
    orders();
  }

  getPermission() async {
    if (await Permission.contacts.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
    } else {
// You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      print(statuses[Permission.location]);
    }
  }

  var d = new DateFormat('dd MMMM, yyyy');
  var d1 = new DateFormat('dd-MMM-yyyy');
  var product, orderdetails;
  String status;
  bool progress = true;
  Future<void>orders() async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token,
    };
    Map data = {'productid': widget.productid, 'orderid': widget.orderid};
    print(data);
    var body = json.encode(data);
    var url = Prefmanager.baseurl + '/my/order/product/view';
    var response = await http.post(url, headers: requestHeaders, body: body);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      product = json.decode(response.body)['product'];
      orderdetails = json.decode(response.body)['orderDetails'];
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress = false;

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

  @override
  Widget build(BuildContext context) {
    FlutterMoneyFormatter fmf;
    MoneyFormatterOutput fo;
    fmf = FlutterMoneyFormatter(
        amount: progress ? 0 : product['offerPrice'].toDouble());
    fo = fmf.output;
    FlutterMoneyFormatter fmf1;
    MoneyFormatterOutput fo1;
    fmf1 = FlutterMoneyFormatter(
        amount: progress ? 0 : product['productSubTotal'].toDouble());
    fo1 = fmf1.output;
    FlutterMoneyFormatter fmf2;
    MoneyFormatterOutput fo2;
    fmf2 = FlutterMoneyFormatter(
        amount: progress ? 0 : product['productTotalAmount'].toDouble());
    fo2 = fmf2.output;
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Text("Orders Details",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              )),
          automaticallyImplyLeading: true,
        ),
        body: //progress ? Center(child: CircularProgressIndicator(),)
        progress?SingleChildScrollView(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              //enabled: progress,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(height:150,width:double.infinity,color:Colors.white),
                    SizedBox(height:10),
                    Container(
                        width: double.infinity,
                        height: 50.0,
                        color:Colors.white
                    ),
                    SizedBox(height:10),
                    Container(height:150,width:double.infinity,color:Colors.white),
                    SizedBox(height:10),
                    Container(height:100,width:double.infinity,color:Colors.white),
                    SizedBox(height:10),
                    Container(height:200,width:double.infinity,color:Colors.white),
                    SizedBox(height:10),
                    Container(height:150,width:double.infinity,color:Colors.white),
                    SizedBox(height:10),
                  ]),
            ))
            : SingleChildScrollView(
                child: Column(children: [
                InkWell(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        // Padding(
                        //   padding: const EdgeInsets.only(right:10.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       Icon(Icons.share_outlined,size:15,color:Color(0xFF5A7EE2)),SizedBox(width:5),
                        //       Text("Share this Item",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF5A7EE2),fontSize:11,fontWeight: FontWeight.w400),)),
                        //     ],
                        //   ),
                        // ),
                        Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: new Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image(
                                        image: product['productId']['photos'] ==
                                                    null ||
                                                product['productId']['photos']
                                                    .isEmpty
                                            ?NetworkImage(Prefmanager.baseurl+"/file/get/noimage.jpg")
                                            : NetworkImage(Prefmanager.baseurl +
                                                "/file/get/" +
                                                product['productId']['photos']
                                                    [0]),
                                        height: 115,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        fit: BoxFit.fill),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(children: [
                                        SizedBox(height: 7),
                                        Row(
                                          children: [
                                            Text(product['name'],
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF000000),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                )),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 1,
                                        ),
                                        Row(children: [
                                          Text("₹ " + fo.nonSymbol,
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFF000000),
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                        ]),
                                        Row(children: [
                                          Text(
                                              "QTY: " +
                                                  product['quantity']
                                                      .toString(),
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFF000000),
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                        ]),
                                        product['color']!=null?
                                        Row(
                                          children:[
                                            Text(
                                                "Color: ",
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF000000),
                                                      fontSize: 11,
                                                      fontWeight:
                                                      FontWeight.w500),
                                                )),
                                            Container(
                                              height: 15,
                                              width: 15,
                                              decoration:
                                              BoxDecoration(
                                                  color: Color(int
                                                      .parse(product[
                                                  'color'])),
                                                  shape: BoxShape
                                                      .circle,

                                              ),
                                            ),
                                          ]
                                        ):SizedBox.shrink(),
                                        SizedBox(height: 10),
                                        Container(
                                            height: 40,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: FlatButton(
                                              color: Color(0xFFFFFFFF),
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: Color(0xFFF0F0F0)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.0)),
                                              child: Text('Track Package',
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        color:
                                                            Color(0xFF000000),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )),
                                              onPressed: () async {
                                                await Navigator.push(
                                                    context,
                                                    new MaterialPageRoute(
                                                        builder: (context) =>
                                                            new TrackPackage(
                                                                widget
                                                                    .productid,
                                                                widget
                                                                    .orderid)));
                                                await orders();
                                              },
                                            )),
                                      ]),
                                    )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
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
                    onTap: () {
                      //Navigator.push(context,new MaterialPageRoute(builder: (context)=>new VieweachProduct(profile[index]['_id'],profile[index]['seller']['_id'],widget.deldate)));
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.border_all, color: Color(0xFF1FA82A)),
                          SizedBox(width: 10),
                          Text(product['productOrderStatus'] + " ",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              )),
                          product['track_dateTime'] != null &&
                                  product['track_dateTime']
                                          [product['productOrderStatus']] !=
                                      null
                              ? Text(
                                  d.format(DateTime.parse(
                                      product['track_dateTime']
                                          [product['productOrderStatus']])),
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ))
                              : SizedBox.shrink()
                        ],
                      ),

                      // Row(
                      //   children: [
                      //     SizedBox(width:35),
                      //     Text('Delivery Estimate',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF393939),fontSize:12,fontWeight: FontWeight.w400),)),
                      //   ],
                      // ),
                      Row(
                        children: [
                          SizedBox(width: 35),
                          Text('Item ' + product['productOrderStatus'],
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xFF30A241),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 20,
                  thickness: 1,
                  indent: 1,
                ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                                    orderdetails['create_date'])),
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
                            Text(orderdetails['orderID'],
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
                                    product['quantity'].toString() +
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
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Card(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Shipping Address',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF393939),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                )),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                orderdetails['deliveryAddress']['firstName'] +
                                    ' ' +
                                    orderdetails['deliveryAddress']['lastName'],
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                )),
                            Text(orderdetails['deliveryAddress']['address'],
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                )),
                            Text(
                                orderdetails['deliveryAddress']['city'] +
                                    ',' +
                                    orderdetails['deliveryAddress']['state'],
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                )),
                            Text(orderdetails['deliveryAddress']['pincode'],
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                )),
                            SizedBox(height: 10),
                            Text('Contact',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF393939),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Text(orderdetails['deliveryAddress']['mobile'],
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
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                            Text(product['name'],
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
                                    product['productDeliveryCharge']
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
                                '₹ ' + product['productTax'].toStringAsFixed(2),
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
                product['productOrderStatus'] == 'cancelled' ||
                        product['productOrderStatus'] == 'cancelledbyseller'
                    ? SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
              ])));
  }
}
