import 'package:eram_app/FirstPage1.dart';
import 'package:eram_app/utils/helper.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:convert';
import 'dart:io';
import 'package:eram_app/CartPage.dart';
import 'package:eram_app/ReviewPage.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_pro/carousel_pro.dart';
import 'package:eram_app/Prefmanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetail extends StatefulWidget {
  final pid;
  ProductDetail(this.pid);
  @override
  _ProductDetail createState() => new _ProductDetail();
}

class _ProductDetail extends State<ProductDetail> {
  void initState() {
    super.initState();
    //Sample();
    productView();
    ratingList();
  }

  // Future Sample()async{
  //   await productView();
  //   await ratingList();
  // }
  int s;
  var addColor;
  bool wishCheck = false;
  var product;
  List colors = [];
  bool inwish = false;
  bool incart = false;
  var colorIncart;
  bool progress = true;
  Future<void>productView() async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token != null ? token : null
    };
    var url = Prefmanager.baseurl + '/product/view/' + widget.pid;
    var response = await http.get(url, headers: requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      product = json.decode(response.body)['data'];
      setState(() {
        if (token != null) {
          incart = json.decode(response.body)['data']['inCart'];
          inwish = json.decode(response.body)['data']['inWishlist'];
          colorIncart=json.decode(response.body)['data']['colorInCart'];
        }
      });

      image = json.decode(response.body)['data']['photos'];
      colors = json.decode(response.body)['data']['colorDetails'];
      print(incart);
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );

    progress = false;
    setState(() {});
  }

  var length;
  List rate = [];
  int limit = 1, page = 1;
  bool progress1 = true;
  Future<void>ratingList() async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token != null ? token : null
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

  bool loading = false;
  bool check = false;
  List images = ['assets/mac.jpg', 'assets/slider1.jpg'];
  List image = [];
  @override
  Widget build(BuildContext context) {
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
        amount: progress ? 0 : product['price'].toDouble());
    MoneyFormatterOutput fo = fmf.output;
    //progress?Center(child:CircularProgressIndicator(),):
    return Scaffold(
        //backgroundColor:  Color(0xFFFFFFFF),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, true),
          ),
          title: Row(
            children: [
              progress
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Text(product['name'],
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      )),
            ],
          ),
        ),
        body: progress?CameraHelper.productdetailLoader(context)

            : SingleChildScrollView(
                physics: ScrollPhysics(),
                child: SafeArea(
                    child: Column(children: [
                  //Center(child: Image(image:AssetImage('assets/mac.jpg'),width:376,height: 300,)),
                  Container(
                    height: 300,
                    child: Carousel(
                      autoplay: false,
                      dotSize: 5,
                      dotSpacing: 15,
                      dotBgColor: Colors.transparent,
                      dotColor: Color(0xFFBCBCBC),
                      dotIncreasedColor: Color(0xFFBCBCBC),
                      // options: CarouselOptions(),
                      // options: CarouselOptions(
                      //     //enableInfiniteScroll: false,
                      //     reverse: false,
                      //     height: 400,
                      //     autoPlay: true,
                      //     enlargeCenterPage: true,
                      //   // aspectRatio:3.8,
                      //     onPageChanged: (index, reason) {
                      //       setState(() {
                      //         _current = index;
                      //       });
                      //     }
                      // ),
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
                                  image: NetworkImage(Prefmanager.baseurl +
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
                          //height: 55,
                          width: 150,

                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Card(
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                    side:
                                        new BorderSide(color: Colors.grey[400]),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                            Text(product['rating'].toString(),
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF9B9B9B),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                            Spacer(),
                                            Column(
                                              children: [
                                                SizedBox(height: 5),
                                                Text(
                                                    product['totalReviews']
                                                        .toString(),
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          color:
                                                              Color(0xFF000000),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    )),
                                                Text("REVIEWS",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          color:
                                                              Color(0xFF9A9A9A),
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    )),
                                              ],
                                            )
                                          ]),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                        onTap: () async {
                          await Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new ReviewPage(
                                      widget.pid, product['name'])));
                          await ratingList();
                          await productView();
                        },
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
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      //height: 110,
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(product['name'],
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      )),
                                  Spacer(),
                                  //Image(image:AssetImage('assets/heart.png'),width:18,height: 16,),
                                  InkWell(
                                      child: Icon(
                                        Icons.favorite_outline,
                                        color: inwish
                                            ? Color(0xFFF43636)
                                            : Color(0xff8D8D8D),
                                        size: 20,
                                      ),
                                      onTap: () {
                                        setState(() async {
                                          String token =
                                              await Prefmanager.getToken();
                                          if (token != null)
                                            senddata1();
                                          else
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        new FirstPage1()));
                                        });
                                      }),
                                  Text(
                                      " " + product['wishlistCount'].toString(),
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF828282),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400),
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
                                          fontWeight: FontWeight.w600),
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Text(product['discount'] == 0 ? "" : "Today",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Color(0xFFF43636),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    )),
                                Expanded(
                                    child: Text(
                                        product['discount'] == 0
                                            ? ""
                                            : " (Rs. " +
                                                product['offerPrice']
                                                    .toStringAsFixed(2) +
                                                ", " +
                                                product['discount'].toString() +
                                                ' % Off)',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Color(0xFFF43636),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ))),
                              ],
                            ),
                            SizedBox(height: 10),
                            colors.isEmpty
                                ? SizedBox.shrink()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Avaliable color",
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xFF000000),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      if(incart==false)
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              for (int i = 0;
                                                  i < colors.length;
                                                  i++)
                                                Row(
                                                  children: [
                                                    SizedBox(width: 5),
                                                    InkWell(
                                                      child: Container(
                                                        height: 25,
                                                        width: 25,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Color(int
                                                                    .parse(colors[
                                                                            i][
                                                                        'color'])),
                                                                shape: BoxShape
                                                                    .circle,
                                                                border:
                                                                    Border.all(
                                                                        //color:Color(int.parse(colors[i]['color'])),
                                                                        width: s ==
                                                                                i
                                                                            ? 5
                                                                            : 20,
                                                                        color: s ==
                                                                                i
                                                                            ? Colors.white  :Color(int.parse(colors[i]['color'])))


                                                            ),
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          check = true;
                                                          s = i;
                                                          addColor=colors[
                                                          i][
                                                          'color'];
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: 30,
                                                    ),
                                                  ],
                                                ),
                                            ]),
                                      ),
                                      if(incart&&colorIncart!=null)
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: <Widget>[
                                                for (int i = 0;
                                                i < colors.length;
                                                i++)
                                                  Row(
                                                    children: [
                                                      SizedBox(width: 5),
                                                      Container(
                                                        height: 25,
                                                        width: 25,
                                                        decoration:
                                                        BoxDecoration(
                                                            color: Color(int
                                                                .parse(colors[
                                                            i][
                                                            'color'])),
                                                            shape: BoxShape
                                                                .circle,
                                                            border:
                                                            Border.all(
                                                              //color:Color(int.parse(colors[i]['color'])),
                                                                width: colors[i]['color'] == colorIncart
                                                                    ? 5
                                                                    : 20,
                                                                color: colors[i]['color'] == colorIncart
                                                                    ? Colors.white  :Color(int.parse(colors[i]['color'])))


                                                        ),
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
                            SizedBox(height: 10),
                            progress3
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : incart
                                    ? FlatButton(
                                        height: 40,
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        textColor: Colors.white,
                                        color: Color(0xFFFC4B4B),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        child: Text('Go To Cart',
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                        onPressed: () async {
                                          // senddata();
                                          await Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      new CartPage()));

                                          await productView();
                                        },
                                      )
                                    : FlatButton(
                                        height: 40,
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        textColor: Colors.white,
                                        color: Color(0xFFFC4B4B),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        child: Text('Add To Cart',
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                        onPressed: () async {
                                          String token =
                                              await Prefmanager.getToken();
                                          if (token != null) {
                                            if(product['isColor']==true&&addColor==null)
                                            Fluttertoast.showToast(
                                              msg:"Please select a color",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,

                                            );
                                              else {
                                              await senddata(null);
                                              addColor=null;
                                              // s=null;
                                              await productView();
                                            }
                                          } else
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        new FirstPage1()));

                                          //  Navigator.push(
                                          //      context, new MaterialPageRoute(
                                          //      builder: (context) => new CartPage()));
                                        },
                                      ),
                          ],
                        ),
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      //height: 350,

                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
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
                                          product['specification'] != null
                                              ? product['specification']
                                              : " ",
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xFF464646),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          ))),
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
                              height: 40,
                              thickness: 1,
                              indent: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("    Reviews",
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Color(0xFF444444),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600))),
                                ],
                              ),
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
                                    children:
                                        List.generate(rate.length, (index) {
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
                                                                EdgeInsets.only(
                                                                    left: 12),
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
                                                            child: CircleAvatar(
                                                              radius: 18,
                                                              backgroundImage: rate[index]['uid']
                                                                              [
                                                                              'customerid']
                                                                          [
                                                                          'photo'] ==
                                                                      null
                                                                  ? AssetImage(
                                                                      'assets/user.jpg')
                                                                  : NetworkImage(
                                                                      Prefmanager
                                                                              .baseurl +
                                                                          "/file/get/" +
                                                                          rate[index]['uid']['customerid']
                                                                              [
                                                                              'photo'],
                                                                    ),
                                                            )),
                                                        //Image(image: AssetImage('assets/fishimage2.jpg'),height:200,width:double.infinity ,fit:BoxFit.fill),
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
                                                                width: 10,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                      rate[index]['uid']['customerid']
                                                                              [
                                                                              'firstName'] +
                                                                          " " +
                                                                          rate[index]['uid']['customerid']
                                                                              [
                                                                              'lastName'],
                                                                      style: GoogleFonts.poppins(
                                                                          textStyle: TextStyle(
                                                                              color: Color(0xFF373737),
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w600))),
                                                                ],
                                                              ),

                                                              // Row(
                                                              //     children:[
                                                              //       Text(count[index]+' reviews',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF828282),fontSize:11,fontWeight: FontWeight.w400))),
                                                              //     ]
                                                              //
                                                              // ),

                                                              Row(children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                    rate[index]['review'] !=
                                                                            null
                                                                        ? rate[index]
                                                                            [
                                                                            'review']
                                                                        : " ",
                                                                    style: GoogleFonts.poppins(
                                                                        textStyle: TextStyle(
                                                                            color: Color(
                                                                                0xFF828282),
                                                                            fontSize:
                                                                                9,
                                                                            fontWeight:
                                                                                FontWeight.w400))),
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
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(width: 60),
                                                        //Expanded(flex:1,child: Text(" ")),
                                                        // Expanded(flex:1,child: Text('RATED',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF3A3636),fontSize:11,fontWeight: FontWeight.w400)))),
                                                        // Expanded(flex:1,child: Text(rated[index],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF434343),fontSize:13,fontWeight: FontWeight.w600)))),
                                                        Expanded(
                                                          flex: 2,
                                                          child: RichText(
                                                            text: TextSpan(
                                                              text: 'RATED ',
                                                              style: GoogleFonts.poppins(
                                                                  textStyle: TextStyle(
                                                                      color: Color(
                                                                          0xFF3A3636),
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400)),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                    text: rate[index]
                                                                            [
                                                                            'rating']
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                            child: Text(
                                                                timeago.format(
                                                                  DateTime.now().subtract(new Duration(
                                                                      minutes: DateTime
                                                                              .now()
                                                                          .difference(DateTime.parse(rate[index]
                                                                              [
                                                                              'update_date']))
                                                                          .inMinutes)),
                                                                ),
                                                                style: GoogleFonts.poppins(
                                                                    textStyle: TextStyle(
                                                                        color: Color(
                                                                            0xFF828282),
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w400)))),
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
                            Container(
                              height: loading ? 20 : 0,
                              width: double.infinity,
                              child: Center(child: CircularProgressIndicator()),
                            )
                          ],
                        ),
                ])),
              ));
  }

  bool progress3 = false;
  Future<void>senddata(var id) async {
    setState(() {
      progress3 = true;
    });
    print("hi");
    try {
      String token = await Prefmanager.getToken();
      var url = Prefmanager.baseurl + '/cart/add';
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': token
      };

      Map data = {
        'productId': widget.pid,
          'color':addColor
      };
      print(data);
      var body = json.encode(data);
      var response = await http.post(url, headers: requestHeaders, body: body);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)['status']) {
          print((json.decode(response.body)['token']));
          String token = await Prefmanager.getToken();
          print(token);
          await Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new CartPage()));
          await productView();
        } else {
          print(json.decode(response.body)['msg']);
          Fluttertoast.showToast(
            msg:json.decode(response.body)['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,

          );
          setState(() {
            progress3=false;
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
    setState(() {
      progress3 = false;
    });

  }

  bool progress2 = false;
  var action;
  void senddata1() async {
    setState(() {
      progress2 = true;
    });
    print("hi");
    try {
      String token = await Prefmanager.getToken();
      var url = Prefmanager.baseurl + '/wishlist/add/remove';
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': token
      };

      Map data = {'productId': widget.pid};
      print(data);
      var body = json.encode(data);
      var response = await http.post(url, headers: requestHeaders, body: body);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)['status']) {
          print((json.decode(response.body)['token']));
          String token = await Prefmanager.getToken();
          print(token);
          setState(() {
            action = json.decode(response.body)['action'];
            print(action);
            action == 'add' ? inwish = true : inwish = false;
            productView();
          });

          Fluttertoast.showToast(
            msg: json.decode(response.body)['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
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
    progress2 = false;
  }
}
