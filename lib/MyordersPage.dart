import 'dart:convert';
import 'package:eram_app/CustomerOrderDetail.dart';
import 'package:eram_app/Prefmanager.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
class MyordersPage extends StatefulWidget {
  @override
  _MyordersPage  createState() => _MyordersPage ();
}
class _MyordersPage  extends State<MyordersPage > {
  final _formKey = GlobalKey<FormState>();
  void initState() {
    super.initState();
    orderList();
  }
  var d=new DateFormat('dd MMM, yyyy');
  bool progress=true;
  int page=1,limit=10;
  List order=[];
  var length;
  Future<void>orderList() async{
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token,

    };
    Map data = {
      'page':page.toString(),
      'limit':limit.toString()
    };
    print(data);
    var body = json.encode(data);
    var url=Prefmanager.baseurl+'/my/orders/products/list';
    var response = await http.post(url,headers:requestHeaders,body: body);
    print(json.decode(response.body));
    print("order");
    if(json.decode(response.body)['status']) {
      length = json.decode(response.body)['totalLength'];
      for (int i = 0; i < json.decode(response.body)['data'].length; i++)
        order.add(json.decode(response.body)['data'][i]);
        page++;
        setState(() {

        });

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
  bool hasPressed=false;
  @override
  Widget build(BuildContext context) {
    List f=[];
    FlutterMoneyFormatter fmf;
    MoneyFormatterOutput fo;
    for(int i=0;i<order.length;i++) {
      fmf = FlutterMoneyFormatter(
          amount: order[i]['productTotalAmount'].toDouble());
      fo = fmf.output;
      f.add(fo);
    }
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Text("Orders", style: GoogleFonts.poppins(textStyle: TextStyle(
              color: Color(0xFF000000),
              fontSize: 16,
              fontWeight: FontWeight.w600),)),
          automaticallyImplyLeading: true,
        ),

        body:
        //progress?Center(child:CircularProgressIndicator(),):
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
                          Container(
                            width: 40.0,
                            height: 8.0,
                            color: Colors.white,
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
        Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height:20),
                order.isEmpty?
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      SizedBox(height:MediaQuery.of(context).size.height/6),
                      Image(image:AssetImage('assets/shoppingcart.png'),height: 200,),
                      Text("No orders yet!",style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.black,fontSize:16,fontWeight: FontWeight.w600))),

                    ] )
               : Expanded(
                 child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
        if (!loading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
        if(length>order.length){
        orderList();
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
                              itemCount:order.length,
    itemBuilder: (BuildContext context,int index){
                            return
                              InkWell(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal:15.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 5,
                                            ),

                                            Expanded(
                                              child: new Row(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .center,
                                                children: [
                                                  Image(image:order[index]['productId']['photos']==null||order[index]['productId']['photos'].isEmpty?NetworkImage(Prefmanager.baseurl+"/file/get/noimage.jpg"):NetworkImage(Prefmanager.baseurl+"/file/get/"+order[index]['productId']['photos'][0]),
                                                      height: 60,
                                                      width: 60,
                                                      fit: BoxFit.fill),
                                                  Expanded(
                                                    child: Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 15.0),
                                                        child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                      order[index]['name'],
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        textStyle: TextStyle(
                                                                            color: Color(
                                                                                0xFF000000),
                                                                            fontSize: 10,
                                                                            fontWeight: FontWeight
                                                                                .w700),)),

                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(flex:1,
                                                                    child: Text(order[index]['description'],maxLines:2,
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                          textStyle: TextStyle(
                                                                              color: Color(
                                                                                  0xFF6A6A6A),
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight
                                                                                  .w300),)),
                                                                  ),
                                                                          Spacer(),InkWell(child: Icon(Icons.keyboard_arrow_right,size:20,color: Color(0xFF818181),),
                                                                  onTap: ()async{ await Navigator.push(context,new MaterialPageRoute(builder: (context)=>new CustomerOrderDetail(order[index]['_id'],order[index]['order_id'],order[index]['productId']['_id'])));
                                                                  setState(() {
                                                                    progress=true;
                                                                  });
                                                                  page=1;
                                                                  order.clear();

                                                                  await orderList();

                                                                  },

                                                                  )
                                                                ],
                                                              ),

                                                              Row(
                                                                  children: [
                                                                     Text("₹ " +
                                                                         f[index].nonSymbol,
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                          textStyle: TextStyle(
                                                                              color: Color(
                                                                                  0xFF000000),
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight
                                                                                  .w600),)),

                                                                  ]

                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),

                                                            ])
                                                    ),

                                                  )
                                                ],
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      SizedBox(height:10),
                                      Padding(
                                        padding: const EdgeInsets.only(left:18.0,right:18),
                                        child: Container(
                                            color:Color(0xFFF7F7F7),
                                            width:MediaQuery.of(context).size.width,
                                            height:30,
                                            child:Row(
                                   children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left:20.0),
                                        child: Icon(Icons.border_all),

                                      ),
                                     SizedBox(width:20),
                                     Padding(
                                       padding: const EdgeInsets.only(left:12.0),
                                       child: Text(order[index]['productOrderStatus'],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF006CFF),fontSize:9,fontWeight: FontWeight.w600))),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.only(left:16.0),
                                       child: Text(d.format(DateTime.parse(order[index]['order_date'])),style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF262626),fontSize:9,fontWeight: FontWeight.w300))),
                                     ),
                                   ],
                            )
                                        ),
                                      ),
                                      // SizedBox(height:10),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(right:16.0),
                                      //   child: Row(
                                      //     mainAxisAlignment: MainAxisAlignment.end,
                                      //     children: [
                                      //       Text("CANCEL ORDER",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:9,fontWeight: FontWeight.w500))),
                                      //     ],
                                      //   ),
                                      // ),
                                      Divider(
                                        height: 30,
                                        thickness: 1,
                                        indent: 1,
                                      ),
                                    ],
                                  ),
                                  onTap: ()async {
                                    await Navigator.push(context,new MaterialPageRoute(builder: (context)=>new CustomerOrderDetail(order[index]['_id'],order[index]['order_id'],order[index]['productId']['_id'])));
                                    setState(() {
                                      progress=true;
                                    });
                                    page=1;
                                    order.clear();
                                    await orderList();

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
            )));
  }}