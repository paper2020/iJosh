import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Prefmanager.dart';
import 'package:http/http.dart' as http;
class SellerMoreImage extends StatefulWidget {
  final seller,details,id;
  SellerMoreImage(this.seller,this.details,this.id);
  @override
  _SellerMoreImage createState() => _SellerMoreImage();
}
class _SellerMoreImage extends State<SellerMoreImage> {
  void initState() {
    super.initState();
    //sellerview();
  }
  List delimg=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        leading: IconButton (icon:Icon(Icons.arrow_back),
          onPressed:() => Navigator.pop(context,true),
        ),
        title:Row(
          children: [
            Text("Shop Images",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:16,fontWeight: FontWeight.w600))),
          ],
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: PageView.builder(
              controller: PageController(
                  initialPage: widget.details
              ),
              reverse: false,
             // pageSnapping: false,
              itemCount: widget.seller.length,
              itemBuilder: (BuildContext context, index) {

                return InkWell(
                  child: Center(
                    child:  ClipRRect(borderRadius: BorderRadius.circular(10.0),child:Image(image:NetworkImage(Prefmanager.baseurl+"/file/get/"+widget.seller[index]),fit: BoxFit.fill,)),
                  ),
                  onLongPress: ()async{
                    delimg.add(widget.seller[index]);
                    print(delimg);
                    setState(() {

                    });
                    },
                );
                },
            ),
          ),
          delimg.isEmpty?SizedBox.shrink():
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:25,vertical:25),
              child: Container(
                decoration:BoxDecoration( boxShadow: [
                  BoxShadow(
                    color: Colors.grey[100].withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 4,
                    offset: Offset(2, 5), // changes position of shadow
                  ),
                ], ),
                child:FlatButton(
                  height: 50,
                  minWidth:MediaQuery.of(context).size.width,
                  color:Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Color(0xFFE8E8E8))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Delete',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:11,fontWeight: FontWeight.w600),)),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      deletephoto();
                    });

                  },
                ),),
            ),
          ),
        ],
      ),


    );

  }
  deletephoto() async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    Map data = {
      'key':delimg
    };
    print(data);
    var body = json.encode(data);
    var url=Prefmanager.baseurl+'/shop/images/delete/'+widget.id;
    var response = await http.post(url,headers:requestHeaders,body: body);
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
     // await sellerview();
      Navigator.pop(context);

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
}
