import 'dart:convert';
//import 'dart:html';
import 'package:eram_app/Prefmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkingHour extends StatefulWidget {
  @override
  _WorkingHour createState() => _WorkingHour();
}

class _WorkingHour extends State<WorkingHour> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black12, //change your color here
              ),
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: Text('Add Working Hour',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  )),
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                color: Colors.black,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: new Container(
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: ListView(children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Is 24*7",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 14,
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
                            activeTrackColor: Colors.blue,
                            activeColor: Colors.white,
                          ),
                        ],
                      ),
                      Card(

                          //color:Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          elevation: 4.0,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Days",
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xFF000000),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          )),
                                      Text("Opening Time",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xFF000000),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          )),
                                      Text("Closing Time",
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xFF000000),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          )),
                                    ]),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Checkbox(
                                          checkColor: Colors.black,
                                          activeColor: Colors.white,
                                          value: suCheck,
                                          onChanged: is24
                                              ? null
                                              : (bool value) {
                                                  suCheck = !suCheck;
                                                  setState(() {});
                                                },
                                        ),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Text("Sunday",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFF000000),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ))),
                                      //Text("Opening Time",style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold,)),
                                      //Text("Opening Time",style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold,)),

                                      MaterialButton(
                                          minWidth: 15,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              side: BorderSide(
                                                  color: Colors.black)),
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
                                            style: TextStyle(fontSize: 10),
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      MaterialButton(
                                          minWidth: 15,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              side: BorderSide(
                                                  color: Colors.black)),
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
                                            style: TextStyle(fontSize: 10),
                                          )

                                          //child: Text('Edit Profile',style: TextStyle(fontSize: 10),),

                                          ),
                                    ]),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Checkbox(
                                          checkColor: Colors.black,
                                          activeColor: Colors.white,
                                          value: moCheck,
                                          onChanged: is24
                                              ? null
                                              : (bool value) {
                                                  moCheck = !moCheck;
                                                  setState(() {});
                                                },
                                        ),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Text("Monday",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFF000000),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ))),
                                      MaterialButton(
                                          minWidth: 15,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              side: BorderSide(
                                                  color: Colors.black)),
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
                                            style: TextStyle(fontSize: 10),
                                          )
                                          //child: Text('Edit Profile',style: TextStyle(fontSize: 10),),

                                          ),
                                      SizedBox(width: 10),
                                      MaterialButton(
                                          minWidth: 15,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              side: BorderSide(
                                                  color: Colors.black)),
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
                                            style: TextStyle(fontSize: 10),
                                          )),
                                    ]),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Checkbox(
                                          checkColor: Colors.black,
                                          activeColor: Colors.white,
                                          value: tuCheck,
                                          onChanged: is24
                                              ? null
                                              : (bool value) {
                                                  tuCheck = !tuCheck;
                                                  setState(() {});
                                                },
                                        ),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Text("Tuesday",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFF000000),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ))),
                                      MaterialButton(
                                          minWidth: 15,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              side: BorderSide(
                                                  color: Colors.black)),
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
                                            style: TextStyle(fontSize: 10),
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      MaterialButton(
                                          minWidth: 15,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              side: BorderSide(
                                                  color: Colors.black)),
                                          textColor: Colors.black,
                                          color: Colors.white,
                                          onPressed: tuCheck
                                              ? () async {
                                                  tuesdayClose =
                                                      await _showTimePicker(
                                                          tuesdayClose);
                                                  tuClose = await format(
                                                      tuesdayClose);
                                                  setState(() {});
                                                }
                                              : null,
                                          child: Text(
                                            tuesdayClose == null
                                                ? "Select Time"
                                                : tuesdayClose,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 10),
                                          )),
                                    ]),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Checkbox(
                                          checkColor: Colors.black,
                                          activeColor: Colors.white,
                                          value: weCheck,
                                          onChanged: is24
                                              ? null
                                              : (bool value) {
                                                  weCheck = !weCheck;
                                                  setState(() {});
                                                },
                                        ),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Text("Wenesday",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFF000000),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ))),
                                      MaterialButton(
                                          minWidth: 15,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              side: BorderSide(
                                                  color: Colors.black)),
                                          textColor: Colors.black,
                                          color: Colors.white,
                                          onPressed: weCheck
                                              ? () async {
                                                  wenesdayOpen =
                                                      await _showTimePicker(
                                                          wenesdayOpen);
                                                  weOpen = await format(
                                                      wenesdayOpen);
                                                  setState(() {});
                                                }
                                              : null,
                                          child: Text(
                                            wenesdayOpen == null
                                                ? "Select Time"
                                                : wenesdayOpen,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 10),
                                          )),
                                      SizedBox(width: 10),
                                      MaterialButton(
                                          minWidth: 15,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              side: BorderSide(
                                                  color: Colors.black)),
                                          textColor: Colors.black,
                                          color: Colors.white,
                                          onPressed: weCheck
                                              ? () async {
                                                  wenesdayClose =
                                                      await _showTimePicker(
                                                          wenesdayClose);
                                                  weClose = await format(
                                                      wenesdayClose);
                                                  setState(() {});
                                                }
                                              : null,
                                          child: Text(
                                            wenesdayClose == null
                                                ? "Select Time"
                                                : wenesdayClose,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 10),
                                          )),
                                    ]),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Checkbox(
                                          checkColor: Colors.black,
                                          activeColor: Colors.white,
                                          value: thCheck,
                                          onChanged: is24
                                              ? null
                                              : (bool value) {
                                                  thCheck = !thCheck;
                                                  setState(() {});
                                                },
                                        ),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Text("Thursday",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFF000000),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ))),
                                      MaterialButton(
                                          minWidth: 15,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              side: BorderSide(
                                                  color: Colors.black)),
                                          textColor: Colors.black,
                                          color: Colors.white,
                                          onPressed: thCheck
                                              ? () async {
                                                  thursdayOpen =
                                                      await _showTimePicker(
                                                          thursdayOpen);
                                                  thOpen = await format(
                                                      thursdayOpen);
                                                  setState(() {});
                                                }
                                              : null,
                                          child: Text(
                                            thursdayOpen == null
                                                ? "Select Time"
                                                : thursdayOpen,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 10),
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      MaterialButton(
                                          minWidth: 15,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              side: BorderSide(
                                                  color: Colors.black)),
                                          textColor: Colors.black,
                                          color: Colors.white,
                                          onPressed: thCheck
                                              ? () async {
                                                  thursdayClose =
                                                      await _showTimePicker(
                                                          thursdayClose);
                                                  thClose = await format(
                                                      thursdayClose);
                                                  setState(() {});
                                                }
                                              : null,
                                          child: Text(
                                            thursdayClose == null
                                                ? "Select Time"
                                                : thursdayClose,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 10),
                                          )),
                                    ]),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Checkbox(
                                          checkColor: Colors.black,
                                          activeColor: Colors.white,
                                          value: frCheck,
                                          onChanged: is24
                                              ? null
                                              : (bool value) {
                                                  frCheck = !frCheck;
                                                  setState(() {});
                                                },
                                        ),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Text("Friday",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFF000000),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ))),
                                      MaterialButton(
                                          minWidth: 15,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              side: BorderSide(
                                                  color: Colors.black)),
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
                                            style: TextStyle(fontSize: 10),
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      MaterialButton(
                                          minWidth: 15,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              side: BorderSide(
                                                  color: Colors.black)),
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
                                            style: TextStyle(fontSize: 10),
                                          )),
                                    ]),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Checkbox(
                                          checkColor: Colors.black,
                                          activeColor: Colors.white,
                                          value: saCheck,
                                          onChanged: is24
                                              ? null
                                              : (bool value) {
                                                  saCheck = !saCheck;
                                                  setState(() {});
                                                },
                                        ),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Text("Saturday",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFF000000),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ))),
                                      MaterialButton(
                                          minWidth: 15,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              side: BorderSide(
                                                  color: Colors.black)),
                                          textColor: Colors.black,
                                          color: Colors.white,
                                          onPressed: saCheck
                                              ? () async {
                                                  saturdayOpen =
                                                      await _showTimePicker(
                                                          saturdayOpen);
                                                  saOpen = await format(
                                                      saturdayOpen);
                                                  setState(() {});
                                                }
                                              : null,
                                          child: Text(
                                            saturdayOpen == null
                                                ? "Select Time"
                                                : saturdayOpen,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 10),
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      MaterialButton(
                                          minWidth: 15,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              side: BorderSide(
                                                  color: Colors.black)),
                                          textColor: Colors.black,
                                          color: Colors.white,
                                          onPressed: saCheck
                                              ? () async {
                                                  saturdayClose =
                                                      await _showTimePicker(
                                                          saturdayClose);
                                                  saClose = await format(
                                                      saturdayClose);
                                                  setState(() {});
                                                }
                                              : null,
                                          child: Text(
                                            saturdayClose == null
                                                ? "Select Time"
                                                : saturdayClose,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 10),
                                          )),
                                    ]),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    width: 650,
                                    height: 50,
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: RaisedButton(
                                        //shape: RoundedRectangleBorder(
                                        //borderRadius: BorderRadius.circular(10.0),
                                        // side: BorderSide(color: Colors.black)),

                                        textColor: Colors.white,
                                        color: Colors.green,
                                        child: Text(
                                          'Submit',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        onPressed: () async {
                                          await senddata();
                                          //_scaffoldKey.currentState.showSnackBar(new SnackBar(
                                          //content: new Text("Your email: $_email and Password: $_password"),
                                        })),
                              ],
                            ),
                          ))
                    ])))));
  }

  List working = [];

  Future<void> senddata() async {
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
    var url = Prefmanager.baseurl + '/user/profile/edit';
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };

    Map<String, dynamic> data = {
      //'token':token,
      "is24x7": is24,
      "workingHour": working,
    };

    print(data.toString());
    // var response = await NetWorkCalls.postRequest("/branch/add/workingHour",sendData:data );
    var body = json.encode(data);
    var response = await http.post(url, headers: requestHeaders, body: body);
    print(response.body);

    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      print("Sucess");
    } else {
      print(json.decode(response.body)['message']);
      Fluttertoast.showToast(
          msg: json.decode(response.body)['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 20.0);
    }
  }
}
