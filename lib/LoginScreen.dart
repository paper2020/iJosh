import 'dart:convert';
import 'dart:io';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/SignupPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
class LoginScreen extends StatefulWidget {
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 6,
                ),
                Image.asset(
                  'assets/logo.jpg',
                  height: 300,
                  width: 300,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "BUYMAX",
                        style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.green,fontSize:30,fontWeight: FontWeight.w600),)
                    ),

                  ],
                ),

                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: 40,
                ),
                loginSession(context)
                // Container(color: Colors.blue.withOpacity(0.1),height:50, width: double.infinity,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextEditingController mobileController = TextEditingController();

  Widget loginSession(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Text(
              "Welcome",
              style: GoogleFonts.poppins(textStyle:TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: Text(
                "Sign in to access your Orders, Offers and Wishlists",
                style: GoogleFonts.poppins(textStyle:TextStyle(
                    color: Colors.black38, fontWeight: FontWeight.w600)),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("+91"),
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.red,
                    thickness: 2.0,
                  ),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      validator: (value) {

                        if (value.isEmpty) {
                          return 'Please enter mobile number';
                        }
                        else{
                          return null;
                        }

                      },
                      controller: mobileController,
                      keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      decoration: InputDecoration(
                        hintText: "Mobile Number",
                        hintStyle: TextStyle(color: Colors.black45),
                        border: InputBorder.none,
                      ),

                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            progress1?Center( child: CircularProgressIndicator(),):
            FlatButton(
              height: 50,
              minWidth:MediaQuery.of(context).size.width /1,
              textColor: Colors.white,
              color: Colors.green,
              child: Text('Next',style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.white,fontSize:13,fontWeight: FontWeight.w600),)),
              onPressed: () {
               // senddata();
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                 senddata();
                //   Navigator.push(
                //       context, new MaterialPageRoute(
                //       builder: (context) => new SignupPage(mobileController.text,exist)));
                 }
              },
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
  var exist;
    bool  progress1=false;
  void senddata() async {
    setState(() {
      progress1=true;
    });
    try{
      var url = Prefmanager.baseurl+'/user/signup/signin/send/otp?phone='+mobileController.text;

      // Map data={
      //   'phone':mobileController.text,
      // };
      //var body=json.encode(data);
      var response = await http.get(url);
      print("yyu"+response.statusCode.toString());
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if(json.decode(response.body)['status'])
        {
          exist=json.decode(response.body)['alreadyExists'];
          Navigator.push(
              context, new MaterialPageRoute(
              builder: (context) => new SignupPage(mobileController.text,exist)));
        }

        else{
          // Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SearchProduct(keyword.text,searchMsg))).then((value) {
          //   //This makes sure the textfield is cleared after page is pushed.
          //
          // });
          // print(json.decode(response.body)['msg']);
          // Fluttertoast.showToast(
          //   msg:json.decode(response.body)['msg'],
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.CENTER,
          //
          // );
        }
      }
      else {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
    on SocketException catch(e){
      print(e.toString());
    }
    catch(e){
      print(e.toString());
    }
    progress1=false;
  }

}

