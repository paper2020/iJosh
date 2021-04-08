
import 'package:eram_app/BottomNavigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:http/http.dart' as http;
class OrderSucess extends StatefulWidget
{
  @override
  _OrderSucess createState() =>_OrderSucess();
}
class _OrderSucess extends State <OrderSucess> {
  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return  new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(

        body:SafeArea(
          child: SingleChildScrollView(
            child: //progress?Center( child: CircularProgressIndicator(),):
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.1,
                ),
                Image(image: AssetImage('assets/orderconfirm.png'),height:300,width: double.infinity,fit:BoxFit.fill),
                SizedBox(
                  height:20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[Text("Congratulations",style: GoogleFonts.poppins(textStyle: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),)),
                    ]
                ),

                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[Text("Your Order has been",style: GoogleFonts.poppins(textStyle: TextStyle(
                        color: Color(0xFF191919),
                        fontSize: 18,
                        fontWeight: FontWeight.w600),)),
                    ]
                ),

                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[Text("placed successfully !! ",style: GoogleFonts.poppins(textStyle: TextStyle(
                        color: Color(0xFF191919),
                        fontSize: 18,
                        fontWeight: FontWeight.w600),)),
                    ]
                ),
                // SizedBox(
                //   height:10,
                // ),
                // Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children:[
                //       Text("You can check your order process in my",style: GoogleFonts.poppins(textStyle: TextStyle(
                //           color: Color(0xFF6F6F6F),
                //           fontSize: 12,
                //           fontWeight: FontWeight.w400),)),
                //     ]
                // ),
                // SizedBox(
                //   height:5,
                // ),
                // Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children:[Text("orders section.",style: GoogleFonts.poppins(textStyle: TextStyle(
                //         color: Color(0xFF6F6F6F),
                //         fontSize: 12,
                //         fontWeight: FontWeight.w400),)),
                //     ]
                // ),
                // FlatButton(
                //   textColor: Colors.green,
                //   child: Text(
                //     'My Orders',
                //     style: GoogleFonts.poppins(textStyle: TextStyle(
                //         color: Color(0xFFFC4B4B),
                //         fontSize: 12,
                //         fontWeight: FontWeight.w500),),
                //   ),
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) =>
                //           MyordersPage()),
                //     ); //signup screen
                //   },
                // ),
                SizedBox(
                    //height:MediaQuery.of(context).size.height*0.2
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    height: 50,
                    minWidth:MediaQuery.of(context).size.width /0,
                    color: Color(0xFFFC4B4B),
                    child: Text('Continue Shopping', style: GoogleFonts.poppins(textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w400),),),
                    onPressed: () {
                      Navigator.push(
                          context, new MaterialPageRoute(
                          builder: (context) => new MyNavigationBar()));
                    },
                  ),
                ),
              ],
            ),

          ),
        ),
      ),
    );
  }
}