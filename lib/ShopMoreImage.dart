import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Prefmanager.dart';
class ShopMoreImage extends StatefulWidget {
  final seller,details;
  ShopMoreImage(this.seller,this.details);
  @override
  _ShopMoreImage createState() => _ShopMoreImage();
}
class _ShopMoreImage extends State<ShopMoreImage> {
  void initState() {
    super.initState();
    print(widget.seller);
    print(widget.details);
    //sellerview();
  }
  @override
  Widget build(BuildContext context) {
  return Scaffold(
      appBar:  AppBar(
        leading: IconButton (icon:Icon(Icons.arrow_back),
          onPressed:() => Navigator.pop(context,true),
        ),
        title:Row(
          children: [
            Text("Shop Images",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:16,fontWeight: FontWeight.w600))),
          ],
        ),
      ),
      body: Center(
        child: PageView.builder(
          controller: PageController(
            initialPage: widget.details
          ),
          reverse: false,
          pageSnapping: false,
          itemCount: widget.seller.length,
          itemBuilder: (BuildContext context, index) {
            //index=widget.details;

            return Center(
              child:  ClipRRect(borderRadius: BorderRadius.circular(10.0),child:Image(image:NetworkImage(Prefmanager.baseurl+"/file/get/"+widget.seller[index]),fit: BoxFit.fill,)),
            );

          },
        ),
      ),
  );

  }
}
