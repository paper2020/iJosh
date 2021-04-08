import 'dart:convert';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/SellerOfferedit.dart';
import 'package:eram_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SellerOfferview extends StatefulWidget {
  final check,id;
  SellerOfferview(this.check,this.id);
  @override
  _SellerOfferview createState() => _SellerOfferview();
}

class _SellerOfferview extends State<SellerOfferview> {
  @override
  void initState() {
    super.initState();
    vieweachOffer();

  }
  var t,t2;
  var d1 = new DateFormat('dd-MMM-yyyy');
  var t1=new DateFormat('mm:ss');
  bool progress = true;
  var offer;
  Future<void>vieweachOffer() async {
    var url = Prefmanager.baseurl + '/seller/offer/view/' + widget.id;
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token,
      //'category':widget.id,
    };
    var response = await http.get(url, headers: requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      //for (int i = 0; i < json.decode(response.body)['data'].length; i++)
      // product.add(json.decode(response.body)['data'][i]);
      offer = json.decode(response.body)['data'];

      t=DateTime.now().subtract(new Duration(
          minutes: DateTime
              .now()
              .difference(DateTime.parse(offer
          [
          'starting']))
              .inMinutes));
      print(t);
      t2=DateTime.now().subtract(new Duration(
          minutes: DateTime
              .now()
              .difference(DateTime.parse(offer
          [
          'ending']))
              .inMinutes));
    } else
      print("Somjj");

    progress = false;
    setState(() {});
  }

  void _showDialog(var id) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Delete this offer",
            style: TextStyle(fontSize: 16),
          ),
          //content: new Text("This will delete your review"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Delete"),
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteOffer(id);
              },
            ),
          ],
        );
      },
    );
  }

  bool pro = true;
  Future<void> deleteOffer(var id) async {
    var url = Prefmanager.baseurl + '/seller/offer/delete/' + id;
    var token = await Prefmanager.getToken();

    //print(data.toString());

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "token": token,
      },
    );
    print(response.body);
    if (json.decode(response.body)['status']) {
      Fluttertoast.showToast(
          msg: json.decode(response.body)['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 20.0);
      Navigator.of(context).pop();
      //await Navigator.pushReplacement(context,new MaterialPageRoute(builder: (context)=>new SellerProductlist()));
    } else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: json.decode(response.body)['msg'],
          toastLength: Toast.LENGTH_SHORT,
          // gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 20.0);
      //progress=false;
      pro = false;
      setState(() {
        //deleterate();
      });
    }
  }


  List images = ['assets/mac.jpg', 'assets/slider1.jpg'];
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    // List f=[];
    // FlutterMoneyFormatter fmf;
    // MoneyFormatterOutput fo;
    // //for(int i=0;i<product.length;i++) {
    //   fmf = FlutterMoneyFormatter(
    //       amount: product['price'].toDouble());
    //   fo = fmf.output;
    //   f.add(fo);
    // }
    return Scaffold(
      appBar: AppBar(
        title: progress
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Text(offer['name']),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ),
      body: SafeArea(
        child: progress
            ? CameraHelper.productdetailLoader(context)
            : SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              Container(
                height:300,
                child:Image(
                    image: NetworkImage(
                        Prefmanager.baseurl +
                            "/file/get/" +
                            offer['photo']),
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover)),

                SizedBox(height:10),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    //height: 110,
                    //width: 364,
                    child: Card(
                        elevation: 4.0,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
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
                                    Text(offer['name'],
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color:
                                              Color(0xFF000000),
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight.w600),
                                        )),

                                  ]),
                              Text(offer['description'],
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF989898),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  )),


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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                             Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text("Offer Starting",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color:
                                          Color(0xFF000000),
                                          fontSize: 14,
                                          fontWeight:
                                          FontWeight.w600),
                                    )),
                                Text(
                                    "Date: "+d1.format(DateTime.parse(
                                        offer['starting'])),
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color:
                                          Color(0xFF464646),
                                          fontSize: 12,
                                          fontWeight:
                                          FontWeight.w400),
                                    )),
                                Text(
                                    "Time: "+new DateFormat.jm().format(DateTime.parse(offer['starting'])),
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color:
                                          Color(0xFF464646),
                                          fontSize: 12,
                                          fontWeight:
                                          FontWeight.w400),
                                    )),
                                SizedBox(
                                  height: 10,
                                ),

                              ],
                            ),

                            Text("Offer Ending",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                )),
                            Text(
                                "Date: "+d1.format(DateTime.parse(
                                    offer['ending'])),
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color:
                                      Color(0xFF464646),
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight.w400),
                                )),
                            // Text(
                            //     "Time: "+t1.format(DateTime.parse(
                            //         offer['ending'])),
                            //     style: GoogleFonts.poppins(
                            //       textStyle: TextStyle(
                            //           color:
                            //           Color(0xFF464646),
                            //           fontSize: 12,
                            //           fontWeight:
                            //           FontWeight.w400),
                            //     )),
                            Text(
                                "Time: "+new DateFormat.jm().format(DateTime.parse(offer['ending'])),
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color:
                                      Color(0xFF464646),
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight.w400),
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                // Expanded(
                                //     flex: 1,
                                //     child: Text(
                                //         product['specification'] !=
                                //             null
                                //             ? product['specification']
                                //             : " ",
                                //         style: GoogleFonts.poppins(
                                //           textStyle: TextStyle(
                                //               color:
                                //               Color(0xFF464646),
                                //               fontSize: 12,
                                //               fontWeight:
                                //               FontWeight.w400),
                                //         ))),
                              ],
                            ),
                            SizedBox(height: 10),
                            widget.check?SizedBox.shrink()
                            :Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Container(
                                    height: 40,
                                    width: MediaQuery.of(context)
                                        .size
                                        .width /
                                        3,
                                    //padding:EdgeInsets.symmetric(horizontal: 15),
                                    child: FlatButton(
                                      textColor: Colors.white,
                                      color: Color(0xFFFC4B4B),
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color:
                                              Color(0xFFD2D2D2)),
                                          borderRadius:
                                          BorderRadius.circular(
                                              7.0)),
                                      child: Text('Edit Offer',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight:
                                                FontWeight.w700),
                                          )),
                                      onPressed: () async{
                                        await Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    SellerOfferedit(offer['_id'])));
                                        await vieweachOffer();
                                      },
                                    )),
                                SizedBox(width: 10),
                                Container(
                                    height: 40,
                                    width: MediaQuery.of(context)
                                        .size
                                        .width /
                                        3,
                                    // padding:EdgeInsets.symmetric(horizontal: 15),
                                    child: FlatButton(
                                      textColor: Colors.white,
                                      color: Color(0xFFFC4B4B),
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color:
                                              Color(0xFFD2D2D2)),
                                          borderRadius:
                                          BorderRadius.circular(
                                              7.0)),
                                      child: Text('Delete Offer',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight:
                                                FontWeight.w700),
                                          )),
                                      onPressed: () {
                                        _showDialog(offer['_id']);
                                      },
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
