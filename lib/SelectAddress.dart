
import 'dart:convert';
import 'package:eram_app/AddNewAddress.dart';
import 'package:eram_app/EditdeliveryAddress.dart';
import 'package:eram_app/Prefmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SelectAddress extends StatefulWidget {
  final id;
  SelectAddress(this.id);
  @override
  _SelectAddress createState() => _SelectAddress();
}
class _SelectAddress extends State<SelectAddress> {
  final _formKey = GlobalKey<FormState>();
  void initState() {
    super.initState();
    deliveryaddressList();
    delid=widget.id;
  }
  var delid;
  List address=[];
  bool progress=true;
  var length,length1;
  Future<void>deliveryaddressList() async{
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };

    var url=Prefmanager.baseurl+'/deliveryAddress/list';
    var response = await http.post(url,headers:requestHeaders);
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
      length1=json.decode(response.body)['length'];
      length = json.decode(response.body)['totalLength'];
        address=json.decode(response.body)['data'];


    }
    else
      Fluttertoast.showToast(
        msg:json.decode(response.body)['message'],
        toastLength:
        Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress=false;
    setState(() {
    });
  }
  void _showDialog(var id) async{
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete this delivery address",style: GoogleFonts.poppins(textStyle:TextStyle(fontSize: 12))),
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
                deleteAddress(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  bool pro=true;
  void  deleteAddress(var id) async {
    var url = Prefmanager.baseurl+'/deliveryAddress/delete/'+id;
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

      setState(() {
        address.removeWhere((element) => id==element['_id']);
        print(length1);
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
  var a;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Text("Select Address",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:16,fontWeight: FontWeight.w600),)),
          automaticallyImplyLeading: true,
        ),

        body:
        //progress?Center( child: CircularProgressIndicator(),):
        progress?Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              enabled: progress,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        height: 50.0,
                        color:Colors.white
                    ),
                    SizedBox(height:20),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (_, __) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                decoration:
                                BoxDecoration(
                                  color:Colors.white,
                                  shape: BoxShape
                                      .circle,
                                ),
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
                                      height: 15.0,
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
                                      alignment: Alignment.bottomRight,
                                      width: 40.0,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 30,)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        itemCount: 4,
                      ),
                    ),
                    Container(
                        width: double.infinity,
                        height: 50.0,
                        color:Colors.white
                    ),
                  ]),
            )):
        Form(
            key: _formKey,
            child: Column(
                children: [
                  SizedBox(height:10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:15.0),
                    child: Container(
                      decoration:BoxDecoration( boxShadow: [
                        BoxShadow(
                          color: Colors.grey[200].withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 4,
                          offset: Offset(2, 5), // changes position of shadow
                        ),
                      ], ),
                      child: FlatButton(
                        height: 50,
                        minWidth:MediaQuery.of(context).size.width,
                        color:Color(0xFFFFFFFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          // side: BorderSide(color: _hasBeenPressed1?Color(0xFFD6D6D6):Color(0xFF707070))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add,size:15,color:Color(0xFFFC4B4B)),
                            Text('  Add new Address',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFFC4B4B),fontSize:12,fontWeight: FontWeight.w500),)),
                          ],
                        ),
                        onPressed: ()async {
                          await Navigator.push(context, new MaterialPageRoute(builder: (context) => AddNewAddress(widget.id)));
                         await deliveryaddressList();

                        },
                      ),
                    ),
                  ),
               SizedBox(height:30),
                  address.isEmpty?
                      Text("No delivery address added",style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.black,fontSize:12,fontWeight: FontWeight.w500),))
                  :Expanded(
                    child: ListView.builder(
                        itemCount:address.length,
                        itemBuilder: (BuildContext context,int index) {
                          return new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              // Column(
                              //     children: deliveryAddress(context)
                              // ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height:10,
                                    child: Radio( value:a==address[index]?true:false, groupValue:true,
                                      onChanged: ( value) {
                                        setState(() {
                                         // Check=value;
                                          a=address[index];
                                         // delid=address[index]['_id'];
                                          print(address[index]);
                                          print(value);
                                        });
                                      },
                                      activeColor: Color(0xFF28D286),
                                    ),
                                  ),
                                  Text(address[index]['firstName']+" "+address[index]['lastName'].toString(),style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:12,fontWeight: FontWeight.w500),)),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                      width: 48
                                  ),
                                 Expanded(flex:1,child: Text(address[index]['address']+", "+address[index]['city']+", "+address[index]['state']+", "+address[index]['pincode'],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:12,fontWeight: FontWeight.w300),))),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                      width: 48
                                  ),
                                  Expanded(flex:1,child: Text(address[index]['mobile'],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:12,fontWeight: FontWeight.w300),))),
                                ],
                              ),
                              SizedBox(height:20,),
                              a==address[index]?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [

                                  Container(
                                      height: 30,
                                      width:70,
                                      //padding:EdgeInsets.symmetric(horizontal: 15),
                                      child:FlatButton(
                                        textColor: Colors.white,
                                        color: Color(0xFFFC4B4B),
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(color: Color(0xFFD2D2D2)),
                                            borderRadius: BorderRadius.circular(7.0)),
                                        child: Text('Edit',style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.white,fontSize:10,fontWeight: FontWeight.w500),)),
                                        onPressed: () async{
                                          await Navigator.push(
                                              context, new MaterialPageRoute(
                                              builder: (context) => new EditdeliveryAddress(address[index],address[index]['_id'])));
                                          address.clear();
                                          await deliveryaddressList();
                                        },
                                      )),
                                  SizedBox(width:5),
                                  Container(
                                      height: 30,
                                      width:70,
                                      //padding:EdgeInsets.symmetric(horizontal: 15),
                                      child:FlatButton(
                                        textColor: Colors.white,
                                        color: Color(0xFFFC4B4B),
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(color: Color(0xFFD2D2D2)),
                                            borderRadius: BorderRadius.circular(7.0)),
                                        child: Text('Delete',style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.white,fontSize:10,fontWeight: FontWeight.w500),)),
                                        onPressed: () {
                                          _showDialog(address[index]['_id']);

                                        },
                                      )),

                                ],
                              )
:SizedBox.shrink(),
                              Divider(
                                height: 20,
                                thickness: 1,
                                indent: 1,
                              ),
                            ],
                          );

                        }),
                  ),
            SizedBox(
              height:80,
            ),
            address.isEmpty?
              SizedBox.shrink()
            :Container(
              height: 50,
              width:MediaQuery.of(context).size.width,
              padding:EdgeInsets.symmetric(horizontal: 15),
              child:FlatButton(
                textColor: Colors.white,
                color: Color(0xFFFC4B4B),
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color(0xFFD2D2D2)),
                    borderRadius: BorderRadius.circular(7.0)),
                child: Text('Deliver Here',style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.white,fontSize:10,fontWeight: FontWeight.w500),)),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    if(a==null)
                      Fluttertoast.showToast(
                        msg:"Please select delivery address",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                      );
                    else
                   Navigator.of(context).pop(a);
                  }

                },
              )),
         SizedBox(height: 20,),
            ],
    )));
  }
}
