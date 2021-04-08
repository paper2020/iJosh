import 'dart:convert';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/SellerEachOrderView.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
class RecentOrders extends StatefulWidget {
  final productstatus;
  RecentOrders(this.productstatus);
  @override
  _RecentOrders  createState() => _RecentOrders();
}
class _RecentOrders  extends State<RecentOrders> {
  final _formKey = GlobalKey<FormState>();
  void initState() {
    super.initState();
     recentOrders();
     print(widget.productstatus);
  }
  bool progress1=true;
  //int page=1, limit=10;
  List recent=[];
  var length,pending;
  Future<void>recentOrders() async{
    var url=Prefmanager.baseurl+'/seller/ordered/products/list';
    var token=await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token,
    };
    Map data = {
      'productOrderStatus':widget.productstatus,
      'filterType':_selectedLocation=='Today'?'today':_selectedLocation=='This Week'?'thisweek':_selectedLocation=='This Month'?'thismonth':_selectedLocation=='Last 6 Months'?'lastsixmonths':_selectedLocation=='This Year'?'thisyear':null

    };
    print(data);
    var body = json.encode(data);
    var response = await http.post(url,headers:requestHeaders,body:body);
    print(json.decode(response.body));
    if(json.decode(response.body)['status'])
    {
      length=json.decode(response.body)['totalLength'];
      pending=json.decode(response.body)['orderStatusPending'];
      recent.clear();
      for (int i = 0; i < json.decode(response.body)['data'].length; i++) {
        recent.add(json.decode(response.body)['data'][i]);
        //page++;

      }
    }
    else
      Fluttertoast.showToast(msg:json.decode(response.body)['msg'],);
    progress1=false;
    setState(() {});
  }
  bool loading=false;
  List<String> _locations = ['Today', 'This Week','This Month', 'Last 6 Months','This Year', 'All']; // Option 2
  String _selectedLocation; // Option 2
  @override
  Widget build(BuildContext context) {
    List f=[];
    FlutterMoneyFormatter fmf;
    MoneyFormatterOutput fo;
    for(int i=0;i<recent.length;i++) {
      fmf = FlutterMoneyFormatter(
          amount: recent[i]['productTotalAmount'].toDouble());
      fo = fmf.output;
      f.add(fo);
    }
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),

        body://progress1?Center(child:CircularProgressIndicator(),):
        progress1?Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      enabled: progress1,
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
        SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      widget.productstatus=='ordered'?
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(pending.toString() + " Order Status Pending",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFCE1616),fontSize:11,fontWeight: FontWeight.w600),)),
                        ],
                      ):SizedBox.shrink(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            child: DropdownButton(
                              hint: Text('Filter',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF8B8B8B),fontSize:12,fontWeight: FontWeight.w500),)), // Not necessary for Option 1
                              value: _selectedLocation,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedLocation = newValue;
                                  print(_selectedLocation);
                                  recent.clear();
                                  recentOrders();
                                });
                              },
                              items: _locations.map((location) {
                                return DropdownMenuItem(
                                  child: new Text(location),
                                  value: location,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  recent.isEmpty?
                  Center(child: Text("No recent orders",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w500),)))
                 : NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!loading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                        if(length>recent.length){
                          //recentOrders();
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
                    child: Column(
                      children: List.generate(recent.length, (index) {
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
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children:[
                                              Image(image:recent[index]['productId']['photos']==null||recent[index]['productId']['photos'].isEmpty?NetworkImage(Prefmanager.baseurl+"/file/get/noimage.jpg"):NetworkImage(Prefmanager.baseurl+"/file/get/"+recent[index]['productId']['photos'][0]),height:75,width:95 ,fit:BoxFit.fill),
                                              Expanded(
                                                  child:Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Column(
                                                        children:[
                                                          SizedBox(height:7),
                                                          Row(
                                                            children:[
                                                              Text(recent[index]['name'],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF808080),fontSize:12,fontWeight: FontWeight.w700),)),

                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height:1,
                                                          ),
                                                          Row(
                                                              children:[
                                                                Text("Price: ₹ "+f[index].nonSymbol,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:11,fontWeight: FontWeight.w700),)),
                                                              ]

                                                          ),
                                                          // SizedBox(
                                                          //   height:5,
                                                          // ),
                                                          SizedBox(
                                                            height:5,
                                                          ),
                                                          Row(
                                                              children:[
                                                                Text("Qty: "+recent[index]['quantity'].toString()+" Pieces",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF188320),fontSize:9,fontWeight: FontWeight.w400),)),
                                                              ]
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                              children:[
                                                                Text(timeago.format(
                                                                  DateTime.now().subtract(new Duration(minutes:DateTime.now().difference(DateTime.parse(recent[index]['order_date'])).inMinutes)),),style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:9,fontWeight: FontWeight.w300))),
                                                              ]
                                                          ),
                                                          // SizedBox(
                                                          //   height:50
                                                          // ),

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

                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 20,
                                    thickness: 1,
                                    indent: 1,
                                  ),
                                ],
                              ),
                              onTap: () async{
                                 await Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SellerEachOrderview(recent[index]['_id'],recent[index]['order_id'])));
                                 await recentOrders();
                              }
                          );
                      }
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
              )),
        ));
  }}