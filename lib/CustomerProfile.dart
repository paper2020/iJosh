import 'dart:convert';
import 'dart:io';
import 'package:eram_app/BottomNavigator.dart';
import 'package:eram_app/CartPage.dart';
import 'package:eram_app/DeliveryAddress.dart';
import 'package:eram_app/EditcustomerProfile.dart';
import 'package:eram_app/FirstPage.dart';
import 'package:eram_app/Model/Customer.dart';
import 'package:eram_app/MyordersPage.dart';
import 'package:eram_app/WishlistPage.dart';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/utils/helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';
class CustomerProfile extends StatefulWidget {
  @override
  _CustomerProfile  createState() => new _CustomerProfile ();
}
class _CustomerProfile  extends State<CustomerProfile >{
  Future<Customer> _futureCustomer;

  final FirebaseMessaging _fcm = FirebaseMessaging();
//  late Future<CustomerProfile> futureAlbum;
  void initState(){
    super.initState();
    //futureAlbum=fetchPhotos(client)
    _saveDeviceToken();
    profile();

  }
  String fcmToken;
  _saveDeviceToken() async {

   fcmToken = await _fcm.getToken();
    print(fcmToken);


  }
  var listprofile;
  bool progress=true;
  Future<Customer> profile() async{

    var response = await CameraHelper.makePostRequest('/user/me');
    if(json.decode(response.body)['status'])
    {
       listprofile= Customer.fromJson(json.decode(response.body)['data']);
    }
    else
      Fluttertoast.showToast(msg:json.decode(response.body)['msg'],);
    progress=false;
    setState(() {});
  }
  bool progress1=false;
  Future<void> deleteDevice() async{
    setState(() {
      progress1=true;
    });
    Map data = {
      'deviceToken':fcmToken
    };
    var response = await CameraHelper.makePostRequest('/user/logout',sendData: data);

    if(json.decode(response.body)['status'])
    {
      setState(() {
        progress1=false;
      });
      //Fluttertoast.showToast(msg:json.decode(response.body)['msg'],);
    }
    else{
      setState(() {
        progress1=false;
      });
    }
      //Fluttertoast.showToast(msg:json.decode(response.body)['msg'],);

  }

  TextEditingController keyword = TextEditingController();
   @override
   Widget build(BuildContext context) {
     return Scaffold(
         backgroundColor: Color(0xFFFFFFFF),
         appBar: AppBar(
           title: Text("Account",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:16,fontWeight: FontWeight.w600),)),
           //elevation: 1.0,
           actions: [
             IconButton (icon:Icon(Icons.favorite_outline,size:20,color: Color(0xFF7A7A7A)),
               onPressed:() => Navigator.push(
                   context, new MaterialPageRoute(
                   builder: (context) => new WishlistPage())),
             ),
             IconButton (icon:Icon(Icons.shopping_cart_outlined,size:20,color: Color(0xFF7A7A7A)),
               onPressed:() => Navigator.push(
                   context, new MaterialPageRoute(
                   builder: (context) => new CartPage())),
             ),
           ],
         ),

         drawer:  Drawer(
         child:ListView(
         // Important: Remove any padding from the ListView.
         padding: EdgeInsets.zero,
         children: <Widget>[
           progress?Center(child:CircularProgressIndicator(),):
           Container(
             color:Colors.red,
             child: DrawerHeader(
               child:Column(
                   mainAxisAlignment:MainAxisAlignment.center,
                   children:[
                     Row(
                         mainAxisAlignment:MainAxisAlignment.center,
                         children:[
                           CircleAvatar(
                             radius: 40.0,
                             backgroundColor: Colors.blue,
                             backgroundImage:listprofile.photo==null?AssetImage('assets/userlogo.jpg'):NetworkImage(Prefmanager.baseurl+"/file/get/"+listprofile.photo,),

                           ),
                         ]
                     ),

                     Row(
                       mainAxisAlignment:MainAxisAlignment.center,
                       children: [
                         Container(
                           padding: new EdgeInsets.all(10.0),
                           child:Text(listprofile.firstname+" "+listprofile.lastname,style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.white,fontSize:15,fontWeight: FontWeight.w600),),),
                         ),
                       ],
                     ),
                     SizedBox(
                       height:10,
                       //   width:40,
                     ),
                   ]
               ),
             ),
           ),

           ListTile(
             leading: Icon(Icons.home,color: Colors.black,),
             title: Text('Home',style: GoogleFonts.poppins(textStyle:TextStyle(fontSize:12,fontWeight: FontWeight.w400),)),
             onTap: () {
               Navigator.push(context, new MaterialPageRoute(builder: (context) => new MyNavigationBar()));
               //Navigator.pop(context);
             },
           ),
           ListTile(
             leading: Icon(Icons.supervised_user_circle,color: Colors.black,),
             title: Text('Your Account',style: GoogleFonts.poppins(textStyle:TextStyle(fontSize:12,fontWeight: FontWeight.w400),)),
             onTap: () {
               Navigator.push(
                   context, new MaterialPageRoute(
                   builder: (context) => new CustomerProfile()));
             },
           ),
           ListTile(
             leading: Icon(Icons.supervised_user_circle,color: Colors.black,),
             title: Text('Your Wishlist',style: GoogleFonts.poppins(textStyle:TextStyle(fontSize:12,fontWeight: FontWeight.w400),)),
             onTap: () {
               Navigator.push(
                   context, new MaterialPageRoute(
                   builder: (context) => new WishlistPage()));
             },
           ),
           ListTile(
             leading: Icon(Icons.shopping_cart,color: Colors.black,),
             title: Text('Your Orders',style: GoogleFonts.poppins(textStyle:TextStyle(fontSize:12,fontWeight: FontWeight.w400),)),
             onTap: () {
               Navigator.push(
                   context, new MaterialPageRoute(
                   builder: (context) => new MyordersPage()));
             },
           ),
           progress1?Center(child:CircularProgressIndicator(),):
           ListTile(
             leading: Icon(Icons.supervised_user_circle,color: Colors.black,),
             title: Text('Logout',style: GoogleFonts.poppins(textStyle:TextStyle(fontSize:12,fontWeight: FontWeight.w400),)),
             onTap: ()async {
               await deleteDevice();
               await Prefmanager.clear();
               await Navigator.push(context, new MaterialPageRoute(builder: (context) => new FirstPage()));
             },
           ),
         ])),
         body:
         //progress?Center(child:CircularProgressIndicator(),):
         progress?SingleChildScrollView(
     child: Shimmer.fromColors(
     baseColor: Colors.grey[300],
       highlightColor: Colors.grey[100],
       //enabled: progress,
       child: Column(
           mainAxisSize: MainAxisSize.max,
           children: <Widget>[
             Container(
                 width: double.infinity,
                 height: 50.0,
                 color:Colors.white
             ),
             SizedBox(height:10),
             Container(height:150,width:double.infinity,color:Colors.white),
             SizedBox(height:10),
             Container(
                 width: double.infinity,
                 height: 50.0,
                 color:Colors.white
             ),
             SizedBox(height:10),
             Container(
                 width: double.infinity,
                 height: 50.0,
                 color:Colors.white
             ),
             SizedBox(height:10),
             Container(
                 width: double.infinity,
                 height: 50.0,
                 color:Colors.white
             ),
             SizedBox(height:10),
             Container(
                 width: double.infinity,
                 height: 50.0,
                 color:Colors.white
             ),
             SizedBox(height:10),
             Container(
                 width: double.infinity,
                 height: 50.0,
                 color:Colors.white
             ),
             SizedBox(height:10),
             Container(
                 width: double.infinity,
                 height: 50.0,
                 color:Colors.white
             ),
             SizedBox(height:10),
             Container(
                 width: double.infinity,
                 height: 50.0,
                 color:Colors.white
             ),
             SizedBox(height:10),
             Container(
                 width: double.infinity,
                 height: 50.0,
                 color:Colors.white
             ),
             SizedBox(height:10),

           ]),
     )):
         SingleChildScrollView(
           physics: AlwaysScrollableScrollPhysics(),
           child: SafeArea(
             child: Padding(
               padding: const EdgeInsets.all(12.0),
               child: Container(
                 //height: MediaQuery.of(context).size.height,
                 child: Column(
                   children: [
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal:15.0),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text("My Account",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF313131),fontSize:15,fontWeight: FontWeight.w600),)),
                           Divider(
                             height: 30,
                             thickness: 1,
                             indent: 1,
                           ),
                           new Row(
                             children:[
                               Container(
                                   padding: EdgeInsets.symmetric(horizontal: 10),
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
                                   child:CircleAvatar(radius:25,backgroundImage:listprofile.photo==null?AssetImage('assets/userlogo.jpg'):NetworkImage(Prefmanager.baseurl+"/file/get/"+listprofile.photo,),)
                               ),
                               //Image(image: AssetImage('assets/fishimage2.jpg'),height:200,width:double.infinity ,fit:BoxFit.fill),
                               Expanded(
                                   child:Column(
                                       children:[
                                         Row(
                                           children:[
                                             Text(listprofile.firstname+" "+listprofile.lastname,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700))),
                                           ],
                                         ),
                                         SizedBox(
                                             height:2
                                         ),
                                         Row(
                                             children:[
                                               Text(listprofile.email!=null?listprofile.email:" ",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:9,fontWeight: FontWeight.w400))),
                                             ]

                                         ),
                                        SizedBox(
                                          height:2
                                        ),
                                         Row(
                                             children:[
                                               Text(listprofile.mobile!=null?"+91 "+listprofile.mobile:" ",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:9,fontWeight: FontWeight.w400))),
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
                           SizedBox(
                             height:30
                           ),
                           Row(
                             children: [
                               Icon(Icons.location_on_outlined,size:15,color: Colors.redAccent[100],),SizedBox(width:5),
                               InkWell(child: Text("Delivery Address",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w700))),
                                onTap: (){ Navigator.push(context,new MaterialPageRoute(builder: (context)=>new DeliveryAddress()));},
                               ),
                               SizedBox(width:40),
                               Image(image: AssetImage('assets/orderhistory.png'),),SizedBox(width:5),
                               InkWell(child: Text("Order History",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w700))),
                                 onTap: (){ Navigator.push(context,new MaterialPageRoute(builder: (context)=>new MyordersPage()));}),
                             ],
                           ),
                           // SizedBox(height:10),
                           // Row(
                           //   children: [
                           //    Icon(Icons.location_on_outlined,size:15,color: Colors.redAccent[100],),SizedBox(width:5),
                           //     Text("Delivery Address",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w700))),
                           //     SizedBox(width:40),
                           //     Icon(Icons.location_on_outlined,size:15,color: Colors.redAccent[100],),SizedBox(width:2),
                           //     Text("Permanent Address",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w700))),
                           //   ],
                           // ),
                           Divider(
                             height: 30,
                             thickness: 1,
                             indent: 1,
                           ),
                           Row(
                             children: [
                               Text("Profile",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:12,fontWeight: FontWeight.w700))),
                              Spacer(),InkWell(child: Icon(Icons.edit_outlined,size:15,color:Color(0xFF000000)),onTap: () {
                                 Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new EditcustomerProfile ()));
                               } ,)
                             ],
                           ),
                           Stack(
                             children:[
                               SizedBox(height: 15,),
                             Positioned(top:13,
                               child: Container(
                                 height:3,
                                 width:120,
                                 color:Color(0xFFFF4A4A),

                                 // indent: 1,
                               ),
                             ),
                           Divider(
                             height: 30,
                             thickness: 1,
                             indent: 1,
                           ),
                             ]
                       ),
                           // progress?CircularProgressIndicator():
                           // FutureBuilder<Customer>(
                           //   future: _futureCustomer,
                           //   builder: (context, snapshot) {
                           //     if (snapshot.hasData) {
                           //       return Text(snapshot.data.firstname);
                           //     } else if (snapshot.hasError) {
                           //       return Text("${snapshot.error}");
                           //     }
                           //
                           //     return CircularProgressIndicator();
                           //   },
                           // ),
                           Text("First Name",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF8D8D8D),fontSize:9,fontWeight: FontWeight.w600))),
                           SizedBox(height:10),
                            Container(
                             height:40,
                             width:330,
                             color:Color(0xFFF8F8F8),
                             child:Padding(
                               padding: const EdgeInsets.all(10.0),
                               child: Text(listprofile.firstname,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w700))),
                             )
                             // indent: 1,
                           ),
                           SizedBox(height:10),
                           Text("Last Name",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF8D8D8D),fontSize:9,fontWeight: FontWeight.w600))),
                           SizedBox(height:10),
                           Container(
                               height:40,
                               width:330,
                               color:Color(0xFFF8F8F8),
                               child:Padding(
                                 padding: const EdgeInsets.all(10.0),
                                 child: Text(listprofile.lastname,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w700))),
                               )
                             // indent: 1,
                           ),

                           SizedBox(height:10),
                           Text("Email Id",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF8D8D8D),fontSize:9,fontWeight: FontWeight.w600))),
                           SizedBox(height:10),
                           Container(
                               height:40,
                               width:330,
                               color:Color(0xFFF8F8F8),
                               child:Padding(
                                 padding: const EdgeInsets.all(10.0),
                                 child: Text(listprofile.email!=null?listprofile.email:" ",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w700))),
                               )
                             // indent: 1,
                           ),
                           SizedBox(height:10),
                           Text("Address",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF8D8D8D),fontSize:9,fontWeight: FontWeight.w600))),
                           SizedBox(height:10),
                           Container(
                               height:40,
                               width:330,
                               color:Color(0xFFF8F8F8),
                               child:Padding(
                                 padding: const EdgeInsets.all(10.0),
                                 child: Text(listprofile.address!=null?listprofile.address:" ",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w700))),
                               )
                             // indent: 1,
                           ),
                           SizedBox(height:10),
                           Text("Mobile Number",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF8D8D8D),fontSize:9,fontWeight: FontWeight.w600))),
                           SizedBox(height:10),
                           Container(
                               height:40,
                               width:330,
                               color:Color(0xFFF8F8F8),
                               child:Padding(
                                 padding: const EdgeInsets.all(10.0),
                                 child: Text(listprofile.mobile!=null?"+91 "+listprofile.mobile:" ",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w700))),
                               )
                             // indent: 1,
                           ),
                           SizedBox(height:10),
                           Text("Gender",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF8D8D8D),fontSize:9,fontWeight: FontWeight.w600))),
                           SizedBox(height:10),
                           Container(
                               height:40,
                               width:330,
                               color:Color(0xFFF8F8F8),
                               child:Padding(
                                 padding: const EdgeInsets.all(10.0),
                                 child: Text(listprofile.gender!=null?listprofile.gender:" ",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w700))),
                               )
                             // indent: 1,
                           ),
                           SizedBox(height:10),
                           Text("Date of Birth",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF8D8D8D),fontSize:9,fontWeight: FontWeight.w600))),
                           SizedBox(height:10),
                           Container(
                               height:40,
                               width:330,
                               color:Color(0xFFF8F8F8),
                               child:Padding(
                                 padding: const EdgeInsets.all(10.0),
                                 child: Text(listprofile.dob!=null?listprofile.dob:" ",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w700))),
                               )
                             // indent: 1,
                           ),
                           SizedBox(height:10),
                           Text("Pincode",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF8D8D8D),fontSize:9,fontWeight: FontWeight.w600))),
                           SizedBox(height:10),
                           Container(
                               height:40,
                               width:330,
                               color:Color(0xFFF8F8F8),
                               child:Padding(
                                 padding: const EdgeInsets.all(10.0),
                                 child: Text(listprofile.pin!=null?listprofile.pin:" ",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w700))),
                               )
                             // indent: 1,
                           ),
                           SizedBox(height:80),
                           Padding(
                             padding: const EdgeInsets.all(15.0),
                             child: Row(children:[
                               Text("My List",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAEAEAE),fontSize:10,fontWeight: FontWeight.w600))),
                               SizedBox(width:50),Text("Legal Information",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAEAEAE),fontSize:10,fontWeight: FontWeight.w600))),
                               SizedBox(width:50),Text("FAQ's",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAEAEAE),fontSize:10,fontWeight: FontWeight.w600))),
                             ]
                             ),
                           ),
                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal:15.0),
                             child: Row(children:[
                               Text("Contact us",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAEAEAE),fontSize:10,fontWeight: FontWeight.w600))),
                               SizedBox(width:30),progress1?Center(child:CircularProgressIndicator(),):InkWell(child: Text("Logout",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAEAEAE),fontSize:10,fontWeight: FontWeight.w600))),
                               onTap: ()async {
                                 await deleteDevice();
                                 await Prefmanager.clear();
                                 await Navigator.push(context, new MaterialPageRoute(builder: (context) => new FirstPage()));
                               }
                               )

                             ]
                             ),
                           )
                         ],
                       ),
                     )
                   ],
                 ),
               ),
             ),
           ),
         )
     );
   }
  var searchMsg;
  void senddata() async {
    try{
      var url = Prefmanager.baseurl+'/seller/search';
      var token=await Prefmanager.getToken();
      Map data={
        'keyword':keyword.text,

      };
      print(data.toString());
      var body=json.encode(data);
      var response = await http.post(url,headers:{"Content-Type":"application/json","token":token},body:body);
      print("yyu"+response.statusCode.toString());
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if(json.decode(response.body)['status'])
        {

        }

        // else{
        //   searchMsg=json.decode(response.body)['msg'];
        //   Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SearchProduct(keyword.text,searchMsg))).then((value) {
        //     //This makes sure the textfield is cleared after page is pushed.
        //     keyword.clear();
        //   });
        // print(json.decode(response.body)['msg']);
        // Fluttertoast.showToast(
        //   msg:json.decode(response.body)['msg'],
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.CENTER,
        //
        // );
        //}
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
  void senddata1() async {
    try{
      var url = Prefmanager.baseurl+'/product/search';
      var token=await Prefmanager.getToken();
      Map data={
        'keyword':keyword.text,

      };
      print(data.toString());
      var body=json.encode(data);
      var response = await http.post(url,headers:{"Content-Type":"application/json","token":token},body:body);
      print("yyu"+response.statusCode.toString());
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if(json.decode(response.body)['status'])
        {
          // Navigator.push(context,new MaterialPageRoute(builder: (context)=>new ShopPage(keyword.text))).then((value) {
          //   //This makes sure the textfield is cleared after page is pushed.
          //   keyword.clear();
          // });
        }

        // else{
        //   searchMsg=json.decode(response.body)['msg'];
        //   Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SearchProduct(keyword.text,searchMsg))).then((value) {
        //     //This makes sure the textfield is cleared after page is pushed.
        //     keyword.clear();
        //   });
        // print(json.decode(response.body)['msg']);
        // Fluttertoast.showToast(
        //   msg:json.decode(response.body)['msg'],
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.CENTER,
        //
        // );
        //}
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

