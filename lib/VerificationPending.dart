
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
class VerificationPending extends StatefulWidget {
  @override
  _VerificationPending createState() => _VerificationPending();
}
class _VerificationPending extends State<VerificationPending> {
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop:() async=>false,
    child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
         // title: Text("Account Settings",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:16,fontWeight: FontWeight.w600),)),
          elevation: 0.0,
         automaticallyImplyLeading: false,
        ),

        body: Center(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical:15),
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 100,),
                  Card(
                      elevation: 5.0,
                      child:Column(
                        children: [
                          SizedBox(height:50),
                          Stack(children:[
                          Image(image: AssetImage('assets/verifyPend.png'),height:100,width:110),
                            Positioned(left:55,child: Image(image: AssetImage('assets/c.png'),height:40,width:40)),
                          ]
                      ),
                          SizedBox(height:10),
                          Text("Please Complete all the steps",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFFF4B4B),fontSize:13,fontWeight: FontWeight.w500),)),
                          Text("Verification Pending",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF191919),fontSize:18,fontWeight: FontWeight.w500),)),
                          SizedBox(height:10),
                          Container(
                              height: 50,
                              width:MediaQuery.of(context).size.width/1.6,
                              padding:EdgeInsets.symmetric(horizontal: 15),
                              child: FlatButton(
                                textColor: Colors.white,
                                color: Color(0xFFFC4B4B),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Color(0xFFD2D2D2)),
                                    borderRadius: BorderRadius.circular(7.0)),
                                child: Text('Logout',style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.white,fontSize:10,fontWeight: FontWeight.w700),)),
                                onPressed: () {
                                  Prefmanager.clear();
                                  Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new MyHomePage ()));
                                },
                              )),
                          SizedBox(height:80),
                        ],
                      )
                  )
                ],
              ) ),
        )));
  }
}
