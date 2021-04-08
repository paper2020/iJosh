
import 'package:eram_app/ReturnItem.dart';
import 'package:eram_app/TrackPackage.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:eram_app/OrderDetails.dart';
import 'package:eram_app/Prefmanager.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
class  CustomerOrderDetail extends StatefulWidget {
  final productid,orderid,productrid;
  CustomerOrderDetail(this.productid,this.orderid,this.productrid);
  @override
  _CustomerOrderDetail createState() => _CustomerOrderDetail();
}
class _CustomerOrderDetail extends State<CustomerOrderDetail> {
  void initState() {
    super.initState();
    getPermission();
     orders();
     ratingView();
  }
  getPermission() async {
    if (await Permission.contacts.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
    } else {
// You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      print(statuses[Permission.location]);
    }
  }
  var d=new DateFormat('dd MMMM, yyyy');
  var product;
  String status;
  bool progress=true;
  Future<void>  orders() async{
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
    var body = json.encode(data);
    var url=Prefmanager.baseurl+'/my/order/product/view';
    var response = await http.post(url,headers:requestHeaders,body: body);
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
        product=json.decode(response.body)['product'];
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
  bool loading=false;
  TextEditingController reviewController=TextEditingController();
  double initialrating=0.0;
  double _rating;
  var myrate,review,myrating;
  Future<void>  ratingView() async{
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    Map data = {
      'ratingType':'product',
      'productId':widget.productrid,
    };
    print(data);
    var body = json.encode(data);
    var url=Prefmanager.baseurl+'/my/rating/view';
    var response = await http.post(url,headers:requestHeaders,body: body);
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {

      myrate=json.decode(response.body)['data'];
      if (myrate != null) {
      myrating=json.decode(response.body)['data']['rating'].toDouble();
      _rating=json.decode(response.body)['data']['rating'].toDouble();
      review=json.decode(response.body)['data']['review'];
      reviewController.text=review;
    }
      }
    else
      Fluttertoast.showToast(
        msg:json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );


    setState(() {
    });
  }
  void deleteReview(var id) async{
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    Map data = {
      'ratingType':'product',
      'productId':id,
    };
    print(data);
    var body = json.encode(data);
    var url=Prefmanager.baseurl+'/rating/delete';
    var response = await http.post(url,headers:requestHeaders,body: body);
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
      Fluttertoast.showToast(
          msg: json.decode(response.body)['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 20.0
      );
      await ratingView();
     // await ratingList();
      reviewController.clear();
      _rating=null;
    }
    else
      Fluttertoast.showToast(
        msg:json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );


    setState(() {
    });
  }
  void _showDialog(var id) async{
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete this review",style: GoogleFonts.poppins(textStyle:TextStyle(fontSize: 12))),
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
  void _showDialog1() async{
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Cancel this order ",style: GoogleFonts.poppins(textStyle:TextStyle(fontSize: 12))),
          //content: new Text("This will delete your review"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            // new FlatButton(
            //   child: new Text("Cancel",style:GoogleFonts.poppins(textStyle:TextStyle())),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
            new FlatButton(
              child: new Text("OK",style: GoogleFonts.poppins(textStyle:TextStyle()),),
              onPressed: () {
                deleteOrder();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void  deleteOrder() async {
    var url = Prefmanager.baseurl+'/customer/order/product/cancel';
    var token = await Prefmanager.getToken();
    Map data = {
    'orderid':widget.orderid,
      'productid':widget.productid
    };
    print(data);
    var body = json.encode(data);
    var response = await http.post(
      url, headers: {"Content-Type": "application/json","token": token,},body: body);
    print(response.body);
    if (json.decode(response.body)['status']) {
      Fluttertoast.showToast(
          msg: json.decode(response.body)['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 20.0
      );
      //await Navigator.pushReplacement(context,new MaterialPageRoute(builder: (context)=>new MyordersPage()));
   //Navigator.of(context).pop(true);
      await orders();
    }
    else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: json.decode(response.body)['msg'],
          toastLength: Toast.LENGTH_SHORT,
          // gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 20.0
      );
      setState(() {

      });

    }
  }

  static Future<String> createFolderInAppDocDir() async {

    //Get this App Document Directory
    //final Directory _appDocDir = await getApplicationDocumentsDirectory();
    //App Document Directory + folder name
    final Directory _appDocDirFolder =  Directory('/storage/emulated/0/iJosh/');

    if(await _appDocDirFolder.exists()){ //if folder already exists return path
      return _appDocDirFolder.path;
    }else{//if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder=await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }


  Future<void> downloadSinglePdf(id) async {

    String dir = await createFolderInAppDocDir();
    //String dir = (await getApplicationDocumentsDirectory()).path;
    print(dir);
    File file = new File('$dir/$id.pdf');
    if (file.existsSync()) {
      print("bdsbj");
      print(Prefmanager.baseurl + '/order/invoice/pdf?orderid='+widget.orderid+'&productid='+widget.productid);

      await OpenFile.open(file.path);
    } else {
      var request = await http.get(
          Prefmanager.baseurl + '/order/invoice/pdf?orderid='+widget.orderid+'&productid='+widget.productid
      );

      print(request.statusCode);
      var bytes = request.bodyBytes; //close();
      await file.writeAsBytes(bytes);
      print("kbdsb");

      await OpenFile.open(file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    //var f;
    FlutterMoneyFormatter fmf;
    MoneyFormatterOutput fo;
      fmf = FlutterMoneyFormatter(
          amount: progress?0:product['offerPrice'].toDouble());
      fo = fmf.output;
     // f=(fo);

    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Text("Orders",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:16,fontWeight: FontWeight.w600),)),
          automaticallyImplyLeading: true,
        ),

        body: //progress?Center(child:CircularProgressIndicator(),):
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
                    Container(
                        width: double.infinity,
                        height: 50.0,
                        color:Colors.white
                    ),
                    SizedBox(height:10),
                    Container(height:150,width:double.infinity,color:Colors.white),
                    SizedBox(height:10),
                    Container(height:150,width:double.infinity,color:Colors.white),
                    SizedBox(height:10),
                    Container(height:150,width:double.infinity,color:Colors.white),
                    SizedBox(height:10),

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
                                                  SizedBox(height:10),
                                                  Container(
                                                      height: 40,
                                                     width:MediaQuery.of(context).size.width,
                                                      child:FlatButton(
                                                        color: Color(0xFFFFFFFF),
                                                        shape: RoundedRectangleBorder(
                                                            side: BorderSide(color: Color(0xFFF0F0F0)),
                                                            borderRadius: BorderRadius.circular(3.0)),
                                                        child: Text('Track Package',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:12,fontWeight: FontWeight.w400),)),
                                                        onPressed: ()async {
                                                          await Navigator.push(context,new MaterialPageRoute(builder: (context)=>new TrackPackage(widget.productid,widget.orderid)));
                                                        await orders();
                                                          },
                                                      )),

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
                    child: Row(
                      children: [
                        Icon(Icons.border_all,color:Color(0xFF1FA82A)),SizedBox(width:10),
                        Text(product['productOrderStatus']+" ",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w600),)),
                     // Text(product['productOrderStatus']=='ordered'&&product['track_dateTime']['ordered']!=null?d.format(DateTime.parse(product['track_dateTime']['ordered'])):product['productOrderStatus']=='packed'&&product['track_dateTime']['packed']!=null?product['track_dateTime']['packed']:product['productOrderStatus']=='shipped'&&product['track_dateTime']['shipped']!=null?product['track_dateTime']['shipped']:product['productOrderStatus']=='outfordelivery'?product['track_dateTime']['outfordelivery']:product['productOrderStatus']=='delivered'&&product['track_dateTime']['delivered']!=null?product['track_dateTime']['delivered']:product['productOrderStatus']=='cancelled'&&product['track_dateTime']['cancelled']!=null?product['track_dateTime']['cancelled']:product['productOrderStatus']=='returned'&&product['track_dateTime']['returned']!=null?product['track_dateTime']['returned']:"",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w600),))
                        product['track_dateTime']!=null&&product['track_dateTime'][product['productOrderStatus']]!=null?Text(d.format(DateTime.parse(product['track_dateTime'][product['productOrderStatus']])),style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w600),)):SizedBox.shrink()
                      ],
                    ),
                  ),
                  Divider(
                    height: 20,
                    thickness: 1,
                    indent: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:12.0),
                    child: Row(
                      children: [
                        Text('Need Help with your Order?',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w600),)),
                      ],
                    ),
                  ),
                  SizedBox(height:10),
                  product['productOrderStatus']=='ordered'|| product['productOrderStatus']=='packed'?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:12.0),
                    child: Container(
                        height: 40,
                        width:MediaQuery.of(context).size.width,
                        child:FlatButton(
                          color: Color(0xFFFFFFFF),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Color(0xFFF0F0F0)),
                              borderRadius: BorderRadius.circular(3.0)),
                          child: Text('Cancel Order',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:12,fontWeight: FontWeight.w400),)),
                          onPressed: () {
                            _showDialog1();
                          },
                        )),

                  )
                  :SizedBox.shrink(),
    SizedBox(height:10),
    Padding(
    padding: const EdgeInsets.symmetric(horizontal:12.0),
    child: Container(
    height: 40,
    width:MediaQuery.of(context).size.width,
    child:FlatButton(
    color: Color(0xFFFFFFFF),
    shape: RoundedRectangleBorder(
    side: BorderSide(color: Color(0xFFF0F0F0)),
    borderRadius: BorderRadius.circular(3.0)),
    child: Text('Return or Replace Item',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:12,fontWeight: FontWeight.w400),)),
    onPressed: () async{
      if(product['productOrderStatus']=='delivered') {
        await Navigator.push(context, new MaterialPageRoute(builder: (
            context) => new ReturnItem(widget.productid, widget.orderid)));
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
    )),),
                  SizedBox(height:5),
                  Divider(
                    height: 20,
                    thickness: 1,
                    indent: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:12.0),
                    child: Row(
                      children: [
                        Text('Order Info',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w600),)),
                      ],
                    ),
                  ),
                  SizedBox(height:10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:12.0),
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
                  SizedBox(height:10),
                  product['productOrderStatus']=='cancelled'|| product['productOrderStatus']=='cancelledbyseller'?
                  SizedBox.shrink()
                  :Padding(
                    padding: const EdgeInsets.symmetric(horizontal:12.0),
                    child: Container(
                        height: 40,
                        width:MediaQuery.of(context).size.width,
                        child:FlatButton(
                          color: Color(0xFFFFFFFF),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Color(0xFFF0F0F0)),
                              borderRadius: BorderRadius.circular(3.0)),
                          child: Text('Download Invoice',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:12,fontWeight: FontWeight.w400),)),
                          onPressed: () {
                           // _downloadFile();
                            downloadSinglePdf(widget.productid);
                          },
                        )),),
                  SizedBox(height:5),
                  Divider(
                    height: 20,
                    thickness: 1,
                    indent: 1,
                  ),
                  product['productOrderStatus']=='delivered'||product['productOrderStatus']=='returned'?
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:12.0),
                        child: Row(
                          children: [
                            Text('Add Rating & Review',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w600),)),
                          ],
                        ),
                      ),
                      SizedBox(height:15),
                      RatingBar.builder(
                        unratedColor: Color(0xFFE3E3E3),
                        initialRating: myrate==null?initialrating:myrating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 20.0,
                        itemPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,

                        ),
                        onRatingUpdate: (rating) {
                          _rating=rating;
                          print(_rating);

                        },

                      ),
                      SizedBox(height:20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(myrate==null?'Write a Review':'Your Review',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF444444),fontSize:14,fontWeight: FontWeight.w600))),
                            Spacer(),
                            myrate!=null?
                            InkWell(
                              child: Icon(
                                Icons.close,color: Colors.grey,
                              ),
                              // iconSize: 20,

                              onTap: () {
                                _showDialog(widget.productrid);
                              },
                            )
                                :SizedBox.shrink()
                          ],
                        ),

                      ),
                      SizedBox(height:10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:12.0),
                        child: TextFormField(
                          validator: (value) {

                            if (value.isEmpty) {
                              return 'Please enter review';
                            }
                            else{
                              return null;
                            }

                          },
                          autofocus: false,
                          controller: reviewController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.edit)
                          ),
                        ),
                      ),

                      progress1?Center( child: CircularProgressIndicator(),):
                      FlatButton(
                        //width:114,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Color(0xFFD2D2D2)),
                            borderRadius: BorderRadius.circular(7.0)),

                        height: 36,
                        minWidth:152,
                        color: Color(0xFFFC4B4B),
                        child: Text(myrate==null?'Add Your Review':'Edit Your Review',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFFFFFFF),fontSize:13,fontWeight: FontWeight.w600))),
                        onPressed: () {
                          // ratingView();
                          print(_rating);
                          if(_rating==null)
                            Fluttertoast.showToast(
                              msg:"Please select rating",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                            );
                          else
                            senddata();
                        },
                      ),
                    ],
                  )
:SizedBox.shrink()
                ])));
  }
  bool progress1=false;
  bool check=false;
  void senddata() async {
    setState(() {
      progress1=true;
    });
    try{
      String token = await Prefmanager.getToken();
      var url = Prefmanager.baseurl+'/rating/add/update';
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': token
      };

      Map data={
        'ratingType':'product',
        'productId':widget.productrid,
        'rating':_rating,
        'review':reviewController.text

      };
      print(data);
      var body=json.encode(data);
      var response = await http.post(url,headers:requestHeaders,body: body);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if(json.decode(response.body)['status'])
        {
          print((json.decode(response.body)['token']));
          String token = await Prefmanager.getToken();
          print(token);

          ratingView();
          //reviewController.clear();


          // Navigator.push(
          //     context, new MaterialPageRoute(
          //     builder: (context) => new ReviewPage(widget.pid, widget.name)));
        }

        else{
          Fluttertoast.showToast(
            msg:json.decode(response.body)['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,

          );
          setState(() {
            progress1=true;
          });
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
    progress1=false;
  }
}
