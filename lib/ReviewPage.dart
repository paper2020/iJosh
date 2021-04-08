import 'package:eram_app/ProductallRating.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:convert';
import 'dart:io';
import 'package:eram_app/Prefmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class ReviewPage extends StatefulWidget {
  final pid, name;
  ReviewPage(this.pid, this.name);
  @override
  _ReviewPage createState() => _ReviewPage();
}

class _ReviewPage extends State<ReviewPage> {
  void initState() {
    super.initState();
    sample();
  }

  Future sample() async {
    String token = await Prefmanager.getToken();
    _getCurrentLocation();
    ratingList();
    if (token != null) ratingView();
  }

  var district, city, lat, lon;
  double initialrating = 0.0;
  double _rating;
  _getCurrentLocation() async {}

  var createdate,
      length,
      rating,
      totalreviews,
      onestar,
      twostar,
      threestar,
      fourstar,
      fivestar;
  List rate = [];
  int limit = 2, page = 1;
  bool progress1 = true;
  Future<void> ratingList() async {
    setState(() {
      initialrating = 0.0;
    });
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
      // 'page':page.toString()
    };
    print(data);
    var body = json.encode(data);
    var url = Prefmanager.baseurl + '/rating/list/';
    var response = await http.post(url, headers: requestHeaders, body: body);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      length = json.decode(response.body)['totalLength'];
      rating = json.decode(response.body)['rating'];
      totalreviews = json.decode(response.body)['totalReviews'];
      onestar = json.decode(response.body)['ratingPercentage']['oneStar'];
      twostar = json.decode(response.body)['ratingPercentage']['twoStar'];
      threestar = json.decode(response.body)['ratingPercentage']['threeStar'];
      fourstar = json.decode(response.body)['ratingPercentage']['fourStar'];
      fivestar = json.decode(response.body)['ratingPercentage']['fiveStar'];
      // for (int i = 0; i < json.decode(response.body)['data'].length; i++)
      //   rate.add(json.decode(response.body)['data'][i]);
      // page++;
      rate = json.decode(response.body)['data'];
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

  var myrate, review, myrating;
  Future<void> ratingView() async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    Map data = {
      'ratingType': 'product',
      'productId': widget.pid,
    };
    print(data);
    var body = json.encode(data);
    var url = Prefmanager.baseurl + '/my/rating/view';
    var response = await http.post(url, headers: requestHeaders, body: body);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      myrate = json.decode(response.body)['data'];
      if (myrate != null) {
        myrating=json.decode(response.body)['data']['rating'].toDouble();
        _rating = json.decode(response.body)['data']['rating'].toDouble();
        review = json.decode(response.body)['data']['review'];
        reviewController.text = review;
      }
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );

    setState(() {});
  }

  void deleteReview(var id) async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    Map data = {
      'ratingType': 'product',
      'productId': id,
    };
    print(data);
    var body = json.encode(data);
    var url = Prefmanager.baseurl + '/rating/delete';
    var response = await http.post(url, headers: requestHeaders, body: body);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      Fluttertoast.showToast(
          msg: json.decode(response.body)['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 20.0);
      if (token != null) {
        await ratingView();
      }
      await ratingList();
      reviewController.clear();
      _rating = null;
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );

    setState(() {});
  }

  void _showDialog(var id) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete this review",
              style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 12))),
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
              onPressed: () {
                deleteReview(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool loading = false;
  bool ontap = false;
  int s = 1;
  List titles = ['Reviews'];
  List name = ['Neha Alex', 'Amy Rex', 'Neha Alex', 'Amy Rex'];
  List count = ['102', '102', '102', '102'];
  List rated = ['4.5', '4.5', '4.5', '4.5'];
  List days = ['2 days ago', '2 days ago', '2 days ago', '2 days ago'];
  List star = ['1 Star', '2 Star', '3 Star', '4 Star', '5 Star'];
  TextEditingController reviewController = TextEditingController();
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
              Text(widget.name,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 16,
                          fontWeight: FontWeight.w600))),
            ],
          ),
          district == null
              ? SizedBox.shrink()
              : Row(
                  children: [
                    Text(district,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Color(0xFF787878),
                                fontSize: 12,
                                fontWeight: FontWeight.w400))),
                  ],
                ),
          // centerTitle: false,
          // bottom: PreferredSize(
          //     child:
          //       ],
          //     ),
          //     preferredSize: null),
          // actions: [
          //   Center(child: Text(city)),
          // ],
        ]),
      ),
      body:// progress1 ? Center(child: CircularProgressIndicator(),
      progress1?SingleChildScrollView(
        child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            //enabled: progress,
            child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(height:200,width:double.infinity,color:Colors.white),
                  SizedBox(height:10),
                  Container(
                      width: double.infinity,
                      height: 500.0,
                      color:Colors.white
                  ),
                  SizedBox(height:10),
                ])),
      )
          : SafeArea(
              child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(children: [
                    SizedBox(height: 10),
                    Container(
                      height: 40,
                      child: ListView.builder(
                          //                       padding: const EdgeInsets.all(10.0),
                          scrollDirection: Axis.horizontal,
                          itemCount: 1,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                                child: Row(
                                  //                            mainAxisAlignment: MainAxisAlignment.start,
                                  //                               crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 30),
                                    Column(
                                      children: [
                                        Text(titles[index],
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFF373737),
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w600))),
                                        Container(
                                          height: 2,
                                          width: 90,
                                          color: Color(0xFFFF4A4A),

                                          // indent: 1,
                                        )
                                      ],
                                    ),
                                    SizedBox(width: 30),
                                  ],
                                ),
                                onTap: () {
                                  //Navigator.push(context,new MaterialPageRoute(builder: (context)=>new VieweachProduct(profile[index]['_id'],profile[index]['seller']['_id'],widget.deldate)));
                                  setState(() {
                                    s = index;
                                  });
                                });
                          }),
                    ),
                    Text(rating.toString() + " / 5",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Color(0xFF212020),
                                fontSize: 30,
                                fontWeight: FontWeight.w600))),
                    Text(totalreviews.toString() + " Reviews",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                color: Color(0xFF7D7D7D),
                                fontSize: 14,
                                fontWeight: FontWeight.w600))),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 55,
                        ),
                        Column(
                          children: [
                            Image(image: AssetImage('assets/star.png')),
                            Text('1 Star',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF9B9B9B),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                )),
                            Text(onestar.toString() + " %",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF9B9B9B),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                )),
                          ],
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Column(
                          children: [
                            Image(image: AssetImage('assets/star.png')),
                            Text('2 Star',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF9B9B9B),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                )),
                            //SizedBox(width: 40,),
                            Text(twostar.toString() + " %",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF9B9B9B),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                )),
                          ],
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Column(
                          children: [
                            Image(image: AssetImage('assets/star.png')),
                            Text('3 Star',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF9B9B9B),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                )),
                            //SizedBox(width: 38,),
                            Text(threestar.toString() + " %",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF9B9B9B),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                )),
                          ],
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Column(
                          children: [
                            Image(image: AssetImage('assets/star.png')),
                            Text('4 Star',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF9B9B9B),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                )),
                            Text(fourstar.toString() + " %",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF9B9B9B),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                )),
                          ],
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Column(
                          children: [
                            Image(image: AssetImage('assets/star.png')),
                            Text('5 Star',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF9B9B9B),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                )),
                            Text(fivestar.toString() + " %",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF9B9B9B),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                )),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [],
                    ),
                    SizedBox(height: 20),
                    myrate != null
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Your Review',
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF444444),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600))),
                                Spacer(),
                                myrate != null
                                    ? InkWell(
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.grey,
                                        ),
                                        // iconSize: 20,

                                        onTap: () {
                                          _showDialog(widget.pid);
                                        },
                                      )
                                    : SizedBox.shrink()
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                    myrate != null
                        ? Column(
                            children: [
                              RatingBar.builder(
                                initialRating:
                                    myrate == null ? initialrating : myrating,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 30.0,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  _rating = rating;
                                  print(_rating);
                                },
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter review';
                                    } else {
                                      return null;
                                    }
                                  },
                                  autofocus: false,
                                  controller: reviewController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.edit)),
                                ),
                              ),
                              SizedBox(height: 10),
                              progress2
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : FlatButton(
                                      //width:114,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Color(0xFFD2D2D2)),
                                          borderRadius:
                                              BorderRadius.circular(7.0)),

                                      height: 36,
                                      minWidth: 152,
                                      color: Color(0xFFFC4B4B),
                                      child: Text('Edit Your Review',
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFFFFFFFF),
                                                  fontSize: 13,
                                                  fontWeight:
                                                      FontWeight.w600))),
                                      onPressed: () {
                                        if (_rating == null)
                                          Fluttertoast.showToast(
                                            msg: "Please select rating",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                          );
                                        else
                                          senddata();
                                      },
                                    ),
                            ],
                          )
                        : SizedBox.shrink(),
                    rate.isEmpty && myrate == null
                        ? Column(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Reviews",
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Color(0xFF444444),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600))),
                                ],
                              ),
                            ),
                            Text("No added reviews yet",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ))
                          ])
                        : SizedBox.shrink(),
                    rate.isEmpty
                        ? SizedBox.shrink()
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Reviews",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xFF444444),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600))),
                                    Spacer(),
                                    InkWell(
                                      child: Text(
                                          rate.length > 3 ? "View All" : "",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF1D1D1D),
                                                  fontSize: 11,
                                                  fontWeight:
                                                      FontWeight.w500))),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    new ProductallRating(
                                                        widget.pid)));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              NotificationListener<ScrollNotification>(
                                onNotification:
                                    (ScrollNotification scrollInfo) {
                                  if (!loading &&
                                      scrollInfo.metrics.pixels ==
                                          scrollInfo.metrics.maxScrollExtent) {
                                    if (length > rate.length) {
                                      ratingList();
                                      setState(() {
                                        loading = true;
                                      });
                                    } else {}
                                  } else {}
                                  //  setState(() =>loading = false);
                                  return true;
                                },
                                child: Column(
                                  children: List.generate(
                                      rate.length > 3 ? 3 : rate.length,
                                      (index) {
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
                                                            // SizedBox(
                                                            //   height: 10,
                                                            // ),
                                                            Row(
                                                              children: [
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
                                                                            color: Color(
                                                                                0xFF373737),
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.w600))),
                                                              ],
                                                            ),

                                                            Row(children: [
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
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(width: 60),
                                                      //Expanded(flex:0,child: Text(" ")),
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
                                                                          FontWeight
                                                                              .bold)),
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
                                                                          FontWeight
                                                                              .w400)))),
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
                              ),
                            ],
                          ),
                    Container(
                      height: loading ? 20 : 0,
                      width: double.infinity,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  ])),
            ),
    );
  }

  bool progress2 = false;
  bool check = false;
  void senddata() async {
    setState(() {
      progress2 = true;
    });
    try {
      String token = await Prefmanager.getToken();
      var url = Prefmanager.baseurl + '/rating/add/update';
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': token
      };

      Map data = {
        'ratingType': 'product',
        'productId': widget.pid,
        'rating': _rating,
        'review': reviewController.text
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
          ratingList();
          if (token != null) {
            ratingView();
          }
          //reviewController.clear();

          // Navigator.push(
          //     context, new MaterialPageRoute(
          //     builder: (context) => new ReviewPage(widget.pid, widget.name)));
        } else {
          print(json.decode(response.body)['msg']);
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
