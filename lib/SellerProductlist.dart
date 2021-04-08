import 'dart:convert';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/SellerProductview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class SellerProductlist extends StatefulWidget {
  @override
  _SellerProductlist createState() => _SellerProductlist();
}
class _SellerProductlist extends State<SellerProductlist> {

  @override
  void initState() {
    super.initState();
   sample();
  }
  Future <void> sample()async{
    await profile();
   await productlist();
  }
  var listprofile;
  var uid;
  Future<void>profile() async{
    var url=Prefmanager.baseurl+'/user/me';
    var token=await Prefmanager.getToken();
    print("Profile");
    print(token);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token,
    };
    var response = await http.post(url,headers:requestHeaders);
    print(json.decode(response.body));
    if(json.decode(response.body)['status'])
    {
       uid=json.decode(response.body)['data']['sellerid']['uid'];
      print(uid);
    }
    else
      Fluttertoast.showToast(msg:json.decode(response.body)['msg'],);
    setState(() {});
  }
  List product=[];
  bool progress=true;
  var length;
  int page=1,limit=10;
  Future<void>productlist() async{
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    Map data = {
      'userid':uid,
      'limit':limit.toString(),
      'page':page.toString(),
    };

    print(data);
    var body = json.encode(data);
    var url=Prefmanager.baseurl+'/product/list';
    var response = await http.post(url,headers:requestHeaders,body:body);
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
      length = json.decode(response.body)['totalLength'];
      for (int i = 0; i < json.decode(response.body)['data'].length; i++)
        product.add(json.decode(response.body)['data'][i]);
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
    List f=[];
    FlutterMoneyFormatter fmf;
    MoneyFormatterOutput fo;
    for(int i=0;i<product.length;i++) {
      fmf = FlutterMoneyFormatter(
          amount: product[i]['price'].toDouble());
      fo = fmf.output;
      f.add(fo);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("All Products",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:16,fontWeight: FontWeight.w600),)),
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
            product.isEmpty?
            Center(child: Text("No products added yet",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w500),)))
            :Expanded(child:NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!loading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  if(length>product.length){
                    print(length);
                    print(product.length);
                    productlist();
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
                    itemCount: product.length,
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
                                            Image(image:product[index]['photos']==null||product[index]['photos'].isEmpty?NetworkImage(Prefmanager.baseurl+"/file/get/noimage.jpg"):NetworkImage(Prefmanager.baseurl+"/file/get/"+product[index]['photos'][0]),fit:BoxFit.fill,height:70,width:90,),
                                            Expanded(
                                                child:Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal:15.0),
                                                  child: Column(
                                                      children:[
                                                        Row(
                                                          children:[
                                                            Text(product[index]['name'],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF808080),fontSize:12,fontWeight: FontWeight.w700),)),

                                                          ],
                                                        ),
                                                        Row(
                                                          children:[
                                                            Expanded(child: Text(product[index]['description'],maxLines:2,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF6A6A6A),fontSize:11,fontWeight: FontWeight.w300),))),

                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height:3,
                                                        ),
                                                        Row(
                                                            children:[
                                                              Text("Price: ₹ "+f[index].nonSymbol,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:11,fontWeight: FontWeight.w700),)),

                                                            ]

                                                        ),
                                                        SizedBox(
                                                          height:3,
                                                        ),
                                                        Row(
                                                            children:[
                                                              Text("Stock: "+product[index]['stockQuantity'].toString()+" Pieces",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF188320),fontSize:11,fontWeight: FontWeight.w400),)),

                                                            ]

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
                             await Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SellerProductview(product[index]['_id'])));
                             setState(() {
                               progress=true;
                             });
                            product.clear();
                            page=1;
                           await productlist();
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
