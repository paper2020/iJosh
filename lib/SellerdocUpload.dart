
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:eram_app/Prefmanager.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import 'SellerBottomBar.dart';
class SellerdocUpload extends StatefulWidget {
  @override
  _SellerdocUpload  createState() => _SellerdocUpload ();
}
class _SellerdocUpload  extends State<SellerdocUpload > {
  void initState() {
    super.initState();
  }
  List<File>files=[];
  var filename,fileslist,filepath;
  bool onPress=false;
  Future<void>filePicker()async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf'],
    );
    // if (result != null) {
    //   PlatformFile file = result.files.last;
    //   filename=file.name;
    //   print(file.name);
    //   print(file.bytes);
    //   print(file.size);
    //   print(file.extension);
    //   print(file.path);
    // } else {
    //   // User canceled the picker
    // }
    // if(result.paths.length>4)
    //   Fluttertoast.showToast(
    //     msg:"Only 4 documents can be added",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //
    //   );
    // else
    // for(int i=0;i<result.paths.length;i++)
    //   files.add(File(result.paths[i]));
    // setState(() {
    //
    // });
    for(int i=0;i<result.paths.length;i++) {
      if (files.length < 4) {
        files.add(File(result.paths[i]));
        setState(() {});
      }
      else
        Fluttertoast.showToast(
          msg: "Only 4 images can be added",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,

        );
    }
    print(files);
    fileslist=result.files;

    filepath=result.paths;
    //print(filepath);
    if(result != null) {
      //List<File> files = result.paths.map((path) => File(path)).toList();
      filename=result.names.toString();
      //print(filename);
    } else {
      // User canceled the picker
   }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop:() async=>false,
    child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Text("Account Settings",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:16,fontWeight: FontWeight.w600),)),
     automaticallyImplyLeading: false,
        ),

        body:Center(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical:15),
              child: ListView(
                children: <Widget>[
                  Text("Account Information Progress",textAlign:TextAlign.center,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:16,fontWeight: FontWeight.w600))),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:8.0),
                    child: LinearProgressIndicator(
                      backgroundColor: Color(0xFFF0F0F0),
                      valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF408BFF)),
                      value:1.0,
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text("4/4 Steps",textAlign:TextAlign.center,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF454545),fontSize:10,fontWeight: FontWeight.w400))),
                  SizedBox(height:30),
                  //SizedBox(height: 100,),
                  Row(
                    children: [
                      Text("Know your Customer",textAlign:TextAlign.center,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w600))),

                    ],
                  ),
                  SizedBox(height: 10,),
                  files.isEmpty?
                  Container(
                    height: MediaQuery.of(context).size.height/2,
                    child: Card(
                        elevation: 5.0,
                        child:Column(
                          children: [
                            SizedBox(height:100),
                            Image(image: AssetImage('assets/upload.png'),height:30,width:45),
                            SizedBox(height:10),
                            Text("Upload Company Documents",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:16,fontWeight: FontWeight.w600),)),
                            Text("Jpg or PDF",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF4E4D4D),fontSize:12,fontWeight: FontWeight.w500),)),
                           SizedBox(height:15),
                            // files.isEmpty?SizedBox.shrink():imageView(),
                            SizedBox(height:15),
                            //onPress? files.isNotEmpty?Text(filename):SizedBox.shrink():SizedBox.shrink(),
                            Container(
                                height: 40,
                                width:200,
                                //width:MediaQuery.of(context).size.width/2,
                                padding:EdgeInsets.symmetric(horizontal: 15),
                                child: FlatButton(
                                  textColor: Colors.white,
                                  color: Color(0xFFFC4B4B),
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Color(0xFFD2D2D2)),
                                      borderRadius: BorderRadius.circular(7.0)),
                                  child: Text('Click here to Upload',style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.white,fontSize:11,fontWeight: FontWeight.w500),)),
                                  onPressed: ()async {
                                    if(files.length==4)
                                      Fluttertoast.showToast(
                                        msg:"Only 4 images can be added at a time",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                      );
                                    else
                                    await filePicker();
                                    setState(() {
                                      onPress=true;
                                    });


                                  },
                                )),
                            //onPress? Text(filename):SizedBox.shrink(),
                            SizedBox(
                              height: 20,
                            ),


                          ],
                        )
                    ),
                  ):imageView(),


                  SizedBox(height: 50,),
                  progress1?Center( child: CircularProgressIndicator(),):
                  Container(
                      height: 50,
                      width:80,
                      //padding:EdgeInsets.symmetric(horizontal: 15),
                      child: FlatButton(
                        textColor: Colors.white,
                        color: Color(0xFFFC4B4B),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Color(0xFFD2D2D2)),
                            borderRadius: BorderRadius.circular(7.0)),
                        child: Text('Submit',style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.white,fontSize:11,fontWeight: FontWeight.w500),)),
                        onPressed: () {
                          if(files.isEmpty)
                            Fluttertoast.showToast(
                              msg:"Please upload company documents",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                            );
                          else
                          addSinglePhoto();
                        },
                      )),
                    //SizedBox(height: 30,)
                ],
              ) ),
        )));
  }
  bool progress1=false;
  addSinglePhoto() async {
    print("ffgg");
    setState(() {
      progress1=true;
    });
    var request = http.MultipartRequest('POST', Uri.parse(Prefmanager.baseurl + '/seller/profile/level4'));
    print(request);
    String token = await Prefmanager.getToken();
    request.headers.addAll({'Content-Type': 'application/form-data', 'token': token});
    if (files != null) {
      files.forEach((File f) {
        request.files.add(http.MultipartFile.fromBytes(
            'documents', f.readAsBytesSync(),
            filename: f.path
                .split('/')
                .last));
      });
    }
    print("ma");
    try {
      http.Response response =
      await http.Response.fromStream(await request.send());
      print("bvcxxx");
      print(response.body);
      print(json.decode(response.body));
      if(json.decode(response.body)['status'])
      {
        print("true");
        await Prefmanager.setLevel(json.decode(response.body)['level']);
        await Prefmanager.setStatus(
            json.decode(response.body)['profileStatus']);
        Navigator.push(
            context, new MaterialPageRoute(
            builder: (context) => new SellerBottomBar()));
      }
      Fluttertoast.showToast(
        msg:json.decode(response.body)['msg'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,

      );
      setState(() {
        progress1=false;
      });
    }
    on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: "No internet",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      print(e.toString());
    }
    catch (e) {
      print(e);
    }
    setState(() {
      progress1=false;
    });

  }
  Widget imageView(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: files.isNotEmpty
          ? Column(
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          GridView.builder(
            shrinkWrap: true,
            physics:
            BouncingScrollPhysics(),
            itemCount: files.length,
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
                // crossAxisSpacing:0.5,
                // mainAxisSpacing: 0.5,
                crossAxisCount: 3),
            itemBuilder:
                (context, index) {
                  File file = files[index];
                  String fileName = file.path.split('.').last;
                  print(fileName);
                if(fileName=='jpg') {
                  return Row(
                    children: [
                      Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              files[index],
                              //  val1[index],
                              fit: BoxFit.cover,height:80,width:MediaQuery.of(context).size.width/5
                            ),
                          ),
                          Positioned(
                              right: 0,
                              top: 0,
                              child:
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 20,
                                child: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 15,
                                    child: IconButton(
                                      onPressed: () {
                                        files
                                            .removeAt(
                                            index);
                                        // val1.removeAt(index);
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                    )
                                ),
                              )
                          ),
                        ],
                      ),

                    ],
                  );
                }
              else{
                  return Container(
                    width:200,
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Expanded(child: Text(filename,style: TextStyle(fontSize: 10),)),
                            //  val1[index],
                          ),
                        Positioned(
                            right: 0,
                            top: 0,
                            child:
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius:20,
                              child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 15,
                                  child: IconButton(
                                    onPressed: () {
                                      files
                                          .removeAt(
                                          index);
                                      // val1.removeAt(index);
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  )
                              ),
                            )
                        ),
                      ],
                    ),
                  );
                  //return Text(filename);
              }
            },
          ),
          SizedBox(
            height: 80,
          ),
          Container(
              height: 40,
              width:200,
              //width:MediaQuery.of(context).size.width/2,
              padding:EdgeInsets.symmetric(horizontal: 15),
              child: FlatButton(
                textColor: Colors.white,
                color: Color(0xFFFC4B4B),
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color(0xFFD2D2D2)),
                    borderRadius: BorderRadius.circular(7.0)),
                child: Text('Click here to Upload',style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.white,fontSize:11,fontWeight: FontWeight.w500),)),
                onPressed: ()async {
                  if(files.length==4)
                    Fluttertoast.showToast(
                      msg:"Only 4 images can be added at a time",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                    );
                  else
                  await filePicker();
                  setState(() {
                    onPress=true;
                  });


                },
              )),
        ],
      )
          : Container(),
    );
  }
}
