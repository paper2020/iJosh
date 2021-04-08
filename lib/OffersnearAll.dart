import 'dart:async';
import 'dart:convert';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/ShopPage1.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_dropdown/searchable_dropdown.dart';

class OffersnearAll extends StatefulWidget {
  // final name;
  // OffersnearAll(this.name);
  @override
  _OffersnearAll  createState() => _OffersnearAll();
}

class _OffersnearAll extends State< OffersnearAll > {
  var _mySelection;
  void initState() {
    super.initState();
    sample();

  }

  Future sample() async {
    await _getCurrentLocation();
    await lisyCity();
    await getcity();
    await offerNear();
  }

  String city1;
  Future<void> getcity() async {
    city1 = await Prefmanager.getCity();
    print(city1);
    // page=1;
    // seller.clear();
    // await sellerlist();
  }

  var district, city, lat, lon;
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        lat = position.latitude;
        lon = position.longitude;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      final coordinates = new Coordinates(lat, lon);
      var addresses =
      await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      city = first.locality;
      district = first.subAdminArea;

      if (mounted) setState(() {});
    } catch (e) {
      print(e);
    }
  }
  List offernear = [];
  var length;
  int page=1,limit=4;
  bool progress2 = true;
  Future<void> offerNear() async {
    print(lat);
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token != null ? token : null
    };
    Map data;
    print(_mySelection);
    if (city1 == null)
      data = {'lat': lat.toString(), 'lon': lon.toString(),'page':page.toString(),'limit':limit.toString()};
    else
      data = {'keyword': _mySelection != null ? _mySelection : city1,'page':page.toString(),'limit':limit.toString()};
    print(lat);
    print(data);
    var body = json.encode(data);
    print(token);
    var url = Prefmanager.baseurl + '/nearby/sellers/offers/list';
    var response = await http.post(url, headers: requestHeaders, body: body);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      for (int i = 0; i < json.decode(response.body)['data'].length; i++)
        offernear.add(json.decode(response.body)['data'][i]);
      page++;
      //offernear=json.decode(response.body)['data'];
      length = json.decode(response.body)['totalLength'];
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress2=false;
    loading=false;
    setState(() {});
  }

  List listcity = [];
  bool progress3 = true;
  Future<void> lisyCity() async {
    var url = Prefmanager.baseurl + '/sellers/city/list?city=$city';
    var response = await http.get(url);
    if (json.decode(response.body)['status']) {
      //listcity.add("Current location");
      listcity.add(city);
      for (int i = 0; i < json.decode(response.body)['data'].length; i++)
        listcity.add(json.decode(response.body)['data'][i]);
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress3 = false;

    setState(() {});
  }

  Widget dropCity(BuildContext context) {
    return SearchableDropdown.single(
      // hint:  Text(city1!=null?city1:city,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF373539),fontSize:11,fontWeight: FontWeight.w600))),
      // hint:  Text(city1==null||_mySelection=="Current location"?city:city1,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF373539),fontSize:11,fontWeight: FontWeight.w600))),
      hint: Text(city1 == null || _mySelection == city ? city : city1,
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: Color(0xFF373539),
                  fontSize: 11,
                  fontWeight: FontWeight.w600))),

      underline: SizedBox(),
      displayClearIcon: false,
      //isExpanded: true,
      items: listcity.map((item) {
        return new DropdownMenuItem(
          //child: new Text(item,style: GoogleFonts.poppins(textStyle:TextStyle(color:item=="Current location"?Colors.red:Color(0xFF373539),fontSize:11,fontWeight: FontWeight.w600))),
          child: new Text(item,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: item == city ? Colors.red : Color(0xFF373539),
                      fontSize: 11,
                      fontWeight: FontWeight.w600))),
          value: item,
        );
      }).toList(),

      onChanged: (newVal) async {
        print("h");
        print(newVal);
        print(listcity);

        _mySelection = newVal;
        print(_mySelection);


        // _mySelection=null;

        //if(_mySelection=="Current location")
        if (_mySelection == city)
          Prefmanager.rem();
        else
          await Prefmanager.setCity(_mySelection);
        print(await Prefmanager.getCity());
        setState(() {
          page = 1;
          offernear.clear();
        });
        await getcity();
        await offerNear();

      },
      //value: _mySelection,

    );
  }

  bool loading = false;
  List cat = ['My G', 'Oxygen', 'Apple Store', 'Reliance Digital'];
  List km = [
    '0.6 Km',
    '2.5 Km',
    '0.6 Km',
    '2.5 Km',
    '2.5 Km',
    '2.5 Km',
    '2.5 Km',
    '2.5 Km'
  ];
  List review = ['4.5', '4.5', '4.0', '4.0', '4.0', '4.0', '4.0', '4.0'];
  List images = [
    'assets/Smartphone.png',
    'assets/tablet.png',
    'assets/monitor.png',
    'assets/laptop.png',
    'assets/laptop.png',
    'assets/laptop.png'
  ];
  List img = ['assets/slider1.jpg'];
  List image = [];
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, true),
          ),
          // actions: [
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       IconButton(icon: Icon(Icons.search,color: Colors.red,), onPressed: () {}),
          //     ],
          //   ),
          //
          // ],

          title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Electronics",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 16,
                            fontWeight: FontWeight.w600))),
                city == null
                    ? SizedBox.shrink()
                    : dropCity(context),
              ]),

        ),
        body: progress2
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              // physics: NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Offers Near By ",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Color(0xFF1D1D1D),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600))),

                            ]),

                        SizedBox(
                          height: 10,
                        ),
                        progress2
                            ? Center(
                          child: CircularProgressIndicator(),
                        )
                            : NotificationListener<ScrollNotification>(
                          onNotification:
                              (ScrollNotification scrollInfo) {
                            if (!loading &&
                                scrollInfo.metrics.pixels ==
                                    scrollInfo.metrics
                                        .maxScrollExtent) {
                              if (length >offernear.length) {

                                offerNear();
                                setState(() {
                                  loading = true;
                                });
                              } else {}
                            } else {}
                            //  setState(() =>loading = false);
                            return true;
                          },
                          child: Container(
                            // height: MediaQuery.of(context).size.height,
                            child: GridView.builder(
                                itemCount: offernear.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics:
                                AlwaysScrollableScrollPhysics(),
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
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      10.0),
                                                  child: Image
                                                      .network(
                                                    Prefmanager
                                                        .baseurl +
                                                        "/file/get/" +
                                                        offernear[index]
                                                        [
                                                        "photo"],
                                                    fit: BoxFit
                                                        .cover,
                                                    width: double
                                                        .infinity,
                                                    height: 150,
                                                  )),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                              new ShopPage1(
                                                  true,false,
                                                  offernear[index]
                                                  ['shopName'],
                                                  offernear[index]
                                                  ['uid']['_id'],
                                                  offernear[index]
                                                  ['uid']['_id'])));
                                      //Navigator.pop(context);
                                    },
                                  );
                                },
                                gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 5,
                                    childAspectRatio: 0.85)),
                          ),
                        ),
                        Container(
                          height: loading ? 20 : 0,
                          width: double.infinity,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      ],
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
