import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'Prefmanager.dart';

class SellerDocView extends StatefulWidget {
  final details, filename;
  SellerDocView(this.details, this.filename);
  @override
  _SellerDocView createState() => _SellerDocView();
}

class _SellerDocView extends State<SellerDocView> {
  void initState() {
    super.initState();
    // sellerview();
    print("dfg");
    print(widget.details);
    print(widget.filename);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: Row(
          children: [
            Text("Company Documents",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 16,
                        fontWeight: FontWeight.w600))),
          ],
        ),
      ),
      body: Column(
        children: [
          widget.filename == 'jpg'
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: PageView(
                        children: [
                          Container(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image(
                                  image: NetworkImage(Prefmanager.baseurl +
                                      "/file/get/" +
                                      widget.details),
                                  fit: BoxFit.fill,
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  //height: ,
                  height: MediaQuery.of(context).size.height - 100,
                  child: PDF.network(
                    Prefmanager.baseurl + "/file/get/" + widget.details,
                    //height: 600,
                    //width: 500,
                  ),
                ),
        ],
      ),
    );
  }
}
