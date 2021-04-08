import 'dart:convert';
import 'package:eram_app/Prefmanager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;
import 'package:shimmer/shimmer.dart';
class ProductallRating extends StatefulWidget {
  final pid;
  ProductallRating(this.pid);
  @override
  _ProductallRating createState() => _ProductallRating();
}
class _ProductallRating extends State<ProductallRating> {

  @override
  void initState() {
    super.initState();
    ratingList();
  }
  var length;
  var rating,totalreviews,onestar,twostar,threestar,fourstar,fivestar;
  bool progress=true;
  int page=1,limit=10;
  List rate=[];
  void ratingList() async{
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    Map data = {
      'ratingType':'product',
      'productId':widget.pid,
      'page':page.toString(),
      'limit':limit.toString(),
    };
    print(data);
    var body = json.encode(data);

    var url=Prefmanager.baseurl+'/rating/list/';
    var response = await http.post(url,headers:requestHeaders,body: body);
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
      length=json.decode(response.body)['totalLength'];
      rating=json.decode(response.body)['rating'];
      totalreviews=json.decode(response.body)['totalReviews'];
      onestar=json.decode(response.body)['ratingPercentage']['oneStar'];
      twostar=json.decode(response.body)['ratingPercentage']['twoStar'];
      threestar=json.decode(response.body)['ratingPercentage']['threeStar'];
      fourstar=json.decode(response.body)['ratingPercentage']['fourStar'];
      fivestar=json.decode(response.body)['ratingPercentage']['fiveStar'];

      for (int i = 0; i < json.decode(response.body)['data'].length; i++)
        rate.add(json.decode(response.body)['data'][i]);
      page++;
    }
    else
      Fluttertoast.showToast(
        msg:json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );

    progress=false;
    loading=false;
    setState(() {
    });
  }
  bool loading=false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("All Reviews",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:16,fontWeight: FontWeight.w600),)),
        leading: IconButton (icon:Icon(Icons.arrow_back),
          onPressed:() => Navigator.pop(context,true),
        ),
      ),

      body: SafeArea(
        child: //progress?Center( child: CircularProgressIndicator(),):
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
                                width: 48.0,
                                height: 48.0,
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
                                    Container(
                                      width: double.infinity,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 40.0,
                                          height: 8.0,
                                          color: Colors.white,
                                        ),
                                        Spacer(),
                                        Container(
                                          width: 70.0,
                                          height: 8.0,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20,)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        itemCount: 15,
                      ),
                    ),
                  )])):
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height:5),
            Expanded(child:NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!loading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  if(length>rate.length){
                    ratingList();
                    setState(() {
                      loading = true;
                    });
                  }
                  else{}

                }
                else{}
                //  setState(() =>loading = false);
                return true;
              },
              child: Container(
                height:MediaQuery.of(context).size.height,
                child: ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: rate.length,
                    itemBuilder: (BuildContext context,int index){
                      return
                        InkWell(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal:10.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),

                                      Expanded(
                                        child: new Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children:[
                                            Container(
                                                padding: EdgeInsets.all(15),
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
                                                child:CircleAvatar(radius:18,backgroundImage:rate[index]['uid']['customerid']['photo']==null?AssetImage('assets/user.jpg'):NetworkImage(Prefmanager.baseurl+"/file/get/"+rate[index]['uid']['customerid']['photo'],),)
                                            ),
                                            //Image(image: AssetImage('assets/fishimage2.jpg'),height:200,width:double.infinity ,fit:BoxFit.fill),
                                            Expanded(
                                                child:Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children:[

                                                      // SizedBox(
                                                      //   height: 10,
                                                      // ),
                                                      Row(
                                                        children:[
                                                          Text(rate[index]['uid']['customerid']['firstName']+" "+rate[index]['uid']['customerid']['lastName'],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF373737),fontSize:13,fontWeight: FontWeight.w600))),

                                                        ],
                                                      ),

                                                      Row(
                                                          children:[
                                                            Text(rate[index]['review']!=null?rate[index]['review']:" ",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF828282),fontSize:9,fontWeight: FontWeight.w400))),
                                                          ]

                                                      ),

                                                    ]
                                                )

                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children:[
                                        Row(
                                          children: [
                                            SizedBox(width:70),
                                            Expanded(flex:2,
                                              child: RichText(
                                                text: TextSpan(
                                                  text: 'RATED ',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF3A3636),fontSize:11,fontWeight: FontWeight.w400)),

                                                  children: <TextSpan>[
                                                    TextSpan(text:  rate[index]['rating'].toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(flex:0,child: Text(timeago.format(
                                              DateTime.now().subtract(new Duration(minutes:DateTime.now().difference(DateTime.parse(rate[index]['update_date'])).inMinutes)),
                                            ),style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF828282),fontSize:10,fontWeight: FontWeight.w400)))),
                                          ],

                                        ),
                                      ]

                                  ),
                                  Divider(
                                    height: 30,
                                    thickness: 1,
                                    indent: 1,
                                  ),


                                ],
                              ),
                            ),
                            onTap:()async {

                            }
                        );
                    }
                ),
              ),
            ),
            ),
            Container(
              height: loading?20:0,
              width:double.infinity,
              child: Center(
                  child:CircularProgressIndicator()
              ),
            )
          ],
        ),
      ),
    );
  }
}
