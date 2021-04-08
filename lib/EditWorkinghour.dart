
import 'dart:io';

import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:eram_app/Prefmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
class EditWorkinghour extends StatefulWidget {
  final name,id;
  EditWorkinghour(this.name,this.id);
  @override
  _EditWorkinghour createState() => _EditWorkinghour();
}
class _EditWorkinghour extends State<EditWorkinghour> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController categoryController = TextEditingController();
  List _mySelection1=[];
  var valuelength;
  String selectedDate;
  var sundayOpen,sundayClose,mondayOpen,mondayClose,tuesdayOpen,tuesdayClose,wenesdayOpen,wenesdayClose,thursdayOpen,thursdayClose,
      fridayOpen,fridayClose,saturdayOpen,saturdayClose;
  //var suCheck;
  bool is24 = false;
  bool suCheck=false;
  bool moCheck=false;
  bool tuCheck=false;
  bool weCheck=false;
  bool thCheck=false;
  bool frCheck=false;
  bool saCheck=false;
  var time;
  String suOpen,suClose,moOpen,moClose,tuOpen,tuClose,weOpen,weClose,thOpen,thClose,frOpen,frClose,saOpen,saClose;
  Future<String> _showTimePicker(String time)async {
    final TimeOfDay picked = await showTimePicker(
        context: context, initialTime: TimeOfDay(hour:5,minute:10));

    if (picked != null) {
      print(picked.format(context));
      return picked.format(context);
    }
    else
      return null;
  }
  format(picked)
  {

    var pik = TimeOfDay.fromDateTime(DateFormat.jm().parse(picked));
    var selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, pik.hour, pik.minute);

    String formattedDate = DateFormat('HH:mm').format(selectedDate);
    print(formattedDate);
    return formattedDate;
  }

  void initState() {
    super.initState();
    //category();
    sellerview();
    //subCategory();
  }
  //  void sample()async{
  //   await category();
  //
  // }
  bool progress2=true;
  var sid;
  List sub=[];
  List seller=[];
  //var seller;
  var caticon;
  List item=[];
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
      for (int i = 0; i < json.decode(response.body)['data']['sellerid']['category'].length; i++) {
        seller = json.decode(response.body)['data']['sellerid']['category'];
        categoryController.text = json.decode(response.body)['data']['sellerid']['category'][i]['name'];
          caticon=json.decode(response.body)['data']['sellerid']['category'][i]['_id'];
          print(caticon);
          subCategory(caticon);
      }
      for (int i = 0; i < json.decode(response.body)['data']['sellerid']['subcategory'].length; i++) {
        _mySelection1.add(json.decode(response.body)['data']['sellerid']['subcategory'][i]['_id']);

      }
      //item=json.decode(response.body)['data']['sellerid']['workingHour'];
      for (int i = 0; i < json.decode(response.body)['data']['sellerid']['workingHour'].length; i++) {
        item.add(json.decode(response.body)['data']['sellerid']['workingHour'][i]);

      }
      suCheck=item[0]['working'];
      print(suCheck);
      moCheck=item[1]['working'];
      print(moCheck);
      tuCheck=item[2]['working'];
      weCheck=item[3]['working'];
      thCheck=item[4]['working'];
      frCheck=item[5]['working'];
      saCheck=item[6]['working'];

      sundayOpen=item[0]['open'];
      sundayClose=item[0]['close'];
      mondayOpen=item[1]['open'];
      mondayClose=item[1]['close'];
      tuesdayOpen=item[2]['open'];
      tuesdayClose=item[2]['close'];
      wenesdayOpen=item[3]['open'];
      wenesdayClose=item[3]['close'];
      thursdayOpen=item[4]['open'];
      thursdayClose=item[4]['close'];
      fridayOpen=item[5]['open'];
      fridayClose=item[5]['close'];
      saturdayOpen=item[6]['open'];
      saturdayClose=item[6]['close'];
    }
    else
      Fluttertoast.showToast(
        msg:json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress2=false;
    setState(() {
    });
  }
  var listcat=[];
  List id=[];
  bool progress=true;
  void category() async{
    var url=Prefmanager.baseurl+'/category/list';
    var response = await http.get(url);
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
      listcat = json.decode(response.body)['data'];
      //id=json.decode(response.body)['data']['_id'];
      // for(int i=0;i<json.decode(response.body)['data'].length;i++)
      // id.add(json.decode(response.body)["data"][i]['_id']);

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
  //List catid=[];
  List listsubcat=[];
  bool progress1=true;
  void subCategory(m) async{
    print("aaaa");
    //catid.add(m);
    var url=Prefmanager.baseurl+'/subcategory/list/'+m;
    var response = await http.get(url);
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
      listsubcat = json.decode(response.body)['data'];
      // print(listsubcat);
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

        body: Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical:15),
                child: ListView(
                  children: <Widget>[
                    Text("Category",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
                    TextFormField(
                      enabled: false,
                      controller: categoryController,
                      style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                      decoration: InputDecoration(
                        labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                      ),
                    ),
                    SizedBox(height:10),
                    // Container(
                    //  // padding: EdgeInsets.all(10),
                    //   child:DropdownButton(
                    //     isExpanded: true,
                    //     //hint: Text(caticon),
                    //     items: seller.map((item) {
                    //       return new DropdownMenuItem(
                    //         child: new Text(item['name']),
                    //         value: item['_id'].toString(),
                    //       );
                    //     }).toList(),
                    //     onChanged: (newVal) {
                    //       setState(() {
                    //         _mySelection = newVal;
                    //         print(_mySelection);
                    //         subCategory(_mySelection);
                    //       });
                    //     },
                    //     value: _mySelection,
                    //   ),
                    // ),
                    Text("Services Provided",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal:20.0),
                    //   // child:Column(
                    //   //     children:sublist(context)
                    //   // ),
                    //   child: GridView.builder(
                    //     // childAspectRatio: 0.8,
                    //       itemCount: sub.length,
                    //       scrollDirection: Axis.vertical,
                    //       shrinkWrap: true,
                    //       physics: NeverScrollableScrollPhysics(),
                    //       //crossAxisCount: 2,
                    //       //children: List.generate(4,(index)
                    //       itemBuilder: (BuildContext context, int index) {
                    //         return GestureDetector(
                    //           child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               children: [
                    //                 Padding(
                    //                   padding: const EdgeInsets.symmetric(horizontal:3.0),
                    //                   child: Stack(
                    //                     alignment: Alignment.centerLeft,
                    //                     children:[ Container(height:30,width:double.infinity,decoration:BoxDecoration(borderRadius: new BorderRadius.circular(50.0),color:Colors.red,),child: Center(child: Text(sub[index]['name'],textAlign:TextAlign.center,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFFFFFFF),fontSize:11,fontWeight: FontWeight.w300)))),
                    //                     ),
                    //                       Positioned(
                    //                           right: 0,
                    //                           top: 0,
                    //                           child:
                    //                           CircleAvatar(
                    //                             backgroundColor: Colors.white,
                    //                             radius: 15,
                    //                             child: CircleAvatar(
                    //                                 backgroundColor: Colors.red,
                    //                                 radius: 15,
                    //                                 child: IconButton(
                    //                                   onPressed: () {
                    //                                     sub
                    //                                         .removeAt(
                    //                                         index);
                    //                                     // val1.removeAt(index);
                    //                                     setState(() {});
                    //                                   },
                    //                                   icon: Icon(
                    //                                     Icons.close,
                    //                                     size: 15,
                    //                                     color: Colors.white,
                    //                                   ),
                    //                                 )
                    //                             ),
                    //                           )
                    //                       ),
                    //                   ]),
                    //                 )]),
                    //           onTap: () {
                    //
                    //           },
                    //         );
                    //       },gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio:2.1,crossAxisCount:4)),
                    // ),
                    progress1?Center( child: CircularProgressIndicator(),):
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:3.0),
                      child: Container(
                        //padding:EdgeInsets.symmetric(horizontal:15),
                        child: MultiSelectFormField(
                            fillColor: Colors.white,
                            title: Text( "Select"),
                            autovalidate: false,
                            // validator: (value) {
                            //   if (value == null) {
                            //     return 'Please select one or more option(s)';
                            //   }
                            //   else
                            //     return null;
                            // },
                            // errorText: 'Please select one or more option(s)',
                            dataSource: [
                              for(int i=0; i<listsubcat.length; i++){
                                "display": listsubcat[i]["name"],
                                "value": listsubcat[i]["_id"],
                              }

                            ],
                            initialValue: _mySelection1,
                            chipBackGroundColor: Colors.red,
                            chipLabelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFFFFFFF),fontSize:11,fontWeight: FontWeight.w300),),
                            textField: 'display',
                            valueField: 'value',
                            required: true,
                            onSaved: (value) {
                              print('The value is $value');
                              valuelength=value.length;
                              print(valuelength);
                              //Text(valuelength.toString());
                              _mySelection1=value;
                            }
                        ),
                      ),
                    ),
                    //Text(valuelength.toString()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Is 24*7",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:11,fontWeight: FontWeight.w500),)),
                        Switch(
                          value: is24,
                          onChanged: (value) {
                            is24 =! is24;
                            if(is24){
                              suCheck=false;
                              moCheck=false;
                              tuCheck=false;
                              weCheck=false;
                              thCheck=false;
                              frCheck=false;
                              saCheck=false;
                            }
                            else{
                              suCheck=true;
                              moCheck=true;
                              tuCheck=true;
                              weCheck=true;
                              thCheck=true;
                              frCheck=true;
                              saCheck=true;
                            }
                            setState(() {

                            });
                          },
                          activeTrackColor: Colors.red,
                          activeColor: Colors.white,
                        ),

                      ],
                    ),
                    progress2?Center( child: CircularProgressIndicator(),):
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          Align(
                            alignment: Alignment.center,
                          ),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:[
                                Text("Store Working Hour",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF5F5F5F),fontSize:12,fontWeight: FontWeight.w400),)),
                                Text("Opening Time",textAlign:TextAlign.center,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF5F5F5F),fontSize:12,fontWeight: FontWeight.w400),)),
                                Text("Closing Time",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF5F5F5F),fontSize:12,fontWeight: FontWeight.w400),)),
                              ]
                          ),
                          SizedBox(height:10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              Container(
                                height:0.5,
                                width:85,
                                color:Color(0xFFAFAFAF),

                                // indent: 1,
                              ),
                              SizedBox(width:20),
                              Container(
                                alignment: Alignment.centerRight,
                                height:0.5,
                                width:90,
                                color:Color(0xFFAFAFAF),

                                // indent: 1,
                              ),
                            ],
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children:[
                                Expanded(flex:1,
                                  child: Checkbox(
                                    //checkColor: Colors.black,
                                    activeColor: Color(0xFF28D286),
                                    value: suCheck,
                                    // groupValue: suCheck,
                                    onChanged:is24?null: (bool value) {
                                      suCheck=!suCheck;
                                      // suCheck=value;
                                      setState(() {

                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width:5),
                                Expanded(flex:3,child: Text("SUNDAY",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w500),))),
                                //Text("Opening Time",style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold,)),
                                //Text("Opening Time",style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold,)),

                                FlatButton(
                                  // minWidth: 15,
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(50.0),
                                  //     side: BorderSide(color: Colors.black)),

                                    textColor: Colors.black,
                                    color: Colors.white,

                                    //child: Text(time),
                                    onPressed:suCheck? () async{
                                      sundayOpen= await _showTimePicker(sundayOpen);
                                      suOpen= await format(sundayOpen);
                                      sundayOpen=suOpen;
                                      setState(() {

                                      });


                                    }:null,
                                    child:Text(suOpen??item[0]['open']??"Select Time",textAlign: TextAlign.center,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF525252),fontSize:10,fontWeight: FontWeight.w400),))
                                ),
                                SizedBox(
                                  width:10,
                                ),
                                FlatButton(
                                  // minWidth: 15,
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(50.0),
                                  //     side: BorderSide(color: Colors.black)),

                                    textColor: Colors.black,
                                    color: Colors.white,
                                    onPressed:suCheck?  () async{
                                      sundayClose= await _showTimePicker(sundayClose);
                                      suClose= await format(sundayClose);
                                      sundayClose=suClose;
                                      setState(() {

                                      });

                                    }:null,
                                    child:Text(suClose??item[0]['close']??"Select Time",textAlign: TextAlign.center,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF525252),fontSize:10,fontWeight: FontWeight.w400),),)

                                  //child: Text('Edit Profile',style: TextStyle(fontSize: 10),),

                                ),
                              ]
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                height:0.5,
                                width:200,
                                color:Color(0xFFAFAFAF),

                                // indent: 1,
                              ),
                              SizedBox(width:20),
                              Container(
                                alignment: Alignment.centerRight,
                                height:0.5,
                                width:90,
                                color:Color(0xFFAFAFAF),

                                // indent: 1,
                              ),
                            ],
                          ),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children:[
                                Expanded(flex:1,
                                  child: Checkbox(

                                    //checkColor: Colors.black,
                                    activeColor: Color(0xFF28D286),
                                    value: moCheck,
                                    onChanged:is24?null: (bool value) {
                                      moCheck=!moCheck;
                                      setState(() {

                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width:5),
                                Expanded(flex:3,child: Text("MONDAY",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w500),))),
                                FlatButton(
                                  // minWidth:15,
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(50.0),
                                  //     side: BorderSide(color: Colors.black)),

                                    textColor: Colors.black,
                                    color: Colors.white,
                                    onPressed:moCheck? () async{
                                      mondayOpen= await _showTimePicker(mondayOpen);
                                      moOpen= await format(mondayOpen);
                                      mondayOpen=moOpen;
                                      setState(() {

                                      });

                                    }:null,
                                    child:Text(moOpen??item[1]['open']??"Select Time",textAlign: TextAlign.center,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF525252),fontSize:10,fontWeight: FontWeight.w400),))
                                  //child: Text('Edit Profile',style: TextStyle(fontSize: 10),),

                                ),
                                SizedBox(
                                    width:10
                                ),
                                FlatButton(
                                  // minWidth: 15,
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(50.0),
                                  //     side: BorderSide(color: Colors.black)),

                                    textColor: Colors.black,
                                    color: Colors.white,
                                    onPressed: moCheck?() async{
                                      mondayClose= await _showTimePicker(mondayClose);
                                      moClose= await format(mondayClose);
                                      mondayClose=moClose;
                                      setState(() {

                                      });

                                    }:null,
                                    child:Text(moClose??item[1]['close']??"Select Time",textAlign: TextAlign.center,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF525252),fontSize:10,fontWeight: FontWeight.w400),))

                                ),
                              ]
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                height:0.5,
                                width:200,
                                color:Color(0xFFAFAFAF),

                                // indent: 1,
                              ),
                              SizedBox(width:20),
                              Container(
                                alignment: Alignment.centerRight,
                                height:0.5,
                                width:90,
                                color:Color(0xFFAFAFAF),

                                // indent: 1,
                              ),
                            ],
                          ),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children:[
                                Expanded(flex:1,
                                  child: Checkbox(

                                    //checkColor: Colors.black,
                                    activeColor: Color(0xFF28D286),
                                    value: tuCheck,
                                    onChanged:is24?null: (bool value) {
                                      tuCheck=!tuCheck;
                                      setState(() {

                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width:5),
                                Expanded(flex:3,child: Text("TUESDAY",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w500),))),
                                FlatButton(
                                  // minWidth: 15,
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(50.0),
                                  //     side: BorderSide(color: Colors.black)),

                                    textColor: Colors.black,
                                    color: Colors.white,
                                    onPressed: tuCheck?() async{
                                      tuesdayOpen= await _showTimePicker(tuesdayOpen);
                                      tuOpen= await format(tuesdayOpen);
                                      tuesdayOpen=tuOpen;
                                      setState(() {

                                      });

                                    }:null,
                                    child:Text(tuOpen??item[2]['open']??"Select Time",textAlign: TextAlign.center,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF525252),fontSize:10,fontWeight: FontWeight.w400),))
                                ),
                                SizedBox(
                                  width:10,
                                ),
                                FlatButton(
                                  // minWidth: 15,
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(50.0),
                                  //     side: BorderSide(color: Colors.black)),

                                    textColor: Colors.black,
                                    color: Colors.white,
                                    onPressed:tuCheck? () async{
                                      tuesdayClose= await _showTimePicker(tuesdayClose);
                                      tuClose= await format(tuesdayClose);
                                      tuesdayClose=tuClose;
                                      setState(() {

                                      });

                                    }:null,
                                    child:Text(tuClose??item[2]['close']??"Select Time",textAlign: TextAlign.center,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF525252),fontSize:10,fontWeight: FontWeight.w400),))

                                ),
                              ]
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                height:0.5,
                                width:200,
                                color:Color(0xFFAFAFAF),

                                // indent: 1,
                              ),
                              SizedBox(width:20),
                              Container(
                                alignment: Alignment.centerRight,
                                height:0.5,
                                width:90,
                                color:Color(0xFFAFAFAF),

                                // indent: 1,
                              ),
                            ],
                          ),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children:[
                                Expanded(flex:1,
                                  child:Checkbox(

                                    //checkColor: Colors.black,
                                    activeColor: Color(0xFF28D286),
                                    value: weCheck,
                                    onChanged:is24?null: (bool value) {
                                      weCheck=!weCheck;
                                      setState(() {

                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width:5),
                                Expanded(flex:3,child: Text("WENESDAY",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w500),))),
                                FlatButton(
                                  // minWidth: 15,
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(50.0),
                                  //     side: BorderSide(color: Colors.black)),

                                    textColor: Colors.black,
                                    color: Colors.white,
                                    onPressed:weCheck? () async{
                                      wenesdayOpen= await _showTimePicker(wenesdayOpen);
                                      weOpen= await format(wenesdayOpen);
                                      wenesdayOpen=weOpen;
                                      setState(() {

                                      });

                                    }:null,
                                    child:Text(weOpen??item[3]['open']??"Select Time",textAlign: TextAlign.center,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF525252),fontSize:10,fontWeight: FontWeight.w400),))


                                ),
                                SizedBox(
                                    width:10
                                ),
                                FlatButton(
                                  // minWidth: 15,
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(50.0),
                                  //     side: BorderSide(color: Colors.black)),

                                    textColor: Colors.black,
                                    color: Colors.white,
                                    onPressed: weCheck?() async{
                                      wenesdayClose= await _showTimePicker(wenesdayClose);
                                      weClose= await format(wenesdayClose);
                                      wenesdayClose=weClose;
                                      setState(() {

                                      });

                                    }:null,
                                    child:Text(weClose??item[3]['close']??"Select Time",textAlign: TextAlign.center,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF525252),fontSize:10,fontWeight: FontWeight.w400),))


                                ),
                              ]
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                height:0.5,
                                width:200,
                                color:Color(0xFFAFAFAF),

                                // indent: 1,
                              ),
                              SizedBox(width:20),
                              Container(
                                alignment: Alignment.centerRight,
                                height:0.5,
                                width:90,
                                color:Color(0xFFAFAFAF),

                                // indent: 1,
                              ),
                            ],
                          ),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children:[
                                Expanded(flex:1,
                                  child: Checkbox(

                                    // checkColor: Colors.black,
                                    activeColor: Color(0xFF28D286),
                                    value: thCheck,
                                    onChanged:is24?null: (bool value) {
                                      thCheck=!thCheck;
                                      setState(() {

                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width:5),
                                Expanded(flex:3,child: Text("THURSDAY",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w500),))),
                                FlatButton(
                                  // minWidth: 15,
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(50.0),
                                  //     side: BorderSide(color: Colors.black)),

                                    textColor: Colors.black,
                                    color: Colors.white,
                                    onPressed:thCheck? () async{
                                      thursdayOpen= await _showTimePicker(thursdayOpen);
                                      thOpen= await format(thursdayOpen);
                                      thursdayOpen=thOpen;
                                      setState(() {

                                      });

                                    }:null,
                                    child:Text(thOpen??item[4]['open']??"Select Time",textAlign: TextAlign.center,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF525252),fontSize:10,fontWeight: FontWeight.w400),))

                                ),
                                SizedBox(
                                  width:10,
                                ),
                                FlatButton(
                                  // minWidth: 15,
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(50.0),
                                  //     side: BorderSide(color: Colors.black)),

                                    textColor: Colors.black,
                                    color: Colors.white,
                                    onPressed:thCheck? () async{
                                      thursdayClose= await _showTimePicker(thursdayClose);
                                      thClose= await format(thursdayClose);
                                      thursdayClose=thClose;
                                      setState(() {

                                      });

                                    }:null,
                                    child:Text(thClose??item[4]['close']??"Select Time",textAlign: TextAlign.center,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF525252),fontSize:10,fontWeight: FontWeight.w400),))


                                ),
                              ]
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                height:0.5,
                                width:200,
                                color:Color(0xFFAFAFAF),

                                // indent: 1,
                              ),
                              SizedBox(width:20),
                              Container(
                                alignment: Alignment.centerRight,
                                height:0.5,
                                width:90,
                                color:Color(0xFFAFAFAF),

                                // indent: 1,
                              ),
                            ],
                          ),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children:[
                                Expanded(flex:1,
                                  child: Checkbox(

                                    //checkColor: Colors.black,
                                    activeColor: Color(0xFF28D286),
                                    value: frCheck,
                                    onChanged:is24?null: (bool value) {
                                      frCheck=!frCheck;
                                      setState(() {

                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width:5),
                                Expanded(flex:3,child: Text("FRIDAY",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w500),))),
                                FlatButton(
                                  // minWidth: 15,
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(50.0),
                                  //     side: BorderSide(color: Colors.black)),

                                    textColor: Colors.black,
                                    color: Colors.white,
                                    onPressed:frCheck? () async{
                                      fridayOpen= await _showTimePicker(fridayOpen);
                                      frOpen= await format(fridayOpen);
                                      fridayOpen=frOpen;
                                      setState(() {

                                      });

                                    }:null,
                                    child:Text(frOpen??item[5]['open']??"Select Time",textAlign: TextAlign.center,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF525252),fontSize:10,fontWeight: FontWeight.w400),))


                                ),
                                SizedBox(
                                  width:10,
                                ),
                                FlatButton(
                                  // minWidth: 15,
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(50.0),
                                  //     side: BorderSide(color: Colors.black)),

                                    textColor: Colors.black,
                                    color: Colors.white,
                                    onPressed:frCheck? () async{
                                      fridayClose= await _showTimePicker(fridayClose);
                                      frClose= await format(fridayClose);
                                      fridayClose=frClose;
                                      setState(() {

                                      });

                                    }:null,
                                    child:Text(frClose??item[5]['close']??"Select Time",textAlign: TextAlign.center,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF525252),fontSize:10,fontWeight: FontWeight.w400),))


                                ),
                              ]
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                height:0.5,
                                width:200,
                                color:Color(0xFFAFAFAF),

                                // indent: 1,
                              ),
                              SizedBox(width:20),
                              Container(
                                alignment: Alignment.centerRight,
                                height:0.5,
                                width:90,
                                color:Color(0xFFAFAFAF),

                                // indent: 1,
                              ),
                            ],
                          ),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children:[
                                Expanded(flex:1,
                                  child: Checkbox(

                                    // checkColor: Colors.black,
                                    activeColor: Color(0xFF28D286),
                                    value: saCheck,
                                    onChanged:is24?null: (bool value) {
                                      saCheck=!saCheck;
                                      setState(() {


                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width:5),
                                Expanded(flex:3,child: Text("SATURDAY",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:10,fontWeight: FontWeight.w500),))),
                                FlatButton(
                                  // minWidth: 15,
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(50.0),
                                  //     side: BorderSide(color: Colors.black)),

                                    textColor: Colors.black,
                                    color: Colors.white,
                                    onPressed:saCheck? () async{
                                      saturdayOpen = await _showTimePicker(saturdayOpen);
                                      saOpen= await format(saturdayOpen);
                                      saturdayOpen=saOpen;
                                      setState(() {


                                      });

                                    }:null,
                                    child:Text(saOpen??item[6]['open']??"Select Time",textAlign: TextAlign.center,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF525252),fontSize:10,fontWeight: FontWeight.w400),))
                                ),
                                SizedBox(
                                  width:10,
                                ),
                                FlatButton(
                                  // minWidth: 15,
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(50.0),
                                  //     side: BorderSide(color: Colors.black)),

                                    textColor: Colors.black,
                                    color: Colors.white,
                                    onPressed: saCheck?() async{
                                      saturdayClose= await _showTimePicker(saturdayClose);
                                      saClose= await format(saturdayClose);
                                      saturdayClose=saClose;
                                      setState(() {

                                      });

                                    }:null,
                                    child:Text(saClose??item[6]['close']??"Select Time",textAlign: TextAlign.center,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF525252),fontSize:10,fontWeight: FontWeight.w400),))


                                ),

                              ]

                          ),
                          SizedBox(
                            height:10,
                          ),


                        ],),
                    ),
                    // SizedBox(height: 150,),
                    progress3?Center( child: CircularProgressIndicator(),):
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
                          child: Text('Edit',style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.white,fontSize:11,fontWeight: FontWeight.w500),)),
                          onPressed: ()async {
                            if(_mySelection1.isEmpty)
                              Fluttertoast.showToast(
                                msg:"Please select atlest 1 subcategory",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                              );
                            else
                              await senddata();

                          },
                        )),
                  ],
                ) )));
  }
  bool progress3=false;
  List working=[];
  Future <void> senddata() async {
    setState(() {
      progress3=true;
    });
    try{
    working = [
      <String, dynamic> {"working": suCheck, "day": "Sunday", "open": sundayOpen, "close": sundayClose},
      <String, dynamic> {"working": moCheck, "day": "Monday", "open": mondayOpen, "close": mondayClose},
      <String, dynamic> {"working": tuCheck, "day": "Tuesday", "open": tuesdayOpen, "close": tuesdayClose},
      <String, dynamic> {"working": weCheck, "day": "Wednesday", "open": wenesdayOpen, "close": wenesdayClose},
      <String, dynamic> {"working": thCheck, "day": "Thrusday", "open": thursdayOpen, "close": thursdayClose},
      <String, dynamic>{"working": frCheck, "day": "Friday", "open": fridayOpen, "close": fridayClose},
      <String, dynamic> {"working": saCheck, "day": "Saturday", "open": saturdayOpen, "close": saturdayClose},
    ];
    String token = await Prefmanager.getToken();
    print(token);
    var url = Prefmanager.baseurl+'/seller/profile/level2';
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };


    Map<String, dynamic> data = {
      //'token':token,
     // 'category':[_mySelection],
      'subcategory':_mySelection1,
      "is24x7": is24,
      "workingHour":working,
    };

    print(data.toString());
    // var response = await NetWorkCalls.postRequest("/branch/add/workingHour",sendData:data );
    var body=json.encode(data);
    var response = await http.post(url,headers:requestHeaders,body: body);
    print(response.body);

    print(json.decode(response.body));
    if (response.statusCode == 200) {
    if (json.decode(response.body)['status']) {

      Navigator.of(context).pop(true);
    }

    else {
     check();
      setState(() {
        progress3=false;
      });
    }
    }
    else {
      print('Request failed with status: ${response.statusCode}.');
    }
    } on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: "No internet",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      progress3=false;
    });

  }
  void check() async{
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
         title: new Text("Cant't remove this subcategory as product is added in this subcategory",style: GoogleFonts.poppins(textStyle:TextStyle(fontSize: 12))),
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
}
