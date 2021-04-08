import 'package:eram_app/RecentOrders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabBarDemo extends StatelessWidget {
  final details;
  TabBarDemo(this.details);
  bool progress = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Orders",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              )),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            progress
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    //child: InkWell(child: Image(image:AssetImage('assets/oxygen.png'),width: 30,height: 30,),onTap: (){},),
                  )
          ],
          bottom: TabBar(
            isScrollable: true,
            labelColor: Color(0xFFD62F2F),
            unselectedLabelColor: Color(0xFF9D9D9D),
            tabs: [
              Tab(
                  child: Text("Recent Orders",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w500),
                      ))),
              Tab(
                  child: Text("Packed",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w500),
                      ))),
              Tab(
                  child: Text("Shipped",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w500),
                      ))),
              Tab(
                  child: Text("Outfordelivery",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w500),
                      ))),
              Tab(
                  child: Text("Delivered",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w500),
                      ))),
              Tab(
                  child: Text("Cancelledby Seller",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w500),
                      ))),
              Tab(
                  child: Text("Return",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w500),
                      ))),
              Tab(
                  child: Text("Cancelled",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w500),
                      ))),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RecentOrders(
              "ordered",
            ),
            RecentOrders("packed"),
            RecentOrders("shipped"),
            RecentOrders("outfordelivery"),
            RecentOrders("delivered"),
            RecentOrders("cancelledbyseller"),
            RecentOrders("returned"),
            RecentOrders("cancelled"),
          ],
        ),
      ),
    );
  }
}
