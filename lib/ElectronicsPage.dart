import 'dart:async';
import 'dart:convert';
import 'package:eram_app/ElectronicsViewall.dart';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/ShopPage1.dart';
import 'package:eram_app/SubcategoryProducts.dart';
import 'package:eram_app/utils/helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_dropdown/searchable_dropdown.dart';

class ElectronicsPage extends StatefulWidget {
  final serviceid, name;
  ElectronicsPage(this.serviceid, this.name);
  @override
  _ElectronicsPage createState() => _ElectronicsPage();
}

class _ElectronicsPage extends State<ElectronicsPage> {
  var _mySelection;
  void initState() {
    super.initState();
    sample();
    print(widget.serviceid);
  }

  Future sample() async {
    await _getCurrentLocation();
    await categorySlider();
    await subCategory();
    await lisyCity();
    await getcity();
    await sellerlist();
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

  List seller = [];
  bool progress = true;
  var length;
  int page = 1, limit = 50;
  Future<void> sellerlist() async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token != null ? token : null
    };
    Map data;
    if (city1 == null)
      data = {
        'categoryId': widget.serviceid,
        'limit': limit.toString(),
        'page': page.toString(),
        'lat': lat.toString(),
        'lon': lon.toString(),
      };
    else
      data = {
        'categoryId': widget.serviceid,
        'limit': limit.toString(),
        'page': page.toString(),
        'keyword': _mySelection != null ? _mySelection : city1
      };
    print(_mySelection);
    print(data);
    var body = json.encode(data);

    var url = Prefmanager.baseurl + '/seller/nearby/list';
    var response = await http.post(url, headers: requestHeaders, body: body);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      length = json.decode(response.body)['totalLength'];
      //  page=1;
      // seller.clear();
      for (int i = 0; i < json.decode(response.body)['data'].length; i++)
        seller.add(json.decode(response.body)['data'][i]);
      page++;
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress = false;
    loading = false;
    setState(() {});
  }

  var listsubcat = [];
  bool progress1 = true;
  Future<void> subCategory() async {
    //catid.add(m);
    var url = Prefmanager.baseurl + '/subcategory/list/' + widget.serviceid;
    var response = await http.get(url);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      listsubcat = json.decode(response.body)['data'];
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress1 = false;
    setState(() {});
  }

  var catslider = [];
  bool progress2 = true;
  Future<void> categorySlider() async {
    //catid.add(m);
    var url = Prefmanager.baseurl + '/category/view/' + widget.serviceid;
    var response = await http.get(url);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      //catslider = json.decode(response.body)['data'];
      image = json.decode(response.body)['data']['sliderImages'];
    } else
      // Fluttertoast.showToast(
      //   msg:json.decode(response.body)['message'],
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      // );
      progress2 = false;
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
          seller.clear();
        });
        await getcity();
        await sellerlist();

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
          Text(widget.name,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 12,
                      fontWeight: FontWeight.w600))),
          city == null
              ? SizedBox.shrink()
              : dropCity(context),
        ]),

      ),
      body:
      // progress
      //     ? Center(
      //         child: CircularProgressIndicator(),
      //       ):
      progress?CameraHelper.productlistLoader(context):
      Center(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  // physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                          height: 220.0,
                          child: Carousel(
                            dotBgColor: Colors.transparent,
                            dotColor: Colors.white,
                            dotPosition: DotPosition.bottomRight,
                            dotSize: 5,
                            dotSpacing: 15,
                            images: image.isEmpty
                                ? img
                                    .map((item) => Image(
                                        image: AssetImage(item),
                                        width: 300,
                                        height: 400,
                                        fit: BoxFit.fill))
                                    .toList()
                                : image
                                    .map((item) => Image(
                                        image: NetworkImage(
                                            Prefmanager.baseurl +
                                                "/file/get/" +
                                                item),
                                        width: 300,
                                        height: 400,
                                        fit: BoxFit.cover))
                                    .toList(),
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 25,
                            ),
                            Expanded(
                              flex: 5,
                              child: ListView.builder(
                                  itemCount: listsubcat.length > 4
                                      ? 4
                                      : listsubcat.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return
                                        // listsubcat[index]['name']=='View all'?
                                        InkWell(
                                            child: Column(children: [
                                              Expanded(
                                                //flex: 1,
                                                child: Row(children: [
                                                  Column(
                                                    children: [
                                                      Image(
                                                          image: listsubcat[
                                                                          index]
                                                                      [
                                                                      'icon'] !=
                                                                  null
                                                              ? NetworkImage(Prefmanager
                                                                      .baseurl +
                                                                  "/file/get/" +
                                                                  listsubcat[
                                                                          index]
                                                                      ['icon'])
                                                              : AssetImage(
                                                                  'assets/oxygen.png'),
                                                          width: 30,
                                                          height: 30),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Expanded(
                                                          flex: 1,
                                                          child: Text(
                                                              listsubcat[index][
                                                                      'name'] ??
                                                                  " ",
                                                              style: GoogleFonts.poppins(
                                                                  textStyle: TextStyle(
                                                                      color: Color(
                                                                          0xFF848484),
                                                                      fontSize:
                                                                          9,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300)))),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 35,
                                                  ),
                                                ]),
                                              )
                                            ]),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (context) =>
                                                          new SubcategoryProducts(
                                                              listsubcat[index]
                                                                  ["_id"],
                                                              listsubcat[index]
                                                                  ['name'])));
                                            });
                                  }),
                            ),
                            Expanded(
                              flex: 2,
                              child: InkWell(
                                  child: Column(
                                    children: [
                                      Image(
                                          image: AssetImage('assets/view.png'),
                                          width: 25),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text("View all",
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(0xFF848484),
                                                  fontSize: 10,
                                                  fontWeight:
                                                      FontWeight.w300))),
                                    ],
                                  ),
                                  onTap: () async {
                                    await Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                new ElectronicsViewall(
                                                    widget.serviceid,
                                                    widget.name)));
                                   setState(() {
                                     _mySelection = null;

                                   });
                                   // _mySelection = null;
                                    setState(() {
                                      page = 1;
                                      seller.clear();
                                    });

                                    await getcity();
                                    await sellerlist();

                                  }),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Popular Stores",
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Color(0xFF1D1D1D),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600))),
                                  Spacer(),
                                  Text("15km Range",
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Color(0xFF1D1D1D),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10))),
                                  // Container(
                                  //     padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  //     alignment: Alignment.topRight,
                                  //     child:Text("See all")
                                  // ),
                                ]),
                            Row(
                              children: [
                                city == null
                                    ? SizedBox.shrink()
                                    : Text(city1 != null ? city1 : city,
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Color(0xFF7E7E7E),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        )),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            seller.isEmpty
                                ? Text("No stores are available",
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400)))
                                : progress
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
                                            if (length > seller.length) {
                                              print(length);
                                              print(seller.length);
                                              sellerlist();
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
                                              itemCount: seller.length,
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
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
                                                                      seller[index]
                                                                              [
                                                                              'sellerid']
                                                                          [
                                                                          "photo"],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  width: double
                                                                      .infinity,
                                                                  height: 150,
                                                                )),
                                                            if (seller[index][
                                                                        'sellerid']
                                                                    [
                                                                    'isOffer'] ==
                                                                true)
                                                              Positioned(
                                                                  top: 10,
                                                                  right: 10,
                                                                  child: Image(
                                                                      image: AssetImage(
                                                                          'assets/discount.png'))),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        // Text(cat[index],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w600))),
                                                        Text(
                                                            seller[index]
                                                                    ['sellerid']
                                                                ['shopName'],
                                                            style: GoogleFonts.poppins(
                                                                textStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFF000000),
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600))),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Image(
                                                              image: AssetImage(
                                                                  'assets/googlemaps.png'),
                                                              height: 19,
                                                              width: 19,
                                                            ),
                                                            Text(
                                                                seller[index]['sellerid']
                                                                            [
                                                                            'distance'] !=
                                                                        null
                                                                    ? "  " +
                                                                        seller[index]
                                                                                ['sellerid']
                                                                            [
                                                                            'distance'] +
                                                                        " km"
                                                                    : " ",
                                                                style: GoogleFonts.poppins(
                                                                    textStyle: TextStyle(
                                                                        color: Color(
                                                                            0xFF000000),
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w500))),
                                                            Spacer(),
                                                            Container(
                                                                height: 19,
                                                                child: Icon(
                                                                  Icons.star,
                                                                  color: Color(
                                                                      0xFFFFBF00),
                                                                  size: 10,
                                                                )),
                                                            Text(
                                                                seller[index]
                                                                            ['sellerid']
                                                                        [
                                                                        'rating']
                                                                    .toString(),
                                                                style: GoogleFonts.poppins(
                                                                    textStyle: TextStyle(
                                                                        color: Color(
                                                                            0xFF000000),
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w500))),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                            builder: (context) => ShopPage1(
                                                                false,false,
                                                                seller[index][
                                                                        'sellerid']
                                                                    [
                                                                    'shopName'],
                                                                seller[index][
                                                                        'sellerid']
                                                                    ['uid'],
                                                                seller[index]
                                                                    ['_id'])));
                                                    //Navigator.pop(context);
                                                  },
                                                );
                                              },
                                              gridDelegate:
                                                  new SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      crossAxisSpacing: 10,
                                                      mainAxisSpacing: 10,
                                                      childAspectRatio: 0.75)),
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
