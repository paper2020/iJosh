import 'dart:io';
import 'dart:convert';
import 'dart:ui';
import 'package:eram_app/OrderSummary.dart';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/ProductDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class CartPage extends StatefulWidget {
  @override
  _CartPage createState() => _CartPage();
}
class _CartPage extends State<CartPage> {
  final _formKey = GlobalKey<FormState>();
  void initState() {
    super.initState();
    _controller.text = "1";
    test();

  }
  Future test()async{
   await cartList();
    await saveList();
  }
var _mySelection;
  bool buttoncheck=false;
  List cart=[];
  //List colorList=[];
  var delfee,tax,total,cartlength,status;
  bool statuscheck=false;
  List q1=[];
  bool progress=true;
  Future<void>  cartList() async{
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    Map data = {
      'type':'cart',
      //'productStatus':'active'
    };
    print(data);
    var body = json.encode(data);
    var url=Prefmanager.baseurl+'/cart/list';
    var response = await http.post(url,headers:requestHeaders,body:body);
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
      // for (int i = 0; i < json.decode(response.body)['cart'].length; i++)
      //   cart.add(json.decode(response.body)['cart'][i]);
      cartlength=json.decode(response.body)['cart_length'];
      total=json.decode(response.body)['priceDetails']['orderTotal'];
      delfee=json.decode(response.body)['priceDetails']['deliveryFee'];
      tax=json.decode(response.body)['priceDetails']['tax'];

      cart=json.decode(response.body)['cart'];
      // for (int i = 0; i < json.decode(response.body)['cart'][i]['productId']['colorDetails'].length; i++) {
      //   colorList.add( json.decode(response.body)['cart'][i]['productId']['colorDetails']);
      //
      // }
      // for (int i = 0; i < json.decode(response.body)['cart'].length; i++) {
      //   _mySelection= json.decode(response.body)['cart'][i]['color'];
      //  print(_mySelection);
      // }
      //colorList= json.decode(response.body)['cart']['productId']['colorDetails'];
      statuscheck=false;
      for (int i = 0; i < json.decode(response.body)['cart'].length; i++) {
        q1.add(json.decode(response.body)['cart'][i]['quantity']);
        print(q1);
        setState(() {
          if(cart[i]['productId']['status']=='active')
            statuscheck=true;
        });
      }
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
  bool pro=true;
  List save4=[];
  Future<void>  saveList() async{
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    Map data = {
      'type':'save4later',

    };
    print(data);
    var body = json.encode(data);
    var url=Prefmanager.baseurl+'/cart/list';
    var response = await http.post(url,headers:requestHeaders,body:body);
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
      // for (int i = 0; i < json.decode(response.body)['save4later'].length; i++)
      //   save4.add(json.decode(response.body)['save4later'][i]);
     save4=json.decode(response.body)['save4later'];

    }
    else
      Fluttertoast.showToast(
        msg:json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    pro=false;
    setState(() {
    });
  }
  void _showDialog(var id) async{
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Remove this product from cart ",style: GoogleFonts.poppins(textStyle:TextStyle(fontSize: 12))),
          //content: new Text("This will delete your review"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel",style:GoogleFonts.poppins(textStyle:TextStyle())),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Remove",style: GoogleFonts.poppins(textStyle:TextStyle()),),
              onPressed: () {
                deleteProduct(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void  deleteProduct(var id) async {
    var url = Prefmanager.baseurl+'/cart/remove/'+id;
    var token = await Prefmanager.getToken();

    //print(data.toString());

    var response = await http.post(
      url, headers: {"Content-Type": "application/json","token": token,},);
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

      cartList();
      setState(() {
        cart.removeWhere((element) => id==element['_id']);
        save4.removeWhere((element) => id==element['_id']);

      });

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
      //progress=false;
      pro = false;
      setState(() {

      });

    }
  }
  void checkstock(var msg) async{
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
         // title: new Text("Stock quantity of product is insufficient",style: GoogleFonts.poppins(textStyle:TextStyle(fontSize: 12))),
          title: new Text(msg,style: GoogleFonts.poppins(textStyle:TextStyle(fontSize: 12))),
          //content: new Text("This will delete your review"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

          ],
        );
      },
    );
  }
  void checkUnavailable() async{
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("This product is currently unavailable",style: GoogleFonts.poppins(textStyle:TextStyle(fontSize: 12))),
          //content: new Text("This will delete your review"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

          ],
        );
      },
    );
  }
  bool hasPressed=false;
  List qty=['1','2','3','4','5','6','7','8','9','10'];
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List f=[];
    FlutterMoneyFormatter fmf;
    MoneyFormatterOutput fo;
    for(int i=0;i<cart.length;i++) {
      fmf = FlutterMoneyFormatter(
          amount: cart[i]['offerPrice'].toDouble());
      fo = fmf.output;
      f.add(fo);
    }
    List f1=[];
    FlutterMoneyFormatter fmf1;
    MoneyFormatterOutput fo1;
    for(int i=0;i<save4.length;i++) {
      fmf1 = FlutterMoneyFormatter(
          amount: save4[i]['offerPrice'].toDouble());
      fo1 = fmf1.output;
      f1.add(fo1);
    }
    List f2=[];
    FlutterMoneyFormatter fmf2;
    MoneyFormatterOutput fo2;
    for(int i=0;i<cart.length;i++) {
      fmf2 = FlutterMoneyFormatter(
          amount: cart[i]['productId']['price'].toDouble()-cart[i]['offerPrice'].toDouble());
      fo2 = fmf2.output;
      f2.add(fo2);
    }
    List f3=[];
    FlutterMoneyFormatter fmf3;
    MoneyFormatterOutput fo3;
    for(int i=0;i<save4.length;i++) {
      print("p"+save4[i]['productId']['price'].toString());
      print("o"+save4[i]['offerPrice'].toString());
      fmf3 = FlutterMoneyFormatter(
          amount: save4[i]['productId']['price'].toDouble()-save4[i]['offerPrice'].toDouble());
      fo3 = fmf3.output;
      f3.add(fo3);

    }
    List f4=[];
    FlutterMoneyFormatter fmf4;
    MoneyFormatterOutput fo4;
    for(int i=0;i<cart.length;i++) {
      print(q1);
      fmf4 = FlutterMoneyFormatter(
          amount: cart[i]['offerPrice'].toDouble()*cart[i]['quantity']);
      fo4 = fmf4.output;
      f4.add(fo4);
    }
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Text("Cart",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:16,fontWeight: FontWeight.w600),)),
          leading: IconButton (icon:Icon(Icons.arrow_back),
            onPressed:() => Navigator.pop(context,true),
          ),
        ),

        body:
        //progress?Center( child: CircularProgressIndicator(),):
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
                                    SizedBox(height:5),
                                    Container(
                                      width: double.infinity,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    SizedBox(height:5),
                                    Container(
                                      width: double.infinity,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    SizedBox(height:5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          alignment: Alignment.bottomRight,
                                          width: 50.0,
                                          height: 8.0,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width:10),
                                        Container(
                                          alignment: Alignment.bottomRight,
                                          width: 50.0,
                                          height: 8.0,
                                          color: Colors.white,
                                        ),
                                      ],
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
        Form(
            key: _formKey,
            child: Column(
              children: [

                progress?Center( child: CircularProgressIndicator(),):
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                cart.isEmpty&&save4.isEmpty?
        Column(
        crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            SizedBox(height:MediaQuery.of(context).size.height/6),
            Image(image:AssetImage('assets/shoppingcart.png'),height: 100,),
            Text("Your cart is empty!",style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.black,fontSize:16,fontWeight: FontWeight.w600))),
            SizedBox(height:5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Looks like you haven't added",style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.black,fontSize:12,fontWeight: FontWeight.w400))),
              ],
            ),
            Text("anything to your cart yet.",style:
                 GoogleFonts.poppins(textStyle:TextStyle(color:Colors.black,fontSize:12,fontWeight: FontWeight.w400))),
          ] )
                        :Column(
                          children: List.generate(cart.length,(index){
                            List r=cart[index]['productId']['colorDetails']??[];
                            _mySelection= cart[index]['color'];
                                return
                                  InkWell(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                                    Stack(
                                                        alignment: Alignment.center,
                                                        children:[
                                                        Image(image:cart[index]['productId']['photos']==null||cart[index]['productId']['photos'].isEmpty?NetworkImage(Prefmanager.baseurl+"/file/get/noimage.jpg"):NetworkImage(Prefmanager.baseurl+"/file/get/"+cart[index]['productId']['photos'][0]),height:110,width:90,fit:BoxFit.fill),
                                                          cart[index]['productId']['status']=='inactive'|| cart[index]['productId']['status']=='deleted'?
                                                          Positioned(
                                                            child: Card(
                                                                elevation:5,
                                                                child: Container(
                                                                  width:85,
                                                                  height:35,
                                                                  child: Column(
                                                                    children: [
                                                                      SizedBox(height:3),
                                                                      Row(
                                                                          children:[

                                                                            Expanded(child: Text("Item",textAlign:TextAlign.center,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFE23636),fontSize:8,fontWeight: FontWeight.w400))))
                                                                          ]
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:MainAxisAlignment.center,
                                                                          children:[
                                                                            Align(
                                                                                alignment: Alignment.center,
                                                                                child: Text(cart[index]['productId']['status']=='deleted'?"Removed by Seller"  : "Disabled",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFE23636),fontSize:8,fontWeight: FontWeight.w400,),)))
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
                                                                    Text(cart[index]['productId']['name'],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w700),)),

                                                                  ],
                                                                ),
                                                                Row(
                                                                  children:[
                                                                    Expanded(child: Text(cart[index]['productId']['description'],maxLines:2,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF6A6A6A),fontSize:10,fontWeight: FontWeight.w300),))),

                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height:3,
                                                                ),
                                                                Row(
                                                                    children:[
                                                                      Text("Price: ₹ "+f[index].nonSymbol,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w700),)),
                                                                    SizedBox(width:10),
                                                                      Text("You Save:₹"+f2[index].nonSymbol,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF2DD986),fontSize:8,fontWeight: FontWeight.w300),)),
                                                                    ]

                                                                ),
                                                                SizedBox(
                                                                  height:3,
                                                                ),
                                                                Row(
                                                                    children:[
                                                                      Text("Shipping Charge: ₹"+cart[index]['shippingCharge'].toString(),style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w400),)),
                                                                      //SizedBox(width:100),
                                                                      Spacer(),

                                                                    ]
                                                                ),
                                                                SizedBox(
                                                                  height:3,
                                                                ),
                                                                Row(
                                                                    children:[
                                                                      Text("Seller: "+cart[index]['productId']['sellerId']['shopName'],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF6A6A6A),fontSize:10,fontWeight: FontWeight.w400))),
                                                                     //Spacer(), Text(cart[index]['productId']['status']=='inactive'?"Unavailable":"",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFD83D3D),fontSize:10,fontWeight: FontWeight.w700)))
                                                                    ]
                                                                ),
                                                                SizedBox(
                                                                  height:10
                                                                ),
                                                      //Text("Qty:"),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                                width: 100,
                                                                height:25,
                                                                foregroundDecoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(5.0),
                                                                  border: Border.all(
                                                                    color: Color(0xFFE2E2E2),
                                                                    width: 2.0,
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: <Widget>[
                                                                    Text("   Qty:",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF2A2A2A),fontSize:7,fontWeight: FontWeight.w400))),
                                                                    Expanded(
                                                                      child: DropdownButton(
                                                                        underline: SizedBox(),
                                                                        isExpanded: true,
                                                                       // hint: Text("Select",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF2A2A2A),fontSize:12,fontWeight: FontWeight.w400))),
                                                                        items: cart[index]['productId']['status']=='deleted'||cart[index]['productId']['status']=='inactive'?null:qty.map((s) {

                                                                          return new DropdownMenuItem<String>(
                                                                            child: new Text(s.toString()),
                                                                            value: s.toString(),
                                                                          );
                                                                        }).toList(),
                                                                        onChanged: (newVal) {
                                                                          progress3?Center(child:CircularProgressIndicator(),):
                                                                          setState(() {
                                                                            // _mySelection[index] = newVal;
                                                                           // print(_mySelection);

                                                                             senddata2(cart[index]['_id'],newVal,null);

                                                                          });
                                                                        },
                                                                        value:cart[index]['quantity'].toString(),
                                                                      ),
                                                                    ),

                                                                  ],
                                                                ),
                                                            ),
                                                          ),
                                                          SizedBox(width:5),
                                                          cart[index]['productId']['isColor']==true?
                                                         // colorList.isNotEmpty?
                                                          Expanded(
                                                            child: Container(
                                                              width: 100,

                                                              height:25,
                                                              foregroundDecoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(5.0),
                                                                border: Border.all(
                                                                  color: Color(0xFFE2E2E2),
                                                                  width: 2.0,
                                                                ),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: <Widget>[
                                                                  //for(int i=0;i<colorList.length;i++)
                                                                  Expanded(
                                                                    child: DropdownButton(
                                                                      underline: SizedBox(),
                                                                      isExpanded: true,
                                                                      // hint: Text("Select",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF2A2A2A),fontSize:12,fontWeight: FontWeight.w400))),
                                                                      items: cart[index]['productId']['status']=='deleted'||cart[index]['productId']['status']=='inactive'?null:r.map((a) {

                                                                        return new DropdownMenuItem<String>(
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.only(left:10.0),
                                                                            child: new Container(
                                                                              height: 20,
                                                                              width: 20,
                                                                              decoration:
                                                                              BoxDecoration(
                                                                                color: Color(int
                                                                                    .parse(a['color']
                                                                                )),
                                                                                shape: BoxShape
                                                                                    .circle,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          value: a['color'].toString(),
                                                                        );
                                                                      }).toList(),
                                                                      onChanged: (newVal) {
                                                                        progress3?Center(child:CircularProgressIndicator(),):
                                                                        setState(() {
                                                                          print(newVal);
                                                                           _mySelection = newVal;
                                                                          // print(_mySelection);

                                                                         senddata2(cart[index]['_id'],null,_mySelection);

                                                                        });
                                                                      },
                                                                      value:_mySelection,
                                                                    ),
                                                                  ),

                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                          :SizedBox.shrink(),
                                                          SizedBox(width:10),Expanded(flex:0,
                                                            child: InkWell(child: Text("REMOVE",style: GoogleFonts.poppins(textStyle:TextStyle(color: Color(0xFF000000),fontSize: 7, fontWeight: FontWeight.w500),),),
                                                        onTap: () {
                                                            _showDialog(cart[index]['_id']);
                                                         },
                                                            ),
                                                          ),

                                                          SizedBox(width:10), Expanded(flex:0,
                                                            child: InkWell(child: Text( cart[index]['productId']['status']!='deleted'?"SAVE FOR LATER":"",style: GoogleFonts.poppins(textStyle:TextStyle(color: Color(0xFF000000),fontSize: 7, fontWeight: FontWeight.w500),),),
                                                              onTap: () {
                                                                  senddata(cart[index]['_id']);
                                                              },
                                                            ),
                                                          ),
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
                                        ),

                                        Divider(
                                          height: 30,
                                          thickness: 1,
                                          indent: 1,
                                        ),
                                      ],
                                      ),

                                onTap:() {
                                        cart[index]['productId']['status']=='inactive'|| cart[index]['productId']['status']=='deleted'?SizedBox.shrink()
                                       :Navigator.push(context,new MaterialPageRoute(builder: (context)=>new ProductDetail(cart[index]['productId']['_id'])));
                                      }
                                  );
                              }
                          ),
                        ),

                save4.isEmpty?

                      SizedBox.shrink()
                :pro?Center( child: CircularProgressIndicator(),):
                Column(
                  children: [
                    SizedBox(height:10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Saved for later",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:15,fontWeight: FontWeight.w500),)),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Column(
                      children: List.generate(save4.length,(index){
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
                                              Image(image:save4[index]['productId']['photos']==null||save4[index]['productId']['photos'].isEmpty?NetworkImage(Prefmanager.baseurl+"/file/get/noimage.jpg"):NetworkImage(Prefmanager.baseurl+"/file/get/"+save4[index]['productId']['photos'][0]),height:110,width:90,fit:BoxFit.fill),
                                              Expanded(
                                                  child:Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal:15.0),
                                                    child: Column(
                                                        children:[
                                                          Row(
                                                            children:[
                                                              Text(save4[index]['productId']['name'],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w700),)),

                                                            ],
                                                          ),
                                                          Row(
                                                            children:[
                                                              Expanded(child: Text(save4[index]['productId']['description'],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF6A6A6A),fontSize:10,fontWeight: FontWeight.w300),))),

                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height:3,
                                                          ),
                                                          Row(
                                                              children:[
                                                                Text("Price: ₹ "+f1[index].nonSymbol,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w700),)),
                                                                SizedBox(width:10),
                                                                Text("You Save:₹"+f3[index].nonSymbol,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF2DD986),fontSize:9,fontWeight: FontWeight.w300),)),
                                                              ]

                                                          ),

                                                          SizedBox(
                                                            height:3,
                                                          ),
                                                          Row(
                                                              children:[
                                                                Text("Seller: "+save4[index]['productId']['sellerId']['shopName'],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF6A6A6A),fontSize:10,fontWeight: FontWeight.w400))),
                                                              ]
                                                          ),
                                                          SizedBox(
                                                              height:10
                                                          ),
                                                          //Text("Qty:"),
                                                          Expanded(flex:0,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                SizedBox(width:80),Expanded(flex:0,
                                                                  child: InkWell(child: Text("REMOVE",style: GoogleFonts.poppins(textStyle:TextStyle(color: Color(0xFF000000),fontSize: 10, fontWeight: FontWeight.w500),),),
                                                                    onTap: () {
                                                                      _showDialog(save4[index]['_id']);
                                                                    },
                                                                  ),
                                                                ),
                                                                
                                                                SizedBox(width:10),Expanded(flex:0,
                                                                  child: InkWell(child: Text("MOVE TO CART",style: GoogleFonts.poppins(textStyle:TextStyle(color: Color(0xFF000000),fontSize: 10, fontWeight: FontWeight.w500),),),
                                                                    onTap: () {
                                                                      senddata1(save4[index]['_id']);
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )

                                                        ]
                                                    ),
                                                  )
                                              ),

                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 30,
                                    thickness: 1,
                                    indent: 1,
                                  ),
                                ],
                              ),
                              onTap:() {
                                Navigator.push(context,new MaterialPageRoute(builder: (context)=>new ProductDetail(save4[index]['productId']['_id'])));
                              }
                          );
                      }
                      ),
                    ),
                  ],
                ),
                      ],
                    ),
                  ),
                ),
                // Container(
                //   height: 50,
                //   decoration: BoxDecoration(
                //     color: Color(0xFFFFFFFF),
                //     borderRadius: BorderRadius.only(
                //                 topRight: Radius.circular(40.0),
                //                 topLeft: Radius.circular(40.0)),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.grey[300].withOpacity(0.5),
                //         spreadRadius: 5,
                //         blurRadius: 4,
                //         offset: Offset(2, 5), // changes position of shadow
                //       ),
                //     ],
                //   ),
                //
                //  ),
                cart.isEmpty?
                    SizedBox.shrink()
               : Container(
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft:Radius.circular(30.0,),topRight:Radius.circular(30.0,)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[500].withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 4,
                        offset: Offset(2, 5), // changes position of shadow
                      ),
                    ],
                  ),
                 child: Padding(
                   padding: const EdgeInsets.symmetric(horizontal:30.0),
                   child: Column(
                      children: [
                        SizedBox(height:20),
                        Container(
                          height:3.5,
                              width:MediaQuery.of(context).size.width/3,
                              color:Color(0xFFF4F2F2),
                        ),
                        SizedBox(height:10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Price Details',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:15,fontWeight: FontWeight.w500),)),
                            Spacer(),InkWell(child: Text(!hasPressed?"More Details":"Less Details",style: GoogleFonts.poppins(textStyle:TextStyle(color: Color(0xFF39755B),decoration:TextDecoration.underline,fontSize: 10, fontWeight: FontWeight.w600),),),
                              onTap: () {
                                setState(() {
                                  hasPressed=!hasPressed;
                                });

                              },
                            ),
                            //hasPressed?moreDetails():SizedBox.shrink(),
                          ],
                        ),
                       // SizedBox(height:10),
                        hasPressed?
                        Column(
                          children: [
                            Column(
                                children:
                                List.generate(cart.length, (index){
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(cart[index]['productId']['status']=='active'?cart[index]['productId']['name']:"",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF393939),fontSize:12,fontWeight: FontWeight.w500),)),
                                          Spacer(),Text(cart[index]['productId']['status']=='active'?'₹ '+f4[index].nonSymbol:"",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF474747),fontSize:12,fontWeight: FontWeight.w500),)),

                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                    ],
                                  );
                                }
                                )

                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Delivery Fee',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF474747),fontSize:12,fontWeight: FontWeight.w500),)),
                                Spacer(),Text("₹ "+delfee,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF474747),fontSize:12,fontWeight: FontWeight.w500),)),

                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Tax',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF474747),fontSize:12,fontWeight: FontWeight.w500),)),
                                Spacer(),Text("₹ "+tax,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF474747),fontSize:12,fontWeight: FontWeight.w500),)),

                              ],
                            ),
                             SizedBox(height: 10,),
                          ],
                        )
                            :SizedBox.shrink(),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Order Total',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF474747),fontSize:12,fontWeight: FontWeight.w500),)),
                            Spacer(),Text("₹ "+total,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF474747),fontSize:15,fontWeight: FontWeight.w500),)),

                          ],
                        ),

                        SizedBox(height: 10,),
                        FlatButton(
                          height: 50,
                          minWidth:MediaQuery.of(context).size.width /0,
                          textColor: Colors.white,
                          color: statuscheck?Color(0xFFFC4B4B):Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0)),
                          child: Text('Place Order',style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.white,fontSize:10,fontWeight: FontWeight.w500),)),
                          onPressed: ()async {
                            statuscheck?
                            await Navigator.push(
                                context, new MaterialPageRoute(
                                builder: (context) => new OrderSummary(null))):null;
                            await cartList();

                          },
                        ),
                        SizedBox(height:20)

                      ],
                    ),
                 ),
               ),
               // SizedBox(height:20)

              ],
            )));
  }
  bool progress1=false;
  void senddata(var id) async {
    setState(() {
      progress1=true;
    });
    print("hi");
    try{
      String token = await Prefmanager.getToken();
      var url = Prefmanager.baseurl+'/cart/edit/'+id;
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': token
      };

      Map data={
       'type':"save4later"
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
          cartList();
          saveList();
        }

        else{
          print(json.decode(response.body)['msg']);
          checkUnavailable();
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
    progress1=false;
  }

  bool progress2=false;
  void senddata1(var id) async {
    setState(() {
      progress2=true;
    });
    print("hi");
    try{
      String token = await Prefmanager.getToken();
      var url = Prefmanager.baseurl+'/cart/edit/'+id;
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': token
      };

      Map data={
        'type':"cart"
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
          cartList();
          saveList();
        }

        else{
          print(json.decode(response.body)['msg']);

          Fluttertoast.showToast(
            msg:json.decode(response.body)['msg'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,

          );
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
    progress2=false;
  }
var qu;
  bool progress3=false;
  void senddata2(var id,quantity,color) async {
   setState(() {
     progress3=true;
   });
    try{
      String token = await Prefmanager.getToken();
      var url = Prefmanager.baseurl+'/cart/edit/'+id;
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': token
      };

      Map data={
        'type':'cart',
        'quantity':quantity,
         'color':color
      };
      qu=quantity;
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
          cartList();
        }

        else{
          print(json.decode(response.body)['msg']);
          checkstock(json.decode(response.body)['msg']);

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
progress3=false;
  }
}
