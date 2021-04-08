import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eram_app/CartPage.dart';
import 'package:eram_app/CustomerProfile.dart';
import 'package:eram_app/FirstPage1.dart';
import 'package:eram_app/BottomNavigator.dart';
import 'package:eram_app/MyordersPage.dart';
import 'package:eram_app/ProductDetail.dart';
import 'package:eram_app/SellerOfferview.dart';
import 'package:eram_app/ShopPage.dart';
import 'package:eram_app/SubcategoryProducts.dart';
import 'package:eram_app/WishlistPage.dart';
import 'package:eram_app/utils/helper.dart';
import 'package:http/http.dart' as http;
import 'package:eram_app/Prefmanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class ElectronicsViewall extends StatefulWidget {
  final serviceid, name;
  ElectronicsViewall(this.serviceid, this.name);
  @override
  _ElectronicsViewall createState() => new _ElectronicsViewall();
}

class _ElectronicsViewall extends State<ElectronicsViewall> {
  void initState() {
    super.initState();
    sample();
  }

  Future sample() async {
    await _getCurrentLocation();
    await subCategory();
    await getcity();
    await productlist();
    await offerNear1();
    await lisyCity();
  }

  String city1;
  Future<void> getcity() async {
    city1 = await Prefmanager.getCity();
    print(city1);
    setState(() {});
    // page=1;
    // seller.clear();
    //await offerNear();
    //await category();
  }

  List listcity = [];
  bool progress3 = true;
  Future<void> lisyCity() async {
    var url = Prefmanager.baseurl + '/sellers/city/list?city=$city';
    var response = await http.get(url);
    print(json.decode(response.body));
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
  List offernear1 = [];
  var length1,categoryicon;
  Future<void> offerNear1() async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token != null ? token : null
    };
    Map data;
    data = {'categoryId': widget.serviceid};

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
    setState(() {});
  }
  var _mySelection;
  Widget dropCity(BuildContext context) {
    return SearchableDropdown.single(
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
        if (_mySelection == city)
          Prefmanager.rem();
        else
          await Prefmanager.setCity(_mySelection);
        print(await Prefmanager.getCity());
        page = 1;
        product.clear();
        await getcity();
        await productlist();
      },
    );
  }

  var district, city, lat, lon;
  bool _hasBeenPressed1 = false;
  bool _hasBeenPressed2 = false;
  bool _hasBeenPressed3 = false;
  List imagesp = [
    'assets/mac.jpg',
    'assets/ifb.jpg',
    'assets/tv.jpg',
    'assets/earpod.jpg'
  ];
  List pronames = [
    'MacBook Pro',
    'IFB Front Load',
    'One Plus Tv 32',
    'Sony Wireless Earpod'
  ];
  List offer = ['10% Off', '15% Off', '10% Off', '15% Off'];
  List images = [
    'assets/Smartphone.png',
    'assets/tablet.png',
    'assets/laptop.png',
    'assets/monitor.png',
    'assets/washer.png',
    'assets/stove.png',
    'assets/air.png',
    'assets/fridge.png',
  ];
  List catnames = [
    'Mobile',
    'Tablet',
    'Laptop',
    'Television',
    'Washing Machine',
    'Kitchen Accessories',
    'Air Conditiner',
    'Refrigerator'
  ];
  var listsubcat = [];
  bool progress = true;
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
    progress = false;
    setState(() {});
  }

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
      print("Addresss...");
      final coordinates = new Coordinates(lat, lon);
      print(coordinates);
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

  List product = [];
  bool progress1 = true;
  var length;
  int page = 1, limit = 50;
  Future<void> productlist() async {
    setState(() {
      progress1 = true;
    });

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
        'productType': _hasBeenPressed1
            ? 'bestselling'
                : _hasBeenPressed3
                    ? 'offers'
                    : null,
        'lat': lat.toString(),
        'lon': lon.toString()
      };
    else
      data = {
        'categoryId': widget.serviceid,
        'limit': limit.toString(),
        'page': page.toString(),
        'productType': _hasBeenPressed1
            ? 'bestselling'
            : _hasBeenPressed2
                ? 'todaysdeal'
                : _hasBeenPressed3
                    ? 'offers'
                    : null,
        'keyword': _mySelection != null ? _mySelection : city1
      };
    print(data);
    var body = json.encode(data);
    var url = Prefmanager.baseurl + '/product/list';
    var response = await http.post(url, headers: requestHeaders, body: body);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      length = json.decode(response.body)['totalLength'];
      for (int i = 0; i < json.decode(response.body)['data'].length; i++)
        product.add(json.decode(response.body)['data'][i]);
      page++;
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress1 = false;
    loading = false;
    setState(() {});
  }

  bool loading = false;
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
        // await senddata1();
        //await senddata2();
        // await Navigator.push(context,new MaterialPageRoute(builder: (context)=>new CategorySearch(widget.serviceid,keyword.text))).then((value) {
        //   //This makes sure the textfield is cleared after page is pushed.
        //
        // });
        await Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new ShopPage(
                    keyword.text, null, widget.serviceid, null))).then((value) {
          //This makes sure the textfield is cleared after page is pushed.
        });
        setState(() {});
      });
      check1=false;
    });
    //keyword.clear();
  }

  TextEditingController keyword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(widget.name,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 16,
                            fontWeight: FontWeight.w600))),
              ],
            ),
            Row(
              children: [
                city == null
                    ? SizedBox.shrink()
                    //     :Row(
                    //   children: [
                    //     Text(district,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF373539),fontSize:12,fontWeight: FontWeight.w600))),
                    //     Icon(Icons.keyboard_arrow_down,color:Color(0xFF373539))
                    //
                    //   ],
                    // ),
                    : dropCity(context),
              ],
            )
          ]),
          actions: [
            IconButton(
                icon: Icon(Icons.favorite_outline,
                    size: 20, color: Color(0xFF7A7A7A)),
                onPressed: () async {
                  String token = await Prefmanager.getToken();
                  if (token != null)
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new WishlistPage()));
                  else
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new FirstPage1()));
                }),
            IconButton(
                icon: Icon(Icons.shopping_cart_outlined,
                    size: 20, color: Color(0xFF7A7A7A)),
                onPressed: () async {
                  String token = await Prefmanager.getToken();
                  if (token != null)
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new CartPage()));
                  else
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new FirstPage1()));
                }),
          ],
        ),
        drawer: Drawer(
            child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
              progress
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      color: Colors.red,
                      child: DrawerHeader(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 40.0,
                                      backgroundColor: Colors.blue,
                                      backgroundImage:
                                          AssetImage('assets/userlogo.jpg'),
                                    ),
                                  ]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: new EdgeInsets.all(10.0),
                                    // child:Text(listprofile['customerid']['firstName']+" "+listprofile['customerid']['lastName'],style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.white,fontSize:15,fontWeight: FontWeight.w600),),),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                                //   width:40,
                              ),
                            ]),
                      ),
                    ),
              ListTile(
                leading: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                title: Text('Home',
                    style: GoogleFonts.poppins(
                      textStyle:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    )),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new MyNavigationBar()));
                  //Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.supervised_user_circle,
                  color: Colors.black,
                ),
                title: Text('Your Account',
                    style: GoogleFonts.poppins(
                      textStyle:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    )),
                onTap: () async {
                  String token = await Prefmanager.getToken();
                  if (token != null)
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new CustomerProfile()));
                  else
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new FirstPage1()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.supervised_user_circle,
                  color: Colors.black,
                ),
                title: Text('Your Wishlist',
                    style: GoogleFonts.poppins(
                      textStyle:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    )),
                onTap: () async {
                  String token = await Prefmanager.getToken();
                  if (token != null)
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new WishlistPage()));
                  else
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new FirstPage1()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                ),
                title: Text('Your Orders',
                    style: GoogleFonts.poppins(
                      textStyle:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    )),
                onTap: () async {
                  String token = await Prefmanager.getToken();
                  if (token != null)
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new MyordersPage()));
                  else
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new FirstPage1()));
                },
              ),
            ])),
        body: progress1
            ?CameraHelper.productlistLoader(context):
        SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      height: 50,
                      //color: Colors.grey,
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
                            )),
                        onFieldSubmitted: callSearch,
                        onChanged: displayClose,
                        controller: keyword,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Image(
                    image: AssetImage('assets/Slider 3.png'),
                    width: double.infinity,
                    height: 212,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    //padding: const EdgeInsets.symmetric(horizontal:15.0),
                    child: GridView.builder(
                        itemCount: listsubcat.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        //crossAxisCount: 2,
                        //children: List.generate(4,(index)
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: Container(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image(
                                  image: listsubcat[index]['icon'] != null
                                      ? NetworkImage(Prefmanager.baseurl +
                                          "/file/get/" +
                                          listsubcat[index]['icon'])
                                      : AssetImage('assets/oxygen.png'),
                                  height: 30,
                                  width: 30,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(listsubcat[index]['name'] ?? " ",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Color(0xFF848484),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w300))),
                                ),
                              ],
                            )),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => SubcategoryProducts(
                                          listsubcat[index]["_id"],
                                          listsubcat[index]['name'])));
                            },
                          );
                        },
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 0.5,
                                crossAxisSpacing: 0.5,
                                childAspectRatio: 1.2)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: FlatButton(
                            //width:114,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                              color: _hasBeenPressed1
                                  ? Color(0xFFE50019)
                                  : Color(0xFFD2D2D2),
                            )),

                            height: 26,
                            minWidth: 114,
                            color: Color(0xFFFFFFFF),
                            child: Text('Best Selling',maxLines:1,overflow:TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: _hasBeenPressed1
                                            ? Color(0xFFE50019)
                                            : Color(0xFF000000),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500))),
                            onPressed: () {
                              setState(() {
                                _hasBeenPressed1 = !_hasBeenPressed1;
                                _hasBeenPressed1 = true;
                                _hasBeenPressed2 = false;
                                _hasBeenPressed3 = false;
                                setState(() {
                                  page = 1;
                                  product.clear();
                                });
                                productlist();
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 8),

                        Expanded(
                          child: FlatButton(
                            //width:114,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                              color: _hasBeenPressed2
                                  ? Color(0xFFE50019)
                                  : Color(0xFFD2D2D2),
                            )),

                            height: 26,
                            minWidth: 114,
                            color: Color(0xFFFFFFFF),
                            child: Text('Todays Deal',maxLines:1,overflow:TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: _hasBeenPressed2
                                            ? Color(0xFFE50019)
                                            : Color(0xFF000000),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500))),
                            onPressed: () {
                              setState(() {
                                _hasBeenPressed2 = !_hasBeenPressed2;
                                _hasBeenPressed2 = true;
                                _hasBeenPressed1 = false;
                                _hasBeenPressed3 = false;
                                setState(() {
                                  page = 1;
                                  offernear1.clear();
                                });
                                offerNear1();
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: FlatButton(
                            //width:114,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                              color: _hasBeenPressed3
                                  ? Color(0xFFE50019)
                                  : Color(0xFFD2D2D2),
                            )),

                            height: 26,
                            minWidth: 110,
                            color: Color(0xFFFFFFFF),
                            child: Text('Offers',maxLines:1,overflow:TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: _hasBeenPressed3
                                            ? Color(0xFFE50019)
                                            : Color(0xFF000000),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500))),
                            onPressed: () {
                              setState(() {
                                _hasBeenPressed3 = !_hasBeenPressed3;
                                _hasBeenPressed3 = true;
                                _hasBeenPressed1 = false;
                                _hasBeenPressed2 = false;
                                setState(() {
                                  page = 1;
                                  product.clear();
                                });
                                productlist();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal:15.0),
                  //   child: Row(
                  //     children: [
                  //       Text("Offers on near me",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w500),)),
                  //       Spacer(),
                  //       FlatButton(
                  //         //width:114,
                  //         shape: RoundedRectangleBorder(
                  //             side: BorderSide(color: Color(0xFFD2D2D2))
                  //         ),
                  //
                  //         height: 22,
                  //         minWidth:60,
                  //         color: Color(0xFFFFFFFF),
                  //         child: Text('View all',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF707070),fontSize:10,fontWeight: FontWeight.w300))),
                  //         onPressed: () {
                  //
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 10),
                  if(_hasBeenPressed2)
                    todaysDeal()
                  else
                  product.isEmpty
                      ? Text("No proucts are available",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)))
                      : progress1
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification scrollInfo) {
                                if (!loading &&
                                    scrollInfo.metrics.pixels ==
                                        scrollInfo.metrics.maxScrollExtent) {
                                  if (length > product.length) {
                                    print(length);
                                    print(product.length);
                                    productlist();
                                    setState(() {
                                      loading = true;
                                    });
                                  } else {}
                                } else {}
                                //  setState(() =>loading = false);
                                return true;
                              },
                              child: GridView.builder(
                                  // childAspectRatio: 0.8,
                                  itemCount: product.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  //crossAxisCount: 2,
                                  //children: List.generate(4,(index)
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30.0),
                                        child: Container(
                                            color: Colors.white60,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Column(
                                              children: [
                                                Center(
                                                    child: Image(
                                                  image: product[index]
                                                                  ['photos'] ==
                                                              null ||
                                                          product[index]
                                                                  ['photos']
                                                              .isEmpty
                                                      ? NetworkImage(Prefmanager
                                                              .baseurl +
                                                          "/file/get/noimage.jpg")
                                                      : NetworkImage(Prefmanager
                                                              .baseurl +
                                                          "/file/get/" +
                                                          product[index]
                                                              ['photos'][0]),
                                                  height: 130,
                                                  width: 180,
                                                )),

                                                Text(product[index]['name'],
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            color: Color(
                                                                0xFF000000),
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600))),
                                                Text(
                                                    product[index]
                                                                ['discount'] ==
                                                            0
                                                        ? ""
                                                        : product[index]
                                                                    ['discount']
                                                                .toString() +
                                                            "% Off",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            color: Color(
                                                                0xFFFF4141),
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300))),
                                                Divider(),

                                                //Container(height: 10, child: VerticalDivider(color: Colors.red)),
                                                //Divider(height: 10,)
                                              ],
                                            )),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetail(product[index]
                                                        ["_id"])));
                                        //Navigator.pop(context);
                                      },
                                    );
                                  },
                                  gridDelegate:
                                      new SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 0.9)),
                            ),

                  Container(
                    height: loading ? 20 : 0,
                    width: double.infinity,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  //   child: Container(
                  //     //height:47,
                  //     child: Card(
                  //       child: Column(
                  //         children: [
                  //           SizedBox(height: 13),
                  //           Row(
                  //             children: [
                  //               SizedBox(
                  //                 width: 15,
                  //               ),
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
                  // ),
                ],
              ),
            ),
          ),
        ));
  }
  Widget todaysDeal(){
    return Column(
        children:[
          offernear1.isEmpty?
          Text("No offers are available",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 14,
                      fontWeight: FontWeight.w400)))
              :NotificationListener<ScrollNotification>(
            onNotification:
                (ScrollNotification scrollInfo) {
              if (!loading &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo
                          .metrics.maxScrollExtent) {
                if (length1 > offernear1.length) {
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
              child: GridView.builder(
                  itemCount: offernear1.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  //crossAxisCount: 2,
                  //children: List.generate(4,(index)
                  itemBuilder:
                      (BuildContext context, int index) {
                    return GestureDetector(
                      child: Container(
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              // mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 3,
                                ),
                                Stack(children: [
                                  ClipRRect(
                                      borderRadius:
                                      BorderRadius
                                          .circular(6.0),
                                      child: Image(
                                        image: offernear1[index][
                                        'photo'] ==
                                            null ||
                                            offernear1[index]
                                            [
                                            'photo']
                                                .isEmpty
                                            ? NetworkImage(Prefmanager
                                            .baseurl +
                                            "/file/get/noimage.jpg")
                                            : NetworkImage(Prefmanager
                                            .baseurl +
                                            "/file/get/" +
                                            offernear1[index]
                                            [
                                            'photo']
                                        ),
                                        fit: BoxFit.cover,
                                        height: 175,
                                        width: 175,
                                      )),
                                  // Image(image:AssetImage(imagesp[index]),height: 110,width: 175,),
                                  // offernear1[index]
                                  // ['discount'] !=
                                  //     0
                                  //     ? Positioned(
                                  //     top: 10,
                                  //     right: 10,
                                  //     child: Image(
                                  //         image: AssetImage(
                                  //             'assets/discount.png')))
                                  //     : SizedBox.shrink()
                                ]),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                          offernear1[index]
                                          ['name'],
                                          style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Color(
                                                      0xFF000000),
                                                  fontSize: 14,
                                                  fontWeight:
                                                  FontWeight
                                                      .w600))),
                                    ),
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [

                                    Expanded(
                                      child: Text(
                                          offernear1[index]['description'],
                                          maxLines: 1,
                                          overflow: TextOverflow
                                              .ellipsis,
                                          style: GoogleFonts
                                              .poppins(
                                            textStyle: TextStyle(
                                                color: Color(
                                                    0xFFF43636),
                                                fontSize: 10,
                                                fontWeight:
                                                FontWeight
                                                    .w400),
                                          )),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    SellerOfferview(true,
                                        offernear1[index]
                                        ["_id"])));
                        //Navigator.pop(context);
                      },
                    );
                  },
                  gridDelegate:
                  new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7)),
            ),
          )
        ]
    );

  }
  var searchMsg;
  void senddata1() async {
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

  void senddata2() async {
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
