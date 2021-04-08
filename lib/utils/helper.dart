
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eram_app/Prefmanager.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
class CameraHelper {

  static Future<PickedFile> getImage(int type) async {
    PickedFile pickedImage = await ImagePicker().getImage(
        source: type == 1 ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 50);
    return pickedImage;
  }

  static addSinglePhoto(url,_image,_image1) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse(Prefmanager.baseurl + url));
    String token = await Prefmanager.getToken();
    request.headers
        .addAll({'Content-Type': 'application/form-data', 'token': token});
    if (_image != null) {
      request.files.add(http.MultipartFile.fromBytes(
          'photo', _image.readAsBytesSync(),
          filename: _image.path.split('/').last));
    }
    if (_image1 != null) {
      request.files.add(http.MultipartFile.fromBytes(
          'coverPhoto', _image1.readAsBytesSync(),
          filename: _image1.path.split('/').last));
    }
    try {
      http.Response response =
      await http.Response.fromStream(await request.send());
      if (json.decode(response.body)['status']) {

      }
    } catch (e) {
      print(e);
    }
  }

  static Future<CustomResponse> makePostRequest(url, {Map sendData}) async {
    Map data = {};
    String token = await Prefmanager.getToken();

    if (sendData?.isNotEmpty ?? false) {
      data.addAll(sendData);
    }
    var body = json.encode(data);
    CustomResponse customResponse;

    try {
      var response = await http
          .post(
        Prefmanager.baseurl + url,
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'token': token
        },
        body: body,
      )
          .timeout(Duration(seconds: 20));

      customResponse = CustomResponse(200, response.body);
    } on SocketException catch (_) {
      customResponse = CustomResponse(503, "Please check your internet connection");
    } on TimeoutException catch (_) {
      customResponse = CustomResponse(408, "Takes too much time, Please try again");
    } on FormatException catch (_) {
      customResponse = CustomResponse(404, "Takes too much time, Please try again");
    }

    return customResponse;
  }

  static Future<CustomResponse> makeGetRequest(url, {sendData}) async {
    String token = await Prefmanager.getToken();
    Map<String, String> data = {'Content-type': 'application/json',
      'Accept': 'application/json','token': token};

    if (sendData?.isNotEmpty ?? false) {
      data.addAll(sendData);
    }
    CustomResponse customResponse;

    try {
      var response = await http
          .get(
        Prefmanager.baseurl + url,
        headers: data,
      )
          .timeout(Duration(seconds: 20));

      customResponse = CustomResponse(200, response.body);
    } on SocketException catch (_) {
      customResponse = CustomResponse(503, "Please check your internet connection");
    } on TimeoutException catch (_) {
      customResponse = CustomResponse(408, "Takes too much time, Please try again");
    }

    return customResponse;
  }
static Widget productdetailLoader(BuildContext context){
  return SingleChildScrollView(
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Column(
        children: [
          Container(
              width:double.infinity,height:200,
              color:Colors.white
          ),
          SizedBox(height:10),
          Container(
              width:double.infinity,height:200,
              color:Colors.white
          ),
          SizedBox(height:10),
          Container(
              width:double.infinity,height:200,
              color:Colors.white
          ),

        ],
      ),
    ),
  );
}
static Widget productlistLoader(BuildContext context)
{
  return SingleChildScrollView(

          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            //enabled: progress,
            child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                Container(height:220,width:double.infinity,color:Colors.white),
                  SizedBox(height:20),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 25,
                        ),
                        Expanded(
                          flex: 5,
                          child: ListView.builder(
                              itemCount: 5,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder:
                                  (BuildContext context, int index) {
                                return
                                  // listsubcat[index]['name']=='View all'?
                                  Column(children: [
                                    Expanded(
                                      //flex: 1,
                                      child: Row(children: [
                                        Column(
                                          children: [
                                            Container(
                                              width:30,height:30,color:Colors.white
                                            ),

                                            SizedBox(
                                              height: 5,
                                            ),

                                          ],
                                        ),
                                        SizedBox(
                                          width: 35,
                                        ),
                                      ]),
                                    )
                                  ]);
                              }),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height:10),
                  Container(height:15,width:double.infinity,color:Colors.white),
                  SizedBox(height:10),
                  GridView.builder(
                      itemCount: 4,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics:
                      NeverScrollableScrollPhysics(),
                      itemBuilder:
                          (BuildContext context,
                          int index) {
                        return GestureDetector(
                          child: Container(
                            //height: MediaQuery.of(context).size.height,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                               Container(color:Colors.white,height:150,width:double.infinity),
                                SizedBox(
                                  height: 5,
                                ),
                                // Text(cat[index],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w600))),
                                Container(color:Colors.white,height:10,width:double.infinity),
                                SizedBox(height:5),
                                Container(color:Colors.white,height:10,width:double.infinity),
                              ],
                            ),
                          ),

                        );
                      },
                      gridDelegate:
                      new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75)),

                 ]),
          ));
}
  static Widget subproductsLoader(BuildContext context)
  {
    return SingleChildScrollView(

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
                Container(height:220,width:double.infinity,color:Colors.white),
                SizedBox(height:10),
                GridView.builder(
                    itemCount: 4,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics:
                    NeverScrollableScrollPhysics(),
                    itemBuilder:
                        (BuildContext context,
                        int index) {
                      return GestureDetector(
                        child: Container(
                          //height: MediaQuery.of(context).size.height,
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [
                              Container(color:Colors.white,height:150,width:double.infinity),
                              SizedBox(
                                height: 5,
                              ),
                              // Text(cat[index],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w600))),
                              Container(color:Colors.white,height:10,width:double.infinity),
                              SizedBox(height:5),
                              Container(color:Colors.white,height:10,width:double.infinity),
                            ],
                          ),
                        ),

                      );
                    },
                    gridDelegate:
                    new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.75)),

              ]),
        ));
  }

}

class CustomResponse {
  var statusCode;
  var message;
  var body;

  CustomResponse(this.statusCode, this.body);
}
