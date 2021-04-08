import 'dart:convert';
import 'dart:io';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/SellerOfferslist.dart';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


class AddOffer extends StatefulWidget {
  @override
  _AddOffer createState() => _AddOffer();
}

class _AddOffer extends State<AddOffer> {

  TimeOfDay _time = new TimeOfDay.now();
String formattedDate;
  //TimeOfDay _time1 = new TimeOfDay.now();

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if(picked != null) {
      print('Time selected: ${_time.toString()}');
      setState((){
        // _time = picked;
        // starttimeController.text=_time.format(context);
        // print(starttimeController.text);
        var pik = TimeOfDay.fromDateTime(DateFormat.jm().parse(picked.format(context)));
        var selectedDate = DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, pik.hour, pik.minute);

         formattedDate = DateFormat('HH:mm').format(selectedDate);
        starttimeController.text=formattedDate;
      });
    }
  }
  Future<Null> _selectTime1(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if(picked != null ) {
      print('Time selected: ${_time.toString()}');
      setState((){
        // _time = picked;
        // starttimeController.text=_time.format(context);
        // print(starttimeController.text);
        var pik = TimeOfDay.fromDateTime(DateFormat.jm().parse(picked.format(context)));
        var selectedDate = DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, pik.hour, pik.minute);

        String formattedDate = DateFormat('HH:mm').format(selectedDate);
        enddtimeController.text=formattedDate;
      });
    }
  }
  // Future<Null> _selectTime1(BuildContext context) async {
  //   final TimeOfDay picked = await showTimePicker(
  //     context: context,
  //     initialTime: _time1,
  //   );
  //
  //   if(picked != null && picked != _time1) {
  //     print('Time selected: ${_time1.toString()}');
  //     setState((){
  //       _time1 = picked;
  //       print(_time1);
  //       //enddtimeController.text=DateFormat.jm().format(_time1);
  //       enddtimeController.text=_time1.toString();
  //       print( enddtimeController.text);
  //     });
  //   }
  // }

  File _image;
  _imgFromCamera() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );
    setState(() {
      _image = image;
    });
  }
  _imgFromGallery() async {
    // ignore: deprecated_member_use
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    setState(() {
      _image = image;
    });
  }
  //PickedFile _image;
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () async {
                        //_image = await CameraHelper.getImage(0);
                        //setState(() {});
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () async {
                     // _image = await CameraHelper.getImage(1);
                     // setState(() {});
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
  DateTime currentDate = DateTime.now();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startdateController = TextEditingController();
  TextEditingController enddateController = TextEditingController();
  TextEditingController starttimeController = TextEditingController();
  TextEditingController enddtimeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void initState() {
    super.initState();
   // starttimeController.text=_time;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text("Add Offer",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  )),
            ),
            automaticallyImplyLeading: true,
            actions: [
              Row(
                children: [
                  Divider(
                    height: 20,
                    thickness: 1,
                    indent: 1,
                  ),
                ],
              ),
            ]),
        body: Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: ListView(
                  children: <Widget>[

                    // Container(
                    //   alignment: Alignment.topCenter,
                    //   padding: new EdgeInsets.all(20.0),
                    //   //padding:EdgeInsets.fromLTRB(20, 0, 20, 0),
                    //   child: Stack(
                    //     children: [
                    //       // Container(
                    //       //   padding: EdgeInsets.all(10),
                    //       //   alignment: Alignment.bottomCenter,
                    //       //   child: CircleAvatar(
                    //       //     radius: 80.0,
                    //       //     backgroundColor: Colors.blue,
                    //       //     backgroundImage:AssetImage('assets/userlogo.jpg'),
                    //       //
                    //       //
                    //       //   ),
                    //       // ),
                    //
                    //       CircleAvatar(
                    //         radius: 40,
                    //         backgroundColor: Color(0xFFE3F2FD),
                    //         backgroundImage:_image == null
                    //             ? AssetImage('assets/userlogo.jpg')
                    //             : FileImage(_image),
                    //       ),
                    //       new Positioned(
                    //           bottom: 1,
                    //           right: 2,
                    //           child: ClipOval(
                    //             child: Container(
                    //               height: 30,
                    //               width: 30,
                    //               color: Color(0xFFF4F4F4),
                    //               child: IconButton(
                    //                 icon: Icon(Icons.edit_outlined,
                    //                     size: 15, color: Color(0xFF000000)),
                    //                 onPressed: () {
                    //                   _showPicker(context);
                    //                 },
                    //               ),
                    //             ),
                    //           ))
                    //     ],
                    //   ),
                    // ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: _image!=null?
                        CircleAvatar(
                          radius: 80,
                          backgroundColor: Color(0xFFE3F2FD),
                          backgroundImage:FileImage(
                            _image,
                          ),
                        )
                            : Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(100)),
                          width: 120,
                          height: 120,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                          ),

                        ),
                      ),),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Offer Name",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF8D8D8D),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))),

                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 50,
                          child: TextFormField(
                            validator: (value) {
                              Pattern pattern = r'^[a-zA-Z]';
                              RegExp regex = new RegExp(pattern);
                              if (value.isEmpty) {
                                return 'Please enter offer name';
                              }
                              else if(value.length>35)
                                return 'Only 35 characters are allowed';
                              else if (!regex.hasMatch(value))
                                return 'Invalid offer name';
                              else
                                return null;
                            },
                           // maxLength: 5,
                            controller: nameController,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                            decoration: InputDecoration(
                              labelStyle: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF1C1C1C),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700)),
                              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),

                              //labelText: 'Name',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Offer Description",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF8D8D8D),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))),

                          ],
                        ),
                        Container(
                          height: 50,
                          child: TextFormField(
                            validator: (value) {

                              if (value.isEmpty) {
                                return 'Please enter description';
                              }
                              else if(value.length>35)
                                return 'Only 35 characters are allowed';
                              else
                                return null;
                            },
                            controller: descriptionController,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                            decoration: InputDecoration(
                              labelStyle: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF1C1C1C),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                              //labelText: 'Name',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Starts",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF8D8D8D),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400))),
                          ],
                        ),
                        SizedBox(height:10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Starting Date",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF8D8D8D),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))),
                          ],
                        ),
                        Container(
                          height: 50,
                          child: TextFormField(
                            validator: (value) {

                              if (value.isEmpty) {
                                return 'Please select startingdate';
                              }
                              else
                                return null;
                            },
                            //enabled: false,
                            controller: startdateController,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                            onTap: ()async{
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              final DateTime date =
                                  await showDatePicker(
                                  context: context,
                                  initialDate: currentDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100));
                              startdateController.text =
                                  new DateFormat('yyyy/MM/dd')
                                      .format(date.toLocal());
                              //time1=date;
                              //startController.text=date.toString();
                              currentDate = date;
                            },
                            decoration: InputDecoration(
                              // suffixIcon: IconButton(
                              //   icon: Icon(
                              //     Icons.calendar_today,
                              //     color: Colors.black,
                              //   ),
                              //   onPressed: () async {
                              //     FocusScope.of(context)
                              //         .requestFocus(new FocusNode());
                              //     final DateTime date =
                              //     await showDatePicker(
                              //         context: context,
                              //         initialDate: currentDate,
                              //         firstDate: DateTime.now(),
                              //         lastDate: DateTime(2100));
                              //     startdateController.text =
                              //         new DateFormat('yyyy/MM/dd')
                              //             .format(date.toLocal());
                              //        //time1=date;
                              //        //startController.text=date.toString();
                              //     currentDate = date;
                              //
                              //   },
                              // ),
                               suffixIcon:Icon(Icons.calendar_today,
                                      color: Colors.black,),
                              labelStyle: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF1C1C1C),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),

                              //labelText: 'Name',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Starting Time",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF8D8D8D),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))),
                          ],
                        ),
                        Container(
                          height: 50,
                          child: TextFormField(
                            validator: (value) {

                              if (value.isEmpty) {
                                return 'Please select startingtime';
                              }
                              else
                                return null;
                            },
                            controller: starttimeController,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                            onTap: (){_selectTime(context);},
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                    Icons.timer,
                                    color: Colors.black,
                                  ),
                              // suffixIcon: IconButton(
                              //   icon: Icon(
                              //     Icons.timer,
                              //     color: Colors.black,
                              //   ),
                              //   onPressed: () async {
                              //     _selectTime(context);
                              //
                              //   },
                              // ),
                              labelStyle: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF1C1C1C),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),

                              //labelText: 'Name',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Ends",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF8D8D8D),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400))),
                          ],
                        ),
                        SizedBox(height:10),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Ending Date",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF8D8D8D),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))),
                          ],
                        ),
                        Container(
                          height: 50,
                          child: TextFormField(
                            validator: (value) {

                              if (value.isEmpty) {
                                return 'Please select endingdate';
                              }
                              else
                                return null;
                            },
                            controller: enddateController,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                            onTap: ()async{
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              final DateTime date =
                              await showDatePicker(
                                  context: context,
                                  initialDate: currentDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100));
                              enddateController.text =
                                  new DateFormat('yyyy/MM/dd')
                                      .format(date.toLocal());
                              //time1=date;
                              //startController.text=date.toString();
                              currentDate = date;
                            },
                            decoration: InputDecoration(
                              suffixIcon:Icon(Icons.calendar_today,
                                color: Colors.black,),
                              // suffixIcon: IconButton(
                              //   icon: Icon(
                              //     Icons.calendar_today,
                              //     color: Colors.black,
                              //   ),
                              //   onPressed: () async {
                              //     FocusScope.of(context)
                              //         .requestFocus(new FocusNode());
                              //     final DateTime date =
                              //     await showDatePicker(
                              //         context: context,
                              //         initialDate: DateTime.now(),
                              //         firstDate: DateTime.now(),
                              //         lastDate: DateTime(2100));
                              //         enddateController.text =
                              //         new DateFormat('yyyy/MM/dd')
                              //             .format(date.toLocal());
                              //
                              //   },
                              // ),
                              labelStyle: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF1C1C1C),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),

                              //labelText: 'Name',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Ending Time",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Color(0xFF8D8D8D),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))),
                          ],
                        ),
                        Container(
                          height: 50,
                          child: TextFormField(
                            validator: (value) {

                              if (value.isEmpty) {
                                return 'Please select endingtime';
                              }
                              else
                                return null;
                            },
                            controller: enddtimeController,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                            onTap: (){_selectTime1(context);},
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.timer,
                                color: Colors.black,
                              ),
                              // suffixIcon: IconButton(
                              //   icon: Icon(
                              //     Icons.timer,
                              //     color: Colors.black,
                              //   ),
                              //   onPressed: () async {
                              //     _selectTime1(context);
                              //
                              //   },
                              // ),
                              labelStyle: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFF1C1C1C),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),

                              //labelText: 'Name',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          width: 50,
                        ),
                      ]),
                    ),

                    progress
                        ? Center(
                      child: CircularProgressIndicator(),
                    )
                        :
                    Container(
                        height: 50,
                        width: 80,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Color(0xFFFC4B4B),
                          shape: RoundedRectangleBorder(
                              side:
                              BorderSide(color: Color(0xFFD2D2D2)),
                              borderRadius: BorderRadius.circular(7.0)),
                          child: Text('Submit',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700),
                              )),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              //senddata();
                              if (_image == null)
                                Fluttertoast.showToast(
                                  msg: "Please upload offer image",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                );
                              else
                              addSinglePhoto();
                              // CameraHelper.addSinglePhoto(
                              //     '/seller/offer/add',
                              //     File(_image.path),
                              //     null);
                            }
                          },
                        )),
                  ],
                ))));
  }
  bool progress=false;
  addSinglePhoto() async {
    setState(() {
      progress=true;
    });
    var request = http.MultipartRequest('POST', Uri.parse(Prefmanager.baseurl + '/seller/offer/add'));
    String token = await Prefmanager.getToken();
    Map<String,String> data = {
      //"token": token,
      "name": nameController.text,
      "description": descriptionController.text,
      "startingDate":startdateController.text,
      "endingDate":enddateController.text,
      "startingTime":starttimeController.text,
      "endingTime":enddtimeController.text,

    };
    request.headers.addAll({'Content-Type': 'application/form-data', 'token': token});
    request.fields.addAll(data);
    if (_image != null) {
      request.files.add(http.MultipartFile.fromBytes(
          'photo', _image.readAsBytesSync(),
          filename: _image.path.split('/').last));
    }


    try {
   print(data);
      http.Response response =
      await http.Response.fromStream(await request.send());
      print(json.decode(response.body));
      if(json.decode(response.body)['status'])
      {
        await Navigator.pushReplacement(
            context, new MaterialPageRoute(
            builder: (context) => new SellerOfferslist()));
      }
      else{
        Fluttertoast.showToast(
          msg:json.decode(response.body)['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,

        );
        setState(() {
          progress=false;
        });


      }

    } catch (e) {
      print(e);
    }
    setState(() {
      progress=false;
    });
  }

}
