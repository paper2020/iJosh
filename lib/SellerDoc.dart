import 'dart:convert';
//import 'dart:html';
import 'package:eram_app/SellerDocView.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'Prefmanager.dart';
import 'package:http/http.dart' as http;
class SellerDoc extends StatefulWidget {
  final sellerid;
  SellerDoc(this.sellerid);
  @override
  _SellerDoc createState() => _SellerDoc();
}
class _SellerDoc extends State<SellerDoc> {
  void initState() {
    super.initState();
    sellerview();
    print(widget.sellerid);
  }
  List delimg=[];
  List doc=[];
  var sid,seller,is24;
  List sub=[];
  List shops=[];
  Future<void>sellerview() async{
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token!=null?token:null
    };
    var url=Prefmanager.baseurl+'/user/me/';

    var response = await http.post(url,headers: requestHeaders);
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
      seller= json.decode(response.body)['data'];
      shops=json.decode(response.body)['data']['sellerid']['shopImages'];
      doc=json.decode(response.body)['data']['sellerid']['documents'];
      print("gshdh");
      print(doc);

      is24=json.decode(response.body)['data']['sellerid']['is24x7'];
      sid=json.decode(response.body)['data']['sellerid']['_id'];
      for (int i = 0; i < json.decode(response.body)['data']['sellerid']['subcategory'].length; i++)
        sub.add(json.decode(response.body)['data']['sellerid']['subcategory'][i]);

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        leading: IconButton (icon:Icon(Icons.arrow_back),
          onPressed:() => Navigator.pop(context,true),
        ),
        title:Row(
          children: [
            Text("Company Documents",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:16,fontWeight: FontWeight.w600))),
          ],
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: GridView.builder(
                    itemCount: doc.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      var completePath = doc[index];
                      var fileName = (completePath.split('.').last);
                      var filePath = completePath.replaceAll("/$fileName", '');
                      print(fileName);
                      print(filePath);
                      return GestureDetector(
                        child: Container(
                          //height: MediaQuery.of(context).size.height,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              fileName=='jpg'?

                              InkWell(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children:   [
                                    ClipRRect(borderRadius: BorderRadius.circular(10.0),child:Image(image:NetworkImage(Prefmanager.baseurl+"/file/get/"+doc[index]),height:180,width:double.infinity,fit: BoxFit.fill,)),
                                    Container(
                                      alignment: Alignment.center,
                                      height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color:Colors.blue,
                                        ),
                                        child: Text("JPG",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 15,),)
                                    ),
                                  ],
                                ),
                                onTap: (){
                                  Navigator.push(context,new MaterialPageRoute(builder: (context)=>SellerDocView(doc[index],fileName)));
                                },
                              )

                                  :InkWell(
                                child: Stack(
                                  alignment:Alignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height:150,
                                      child:PDF.network(
                                        Prefmanager.baseurl+"/file/get/"+doc[index],
                                        //height: 600,
                                        //width: 500,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color:Colors.blue,
                                        ),
                                        child: Text("PDF",style: TextStyle(color: Colors.white,fontSize: 15),)),
                                  ],
                                ),
                                onTap: (){
                                  Navigator.push(context,new MaterialPageRoute(builder: (context)=>SellerDocView(doc[index],fileName)));
                                },
                              ),
                              Text(filePath),


                              SizedBox(
                                height: 5,
                              ),
                              // Text(cat[index],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w600))),
                            ],
                          ),
                        ),
                        onTap: () {
                          //Navigator.push(context, new MaterialPageRoute(builder: (context) => ShopPage1(false,seller[index]['sellerid']['shopName'],seller[index]['sellerid']['uid'],seller[index]['_id'])));
                          //Navigator.pop(context);
                        },

                      );
                    },
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing: 10,mainAxisSpacing:10,childAspectRatio: 0.75)),
              ),
            )
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
    var url=Prefmanager.baseurl+'/shop/images/delete/'+sid;
    var response = await http.post(url,headers:requestHeaders,body: body);
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
      await sellerview();
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
