import 'dart:convert';
import 'dart:io';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/SellerOfferview.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class SellerOfferslist extends StatefulWidget {
  @override
  _SellerOfferslist createState() => _SellerOfferslist();
}
class _SellerOfferslist extends State<SellerOfferslist> {

  @override
  void initState() {
    super.initState();
    sample();
  }
  Future <void> sample()async{
    await offersList();
  }
var a;
  List offer=[];
  bool progress=true;
  var length;
  int page=1,limit=10;
  Future<void>offersList() async{
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    Map data = {

      'limit':limit.toString(),
      'page':page.toString(),
    };

    print(data);
    var body = json.encode(data);
    var url=Prefmanager.baseurl+'/seller/my/offer/list';
    var response = await http.post(url,headers:requestHeaders,body:body);
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
      length = json.decode(response.body)['totalLength'];
      for (int i = 0; i < json.decode(response.body)['data'].length; i++)
        offer.add(json.decode(response.body)['data'][i]);
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
  bool selected=true;
  bool loading=false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("My Offers",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:16,fontWeight: FontWeight.w600),)),
        leading: IconButton (icon:Icon(Icons.arrow_back),
          onPressed:() => Navigator.pop(context,true),
        ),
      ),

      body: SafeArea(
        child:// progress?Center( child: CircularProgressIndicator(),):
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
                                    Container(
                                      alignment: Alignment.bottomRight,
                                      width: 40.0,
                                      height: 8.0,
                                      color: Colors.white,
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height:5),
            offer.isEmpty?
            Center(child: Text("No offers added yet",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w500),)))
                :Expanded(child:NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!loading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  if(length>offer.length){
                    offersList();
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
                    itemCount:offer.length,
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
                                            Checkbox(
                                              value: offer[index]['status']=='active'?true:false,
                                              //value:checkValue[index],
                                              activeColor: Colors.green,
                                              onChanged:(bool newValue){
                                                setState(() {
                                                  //checkValue[index] = newValue;
                                                  a=offer[index]['_id'];
                                                  senddata3(a);
                                                });
                                              },
                                            ),
                                            Stack(
                                                alignment: Alignment.center,

                                                children:[ Container(  width:60,child: Image(image:offer[index]['photo']==null||offer[index]['photo'].isEmpty?NetworkImage(Prefmanager.baseurl+"/file/get/noimage.jpg"):NetworkImage(Prefmanager.baseurl+"/file/get/"+offer[index]['photo']),fit:BoxFit.fill,height:68,width:68,)),
                                                  offer[index]['status']=='inactive'?
                                                  Positioned(
                                                    child: Card(
                                                        elevation:5,
                                                        child: Container(
                                                          width:60,
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                  children:[
                                                                    Expanded(child: Text("Item",textAlign:TextAlign.center,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFE23636),fontSize:8,fontWeight: FontWeight.w400))))
                                                                  ]
                                                              ),
                                                              Row(
                                                                  children:[
                                                                    Align(
                                                                        alignment: Alignment.center,
                                                                        child: Text("   Disabled",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFE23636),fontSize:8,fontWeight: FontWeight.w400,),)))
                                                                  ]
                                                              )
                                                            ],

                                                          ),
                                                        )
                                                    ),
                                                  )
                                                      :SizedBox.shrink()
                                                ]
                                            ),
                                            Expanded(
                                                child:Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal:15.0),
                                                  child: Column(
                                                      children:[
                                                        Row(
                                                          children:[
                                                            Text(offer[index]['name'],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF808080),fontSize:12,fontWeight: FontWeight.w700),)),

                                                          ],
                                                        ),
                                                        Row(
                                                          children:[
                                                            Expanded(child: Text(offer[index]['description'],maxLines:2,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF6A6A6A),fontSize:11,fontWeight: FontWeight.w300),))),

                                                          ],
                                                        ),


                                                      ]
                                                  ),
                                                )
                                            ),

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
                            ),
                            onTap:()async {
                              await Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SellerOfferview(false,offer[index]['_id'])));
                              setState(() {
                                progress=true;
                              });
                              offer.clear();
                              page=1;
                              await offersList();
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
  var status;
  void senddata3(var id) async {
    try{
      String token = await Prefmanager.getToken();
      var url = Prefmanager.baseurl+'/seller/offer/status/change/'+id;
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': token,
      };

      var response = await http.post(url,headers: requestHeaders);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if(json.decode(response.body)['status'])
        {

          setState(() {
            page=1;
            offer.clear();
            offersList();
          });

          //   Navigator.push(
          //         context, new MaterialPageRoute(
          //         builder: (context) => new StocksPage(widget.id)));
        }

        else{
          // Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SearchProduct(keyword.text,searchMsg))).then((value) {
          //   //This makes sure the textfield is cleared after page is pushed.
          //
          // });
          print(json.decode(response.body)['msg']);
          // Fluttertoast.showToast(
          //   msg:json.decode(response.body)['msg'],
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.CENTER,
          //
          // );
        }
      }
      else {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
    on SocketException catch(e){
      print(e.toString());
    }
    catch(e){
      print(e.toString());
    }

  }
}
