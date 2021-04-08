
import 'dart:convert';
import 'dart:io';
import 'package:eram_app/Prefmanager.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
class EditBankdetails extends StatefulWidget {
  final name,id;
  EditBankdetails(this.name,this.id);
  @override
  _EditBankdetails createState() => _EditBankdetails();
}
class _EditBankdetails extends State<EditBankdetails> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController bankController = TextEditingController();
  TextEditingController accountHolderController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  void initState() {
    super.initState();
    _getCurrentLocation();
    sellerview();
  }
  var state,city,fulladdress,lat,lon;
  _getCurrentLocation() async {
  }

  List sub=[];
  bool progress1=true;
  var caticon,seller;
  void sellerview() async{
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    var url=Prefmanager.baseurl+'/user/me';
    var response = await http.post(url,headers: requestHeaders);
    print(json.decode(response.body));
    print(widget.id);
    print(token);
    if(json.decode(response.body)['status']) {
      seller= json.decode(response.body)['data'];
      lon=json.decode(response.body)['data']['sellerid']['location'][0];
      lat=json.decode(response.body)['data']['sellerid']['location'][1];
      print(lon);
      bankController.text=seller['sellerid']['bankDetails']['bank'];
      accountHolderController.text=seller['sellerid']['bankDetails']['accountHolder'];
      accountNoController.text=seller['sellerid']['bankDetails']['accountNo'];
      ifscController.text=seller['sellerid']['bankDetails']['ifsc'];
      branchController.text=seller['sellerid']['bankDetails']['branch'];


    }
    else
      Fluttertoast.showToast(
        msg:json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress1=false;
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Text("Account Settings",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:16,fontWeight: FontWeight.w600),)),
          automaticallyImplyLeading: true,
        ),

        body:
        progress1?Center(child:CircularProgressIndicator(),):
        Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical:15),
                child: ListView(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15.0),
                      child: Row(
                        children: [
                          Text("Edit Bank Details",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w600))),
                        ],
                      ),
                    ),

                    SizedBox(height:10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15.0),
                      child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Bank",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
                              ],
                            ),
                            TextFormField(
                              validator: (value) {
                                Pattern pattern =r'^[a-zA-Z]';
                                RegExp regex = new RegExp(pattern);
                                if (value.isEmpty) {
                                  return 'Please enter bank name';
                                }

                                else if (!regex.hasMatch(value))
                                  return 'Invalid bank name';
                                else
                                  return null;
                              },
                              controller: bankController,
                              style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                              decoration: InputDecoration(
                                labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                              ),
                            ),
                            SizedBox(height: 20,),


                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15.0),
                      child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Account Holder",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
                              ],
                            ),
                            TextFormField(
                              validator: (value) {
                                Pattern pattern =r'^[a-zA-Z]';
                                RegExp regex = new RegExp(pattern);
                                if (value.isEmpty) {
                                  return 'Please enter account holder name';
                                }

                                else if (!regex.hasMatch(value))
                                  return 'Invalid name';
                                else
                                  return null;
                              },
                              controller: accountHolderController,
                              style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                              decoration: InputDecoration(
                                labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                              ),
                            ),
                            SizedBox(height: 20,),


                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15.0),
                      child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Account Number",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
                              ],
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter account number';
                                }
                                else
                                  return null;
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ], //
                              controller: accountNoController,
                              style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                              decoration: InputDecoration(
                                labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                              ),
                            ),
                            SizedBox(height: 20,),


                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15.0),
                      child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("IFSC",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
                              ],
                            ),
                            TextFormField(
                              validator: (value) {
                                Pattern pattern = r'^[A-Z]{4}0[A-Z0-9]{6}$';
                                RegExp regex = new RegExp(pattern);
                                if (value.isEmpty) {
                                  return 'Please enter IFSC';
                                }
                                else if (!regex.hasMatch(value))
                                  return 'Invalid IFSC';
                                else
                                  return null;

                              },
                             // keyboardType: TextInputType.text,
                              //textCapitalization: TextCapitalization.characters,
                              controller: ifscController,
                              style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                              decoration: InputDecoration(
                                labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                              ),
                            ),
                            SizedBox(height: 20,),


                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15.0),
                      child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Branch",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
                              ],
                            ),
                            TextFormField(
                              validator: (value) {
                                Pattern pattern =r'^[a-zA-Z]';
                                RegExp regex = new RegExp(pattern);
                                if (value.isEmpty) {
                                  return 'Please enter branch';
                                }

                                else if (!regex.hasMatch(value))
                                  return 'Invalid branch';
                                else
                                  return null;
                              },
                              controller: branchController,
                              style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                              decoration: InputDecoration(
                                labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                              ),
                            ),
                            SizedBox(height: 20,),


                          ]),
                    ),
                   // SizedBox(height: 150,),
                    progress2?Center( child: CircularProgressIndicator(),):
                    Container(
                        height: 50,
                        width:80,
                        padding:EdgeInsets.symmetric(horizontal: 15),
                        child: FlatButton(
                          textColor: Colors.white,
                          color: Color(0xFFFC4B4B),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Color(0xFFD2D2D2)),
                              borderRadius: BorderRadius.circular(7.0)),
                          child: Text('Edit',style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.white,fontSize:10,fontWeight: FontWeight.w700),)),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              senddata();
                            }

                          },
                        )),
                  ],
                ) )));
  }
  bool progress2=false;
  void senddata() async {
    setState(() {
      progress2=true;
    });
    try{
      String token = await Prefmanager.getToken();
      var url = Prefmanager.baseurl+'/seller/profile/level3';
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': token
      };

      Map data={
        'bank':bankController.text,
        'accountHolder':accountHolderController.text,
        'accountNo':accountNoController.text,
        'ifsc':ifscController.text,
        'branch':branchController.text,
      };
      print(data);
      var body=json.encode(data);
      var response = await http.post(url,headers:requestHeaders,body: body);
      //print(response);
      //print("yyu"+response.statusCode.toString());
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if(json.decode(response.body)['status'])
        {
          Navigator.of(context).pop(true);
         //  Navigator.push(
         //      context, new MaterialPageRoute(
         //      builder: (context) => new SellerProfile(widget.id,widget.name)));
        }
        // else if(json.decode(response.body)['status']&&json.decode(response.body)['profileStatus']=='incomplete'&&json.decode(response.body)['role']=='seller')
        // {
        //   await Prefmanager.setToken(json.decode(response.body)['token']);
        //   // Navigator.push(
        //   //     context, new MaterialPageRoute(
        //   //     builder: (context) => new WorkingHour()));
        // }

        else{
          // Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SearchProduct(keyword.text,searchMsg))).then((value) {
          //   //This makes sure the textfield is cleared after page is pushed.
          //
          // });
          print(json.decode(response.body)['msg']);
          Fluttertoast.showToast(
            msg:json.decode(response.body)['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,

          );
          setState(() {
            progress2=false;
          });
        }
      }
      else {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
    on SocketException catch(e){
      Fluttertoast.showToast(
        msg: "No internet",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      print(e.toString());
    }
    catch(e){
      print(e.toString());
    }
    setState(() {
      progress2=false;
    });

  }
}
