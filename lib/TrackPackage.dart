import 'package:eram_app/OrderDetails.dart';
import 'package:eram_app/ReturnItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:eram_app/Prefmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class  TrackPackage extends StatefulWidget {
  final productid,orderid;
  TrackPackage(this.productid,this.orderid);
  @override
  _TrackPackage createState() => _TrackPackage();
}
class _TrackPackage extends State<TrackPackage> {
  void initState() {
    super.initState();
    orders();
  }
  var d=new DateFormat('dd MMMM, yyyy');
  var d1=new DateFormat('dd-MMM-yyyy');
  var d2=new DateFormat('dd MMMM yyyy');
  var product,orderdetails;
  List status1=[];
  String status;
  bool progress=true;
  Future<void>orders() async{
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token,

    };
    Map data = {
      'productid':widget.productid,
      'orderid':widget.orderid
    };
    print(data);
    print(widget.productid);
    print(widget.orderid);
    var body = json.encode(data);
    var url=Prefmanager.baseurl+'/my/order/product/track';
    var response = await http.post(url,headers:requestHeaders,body: body);
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
      product=json.decode(response.body)['product'];
      orderdetails=json.decode(response.body)['orderDetails'];
      for (int i = 0; i < json.decode(response.body)['product']['trackDetails'].length; i++)
      status1=json.decode(response.body)['product']['trackDetails'];
    }
    else
      Fluttertoast.showToast(
        msg:json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress=false;

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    FlutterMoneyFormatter fmf;
    MoneyFormatterOutput fo;
    fmf = FlutterMoneyFormatter(
        amount: progress?0:product['offerPrice'].toDouble());
    fo = fmf.output;
    FlutterMoneyFormatter fmf1;
    MoneyFormatterOutput fo1;
    fmf1 = FlutterMoneyFormatter(
        amount: progress?0:product['productSubTotal'].toDouble());
    fo1 = fmf1.output;
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Text("Track Package",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:16,fontWeight: FontWeight.w600),)),
          automaticallyImplyLeading: true,
        ),

        body:  //progress?Center(child:CircularProgressIndicator(),):
        progress?SingleChildScrollView(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              //enabled: progress,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(height:150,width:double.infinity,color:Colors.white),
                    SizedBox(height:10),
                    Container(height:250,width:double.infinity,color:Colors.white),
                    SizedBox(height:10),
                    Container(height:100,width:double.infinity,color:Colors.white),
                    SizedBox(height:10),
                    Container(height:150,width:double.infinity,color:Colors.white),
                    SizedBox(height:10),
                    Container(height:50,width:double.infinity,color:Colors.white),
                    SizedBox(height:10),
                    Container(height:50,width:double.infinity,color:Colors.white),
                    SizedBox(height:10)
                  ]),
            ))
        :SingleChildScrollView(
            child: Column(
                children: [
                  InkWell(
                      child: Column(
                        children: [
                          SizedBox(height:10),
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
                                  padding: const EdgeInsets.symmetric(horizontal:12.0),
                                  child: new Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children:[

                                      Image(image:product['productId']['photos']==null||product['productId']['photos'].isEmpty?NetworkImage(Prefmanager.baseurl+"/file/get/noimage.jpg"):NetworkImage(Prefmanager.baseurl+"/file/get/"+product['productId']['photos'][0]),height:115,width:MediaQuery.of(context).size.width/3 ,fit:BoxFit.fill),
                                      Expanded(
                                          child:Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Column(
                                                children:[
                                                  SizedBox(height:7),
                                                  Row(
                                                    children:[
                                                      Text(product['name'],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:12,fontWeight: FontWeight.w700),)),

                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:1,
                                                  ),
                                                  Row(
                                                      children:[
                                                        Text("₹ "+fo.nonSymbol,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:11,fontWeight: FontWeight.w500),)),
                                                      ]

                                                  ),


                                                ]
                                            ),
                                          )
                                      ),
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
                      onTap:() {
                        //Navigator.push(context,new MaterialPageRoute(builder: (context)=>new VieweachProduct(profile[index]['_id'],profile[index]['seller']['_id'],widget.deldate)));
                      }
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.border_all,color:Color(0xFF1FA82A)),SizedBox(width:10),
                            Text(product['productOrderStatus']+" ",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w600),)),
                            product['track_dateTime']!=null&&product['track_dateTime'][product['productOrderStatus']]!=null?Text(d.format(DateTime.parse(product['track_dateTime'][product['productOrderStatus']])),style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w600),)):SizedBox.shrink()
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:16.0),
                    child: Column(
                      children: new List.generate(status1.length,(index){
                          return new Column(
                            children: <Widget>[
                             // SizedBox(height: 10,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Column(
                                children: [
                                  new Container(
                                    margin: EdgeInsets.only(top: 16),
                                  height: 10.0,
                                    width: 10.0,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: status1[index]['coloured']==true?Color(0xFFFC4B4B):Color(0xFFE5E5E5)
                                    ),),
                                   index==status1.length-1?SizedBox.shrink()
                                  :new Container(
                                    height: 30,
                                    width: 1.0,
                                    color:index==0? status1[index+1]['coloured']==true?Color(0xFFFC4B4B):Color(0xFFE5E5E5):status1[index-1]['coloured']&&status1[index+1]['coloured']?Color(0xFFFC4B4B):Color(0xFFE5E5E5),
                                  //color:Colors.red,
                                  ),
                                ],
                              ),

                              SizedBox(width:20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(status1[index]['name'],style: GoogleFonts.poppins(textStyle:TextStyle(color:status1[index]['coloured']==true?Color(0xFF393939):Color(0xFFD0D0D0),fontSize:13,fontWeight: FontWeight.w500),)),
                                  Text(status1[index]['dateTime']!=null?d2.format(DateTime.parse(status1[index]['dateTime'])):"",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF393939),fontSize:11,fontWeight: FontWeight.w500),)),
                                ],
                              )
                            ],
                          ),
                             // SizedBox(height: 20,),
                            ],
                          );

                        },

                      ),
                    ),
                  ),
    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   children: [
    //     Container(
    //       height: 200,
    //       alignment: Alignment.topLeft,
    //
    //       child: Timeline.tileBuilder(
    //
    //         physics: NeverScrollableScrollPhysics(),
    //       builder: TimelineTileBuilder.fromStyle(
    //       contentsAlign: ContentsAlign.basic,
    //       contentsBuilder: (context, index) => Padding(
    //       padding: const EdgeInsets.all(10.0),
    //       child:Column(
    //         children:[
    //           index==0?Text("Item Ordered"):
    //           index==1?Text("Item Packed"):
    //           index==2?Text("Item Shipped"):
    //           index==3?Text("Out for Delivery"):
    //             Text("Item Delivered")
    //         ]
    //       ),
    //       ),
    //       itemCount: 5,
    //       ),
    //       ),
    //     ),
    //   ],
    // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:5.0),
                    child: Card(
                        child:Padding(
                          padding: const EdgeInsets.symmetric(horizontal:8.0),
                          child: Column(
                            children: [
                              SizedBox(height:15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Order Date',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF393939),fontSize:12,fontWeight: FontWeight.w400),)),
                                  Spacer(),Text(d1.format(DateTime.parse(orderdetails['create_date'])),style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400),)),

                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Order ID',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF393939),fontSize:12,fontWeight: FontWeight.w400),)),
                                  Spacer(),Text(orderdetails['orderID'],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400),)),

                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Total Amount',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF393939),fontSize:12,fontWeight: FontWeight.w400),)),
                                  Spacer(),Text('₹ '+fo1.nonSymbol+" ("+product['quantity'].toString()+" Item)",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400),)),

                                ],
                              ),
                              SizedBox(height:15)
                            ],
                          ),
                        )
                    ),
                  ),
                 SizedBox(height:5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:5.0),
                    child: Card(
                        child:Padding(
                          padding: const EdgeInsets.symmetric(horizontal:8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height:15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Shipping Address',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF393939),fontSize:12,fontWeight: FontWeight.w600),)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5,),
                                  Text(orderdetails['deliveryAddress']['firstName']+' '+orderdetails['deliveryAddress']['lastName'],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400),)),
                                  Text(orderdetails['deliveryAddress']['address'],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400),)),
                                  Text(orderdetails['deliveryAddress']['city']+','+orderdetails['deliveryAddress']['state'],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400),)),
                                  Text(orderdetails['deliveryAddress']['pincode'],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400),)),
                                  SizedBox(height:10),
                                  Text('Contact',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF393939),fontSize:12,fontWeight: FontWeight.w600),)),
                                  SizedBox(height: 5,),
                                  Text(orderdetails['deliveryAddress']['mobile'],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400),)),
                                ],
                              ),
                              SizedBox(height:15)

                            ],
                          ),
                        )
                    ),
                  ),
                  SizedBox(height:5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:8.0),
                    child: Container(
                        height: 40,
                        width:MediaQuery.of(context).size.width,
                        child:FlatButton(
                          color: Color(0xFFFFFFFF),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Color(0xFFF0F0F0)),
                              borderRadius: BorderRadius.circular(3.0)),
                          child: Text('Return or Replace Item',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:12,fontWeight: FontWeight.w400),)),
                          onPressed: ()async {
                            if(product['productOrderStatus']=='delivered'){
                              await Navigator.push(context,new MaterialPageRoute(builder: (context)=>new ReturnItem(widget.productid,widget.orderid)));
                               await orders();
                            }
                            else if(product['productOrderStatus']=='returned')
                              Fluttertoast.showToast(
                                msg:"Already returned",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,

                              );
                            else
                              Fluttertoast.showToast(
                                msg:"Only delivered products are able to replace",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,

                              );
                          },
                        )),

                  ),
                  SizedBox(height:8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:8.0),
                    child: Container(
                        height: 40,
                        width:MediaQuery.of(context).size.width,
                        child:FlatButton(
                          color: Color(0xFFFFFFFF),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Color(0xFFF0F0F0)),
                              borderRadius: BorderRadius.circular(3.0)),
                          child: Text('View Order Details',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:12,fontWeight: FontWeight.w400),)),
                          onPressed: () {
                            Navigator.push(context,new MaterialPageRoute(builder: (context)=>new OrderDetails(widget.productid,widget.orderid)));
                          },
                        )),

                  ),
                  SizedBox(height:30),
                ])));
  }
}
