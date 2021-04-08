import 'dart:io';

import 'package:eram_app/SellerBankDetail.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:eram_app/Prefmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class SellerworkHour extends StatefulWidget {
  @override
  _SellerworkHour createState() => _SellerworkHour();
}

class _SellerworkHour extends State<SellerworkHour> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController bankController = TextEditingController();
  TextEditingController accountHolderController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  var _mySelection;
  var _mySelection1=[];
  var valuelength;
  String selectedDate;
  var sundayOpen,
      sundayClose,
      mondayOpen,
      mondayClose,
      tuesdayOpen,
      tuesdayClose,
      wenesdayOpen,
      wenesdayClose,
      thursdayOpen,
      thursdayClose,
      fridayOpen,
      fridayClose,
      saturdayOpen,
      saturdayClose;
  //var suCheck;
  bool is24 = false;
  bool suCheck = false;
  bool moCheck = false;
  bool tuCheck = false;
  bool weCheck = false;
  bool thCheck = false;
  bool frCheck = false;
  bool saCheck = false;
  var time;
  String suOpen,
      suClose,
      moOpen,
      moClose,
      tuOpen,
      tuClose,
      weOpen,
      weClose,
      thOpen,
      thClose,
      frOpen,
      frClose,
      saOpen,
      saClose;
  Future<String> _showTimePicker(String time) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: time == null
            ? TimeOfDay(hour: 5, minute: 10)
            : TimeOfDay.fromDateTime(DateFormat.jm().parse(time)));

    if (picked != null) {
      print(picked.format(context));
      return picked.format(context);
    } else
      return null;
  }

  format(picked) {
    var pik = TimeOfDay.fromDateTime(DateFormat.jm().parse(picked));
    var selectedDate = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, pik.hour, pik.minute);

    String formattedDate = DateFormat('HH:mm').format(selectedDate);
    print(formattedDate);
    return formattedDate;
  }

  void initState() {
    super.initState();
    category();
  }

  //  void sample()async{
  //   await category();
  //
  // }
  var listcat = [];
  List id = [];
  bool progress = true;
  void category() async {
    var url = Prefmanager.baseurl + '/category/list';
    var response = await http.get(url);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      listcat = json.decode(response.body)['data'];
      //id=json.decode(response.body)['data']['_id'];
      // for(int i=0;i<json.decode(response.body)['data'].length;i++)
      // id.add(json.decode(response.body)["data"][i]['_id']);

    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress = false;
    setState(() {});
  }

  //List catid=[];
  var listsubcat = [];
  bool progress1 = true;
  void subCategory(m) async {
    //catid.add(m);
    var url = Prefmanager.baseurl + '/subcategory/list/' + _mySelection;
    var response = await http.get(url);
    print('/subcategory/list/$id');
    print("hhh");
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      listsubcat = json.decode(response.body)['data'];
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: Color(0xFFFFFFFF),
            appBar: AppBar(
              title: Text("Account Settings",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  )),
              automaticallyImplyLeading: false,
            ),
            body: Form(
                key: _formKey,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: ListView(
                      children: <Widget>[
                        Text("Account Information Progress",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600))),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: LinearProgressIndicator(
                            backgroundColor: Color(0xFFF0F0F0),
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Color(0xFF408BFF)),
                            value: 0.7,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("2/4 Steps",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xFF454545),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400))),
                        SizedBox(height: 30),
                        Text("Category",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xFFAFAFAF),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400))),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: DropdownButton(
                            isExpanded: true,
                            hint: Text("Select Category"),
                            items: listcat.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(item['name']),
                                value: item['_id'].toString(),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                _mySelection1.clear();
                                _mySelection = newVal;
                              });
                                print(_mySelection);
                                subCategory(_mySelection);


                            },
                            value: _mySelection,
                          ),
                        ),
                        Text("Services Provided",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xFFAFAFAF),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400))),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: MultiSelectFormField(
                              fillColor: Colors.white,
                              title: Text("Select"),
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
                                for (int i = 0; i < listsubcat.length; i++)
                                  {
                                    "display": listsubcat[i]["name"],
                                    "value": listsubcat[i]["_id"],
                                  }
                              ],
                              chipBackGroundColor: Colors.red,
                              chipLabelStyle: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300),
                              ),
                              textField: 'display',
                              valueField: 'value',
                              required: true,
                              onSaved: (value) {
                                print('The value is $value');
                                valuelength = value.length;
                                print(valuelength);
                                //Text(valuelength.toString());
                                _mySelection1 = value;
                              }),
                        ),

                        //Text(valuelength.toString()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Is 24*7",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500),
                                )),
                            Switch(
                              value: is24,
                              onChanged: (value) {
                                is24 = !is24;
                                if (is24) {
                                  suCheck = false;
                                  moCheck = false;
                                  tuCheck = false;
                                  weCheck = false;
                                  thCheck = false;
                                  frCheck = false;
                                  saCheck = false;
                                } else {
                                  suCheck = true;
                                  moCheck = true;
                                  tuCheck = true;
                                  weCheck = true;
                                  thCheck = true;
                                  frCheck = true;
                                  saCheck = true;
                                }
                                setState(() {});
                              },
                              activeTrackColor: Colors.red,
                              activeColor: Colors.white,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.center,
                              ),
                              // SizedBox(
                              //   height: 20,
                              // ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Store Working Hour",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Color(0xFF5F5F5F),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        )),
                                    Text("Opening Time",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Color(0xFF5F5F5F),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        )),
                                    Text("Closing Time",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Color(0xFF5F5F5F),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        )),
                                  ]),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Spacer(),
                                  Container(
                                    height: 0.5,
                                    width: 85,
                                    color: Color(0xFFAFAFAF),

                                    // indent: 1,
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    height: 0.5,
                                    width: 90,
                                    color: Color(0xFFAFAFAF),

                                    // indent: 1,
                                  ),
                                ],
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Checkbox(
                                        //checkColor: Colors.black,
                                        activeColor: Color(0xFF28D286),
                                        value: suCheck,
                                        // groupValue: suCheck,
                                        onChanged: is24
                                            ? null
                                            : (bool value) {
                                                suCheck = !suCheck;
                                                // suCheck=value;
                                                setState(() {});
                                              },
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                        flex: 3,
                                        child: Text("SUNDAY",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500),
                                            ))),
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
                                        onPressed: suCheck
                                            ? () async {
                                                sundayOpen =
                                                    await _showTimePicker(
                                                        sundayOpen);
                                                suOpen =
                                                    await format(sundayOpen);
                                                setState(() {});
                                              }
                                            : null,
                                        child: Text(
                                            sundayOpen == null
                                                ? "Select Time"
                                                : sundayOpen,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF525252),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400),
                                            ))),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    FlatButton(
                                        // minWidth: 15,
                                        // shape: RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.circular(50.0),
                                        //     side: BorderSide(color: Colors.black)),

                                        textColor: Colors.black,
                                        color: Colors.white,
                                        onPressed: suCheck
                                            ? () async {
                                                sundayClose =
                                                    await _showTimePicker(
                                                        sundayClose);
                                                suClose =
                                                    await format(sundayClose);
                                                setState(() {});
                                              }
                                            : null,
                                        child: Text(
                                          sundayClose == null
                                              ? "Select Time"
                                              : sundayClose,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xFF525252),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        )

                                        //child: Text('Edit Profile',style: TextStyle(fontSize: 10),),
                                        ),
                                  ]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    height: 0.5,
                                    width: 200,
                                    color: Color(0xFFAFAFAF),

                                    // indent: 1,
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    height: 0.5,
                                    width: 90,
                                    color: Color(0xFFAFAFAF),

                                    // indent: 1,
                                  ),
                                ],
                              ),

                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Checkbox(
                                        //checkColor: Colors.black,
                                        activeColor: Color(0xFF28D286),
                                        value: moCheck,
                                        onChanged: is24
                                            ? null
                                            : (bool value) {
                                                moCheck = !moCheck;
                                                setState(() {});
                                              },
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                        flex: 3,
                                        child: Text("MONDAY",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500),
                                            ))),
                                    FlatButton(
                                        // minWidth:15,
                                        // shape: RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.circular(50.0),
                                        //     side: BorderSide(color: Colors.black)),

                                        textColor: Colors.black,
                                        color: Colors.white,
                                        onPressed: moCheck
                                            ? () async {
                                                mondayOpen =
                                                    await _showTimePicker(
                                                        mondayOpen);
                                                moOpen =
                                                    await format(mondayOpen);
                                                setState(() {});
                                              }
                                            : null,
                                        child: Text(
                                            mondayOpen == null
                                                ? "Select Time"
                                                : mondayOpen,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF525252),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400),
                                            ))
                                        //child: Text('Edit Profile',style: TextStyle(fontSize: 10),),

                                        ),
                                    SizedBox(width: 10),
                                    FlatButton(
                                        // minWidth: 15,
                                        // shape: RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.circular(50.0),
                                        //     side: BorderSide(color: Colors.black)),

                                        textColor: Colors.black,
                                        color: Colors.white,
                                        onPressed: moCheck
                                            ? () async {
                                                mondayClose =
                                                    await _showTimePicker(
                                                        mondayClose);
                                                moClose =
                                                    await format(mondayClose);
                                                setState(() {});
                                              }
                                            : null,
                                        child: Text(
                                            mondayClose == null
                                                ? "Select Time"
                                                : mondayClose,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF525252),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400),
                                            ))),
                                  ]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    height: 0.5,
                                    width: 200,
                                    color: Color(0xFFAFAFAF),

                                    // indent: 1,
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    height: 0.5,
                                    width: 90,
                                    color: Color(0xFFAFAFAF),

                                    // indent: 1,
                                  ),
                                ],
                              ),

                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Checkbox(
                                        //checkColor: Colors.black,
                                        activeColor: Color(0xFF28D286),
                                        value: tuCheck,
                                        onChanged: is24
                                            ? null
                                            : (bool value) {
                                                tuCheck = !tuCheck;
                                                setState(() {});
                                              },
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                        flex: 3,
                                        child: Text("TUESDAY",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500),
                                            ))),
                                    FlatButton(
                                        // minWidth: 15,
                                        // shape: RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.circular(50.0),
                                        //     side: BorderSide(color: Colors.black)),

                                        textColor: Colors.black,
                                        color: Colors.white,
                                        onPressed: tuCheck
                                            ? () async {
                                                tuesdayOpen =
                                                    await _showTimePicker(
                                                        tuesdayOpen);
                                                tuOpen =
                                                    await format(tuesdayOpen);
                                                setState(() {});
                                              }
                                            : null,
                                        child: Text(
                                            tuesdayOpen == null
                                                ? "Select Time"
                                                : tuesdayOpen,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF525252),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400),
                                            ))),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    FlatButton(
                                        // minWidth: 15,
                                        // shape: RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.circular(50.0),
                                        //     side: BorderSide(color: Colors.black)),

                                        textColor: Colors.black,
                                        color: Colors.white,
                                        onPressed: tuCheck
                                            ? () async {
                                                tuesdayClose =
                                                    await _showTimePicker(
                                                        tuesdayClose);
                                                tuClose =
                                                    await format(tuesdayClose);
                                                setState(() {});
                                              }
                                            : null,
                                        child: Text(
                                            tuesdayClose == null
                                                ? "Select Time"
                                                : tuesdayClose,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF525252),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400),
                                            ))),
                                  ]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    height: 0.5,
                                    width: 200,
                                    color: Color(0xFFAFAFAF),

                                    // indent: 1,
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    height: 0.5,
                                    width: 90,
                                    color: Color(0xFFAFAFAF),

                                    // indent: 1,
                                  ),
                                ],
                              ),

                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Checkbox(
                                        //checkColor: Colors.black,
                                        activeColor: Color(0xFF28D286),
                                        value: weCheck,
                                        onChanged: is24
                                            ? null
                                            : (bool value) {
                                                weCheck = !weCheck;
                                                setState(() {});
                                              },
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                        flex: 3,
                                        child: Text("WENESDAY",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500),
                                            ))),
                                    FlatButton(
                                        // minWidth: 15,
                                        // shape: RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.circular(50.0),
                                        //     side: BorderSide(color: Colors.black)),

                                        textColor: Colors.black,
                                        color: Colors.white,
                                        onPressed: weCheck
                                            ? () async {
                                                wenesdayOpen =
                                                    await _showTimePicker(
                                                        wenesdayOpen);
                                                weOpen =
                                                    await format(wenesdayOpen);
                                                setState(() {});
                                              }
                                            : null,
                                        child: Text(
                                            wenesdayOpen == null
                                                ? "Select Time"
                                                : wenesdayOpen,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF525252),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400),
                                            ))),
                                    SizedBox(width: 10),
                                    FlatButton(
                                        // minWidth: 15,
                                        // shape: RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.circular(50.0),
                                        //     side: BorderSide(color: Colors.black)),

                                        textColor: Colors.black,
                                        color: Colors.white,
                                        onPressed: weCheck
                                            ? () async {
                                                wenesdayClose =
                                                    await _showTimePicker(
                                                        wenesdayClose);
                                                weClose =
                                                    await format(wenesdayClose);
                                                setState(() {});
                                              }
                                            : null,
                                        child: Text(
                                            wenesdayClose == null
                                                ? "Select Time"
                                                : wenesdayClose,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF525252),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400),
                                            ))),
                                  ]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    height: 0.5,
                                    width: 200,
                                    color: Color(0xFFAFAFAF),

                                    // indent: 1,
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    height: 0.5,
                                    width: 90,
                                    color: Color(0xFFAFAFAF),

                                    // indent: 1,
                                  ),
                                ],
                              ),

                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Checkbox(
                                        // checkColor: Colors.black,
                                        activeColor: Color(0xFF28D286),
                                        value: thCheck,
                                        onChanged: is24
                                            ? null
                                            : (bool value) {
                                                thCheck = !thCheck;
                                                setState(() {});
                                              },
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                        flex: 3,
                                        child: Text("THURSDAY",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500),
                                            ))),
                                    FlatButton(
                                        // minWidth: 15,
                                        // shape: RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.circular(50.0),
                                        //     side: BorderSide(color: Colors.black)),

                                        textColor: Colors.black,
                                        color: Colors.white,
                                        onPressed: thCheck
                                            ? () async {
                                                thursdayOpen =
                                                    await _showTimePicker(
                                                        thursdayOpen);
                                                thOpen =
                                                    await format(thursdayOpen);
                                                setState(() {});
                                              }
                                            : null,
                                        child: Text(
                                            thursdayOpen == null
                                                ? "Select Time"
                                                : thursdayOpen,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF525252),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400),
                                            ))),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    FlatButton(
                                        // minWidth: 15,
                                        // shape: RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.circular(50.0),
                                        //     side: BorderSide(color: Colors.black)),

                                        textColor: Colors.black,
                                        color: Colors.white,
                                        onPressed: thCheck
                                            ? () async {
                                                thursdayClose =
                                                    await _showTimePicker(
                                                        thursdayClose);
                                                thClose =
                                                    await format(thursdayClose);
                                                setState(() {});
                                              }
                                            : null,
                                        child: Text(
                                            thursdayClose == null
                                                ? "Select Time"
                                                : thursdayClose,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF525252),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400),
                                            ))),
                                  ]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    height: 0.5,
                                    width: 200,
                                    color: Color(0xFFAFAFAF),

                                    // indent: 1,
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    height: 0.5,
                                    width: 90,
                                    color: Color(0xFFAFAFAF),

                                    // indent: 1,
                                  ),
                                ],
                              ),

                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Checkbox(
                                        //checkColor: Colors.black,
                                        activeColor: Color(0xFF28D286),
                                        value: frCheck,
                                        onChanged: is24
                                            ? null
                                            : (bool value) {
                                                frCheck = !frCheck;
                                                setState(() {});
                                              },
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                        flex: 3,
                                        child: Text("FRIDAY",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500),
                                            ))),
                                    FlatButton(
                                        // minWidth: 15,
                                        // shape: RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.circular(50.0),
                                        //     side: BorderSide(color: Colors.black)),

                                        textColor: Colors.black,
                                        color: Colors.white,
                                        onPressed: frCheck
                                            ? () async {
                                                fridayOpen =
                                                    await _showTimePicker(
                                                        fridayOpen);
                                                frOpen =
                                                    await format(fridayOpen);
                                                setState(() {});
                                              }
                                            : null,
                                        child: Text(
                                            fridayOpen == null
                                                ? "Select Time"
                                                : fridayOpen,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF525252),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400),
                                            ))),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    FlatButton(
                                        // minWidth: 15,
                                        // shape: RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.circular(50.0),
                                        //     side: BorderSide(color: Colors.black)),

                                        textColor: Colors.black,
                                        color: Colors.white,
                                        onPressed: frCheck
                                            ? () async {
                                                fridayClose =
                                                    await _showTimePicker(
                                                        fridayClose);
                                                frClose =
                                                    await format(fridayClose);
                                                setState(() {});
                                              }
                                            : null,
                                        child: Text(
                                            fridayClose == null
                                                ? "Select Time"
                                                : fridayClose,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF525252),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400),
                                            ))),
                                  ]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    height: 0.5,
                                    width: 200,
                                    color: Color(0xFFAFAFAF),

                                    // indent: 1,
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    height: 0.5,
                                    width: 90,
                                    color: Color(0xFFAFAFAF),

                                    // indent: 1,
                                  ),
                                ],
                              ),

                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Checkbox(
                                        // checkColor: Colors.black,
                                        activeColor: Color(0xFF28D286),
                                        value: saCheck,
                                        onChanged: is24
                                            ? null
                                            : (bool value) {
                                                saCheck = !saCheck;
                                                setState(() {});
                                              },
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                        flex: 3,
                                        child: Text("SATURDAY",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500),
                                            ))),
                                    FlatButton(
                                        // minWidth: 15,
                                        // shape: RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.circular(50.0),
                                        //     side: BorderSide(color: Colors.black)),

                                        textColor: Colors.black,
                                        color: Colors.white,
                                        onPressed: saCheck
                                            ? () async {
                                                saturdayOpen =
                                                    await _showTimePicker(
                                                        saturdayOpen);
                                                saOpen =
                                                    await format(saturdayOpen);
                                                setState(() {});
                                              }
                                            : null,
                                        child: Text(
                                            saturdayOpen == null
                                                ? "Select Time"
                                                : saturdayOpen,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF525252),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400),
                                            ))),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    FlatButton(
                                        // minWidth: 15,
                                        // shape: RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.circular(50.0),
                                        //     side: BorderSide(color: Colors.black)),

                                        textColor: Colors.black,
                                        color: Colors.white,
                                        onPressed: saCheck
                                            ? () async {
                                                saturdayClose =
                                                    await _showTimePicker(
                                                        saturdayClose);
                                                saClose =
                                                    await format(saturdayClose);
                                                setState(() {});
                                              }
                                            : null,
                                        child: Text(
                                            saturdayClose == null
                                                ? "Select Time"
                                                : saturdayClose,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF525252),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400),
                                            ))),
                                  ]),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(height: 150,),
                        progress2
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container(
                                height: 50,
                                width: 80,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: FlatButton(
                                    textColor: Colors.white,
                                    color: Color(0xFFFC4B4B),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Color(0xFFD2D2D2)),
                                        borderRadius:
                                            BorderRadius.circular(7.0)),
                                    child: Text('Next',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500),
                                        )),
                                    onPressed: () async {
                                      // if (_formKey.currentState.validate()) {
                                      //   _formKey.currentState.save();
                                      if (_mySelection == null)
                                        Fluttertoast.showToast(
                                          msg: "Please select category",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                        );
                                      else if (_mySelection1 == null)
                                        Fluttertoast.showToast(
                                          msg: "Please select subcategory",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                        );
                                      else if (is24 == false) {
                                        if (suCheck == false &&
                                            moCheck == false &&
                                            tuCheck == false &&
                                            weCheck == false &&
                                            thCheck == false &&
                                            frCheck == false &&
                                            saCheck == false)
                                          Fluttertoast.showToast(
                                            msg: "Please select working hour",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                          );
                                        else if (suCheck == true &&
                                            (sundayOpen == null ||
                                                sundayClose == null))
                                          Fluttertoast.showToast(
                                            msg: "Please select working hour",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                          );
                                        else if (moCheck == true &&
                                            (mondayOpen == null ||
                                                mondayClose == null))
                                          Fluttertoast.showToast(
                                            msg: "Please select working hour",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                          );
                                        else if (tuCheck == true &&
                                            (tuesdayOpen == null ||
                                                tuesdayClose == null))
                                          Fluttertoast.showToast(
                                            msg: "Please select working hour",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                          );
                                        else if (weCheck == true &&
                                            (wenesdayOpen == null ||
                                                wenesdayClose == null))
                                          Fluttertoast.showToast(
                                            msg: "Please select working hour",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                          );
                                        else if (thCheck == true &&
                                            (thursdayOpen == null ||
                                                thursdayClose == null))
                                          Fluttertoast.showToast(
                                            msg: "Please select working hour",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                          );
                                        else if (frCheck == true &&
                                            (fridayOpen == null ||
                                                fridayClose == null))
                                          Fluttertoast.showToast(
                                            msg: "Please select working hour",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                          );
                                        else if (saCheck == true &&
                                            (saturdayOpen == null ||
                                                saturdayClose == null))
                                          Fluttertoast.showToast(
                                            msg: "Please select working hour",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                          );
                                        else
                                          senddata();
                                      } else
                                        senddata();
                                    }

                                    //},
                                    )),
                      ],
                    )))));
  }

  bool progress2 = false;
  List working = [];
  Future<void> senddata() async {
    setState(() {
      progress2 = true;
    });
    try {
      working = [
        <String, dynamic>{
          "working": suCheck,
          "day": "Sunday",
          "open": suOpen,
          "close": suClose
        },
        <String, dynamic>{
          "working": moCheck,
          "day": "Monday",
          "open": moOpen,
          "close": moClose
        },
        <String, dynamic>{
          "working": tuCheck,
          "day": "Tuesday",
          "open": tuOpen,
          "close": tuClose
        },
        <String, dynamic>{
          "working": weCheck,
          "day": "Wednesday",
          "open": weOpen,
          "close": weClose
        },
        <String, dynamic>{
          "working": thCheck,
          "day": "Thrusday",
          "open": thOpen,
          "close": thClose
        },
        <String, dynamic>{
          "working": frCheck,
          "day": "Friday",
          "open": frOpen,
          "close": frClose
        },
        <String, dynamic>{
          "working": saCheck,
          "day": "Saturday",
          "open": saOpen,
          "close": saClose
        },
      ];
      String token = await Prefmanager.getToken();
      print(token);
      var url = Prefmanager.baseurl + '/seller/profile/level2';
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': token
      };

      Map<String, dynamic> data = {
        //'token':token,
        'category': [_mySelection],
        'subcategory': _mySelection1,
        "is24x7": is24,
        "workingHour": working,
      };

      print(data.toString());
      // var response = await NetWorkCalls.postRequest("/branch/add/workingHour",sendData:data );
      var body = json.encode(data);
      var response = await http.post(url, headers: requestHeaders, body: body);
      print(response.body);

      print(json.decode(response.body));
      if (response.statusCode == 200) {
      if (json.decode(response.body)['status']) {
        await Prefmanager.setLevel(json.decode(response.body)['level']);
        print("Sucess");
        Navigator.push(context,
            new MaterialPageRoute(
                builder: (context) => new SellerBankDetail()));
      } else {
        Fluttertoast.showToast(
            msg: json.decode(response.body)['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 20.0);
        setState(() {
          progress2 = false;
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
      progress2=false;
    });

  }
}
