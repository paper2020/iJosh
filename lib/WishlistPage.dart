import 'dart:convert';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/ProductDetail.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPage createState() => _WishlistPage();
}

class _WishlistPage extends State<WishlistPage> {
  final _formKey = GlobalKey<FormState>();
  void initState() {
    super.initState();
    wishList();
  }

  List wish = [];
  bool progress = true;
  void wishList() async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    var url = Prefmanager.baseurl + '/wishlist/list';
    var response = await http.post(url, headers: requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      for (int i = 0; i < json.decode(response.body)['data'].length; i++)
        wish.add(json.decode(response.body)['data'][i]);
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress = false;
    setState(() {});
  }

  void _showDialog(var id) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Remove this product from wishlist ",
              style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 12))),
          //content: new Text("This will delete your review"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel",
                  style: GoogleFonts.poppins(textStyle: TextStyle())),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Remove",
                style: GoogleFonts.poppins(textStyle: TextStyle()),
              ),
              onPressed: () {
                deleteProduct(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool pro = true;
  void deleteProduct(var id) async {
    var url = Prefmanager.baseurl + '/wishlist/remove/' + id;
    var token = await Prefmanager.getToken();
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

      //cartList();
      setState(() {
        wish.removeWhere((element) => id == element['_id']);
      });
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
      setState(() {});
    }
  }

  var a, q;
  bool check = false;
  bool hasPressed = false;
  List img = ['assets/cart1.png', 'assets/cart2.png', 'assets/cart2.png'];
  List product = ['MacBook Pro 16', 'MacBook Pro 16', 'MacBook Pro 16'];
  List d = [
    '1TB SSD, 16gm ram, retina display',
    '1TB SSD, 16gm ram, retina display',
    '1TB SSD, 16gm ram, retina display'
  ];
  List price = ['229', '229', '229'];
  List save = ['51', '51', '51'];
  List shipping = ['40', '40', '40'];
  List seller = ['MYG', 'MYG', 'MYG'];
  List qty = ['1', '2', '3', '4', '5'];
  @override
  Widget build(BuildContext context) {
    List f = [];
    FlutterMoneyFormatter fmf;
    MoneyFormatterOutput fo;
    for (int i = 0; i < wish.length; i++) {
      fmf = FlutterMoneyFormatter(
          amount: wish[i]['productId']['price'].toDouble());
      fo = fmf.output;
      f.add(fo);
    }
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Text("Wishlist",
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
        ),
        body:
        // progress ? Center(
        //         child: CircularProgressIndicator(),
        //       ):
        progress?Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
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
                              Container(
                                width: 60.0,
                                height: 60.0,
                                color: Colors.white,
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
                                    SizedBox(height:10),
                                    Container(
                                      width: double.infinity,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    SizedBox(height:10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          alignment: Alignment.bottomRight,
                                          width: 40.0,
                                          height: 8.0,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 50,)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        itemCount: 10,
                      ),
                    ),
                  )])):

             SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Column(
                              children: [
                                wish.isEmpty
                                    ? Center(
                                        child: Column(children: [
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  6),
                                          Image(
                                              image: AssetImage(
                                                  'assets/emptywishlist.jpg')),
                                          SizedBox(height: 5),
                                          Text("Your wishlist is empty!",
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                          SizedBox(height: 5),
                                          Text(
                                              "Explore more and shortlist some items.",
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400))),
                                        ]),
                                      )
                                    : Column(
                                        children:
                                            List.generate(wish.length, (index) {
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
                                                            Image(
                                                                image: wish[index]['productId']['photos'] ==
                                                                            null ||
                                                                        wish[index]['productId']['photos']
                                                                            .isEmpty
                                                                    ?NetworkImage(Prefmanager.baseurl+"/file/get/noimage.jpg")
                                                                    : NetworkImage(Prefmanager
                                                                            .baseurl +
                                                                        "/file/get/" +
                                                                        wish[index]['productId']['photos']
                                                                            [
                                                                            0]),
                                                                height: 90,
                                                                width: 90,
                                                                fit: BoxFit
                                                                    .cover),
                                                            Expanded(
                                                                child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      15.0),
                                                              child: Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                            wish[index]['productId'][
                                                                                'name'],
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              textStyle: TextStyle(color: Color(0xFF000000), fontSize: 10, fontWeight: FontWeight.w700),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                            child: Text(wish[index]['productId']['description'],
                                                                                maxLines: 2,
                                                                                style: GoogleFonts.poppins(
                                                                                  textStyle: TextStyle(color: Color(0xFF6A6A6A), fontSize: 10, fontWeight: FontWeight.w300),
                                                                                ))),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 3,
                                                                    ),
                                                                    Row(
                                                                        children: [
                                                                          Text(
                                                                              "Price: ₹ " + f[index].nonSymbol,
                                                                              style: GoogleFonts.poppins(
                                                                                textStyle: TextStyle(color: Color(0xFF000000), fontSize: 10, fontWeight: FontWeight.w700),
                                                                              )),
                                                                          SizedBox(
                                                                              width: 10),
                                                                          Text(
                                                                              "You Save:₹" + save[index],
                                                                              style: GoogleFonts.poppins(
                                                                                textStyle: TextStyle(color: Color(0xFF2DD986), fontSize: 9, fontWeight: FontWeight.w300),
                                                                              )),
                                                                        ]),

                                                                    SizedBox(
                                                                      height: 3,
                                                                    ),
                                                                    Row(
                                                                        children: [
                                                                          Text(
                                                                              "Seller: " + wish[index]['productId']['sellerId']['shopName'],
                                                                              style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF6A6A6A), fontSize: 10, fontWeight: FontWeight.w400))),
                                                                        ]),
                                                                    SizedBox(
                                                                        height:
                                                                            10),
                                                                    //Text("Qty:"),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        InkWell(
                                                                          child:
                                                                              Text(
                                                                            "REMOVE",
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              textStyle: TextStyle(color: Color(0xFF000000), fontSize: 10, fontWeight: FontWeight.w500),
                                                                            ),
                                                                          ),
                                                                          onTap:
                                                                              () {
                                                                            _showDialog(wish[index]['_id']);
                                                                          },
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ]),
                                                            )),
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
                                                            new ProductDetail(wish[
                                                                        index][
                                                                    'productId']
                                                                ['_id'])));
                                              });
                                        }),
                                      ),
                              ],
                            )))),
              ));
  }
}
