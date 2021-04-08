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

class TodaysoffersAll extends StatefulWidget {
  // final name;
  // OffersnearAll(this.name);
  @override
  _TodaysoffersAll createState() => _TodaysoffersAll();
}

class _TodaysoffersAll  extends State<TodaysoffersAll > {
  var _mySelection;
  void initState() {
    super.initState();
    sample();

  }

  Future sample() async {
    await _getCurrentLocation();
    await lisyCity();
    await getcity();
    await offerNear1();
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
  List offernear1 = [];
  bool progress4=true;
  int page1=1,limit1=4;
  var length1,categoryicon;
  Future<void> offerNear1() async {
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
      data = {'lat': lat.toString(), 'lon': lon.toString(),'page':page1.toString(),'limit':limit1.toString()};
    else
      data = {'keyword': _mySelection != null ? _mySelection : city1,'page':page1.toString(),'limit':limit1.toString()};
    print(lat);
    print(data);
    var body = json.encode(data);
    print(token);
    var url = Prefmanager.baseurl + '/seller/offer/list';
    var response = await http.post(url, headers: requestHeaders, body: body);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
     for (int i = 0; i < json.decode(response.body)['data'].length; i++)
              offernear1.add(json.decode(response.body)['data'][i]);
            page1++;
     //offernear1 = json.decode(response.body)['data'];
      length1 = json.decode(response.body)['totalLength'];

    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress4=false;
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
          page1 = 1;
          offernear1.clear();
        });
        await getcity();
        await offerNear1();

      },
      //value: _mySelection,

    );
  }

  bool loading = false;

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
        body: progress4
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
                              Text("Todays offers on near by sellers ",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Color(0xFF1D1D1D),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600))),

                            ]),

                        SizedBox(
                          height: 10,
                        ),
                        progress4
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
                              if (length1 >offernear1.length) {

                                offerNear1();
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
                                itemCount: offernear1.length,
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
                                                  BorderRadius.circular(10.0),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                    child: Image(
                                                      image: NetworkImage(Prefmanager
                                                          .baseurl +
                                                          "/file/get/" +
                                                          offernear1[
                                                          index]
                                                          [
                                                          'photo']),
                                                      width: 150,
                                                      height: 167,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  )),
                                              Positioned(
                                                bottom: 10,
                                                left: 10,
                                                right: 10,
                                                child: Center(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                            width: 70,
                                                            child: Text(offernear1[index]['description'],
                                                                textAlign: TextAlign.center,
                                                                style: GoogleFonts.poppins(
                                                                    textStyle: TextStyle(
                                                                        color:
                                                                        Color(0xFFFFFFFF),
                                                                        fontSize: 10,
                                                                        fontWeight: FontWeight
                                                                            .bold)))),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                          children: [
                                                            ClipRRect(
                                                                child: Image(
                                                                    image: offernear1[index]['sellerId']['category'][0]['icon'] !=
                                                                        null
                                                                        ? NetworkImage(Prefmanager
                                                                        .baseurl +
                                                                        "/file/get/" +offernear1[index]['sellerId']['category'][0]['icon']
                                                                    )
                                                                        : AssetImage(
                                                                        'assets/oxygen.png'),
                                                                    width: 15,
                                                                    height: 15)),
                                                            Spacer(),
                                                            Text(offernear1[index]['sellerId']['distance']+'km',
                                                                maxLines: 3,
                                                                style: GoogleFonts.poppins(
                                                                    textStyle: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 11))),
                                                          ],
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) => ShopPage1(false,true,offernear1[index]['sellerId']['shopName'],offernear1[index]['sellerId']['uid'], offernear1[index]['sellerId']['uid'])));
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
