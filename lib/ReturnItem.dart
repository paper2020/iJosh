import 'package:eram_app/TrackPackage.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:eram_app/Prefmanager.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class ReturnItem extends StatefulWidget {
  final productid, orderid;
  ReturnItem(this.productid, this.orderid);
  @override
  _ReturnItem createState() => _ReturnItem();
}

class _ReturnItem extends State<ReturnItem> {
  void initState() {
    super.initState();
    orders();
    getReason();
  }

  var d = new DateFormat('dd MMMM, yyyy');
  var product;
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
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress = false;

    setState(() {});
  }

  bool progress1 = true;
  List reason = [];
  void getReason() async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token,
    };
    var url = Prefmanager.baseurl + '/return/replace/reasonlist';
    var response = await http.get(url, headers: requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      for (int i = 0; i < json.decode(response.body)['data'].length; i++)
        reason = json.decode(response.body)['data'];
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress1 = false;
    setState(() {});
  }

  var a;
  TextEditingController reasonController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //var f;
    FlutterMoneyFormatter fmf;
    MoneyFormatterOutput fo;
    fmf = FlutterMoneyFormatter(
        amount: progress ? 0 : product['offerPrice'].toDouble());
    fo = fmf.output;
    //f = (fo);

    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Text("Return or Replace Item",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              )),
          automaticallyImplyLeading: true,
        ),
        body: //progress ? Center(child: CircularProgressIndicator(),)
        progress?Shimmer.fromColors(
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
                Expanded(
                    child: ListView.builder(
                      itemCount: 4,
                        itemBuilder: (_, __) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left:10.0),
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
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[

                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal:10,vertical: 2.0),
                                      ),
                                      Container(
                                        alignment: Alignment.bottomRight,
                                        width: double.infinity,
                                        height: 30.0,
                                        color: Colors.white,
                                      ),

                                    ],
                                  ),
                                ) ]))
                    )),

                Container(height:100,width:double.infinity,color:Colors.white),
                SizedBox(height:10),

                Container(height:50,width:double.infinity,color:Colors.white),
                SizedBox(height:10),

              ]))
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
                                            ? NetworkImage(Prefmanager.baseurl+"/file/get/noimage.jpg")
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
                  child: Row(
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
                      // Text(product['productOrderStatus']=='ordered'&&product['track_dateTime']['ordered']!=null?d.format(DateTime.parse(product['track_dateTime']['ordered'])):product['productOrderStatus']=='packed'&&product['track_dateTime']['packed']!=null?product['track_dateTime']['packed']:product['productOrderStatus']=='shipped'&&product['track_dateTime']['shipped']!=null?product['track_dateTime']['shipped']:product['productOrderStatus']=='outfordelivery'?product['track_dateTime']['outfordelivery']:product['productOrderStatus']=='delivered'&&product['track_dateTime']['delivered']!=null?product['track_dateTime']['delivered']:product['productOrderStatus']=='cancelled'&&product['track_dateTime']['cancelled']!=null?product['track_dateTime']['cancelled']:product['productOrderStatus']=='returned'&&product['track_dateTime']['returned']!=null?product['track_dateTime']['returned']:"",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w600),))
                      product['track_dateTime'] != null &&
                              product['track_dateTime']
                                      [product['productOrderStatus']] !=
                                  null
                          ? Text(
                              d.format(DateTime.parse(product['track_dateTime']
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
                ),
                Divider(
                  height: 20,
                  thickness: 1,
                  indent: 1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Row(
                    children: [
                      Text('Select reason for return',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                progress1
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                            children: List.generate(reason.length, (index) {
                          return Container(
                            height: 75,
                            child: Column(
                              children: [
                                Card(
                                  elevation: 1.0,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 10,
                                            child: Radio(
                                              value: a == reason[index]
                                                  ? true
                                                  : false,
                                              groupValue: true,
                                              onChanged: (value) {
                                                setState(() {
                                                  // Check=value;
                                                  a = reason[index];
                                                  print(a);
                                                });
                                              },
                                              activeColor: Color(0xFF28D286),
                                            ),
                                          ),
                                          Text(reason[index],
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFF393939),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        })),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Text('Select reason for return',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: SizedBox(
                    height: 100,
                    child: TextFormField(
                      maxLines: null,
                      expands: true,
                      // keyboardType: TextInputType.multiline,
                      controller: reasonController,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
                      decoration: InputDecoration(
                        labelStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Color(0xFF1C1C1C),
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Color(0xFFF0F0F0),
                          ),
                        ),
                        hintText: 'Add Comments',
                        hintStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Color(0xFFB1ADAD),
                                fontSize: 12,
                                fontWeight: FontWeight.w400)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                progress2
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: FlatButton(
                            textColor: Colors.white,
                            color: Color(0xFFFC4B4B),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Color(0xFFD2D2D2)),
                                borderRadius: BorderRadius.circular(7.0)),
                            child: Text('Continue',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700),
                                )),
                            onPressed: () {
                              if (a == null)
                                Fluttertoast.showToast(
                                  msg: "Please select a reason",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                );
                              else
                                senddata();
                            })),
              ])));
  }

  bool progress2 = false;
  void senddata() async {
    setState(() {
      progress2 = true;
    });
    try {
      String token = await Prefmanager.getToken();
      var url = Prefmanager.baseurl + '/customer/order/product/return';
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': token
      };

      Map data = {
        'productid': widget.productid,
        'orderid': widget.orderid,
        'reason': a,
        'comments': reasonController.text
      };
      print(data);
      var body = json.encode(data);
      var response = await http.post(url, headers: requestHeaders, body: body);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)['status']) {

          Navigator.of(context).pop();
        } else {
          Fluttertoast.showToast(
            msg: json.decode(response.body)['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
          setState(() {
            progress2 = false;
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
    progress2 = false;
  }
}
