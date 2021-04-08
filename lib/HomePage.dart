import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eram_app/CustomerProfile.dart';
import 'package:eram_app/ElectronicsPage.dart';
import 'package:eram_app/FirstPage1.dart';
import 'package:eram_app/OffersnearAll.dart';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/ShopPage.dart';
import 'package:eram_app/ShopPage1.dart';
import 'package:eram_app/TodaysoffersAll.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => new _HomePage();
}

class _HomePage extends State<HomePage> {
  DateTime currentBackPressedTime;
  Future<bool> _onWillPop() async {

    DateTime now = DateTime.now();
    if (currentBackPressedTime == null ||
        now.difference(currentBackPressedTime) > Duration(seconds: 2)) {
      currentBackPressedTime = now;
      Fluttertoast.showToast(
          msg: "Press again to exit the app",
          backgroundColor: Colors.black,
          gravity: ToastGravity.BOTTOM);
      return Future.value(false);
    } else {
      await Prefmanager.rem();
      exit(0);
    }
  }

  void initState() {
    super.initState();
    sample();
  }

  Future sample() async {

    await getcity();
    await _getCurrentLocation();
    await offerNear();
    await offerNear1();
    await category();
    await lisyCity();
  }
bool progress1=false;
  String city1;
  Future<void> getcity() async {

    city1 = await Prefmanager.getCity();
    print(city1);
    print(await Prefmanager.getCity());

    setState(() {
      //progress1=false;
    });
    // page=1;
    // seller.clear();
    //await offerNear();
    //await category();
  }

  bool loading = true;
  var check;
  var district, state, city, fulladdress, lat, lon;

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        lat = position.latitude;
        lon = position.longitude;
        print(lat);
      });
      _getAddressFromLatLng();
      _markers.add(Marker(
          position: LatLng(lat, lon),
          markerId: MarkerId("selected-location"),
          onTap: () {
            //CommonFunction.openMap(postion);
          }));
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      print("Addresss...");
      final coordinates = new Coordinates(lat, lon);
      print(coordinates);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      print(addresses.first.addressLine);
      state = first.adminArea;
      city = first.locality;
      district = first.subAdminArea;
      fulladdress = first.addressLine;
      //print("${first.adminArea} : ${first.}");
      print(state);
      print(fulladdress);
      print(city);
      print(district);
      _kLake = CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(lat, lon),
          zoom: 17.151926040649414);
      if (mounted) setState(() {});
    } catch (e) {
      city=null;
      print(e);
    }
  }

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _kLake;
  Set<Marker> _markers = {};
  BitmapDescriptor pinLocationIcon;
  _getAddressFromLatLon() async {
    try {
      print("Addresss...");
      final coordinates = new Coordinates(lat, lon);
      print(coordinates);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      print(addresses.first.addressLine);
      state = first.adminArea;
      city = first.locality;
      fulladdress = first.addressLine;
      //print("${first.adminArea} : ${first.}");
      print(state);
      print(fulladdress);
      print(city);
      _kLake = CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(lat, lon),
          zoom: 17.151926040649414);
      //loading = false;

      if (mounted) setState(() {});
    } catch (e) {
      print(e);
    }
    //Text(fulladdress.text);
  }

  LatLng postion;
  void onMapTapFun(latlon) {
    print("gggh");
    lat = latlon.latitude;
    print(lat);
    lon = latlon.longitude;
    print(lon);
    setState(() {
      _getAddressFromLatLon();
    });
  }

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Column(children: [
            Container(
              height: 300,
              child: GoogleMap(
                //myLocationEnabled: true,
                mapType: MapType.normal,
                initialCameraPosition: _kLake,
                markers: _markers,
                onTap: (latlon) {
                  postion = latlon;
                  onMapTapFun(latlon);
                  setState(() {
                    _markers.clear();
                    _markers.add(Marker(
                        position: postion,
                        markerId: MarkerId("selected-location"),
                        onTap: () {
                          //CommonFunction.openMap(postion);
                        }));
                  });
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  setState(() {});
                },
              ),
            ),
            SizedBox(height: 10),
            Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                // padding:EdgeInsets.symmetric(horizontal: 15),
                child: FlatButton(
                  textColor: Colors.white,
                  color: Color(0xFFFC4B4B),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xFFD2D2D2)),
                      borderRadius: BorderRadius.circular(7.0)),
                  child: Text('Submit',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700),
                      )),
                  onPressed: () {},
                )),
          ]);
        });
  }

  List offernear = [];
  var length;
  int page=1,limit=10;
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
      offernear = json.decode(response.body)['data'];
      length = json.decode(response.body)['totalLength'];
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress2=false;
    setState(() {});
  }
  List offernear1 = [];
  bool progress4=true;
  int page1=1,limit1=10;
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
      offernear1 = json.decode(response.body)['data'];
      length1 = json.decode(response.body)['totalLength'];

    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress4=false;
    setState(() {});
  }
  var serviceid;
  List listcat = [];
  bool progress = true;
  Future<void> category() async {
    var url = Prefmanager.baseurl + '/homepage/category/list';
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      //'token': token != null ? token : null
    };
    Map data;
    if (city1 == null)
      data = {'lat': lat.toString(), 'lon': lon.toString()};
    else
      data = {'keyword': _mySelection != null ? _mySelection : city1};
    print(data);
    print("hh");
    var body = json.encode(data);
    var response = await http.post(url, headers: requestHeaders, body: body);
    print(json.decode(response.body));

    if (json.decode(response.body)['status']) {
      //for (int i = 0; i < json.decode(response.body)['data'].length; i++)
      listcat = json.decode(response.body)["data"];
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress = false;
    setState(() {});
  }

  List listcity = [];
  bool progress3 = true;
  Future<void> lisyCity() async {
    var url = Prefmanager.baseurl + '/sellers/city/list?city=$city';
    var response = await http.get(url);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      // listcity.add("Current location");
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

  var _mySelection;

  Widget dropCity(BuildContext context) {

    return  SearchableDropdown.single(
      // hint:  Text(city1!=null?city1:city,style: GoogleFonts.poppins(
      //   textStyle: TextStyle(
      //       color: Color(0xFF373539),
      //       fontSize: 16,
      //       fontWeight: FontWeight.w600),
      // )),
      // hint:  Text(city1==null||_mySelection=="Current location"?city:city1,
      //     style: GoogleFonts.poppins(
      //       textStyle: TextStyle(
      //           color: Color(0xFF373539),
      //           fontSize: 16,
      //           fontWeight: FontWeight.w600),
      //     )),
      hint: Text(city1 == null || _mySelection == city ? city : city1,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                color: Color(0xFF373539),
                fontSize: 16,
                fontWeight: FontWeight.w600),
          )),
// searchHint: Text(city1 == null || _mySelection == city ? city : city1,
//     style: GoogleFonts.poppins(
//       textStyle: TextStyle(
//           color: Color(0xFF373539),
//           fontSize: 16,
//           fontWeight: FontWeight.w600),
//     )),
      underline: SizedBox(),
      displayClearIcon: false,
      //isExpanded: true,
      items: listcity.map((item) {
        return new DropdownMenuItem(
          // child: new Text(item, style: GoogleFonts.poppins(
          //   textStyle: TextStyle(
          //       color: item=="Current location"?Colors.red:Color(0xFF373539),
          //       fontSize: 16,
          //       fontWeight: FontWeight.w600),
          // )),
          child: new Text(item,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: item == city ? Colors.red : Color(0xFF373539),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              )),
          value: item,
        );
      }).toList(),
      //value: _mySelection,
      onChanged: (newVal) async {
        setState(() {
          _mySelection = newVal;
          print(_mySelection);
        });
        //if(_mySelection=="Current location")
        if (_mySelection == city)
          Prefmanager.rem();
        else
          await Prefmanager.setCity(_mySelection);
        print(await Prefmanager.getCity());

        await getcity();
        await offerNear();
        await offerNear1();
        await category();
      },
    );
  }
  bool check1=false;
displayClose(String q){
  setState(() {
    check1=true;
  });

}
  var searchOnStopTyping;

  callSearch(String query) {

    const duration = Duration(milliseconds: 800);

    if (searchOnStopTyping != null) {
      setState(() {
        searchOnStopTyping.cancel();
      });
    }
    setState(() {
      searchOnStopTyping = new Timer(duration, () async {
        //await senddata();
        //await senddata1();
        await Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) =>
                        new ShopPage(keyword.text, null, null, null)))
            .then((value) {
          //This makes sure the textfield is cleared after page is pushed.
          // keyword.clear();
        });
        setState(() {});
      });
      check1=false;
    });
    //keyword.clear();
  }

  TextEditingController keyword = TextEditingController();
  List images = [
    'assets/kalyan.png',
    'assets/seematti.png',
    'assets/lamiya.png',
    'assets/home4.png',
  ];
  List todayoff = [
    'assets/paracon.png',
    'assets/meredian.png',
    'assets/meredian.png'
  ];
  List categoryimg = [
    'assets/fork.png',
    'assets/cart.png',
    'assets/fashion.png',
    'assets/monitor.png',
    'assets/monitor.png'
  ];
  List categories = ['Restaurent', 'Hyper Market', 'Textiles', 'Electronics'];
  List near = [
    '3 near by',
    '2 near by',
    '5 near by',
    '1 near by',
    '1 near by',
    '1 near by'
  ];
  List offer = [
    '10% Off for orders above Rs.1000',
    '10% Off for orders above Rs.1000',
    'Rooms Available @2500'
  ];
  List img = ['assets/fork.png', 'assets/fork.png', 'assets/slumber.png'];
  List km = ['0.6 km', '0.8 km', '1.0 km'];
  @override
  Widget build(BuildContext context) {

    return
    //   progress1
    //     ? Center(
    //   child: CircularProgressIndicator(),
    // ):
        WillPopScope(

      onWillPop: _onWillPop,
      child: Scaffold(
          body:
          // progress||progress1||progress2||progress4 ? Center(
          //         child: CircularProgressIndicator(),
          //       ):
          progress||progress1||progress2||progress4?Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            enabled: progress||progress1||progress2||progress4,
            child: Column(
                //mainAxisSize: MainAxisSize.max,

                children: <Widget>[
                  SizedBox(height:20),
                  Container(
                    width: double.infinity,
                    height: 50.0,
                    color: Colors.white,
                  ),
                  SizedBox(height:20),
                  Container(
                    width: double.infinity,
                    height: 50.0,
                    color: Colors.white,
                  ),
                  SizedBox(height:20),
                  Container(
                    //height: MediaQuery.of(context).size.height / 5.75,
                    height: 120,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder:
                            (BuildContext context, int index) {
                          return Row(
                            children: [
                              new Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets
                                              .all(5.0),
                                         child:Container(
                                           height:100,
                                           width:100,
                                             color:Colors.white
                                         )
                                        ),
                                      ]),
                                ],
                              ),
                            ],
                          );
                        }),
                  ),
                  Container(
                      width: double.infinity,
                      height: 20,
                      color:Colors.white
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      //width: 200,
                      height: 180,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0),
                                child: Container(
                                  width: 120,
                                  height: 167,
                                  color:Colors.white
                                )),

                            ]);
                          }),
                    ),
                  ),
                  Container(
                    height:150,
                    child: GridView.builder(
                      itemCount: 4,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),

                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          // width:150,
                          // height:10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                             color: Colors.white,

                          ),
                          margin: EdgeInsets.all(4),

                        );
                      },
                      gridDelegate:
                      new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 183 / 105),
                    ),
                  ),
                  // Expanded(
                  //   child: GridView.builder(
                  //     scrollDirection: Axis.vertical,
                  //     gridDelegate:
                  //     new SliverGridDelegateWithFixedCrossAxisCount(
                  //         crossAxisCount: 2,
                  //         childAspectRatio: 183 / 105),
                  //     itemBuilder: (_, __) => Padding(
                  //       padding: const EdgeInsets.only(bottom: 8.0),
                  //       child: Row(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //
                  //           Container(
                  //             width: 100.0,
                  //             height: 60.0,
                  //             color: Colors.white,
                  //           ),
                  //
                  //         ],
                  //       ),
                  //     ),
                  //     itemCount: 4,
                  //
                  //   ),
                  // )
            ]),
          ):
          SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            //color: Color(0xFFB8B8B8),
                            child: Image(
                                image: AssetImage('assets/marker.png'),
                                height: 50),
                          ),
                          //Image(image: AssetImage('assets/fishimage2.jpg'),height:200,width:double.infinity ,fit:BoxFit.fill),
                          Expanded(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("You are here",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Color(0xFFB8B8B8),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400),
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    city == null
                                        ? SizedBox.shrink()
                                        // : Text(district,
                                        //     style: GoogleFonts.poppins(
                                        //       textStyle: TextStyle(
                                        //           color: Color(0xFF373539),
                                        //           fontSize: 16,
                                        //           fontWeight: FontWeight.w600),
                                        //     )),
                                        // InkWell(
                                        //   child: Icon(
                                        //     Icons.keyboard_arrow_down,
                                        //     size: 20,
                                        //   ),
                                        //   onTap: () {
                                        //     //displayBottomSheet(context);
                                        //   },
                                        // ),
                                        // :Text(city1!=null?city1:city,
                                        //       style: GoogleFonts.poppins(
                                        //         textStyle: TextStyle(
                                        //             color: Color(0xFF373539),
                                        //             fontSize: 16,
                                        //             fontWeight: FontWeight.w600),
                                        //       )),
                                        : dropCity(context),
                                    Spacer(),
                                    InkWell(
                                      child: Icon(
                                        Icons.person_outline,
                                        color: Color(0xff8D8D8D),
                                        size: 20,
                                      ),
                                      onTap: () async {
                                        String token =
                                            await Prefmanager.getToken();
                                        if (token != null)
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      new CustomerProfile()));
                                        else
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      new FirstPage1()));
                                        // Prefmanager.clear();
                                        // Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new FirstPage()));
                                      },
                                    )
                                  ],
                                ),
                              ])),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 20,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300],
                          spreadRadius: 2,
                          blurRadius: 2,
                          //offset: Offset(2, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(Icons.search, color: Colors.red),
                          suffixIcon: check1?IconButton(
                            onPressed: () => keyword.clear(),
                            icon: Icon(Icons.clear,color: Colors.red),
                          ):SizedBox.shrink(),
                          hintText: ' What are you looking for?',
                          hintStyle: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Color(0xFFB8B8B8))),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30.0),
                            ),
                          )),
                      onChanged: displayClose,
                      onFieldSubmitted: callSearch,
                      controller: keyword,
                    ),
                  ),
                ),
                length == 0
                    ? SizedBox.shrink()
                //     :  progress2
                //     ? Center(
                //   child: CircularProgressIndicator(),
                // )
                    :Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Text("Offers Near By",
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Color(0xFF4E4E4E),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600))),
                                  Spacer(),
                                  InkWell(
                                    child: Text(
                                        length > 10
                                            ? "View All"
                                            : "",
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color:
                                                Color(0xFF1D1D1D),
                                                fontSize: 11,
                                                fontWeight:
                                                FontWeight.w500))),
                                    onTap: () async{
                                      await Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                              new OffersnearAll(
                                                  )));
                                      setState(() {
                                        _mySelection = null;
                                        progress1=true;
                                      });
                                      //_mySelection=null;
                                      await getcity();
                                      await offerNear();
                                      await offerNear1();
                                      await category();
                                      print(await Prefmanager.getCity());
                                      print(city1);
                                      setState(() {
                                      progress1=false;
                                      });
                                    },
                                  )
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.end,
                                  //   children: images.map((url) {
                                  //     int index = images.indexOf(url);
                                  //     return Container(
                                  //       width: 4.0,
                                  //       height: 4.0,
                                  //       margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                                  //       decoration: BoxDecoration(
                                  //         shape: BoxShape.circle,
                                  //         color: _current == index
                                  //             ? Color.fromRGBO(0, 0, 0, 0.9)
                                  //             : Color.fromRGBO(0, 0, 0, 0.4),
                                  //       ),
                                  //     );
                                  //   }).toList(),
                                  // ),
                                ],
                              ),
                            ),
                            // SizedBox(
                            //   width:120
                            // ),
                            //     Spacer(),
                            //     new DotsIndicator(
                            //         dotsCount: 3,
                            //         position: 2,
                            //       decorator: DotsDecorator(
                            //         //size: const Size.square(9.0),
                            //         size: const Size(5,5),
                            //         activeSize: const Size(5,5),
                            //         activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                            //       ),
                            //     )
                            //   ],
                            // ),
                            // SizedBox(
                            //   height:10
                            // ),
                            Container(
                              //height: MediaQuery.of(context).size.height / 5.75,
                              height: 120,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: offernear.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                        child: Row(
                                          children: [
                                            new Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            child: Image(
                                                              image: NetworkImage(Prefmanager
                                                                      .baseurl +
                                                                  "/file/get/" +
                                                                  offernear[
                                                                          index]
                                                                      [
                                                                      'photo']),
                                                              width: 103,
                                                              height: 103,
                                                              fit: BoxFit.fill,
                                                            )),
                                                      ),
                                                    ]),
                                              ],
                                            ),
                                          ],
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
                                        });
                                  }),
                            ),
                            // Column(
                            //   children: [
                            //     CarouselSlider(
                            //       items: images,
                            //       options: CarouselOptions(
                            //           autoPlay: true,
                            //           enlargeCenterPage: true,
                            //           aspectRatio: 2.0,
                            //           onPageChanged: (index, reason) {
                            //             setState(() {
                            //               _current = index;
                            //             });
                            //           }
                            //       ),
                            //     ),
                            //
                            //   ],
                            // ),
                            // CarouselSlider(
                            //  // options: CarouselOptions(),
                            //   options: CarouselOptions(
                            //     //viewportFraction: 1,
                            //     reverse: false,
                            //       height: 100,
                            //       autoPlay: true,
                            //     // enlargeCenterPage: true,
                            //       aspectRatio: 1.0,
                            //       onPageChanged: (index, reason) {
                            //         setState(() {
                            //           _current = index;
                            //         });
                            //       }
                            //   ),
                            //   items: images.map((item) => ClipRRect(borderRadius: BorderRadius.circular(10.0),child:Image.asset(item,height:250,fit: BoxFit.fill,))).toList(),
                            // ),
                          ]),
                length1 == 0
                    ? SizedBox.shrink()
                //     : progress4
                //     ? Center(
                //   child: CircularProgressIndicator(),
                // )
                :Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        //mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                              child: Text(
                                  "Todays offers on near by sellers",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          color: Color(0xFF4E4E4E),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)))),
                          Spacer(),
                          InkWell(
                            child: Text(
                                length1 > 10
                                    ? "View All"
                                    : "",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color:
                                        Color(0xFF1D1D1D),
                                        fontSize: 11,
                                        fontWeight:
                                        FontWeight.w500))),
                            onTap: () async{
                              await Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => TodaysoffersAll()));
                              setState(() {
                                _mySelection = null;
                                progress1=true;
                              });
                              //_mySelection=null;
                              await getcity();
                              await offerNear();
                              await offerNear1();
                              await category();
                              print(await Prefmanager.getCity());
                              print(city1);
                              setState(() {
                                progress1=false;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        //width: 200,
                        height: 180,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: offernear1.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                  child: Column(children: [
                                    Stack(
                                      // fit: StackFit.expand,
                                      children: <Widget>[
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
                                                width: 120,
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
                                    // Container(
                                    //   height: 20,
                                    //   width: 130,
                                    //   child: Padding(
                                    //     padding:
                                    //         EdgeInsets.symmetric(horizontal: 10.0),
                                    //     child: Row(
                                    //       mainAxisAlignment:
                                    //           MainAxisAlignment.start,
                                    //       children: [
                                    //         ClipRRect(
                                    //             child: Image(
                                    //                 image: AssetImage(img[index]),
                                    //                 width: 15,
                                    //                 height: 15)),
                                    //         Spacer(),
                                    //         Text(km[index],
                                    //             maxLines: 3,
                                    //             style: GoogleFonts.poppins(
                                    //                 textStyle: TextStyle(
                                    //                     color: Colors.black,
                                    //                     fontSize: 11))),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // )
                                  ]),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) => ShopPage1(false,true,offernear1[index]['sellerId']['shopName'],offernear1[index]['sellerId']['uid'], offernear1[index]['sellerId']['uid'])));
                                  });
                            }),
                      ),
                    ),
                  ],
                ),

                Divider(
                  height: 8,
                  thickness: 1,
                ),
                // progress
                //     ? Center(
                //         child: CircularProgressIndicator(),
                //       ):
                     Container(
                        width: double.infinity,
                        child: GridView.builder(
                          // childAspectRatio: 0.8,
                          itemCount: listcat.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          //crossAxisCount: 2,
                          //children: List.generate(4,(index)
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  // color: Colors.white,
                                  color: listcat[index]['name'] == 'Restaurant'
                                      ? Color(0xFF5779FF)
                                      : listcat[index]['name'] == 'Hyper Market'
                                          ? Color(0xFF2900FF)
                                          : listcat[index]['name'] == 'Textiles'
                                              ? Color(0xFF12CE44)
                                              : listcat[index]['name'] ==
                                                      'Electronics'
                                                  ? Color(0xFFFF9100)
                                                  : Color(0xFFFF9100),
                                ),
                                margin: EdgeInsets.all(4),
                                //padding: EdgeInsets.all(5) ,
                                //width:183,
                                //height:105,
                                //padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              child: Image(
                                                image: listcat[index]['icon'] !=
                                                        null
                                                    ? NetworkImage(Prefmanager
                                                            .baseurl +
                                                        "/file/get/" +
                                                        listcat[index]['icon'])
                                                    : AssetImage(
                                                        'assets/oxygen.png'),
                                                width: 40,
                                                height: 39,
                                              )),
                                          // SizedBox(
                                          //   width:20
                                          //  // width: MediaQuery.of(context).size.width/16,
                                          // ),
                                          Spacer(),
                                          Container(
                                              height: 40,
                                              child: Text(
                                                  listcat[index]['sellerCount']
                                                      .toString(),
                                                  style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12,
                                                          color: Color(
                                                              0xFFFFFFFF))))),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Expanded(
                                          flex: 1,
                                          child: Text(listcat[index]['name'],
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                      color:
                                                          Color(0xFFFFFFFF)))))
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () async {
                                // Navigator.push(context, new MaterialPageRoute(builder: (context) => SubCategory(listcat[index]["_id"],listcat[index]['cname'])));
                                //Navigator.pop(context);
                                if (listcat[index]['name'] == 'Electronics') {
                                   await Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => ElectronicsPage(
                                              listcat[index]['_id'],
                                              listcat[index]['name'])));
                                   setState(() {
                                     _mySelection = null;
                                     progress1=true;
                                   });
                                 //_mySelection=null;
                                  await getcity();
                                  await offerNear();
                                  await offerNear1();
                                  await category();
                                  print(await Prefmanager.getCity());
                                  print(city1);
                                  setState(() {
                                    progress1=false;
                                  });
                                }
                                //if(categories[index]=='Textiles')
                                // Navigator.push(context, new MaterialPageRoute(builder: (context) => ElectronicsViewall()));
                              },
                            );
                          },
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 183 / 105),
                        ),
                      ),
                // Container(
                //   //height:47,
                //   child: Card(
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
                //       child: Column(
                //         children: [
                //           SizedBox(height: 13),
                //           Row(
                //             children: [
                //               Image(
                //                   image: AssetImage(
                //                 'assets/discount.png',
                //               )),
                //               SizedBox(width: 20),
                //               Expanded(
                //                   child: Text(
                //                       "Invite friends to Eram to earn upto 10% cashback",
                //                       style: GoogleFonts.poppins(
                //                         textStyle: TextStyle(
                //                             fontWeight: FontWeight.w500,
                //                             fontSize: 12,
                //                             color: Color(0xFF373737)),
                //                       ))),
                //               Icon(Icons.keyboard_arrow_right,
                //                   color: Colors.red)
                //             ],
                //           ),
                //           SizedBox(height: 13),
                //           // Row(
                //           //   children: [
                //           //     SizedBox(width:45),
                //           //     Text("cashback",style:GoogleFonts.poppins(textStyle: TextStyle(fontWeight:FontWeight.w500,fontSize:12,color:Color(0xFF373737)))),
                //           //
                //           //   ],
                //           // ),
                //         ],
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      )),
    );
  }

  var searchMsg;
  void senddata() async {
    try {
      var url = Prefmanager.baseurl + '/seller/search';
      var token = await Prefmanager.getToken();
      Map data = {
        'keyword': keyword.text,
      };
      print(data.toString());
      var body = json.encode(data);
      var response = await http.post(url,
          headers: {"Content-Type": "application/json", "token": token},
          body: body);
      print("yyu" + response.statusCode.toString());
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)['status']) {}

        // else{
        //   searchMsg=json.decode(response.body)['msg'];
        //   Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SearchProduct(keyword.text,searchMsg))).then((value) {
        //     //This makes sure the textfield is cleared after page is pushed.
        //     keyword.clear();
        //   });
        // print(json.decode(response.body)['msg']);
        // Fluttertoast.showToast(
        //   msg:json.decode(response.body)['msg'],
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.CENTER,
        //
        // );
        //}
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } on SocketException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  void senddata1() async {
    try {
      var url = Prefmanager.baseurl + '/product/search';
      var token = await Prefmanager.getToken();
      Map data = {
        'keyword': keyword.text,
      };
      print(data.toString());
      var body = json.encode(data);
      var response = await http.post(url,
          headers: {"Content-Type": "application/json", "token": token},
          body: body);
      print("yyu" + response.statusCode.toString());
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)['status']) {
          // Navigator.push(context,new MaterialPageRoute(builder: (context)=>new ShopPage(keyword.text))).then((value) {
          //   //This makes sure the textfield is cleared after page is pushed.
          //   keyword.clear();
          // });
        }

        // else{
        //   searchMsg=json.decode(response.body)['msg'];
        //   Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SearchProduct(keyword.text,searchMsg))).then((value) {
        //     //This makes sure the textfield is cleared after page is pushed.
        //     keyword.clear();
        //   });
        // print(json.decode(response.body)['msg']);
        // Fluttertoast.showToast(
        //   msg:json.decode(response.body)['msg'],
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.CENTER,
        //
        // );
        //}
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } on SocketException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
  }
}
