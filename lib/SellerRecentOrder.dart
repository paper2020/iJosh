import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SellerRecentOrder extends StatefulWidget {
  @override
  _SellerRecentOrder createState() => new _SellerRecentOrder();
}

class _SellerRecentOrder extends State<SellerRecentOrder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: List.generate(5, (index) {
                return InkWell(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image(
                                      image: AssetImage('assets/oxygen.png'),
                                      height: 75,
                                      width: 95,
                                      fit: BoxFit.fill),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(children: [
                                      SizedBox(height: 7),
                                      Row(
                                        children: [
                                          Text("Dell XPS15",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFF808080),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 1,
                                      ),
                                      Row(children: [
                                        Text("Price: ₹ 120000",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w700),
                                            )),
                                      ]),
                                      Row(children: [
                                        Text("Stock:200 Pieces",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF188320),
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w400),
                                            )),
                                      ]),
                                      Row(children: [
                                        Text("2 min ago",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w300),
                                            )),
                                        //SizedBox(width:100),
                                      ]),
                                      SizedBox(
                                        height: 5,
                                      ),

                                      // SizedBox(
                                      //   height:50
                                      // ),
                                    ]),
                                  )),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 20,
                          thickness: 1,
                          indent: 1,
                        ),
                      ],
                    ),
                    onTap: () {
                      //Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SellerEachOrderview()));
                    });
              }),
            ),
          ),
        ),
      ),
    );
  }
}
