
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
class VerificationSucessful extends StatefulWidget {
  @override
  _VerificationSucessful createState() => _VerificationSucessful();
}
class _VerificationSucessful extends State<VerificationSucessful> {
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Text("Account Settings",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:16,fontWeight: FontWeight.w600),)),
          elevation: 0.0,
          actions: [
            IconButton (icon:Icon(Icons.person_outline,size:20,color: Color(0xFF7A7A7A)),
               onPressed:(){},
            ),

          ],
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
                 Image(image: AssetImage('assets/VerifySucess.png'),height:100,width:110),
                 SizedBox(height:10),
                 Text("Congratulations",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF2FDF84),fontSize:13,fontWeight: FontWeight.w500),)),
                 Text("Verification Succesfull",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF191919),fontSize:18,fontWeight: FontWeight.w500),)),
                 SizedBox(height:80),
               ],
             )
           )
                ],
              ) ),
        ));
  }
}
