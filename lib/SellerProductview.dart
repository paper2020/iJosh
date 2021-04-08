import 'dart:convert';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:eram_app/EditProduct.dart';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;

class SellerProductview extends StatefulWidget {
  final pid;
  SellerProductview(this.pid);
  @override
  _SellerProductview createState() => _SellerProductview();
}

class _SellerProductview extends State<SellerProductview> {
  @override
  void initState() {
    super.initState();
    vieweachproduct();
    ratingList();
  }

  FlutterMoneyFormatter fmf;
  MoneyFormatterOutput fo;
  bool progress = true;
  List image = [];
  //List <Color>colors=[];
  List colors = [];
  var product;
  Future<void>vieweachproduct() async {
    var url = Prefmanager.baseurl + '/product/view/' + widget.pid;
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
      product = json.decode(response.body)['data'];
      List f = [];

      //for(int i=0;i<product.length;i++) {
      fmf = FlutterMoneyFormatter(amount: product['price'].toDouble());
      fo = fmf.output;
      f.add(fo);

      image = json.decode(response.body)['data']['photos'];
      colors = json.decode(response.body)['data']['colorDetails'];
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
            "Delete this product",
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
                await deleteProduct(id);
              },
            ),
          ],
        );
      },
    );
  }

  bool pro = true;
  Future<void> deleteProduct(var id) async {
    var url = Prefmanager.baseurl + '/product/delete/' + id;
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

  var length;
  List rate = [];
  int limit = 1, page = 1;
  bool progress1 = true;
  void ratingList() async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    Map data = {
      'ratingType': 'product',
      'productId': widget.pid,
      //'limit':limit.toString(),
      //'page':page.toString()
    };
    print(data);
    var body = json.encode(data);
    var url = Prefmanager.baseurl + '/rating/list/';
    var response = await http.post(url, headers: requestHeaders, body: body);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      length = json.decode(response.body)['totalLength'];
      // for (int i = 0; i < json.decode(response.body)['data'].length; i++)
      rate = json.decode(response.body)['data'];
      page++;
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    loading = false;
    progress1 = false;
    setState(() {});
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
            : Text(product['name']),
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
                              width: 150,

                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0),
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
                                                  color: Color(0xFFFFC107),
                                                ),
                                                Text(
                                                    product['rating']
                                                        .toString(),
                                                    style:
                                                        GoogleFonts.poppins(
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
                                                        product['totalReviews']
                                                            .toString(),
                                                        style: GoogleFonts
                                                            .poppins(
                                                          textStyle: TextStyle(
                                                              color: Color(
                                                                  0xFF000000),
                                                              fontSize: 14,
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
                                                              fontSize: 10,
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
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: image.map((url) {
                      //     int index = image.indexOf(url);
                      //     return Container(
                      //       width: 4.0,
                      //       height: 4.0,
                      //       margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      //       decoration: BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         color: _current == index
                      //             // ? Color(0xFFD1D1D1)
                      //             // : Color(0xFF828282),
                      //             ? Color.fromRGBO(0, 0, 0, 0.9)
                      //             : Color(0xFF828282),
                      //       ),
                      //     );
                      //   }).toList(),
                      // ),
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
                                          Text(product['name'],
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
                                                  product['wishlistCount']
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
                                    Text(product['description'],
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Color(0xFF989898),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        )),
                                    Row(
                                      children: [
                                        Text("Rs. " + fo.nonSymbol,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.w600),
                                            )),
                                      ],
                                    ),
                                    product['discount'] == 0
                                        ? SizedBox.shrink()
                                        : Row(
                                            children: [
                                              Text(
                                                  product['discount'] == 0
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
                                                      product['discount'] ==
                                                              0
                                                          ? ""
                                                          : " (Rs. " +
                                                              product['offerPrice']
                                                                  .toStringAsFixed(2) +
                                                              ", " +
                                                              product['discount']
                                                                  .toString() +
                                                              ' % Off)',
                                                      maxLines: 2,
                                                      overflow: TextOverflow
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
                                    SizedBox(height: 10),
                                    Row(children: [
                                      Text(
                                          "Stock: " +
                                              product['stockQuantity']
                                                  .toString() +
                                              " Pieces",
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xFF188320),
                                                fontSize: 9,
                                                fontWeight:
                                                    FontWeight.w400),
                                          )),
                                    ]),
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
                                  colors.isEmpty
                                      ? SizedBox.shrink()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Avaliable color",
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color:
                                                          Color(0xFF000000),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
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

                                  // Row(
                                  //   children: [
                                  //     CircleAvatar(radius:15,backgroundColor: Color(0xFFF0F0F2),),SizedBox(width: 30,),
                                  //     CircleAvatar(radius:15,backgroundColor: Color(0xFFD9D9D9),),
                                  //   ],
                                  // ),
                                  // Row(
                                  //   children: [
                                  //     Text("Silver",style: GoogleFonts.poppins(textStyle:TextStyle(color: Color(0xFF828282),fontSize: 11, fontWeight: FontWeight.w400),)),SizedBox(width: 30,),
                                  //     Text("Space Grey",style: GoogleFonts.poppins(textStyle:TextStyle(color: Color(0xFF828282),fontSize: 11, fontWeight: FontWeight.w400),)),
                                  //   ],
                                  // ),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.start,
                                  //   children: [
                                  //     SizedBox(
                                  //       height: 20,
                                  //     ),
                                  //     Text("Product Details",style: GoogleFonts.poppins(textStyle:TextStyle(color: Color(0xFF000000),fontSize: 14, fontWeight: FontWeight.w600),)),
                                  //   ],
                                  // ),
                                  // Row(
                                  //   children: [
                                  //     SizedBox(
                                  //       height: 40,
                                  //     ),
                                  //     Expanded(child: Text(product['description'],style: GoogleFonts.poppins(textStyle:TextStyle(color: Color(0xFF464646),fontSize: 12, fontWeight: FontWeight.w400),))),
                                  //   ],
                                  // ),
                                  SizedBox(height: 5),
                                  // Text("Stock Quantity",style: GoogleFonts.poppins(textStyle:TextStyle(color: Color(0xFF000000),fontSize: 14, fontWeight: FontWeight.w600),)),
                                  // SizedBox(
                                  //   height: 5,
                                  // ),
                                  // Row(
                                  //   children: [
                                  //
                                  //     Text(product['stockQuantity']!=null?product['stockQuantity'].toString():" ",style: GoogleFonts.poppins(textStyle:TextStyle(color: Color(0xFF464646),fontSize: 12, fontWeight: FontWeight.w400),)),
                                  //   ],
                                  // ),
                                  // SizedBox(
                                  //   height: 5,
                                  // ),
                                  // Text("Offer",style: GoogleFonts.poppins(textStyle:TextStyle(color: Color(0xFF000000),fontSize: 14, fontWeight: FontWeight.w600),)),
                                  // SizedBox(
                                  //   height: 5,
                                  // ),
                                  // Row(
                                  //   children: [
                                  //
                                  //     Text(product['discount']!=null?product['discount'].toString():" ",style: GoogleFonts.poppins(textStyle:TextStyle(color: Color(0xFF464646),fontSize: 12, fontWeight: FontWeight.w400),)),
                                  //   ],
                                  // ),
                                  // SizedBox(
                                  //   height: 5,
                                  // ),
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
                                              product['specification'] !=
                                                      null
                                                  ? product['specification']
                                                  : " ",
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
                                  Row(
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
                                            child: Text('Edit Product',
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
                                                          EditProduct(
                                                              product[
                                                                  "_id"])));
                                              await vieweachproduct();
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
                                            child: Text('Delete Product',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                )),
                                            onPressed: () {
                                              _showDialog(product['_id']);
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

                      rate.isEmpty
                          ? SizedBox.shrink()
                          : Column(
                              children: [
                                Divider(
                                  height: 30,
                                  thickness: 1,
                                  indent: 1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  children: [
                                    Text("    Reviews",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xFF444444),
                                                fontSize: 16,
                                                fontWeight:
                                                    FontWeight.w600))),
                                  ],
                                ),
                                progress1
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    :
                                    // NotificationListener<ScrollNotification>(
                                    //     onNotification: (ScrollNotification scrollInfo) {
                                    //       if (!loading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                                    //         if(length>rate.length){
                                    //
                                    //           ratingList();
                                    //           setState(() {
                                    //             loading = true;
                                    //           });
                                    //         }
                                    //         else{}
                                    //
                                    //       }
                                    //       else{}
                                    //       //  setState(() =>loading = false);
                                    //       return true;
                                    //     },
                                    Column(
                                        // width: MediaQuery.of(context).size.width,
                                        // //height:MediaQuery.of(context).size.height,
                                        // height: 500,
                                        children: List.generate(rate.length,
                                            (index) {
                                          //padding: const EdgeInsets.all(10.0),
                                          // physics: NeverScrollableScrollPhysics(),
                                          // shrinkWrap: true,
                                          // itemCount: rate.length,
                                          // itemBuilder: (BuildContext context,int index){
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
                                                            Container(
                                                                padding:
                                                                    EdgeInsets.all(
                                                                        10),
                                                                // child: ClipRRect(
                                                                //   borderRadius:BorderRadius.circular(65.0),
                                                                //   child:FadeInImage(
                                                                //     //   image:NetworkImage(
                                                                //     //       Prefmanager.baseurl+"/u/"+profile[index]['seller']["photo"]) ,
                                                                //     image: AssetImage('assets/vegetables.jpg'),
                                                                //     placeholder: AssetImage("assets/userlogo.jpg"),
                                                                //     fit: BoxFit.cover,
                                                                //     width:90,
                                                                //     height:90,
                                                                //   ),
                                                                //
                                                                // ),
                                                                child:
                                                                    CircleAvatar(
                                                                  radius:
                                                                      18,
                                                                  backgroundImage:
                                                                  rate[index]['uid']['customerid']['photo'] == null
                                                                      ? AssetImage('assets/user.jpg')
                                                                      : NetworkImage(
                                                                    Prefmanager.baseurl + "/file/get/" + rate[index]['uid']['customerid']['photo'],
                                                                  ),
                                                                )),
                                                            //Image(image: AssetImage('assets/fishimage2.jpg'),height:200,width:double.infinity ,fit:BoxFit.fill),
                                                            Expanded(
                                                                child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment.start,
                                                                    children: [
                                                                  // SizedBox(
                                                                  //   height: 10,
                                                                  // ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                          rate[index]['uid']['customerid']['firstName'] + " " + rate[index]['uid']['customerid']['lastName'],
                                                                          style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF373737), fontSize: 13, fontWeight: FontWeight.w600))),
                                                                      Spacer(),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(right: 20.0),
                                                                      )
                                                                    ],
                                                                  ),

                                                                  // Row(
                                                                  //     children:[
                                                                  //       Text(count[index]+' reviews',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF828282),fontSize:11,fontWeight: FontWeight.w400))),
                                                                  //     ]
                                                                  //
                                                                  // ),

                                                                  Row(
                                                                      children: [
                                                                        Text(rate[index]['review'] != null ? rate[index]['review'] : " ",
                                                                            style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF828282), fontSize: 9, fontWeight: FontWeight.w400))),
                                                                      ]),
                                                                ])),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                                width: 60),
                                                            //Expanded(flex:1,child: Text(" ")),
                                                            // Expanded(flex:1,child: Text('RATED',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF3A3636),fontSize:11,fontWeight: FontWeight.w400)))),
                                                            // Expanded(flex:1,child: Text(rated[index],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF434343),fontSize:13,fontWeight: FontWeight.w600)))),
                                                            Expanded(
                                                              flex: 2,
                                                              child:
                                                                  RichText(
                                                                text:
                                                                    TextSpan(
                                                                  text:
                                                                      'RATED ',
                                                                  style: GoogleFonts.poppins(
                                                                      textStyle: TextStyle(
                                                                          color: Color(0xFF3A3636),
                                                                          fontSize: 11,
                                                                          fontWeight: FontWeight.w400)),
                                                                  children: <
                                                                      TextSpan>[
                                                                    TextSpan(
                                                                        text:
                                                                            rate[index]['rating'].toString(),
                                                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                                child: Text(
                                                                    timeago
                                                                        .format(
                                                                      DateTime.now()
                                                                          .subtract(new Duration(minutes: DateTime.now().difference(DateTime.parse(rate[index]['update_date'])).inMinutes)),
                                                                    ),
                                                                    style: GoogleFonts.poppins(
                                                                        textStyle: TextStyle(
                                                                            color: Color(0xFF828282),
                                                                            fontSize: 10,
                                                                            fontWeight: FontWeight.w400)))),
                                                          ],
                                                        ),
                                                      ]),
                                                  Divider(
                                                    height: 30,
                                                    thickness: 1,
                                                    indent: 1,
                                                  ),
                                                ],
                                              ),
                                              onTap: () {});
                                        }),
                                      ),
                              ],
                            ),
                    ]),
              ),
      ),
    );
  }
}
