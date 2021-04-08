import 'dart:convert';
import 'dart:io';
import 'package:eram_app/OrderSucess.dart';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/SelectAddress.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class OrderSummary extends StatefulWidget {
  final a;
  OrderSummary(this.a);
  @override
  _OrderSummary createState() => _OrderSummary();
}

class _OrderSummary extends State<OrderSummary> {
  final _formKey = GlobalKey<FormState>();
  void initState() {
    super.initState();
    cartList();
    defaultAddress();
    print(a);
  }

  var delid;
  List cart = [];
  var delfee, tax, total, cartlength;
  List q1 = [];
  bool progress = true;
  void cartList() async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    Map data = {'type': 'cart', 'productStatus': 'active'};
    print(data);
    var body = json.encode(data);
    var url = Prefmanager.baseurl + '/cart/list';
    var response = await http.post(url, headers: requestHeaders, body: body);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      // for (int i = 0; i < json.decode(response.body)['cart'].length; i++)
      //   cart.add(json.decode(response.body)['cart'][i]);
      cartlength = json.decode(response.body)['cart_length'];
      total = json.decode(response.body)['priceDetails']['orderTotal'];
      delfee = json.decode(response.body)['priceDetails']['deliveryFee'];
      tax = json.decode(response.body)['priceDetails']['tax'];
      cart = json.decode(response.body)['cart'];
      for (int i = 0; i < json.decode(response.body)['cart'].length; i++) {
        q1.add(json.decode(response.body)['cart'][i]['quantity']);
        print(q1);
      }
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress = false;
    setState(() {});
  }

  bool progress1 = true;
  var address;
  Future<void>defaultAddress() async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token,
    };
    var url = Prefmanager.baseurl + '/customer/default/deliveryAddress';
    var response = await http.get(url, headers: requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      address = json.decode(response.body)['data'];
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress1 = false;
    setState(() {});
  }

  void paymentSucess(var id) async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token,
    };
    Map data = {'paymentStatus': 'success'};
    print(data);
    var body = json.encode(data);
    var url =
        Prefmanager.baseurl + '/customer/order/paymentStatus/change/' + id;
    var response = await http.post(url, headers: requestHeaders, body: body);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      address = json.decode(response.body)['data'];
    } else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );

    setState(() {});
  }

  void _showDialog(var id) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Remove this product",
              style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 12))),
          //content: new Text("This will delete your review"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel",
                  style: GoogleFonts.poppins(textStyle: TextStyle())),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Remove",
                style: GoogleFonts.poppins(textStyle: TextStyle()),
              ),
              onPressed: () {
                deleteProduct(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteProduct(var id) async {
    var url = Prefmanager.baseurl + '/cart/remove/' + id;
    var token = await Prefmanager.getToken();

    //print(data.toString());

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "token": token,
      },
    );
    print(response.body);
    if (json.decode(response.body)['status']) {
      Fluttertoast.showToast(
          msg: json.decode(response.body)['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 20.0);

      cartList();
      setState(() {
        cart.removeWhere((element) => id == element['_id']);
      });
    } else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: json.decode(response.body)['msg'],
          toastLength: Toast.LENGTH_SHORT,
          // gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 20.0);
      //progress=false;
      //pro = false;
      setState(() {});
    }
  }

  var a, q,_mySelection;
  bool check = false;
  bool hasPressed = false;
  List img = ['assets/cart1.png', 'assets/cart2.png', 'assets/cart2.png'];
  List product = ['MacBook Pro 16', 'MacBook Pro 16', 'MacBook Pro 16'];
  List d = [
    '1TB SSD, 16gm ram, retina display',
    '1TB SSD, 16gm ram, retina display',
    '1TB SSD, 16gm ram, retina display'
  ];
  List price = ['229', '229', '229'];
  List save = ['51', '51', '51'];
  List shipping = ['40', '40', '40'];
  List seller = ['MYG', 'MYG', 'MYG'];
  List qty = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  @override
  Widget build(BuildContext context) {
    List f = [];
    FlutterMoneyFormatter fmf;
    MoneyFormatterOutput fo;
    for (int i = 0; i < cart.length; i++) {
      fmf = FlutterMoneyFormatter(amount: cart[i]['offerPrice'].toDouble());
      fo = fmf.output;
      f.add(fo);
    }
    List f2 = [];
    FlutterMoneyFormatter fmf2;
    MoneyFormatterOutput fo2;
    for (int i = 0; i < cart.length; i++) {
      fmf2 = FlutterMoneyFormatter(
          amount: cart[i]['productId']['price'].toDouble() -
              cart[i]['offerPrice'].toDouble());
      fo2 = fmf2.output;
      f2.add(fo2);
    }
    List f4 = [];
    FlutterMoneyFormatter fmf4;
    MoneyFormatterOutput fo4;
    for (int i = 0; i < cart.length; i++) {
      print(q1);
      fmf4 = FlutterMoneyFormatter(
          amount: cart[i]['offerPrice'].toDouble() * cart[i]['quantity']);
      fo4 = fmf4.output;
      f4.add(fo4);
    }
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Text("Order summary",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              )),
          automaticallyImplyLeading: true,
        ),
        body:
        // progress || progress1
        //     ? Center(
        //         child: CircularProgressIndicator(),
        //       ):
        progress||progress1?Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              enabled: progress||progress1,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 100.0,
                      color: Colors.white,
                    ),
                    SizedBox(height:20),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (_, __) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Container(
                                width: 60.0,
                                height: 60.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    SizedBox(height:5),
                                    Container(
                                      width: double.infinity,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    SizedBox(height:5),
                                    Container(
                                      width: double.infinity,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    SizedBox(height:5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          alignment: Alignment.bottomRight,
                                          width: 50.0,
                                          height: 8.0,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width:10),
                                        Container(
                                          alignment: Alignment.bottomRight,
                                          width: 50.0,
                                          height: 8.0,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 50,)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        itemCount: 10,
                      ),
                    )]),
            )):
             SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Card(
                            elevation: 2.0,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  address.isNotEmpty
                                      ? Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                    address['firstName'] +
                                                        " " +
                                                        address['lastName'],
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          color:
                                                              Color(0xFF000000),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                        address['address'] +
                                                            ", " +
                                                            address['city'] +
                                                            ", " +
                                                            address['state'] +
                                                            ", " +
                                                            address['pincode'],
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                              color: Color(
                                                                  0xFF000000),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        ))),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(address['mobile'],
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          color:
                                                              Color(0xFF000000),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),
                                  FlatButton(
                                    height: 40,
                                    minWidth: MediaQuery.of(context).size.width,
                                    textColor: Colors.white,
                                    color: Color(0xFFFC4B4B),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: Text('Add or Change Address',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500),
                                        )),
                                    onPressed: () async {
                                      var a = await Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  new SelectAddress(
                                                      address['_id'])));
                                      print(a);
                                      await defaultAddress();
                                      if (a != null)
                                        setState(() {
                                          address = a;
                                        });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Column(
                          //height:MediaQuery.of(context).size.height,

                          children: List.generate(cart.length, (index) {
                            List r=cart[index]['productId']['colorDetails']??[];
                            _mySelection= cart[index]['color'];
                            // padding: const EdgeInsets.symmetric(horizontal:5.0,),
                            // scrollDirection: Axis.vertical,
                            // itemCount: 3,
                            // shrinkWrap: true,
                            // physics: NeverScrollableScrollPhysics(),
                            // itemBuilder: (BuildContext context,int index){
                            return InkWell(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: new Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image(
                                                    image: cart[index]['productId']
                                                                    [
                                                                    'photos'] ==
                                                                null ||
                                                            cart[index]['productId']
                                                                    ['photos']
                                                                .isEmpty
                                                        ? NetworkImage(Prefmanager.baseurl+"/file/get/noimage.jpg")
                                                        : NetworkImage(Prefmanager
                                                                .baseurl +
                                                            "/file/get/" +
                                                            cart[index][
                                                                    'productId']
                                                                ['photos'][0]),
                                                    height: 110,
                                                    width: 90,
                                                    fit: BoxFit.fill),
                                                Expanded(
                                                    child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 12.0),
                                                  child: Column(children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                            cart[index][
                                                                    'productId']
                                                                ['name'],
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle: TextStyle(
                                                                  color: Color(
                                                                      0xFF000000),
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            )),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child: Text(
                                                                cart[index][
                                                                        'productId']
                                                                    [
                                                                    'description'],
                                                                maxLines: 2,
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  textStyle: TextStyle(
                                                                      color: Color(
                                                                          0xFF6A6A6A),
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                ))),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Row(children: [
                                                      Text(
                                                          "Price: ₹ " +
                                                              f[index]
                                                                  .nonSymbol,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle: TextStyle(
                                                                color: Color(
                                                                    0xFF000000),
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          )),
                                                      SizedBox(width: 10),
                                                      Text(
                                                          "You Save:₹" +
                                                              f2[index]
                                                                  .nonSymbol,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle: TextStyle(
                                                                color: Color(
                                                                    0xFF2DD986),
                                                                fontSize: 9,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                          )),
                                                    ]),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Row(children: [
                                                      Text(
                                                          "Shipping Charge: ₹40",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle: TextStyle(
                                                                color: Color(
                                                                    0xFF000000),
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          )),
                                                      //SizedBox(width:100),
                                                      Spacer(),
                                                    ]),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Row(children: [
                                                      Text(
                                                          "Seller: " +
                                                              cart[index]['productId']
                                                                      ['sellerId']
                                                                  ['shopName'],
                                                          style: GoogleFonts.poppins(
                                                              textStyle: TextStyle(
                                                                  color: Color(
                                                                      0xFF6A6A6A),
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400))),
                                                    ]),
                                                    SizedBox(height: 10),
                                                    //Text("Qty:"),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: 100.0,
                                                          height: 25,
                                                          foregroundDecoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                            border: Border.all(
                                                              color: Color(
                                                                  0xFFE2E2E2),
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text("   Qty:",
                                                                  style: GoogleFonts.poppins(
                                                                      textStyle: TextStyle(
                                                                          color: Color(
                                                                              0xFF2A2A2A),
                                                                          fontSize:
                                                                              7,
                                                                          fontWeight:
                                                                              FontWeight.w400))),
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    DropdownButton(
                                                                  isExpanded:
                                                                      true,
                                                                  underline:
                                                                      SizedBox(),
                                                                  // hint: Text("Select",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF2A2A2A),fontSize:12,fontWeight: FontWeight.w400))),
                                                                  items: qty
                                                                      .map((s) {
                                                                    return new DropdownMenuItem<
                                                                        String>(
                                                                      child: new Text(
                                                                          s.toString()),
                                                                      value: s
                                                                          .toString(),
                                                                    );
                                                                  }).toList(),
                                                                  onChanged:
                                                                      (newVal) {
                                                                    setState(
                                                                        () {
                                                                      // _mySelection[index] = newVal;
                                                                      // print(_mySelection);

                                                                      senddata2(
                                                                          cart[index]
                                                                              [
                                                                              '_id'],
                                                                          newVal,null);
                                                                    });
                                                                  },
                                                                  value: cart[index]
                                                                          [
                                                                          'quantity']
                                                                      .toString(),
                                                                ),
                                                                // child: TextFormField(
                                                                //   textAlign: TextAlign.center,
                                                                //   decoration: InputDecoration(
                                                                //     labelText: 'Qty:',
                                                                //     contentPadding: EdgeInsets.all(8.0),
                                                                //     border: OutlineInputBorder(
                                                                //       borderRadius: BorderRadius.circular(8.0),
                                                                //     ),
                                                                //   ),
                                                                //   controller: _controller,
                                                                //   keyboardType: TextInputType.numberWithOptions(
                                                                //     decimal: false,
                                                                //     signed: true,
                                                                //   ),
                                                                //   //inputFormatters: <TextInputFormatter>[
                                                                //   //WhitelistingTextInputFormatter.digitsOnly
                                                                //   //],
                                                                //   onSaved: (v) {
                                                                //     q = v;
                                                                //   },
                                                                // ),
                                                              ),

                                                              // Container(
                                                              //   height: 38.0,
                                                              //   child: Column(
                                                              //     crossAxisAlignment: CrossAxisAlignment.center,
                                                              //     mainAxisAlignment: MainAxisAlignment.center,
                                                              //     children: <Widget>[
                                                              //       Container(
                                                              //         decoration: BoxDecoration(
                                                              //           border: Border(
                                                              //             bottom: BorderSide(
                                                              //               width: 0.5,
                                                              //             ),
                                                              //           ),
                                                              //         ),
                                                              //         child: InkWell(
                                                              //           child: Icon(
                                                              //             Icons.arrow_drop_up,
                                                              //             size: 18.0,
                                                              //           ),
                                                              //           onTap: () {
                                                              //             print(_controller.text);
                                                              //
                                                              //             int currentValue = int.parse(_controller.text);
                                                              //             setState(() {
                                                              //               currentValue++;
                                                              //               _controller.text = (currentValue)
                                                              //                   .toString(); // incrementing value
                                                              //               print(currentValue);
                                                              //               print(_controller.text);
                                                              //             });
                                                              //           },
                                                              //         ),
                                                              //       ),
                                                              //       InkWell(
                                                              //         child: Icon(
                                                              //           Icons.arrow_drop_down,
                                                              //           size: 18.0,
                                                              //         ),
                                                              //         onTap: () {
                                                              //           print(_controller.text);
                                                              //           int currentValue = int.parse(_controller.text);
                                                              //           setState(() {
                                                              //             print("Setting state");
                                                              //             currentValue--;
                                                              //             _controller.text =
                                                              //                 (currentValue > 0 ? currentValue : 1)
                                                              //                     .toString(); // decrementing value
                                                              //             print(currentValue);
                                                              //             print(_controller.text);
                                                              //
                                                              //           });
                                                              //         },
                                                              //       ),
                                                              //     ],
                                                              //   ),
                                                              // ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(width:5),
                                                        cart[index]['productId']['isColor']==true?
                                                        // colorList.isNotEmpty?
                                                        Expanded(
                                                          child: Container(
                                                            width: 100,
                                                            height:25,
                                                            foregroundDecoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5.0),
                                                              border: Border.all(
                                                                color: Color(0xFFE2E2E2),
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: <Widget>[
                                                                //for(int i=0;i<colorList.length;i++)
                                                                Expanded(
                                                                  child: DropdownButton(
                                                                    underline: SizedBox(),
                                                                    isExpanded: true,
                                                                    // hint: Text("Select",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF2A2A2A),fontSize:12,fontWeight: FontWeight.w400))),
                                                                    items: cart[index]['productId']['status']=='deleted'||cart[index]['productId']['status']=='inactive'?null:r.map((a) {

                                                                      return new DropdownMenuItem<String>(
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(left:10.0),
                                                                          child: new Container(
                                                                            height: 20,
                                                                            width: 20,
                                                                            decoration:
                                                                            BoxDecoration(
                                                                              color: Color(int
                                                                                  .parse(a['color']
                                                                              )),
                                                                              shape: BoxShape
                                                                                  .circle,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        value: a['color'].toString(),
                                                                      );
                                                                    }).toList(),
                                                                    onChanged: (newVal) {
                                                                      progress3?Center(child:CircularProgressIndicator(),):
                                                                      setState(() {
                                                                        print(newVal);
                                                                        _mySelection = newVal;
                                                                        // print(_mySelection);

                                                                        senddata2(cart[index]['_id'],null,_mySelection);

                                                                      });
                                                                    },
                                                                    value:_mySelection,
                                                                  ),
                                                                ),

                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                            :SizedBox.shrink(),
                                                        SizedBox(width: 10),
                                                        Expanded(
                                                          flex: 0,
                                                          child: InkWell(
                                                            child: Text(
                                                              "REMOVE",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                textStyle: TextStyle(
                                                                    color: Color(
                                                                        0xFF000000),
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              _showDialog(
                                                                  cart[index]
                                                                      ['_id']);
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ]),
                                                )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      height: 30,
                                      thickness: 1,
                                      indent: 1,
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  //Navigator.push(context,new MaterialPageRoute(builder: (context)=>new VieweachProduct(profile[index]['_id'],profile[index]['seller']['_id'],widget.deldate)));
                                });
                          }),
                        ),
                        // Container(
                        //   height: 50,
                        //   decoration: BoxDecoration(
                        //     color: Color(0xFFFFFFFF),
                        //     borderRadius: BorderRadius.only(
                        //                 topRight: Radius.circular(40.0),
                        //                 topLeft: Radius.circular(40.0)),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.grey[300].withOpacity(0.5),
                        //         spreadRadius: 5,
                        //         blurRadius: 4,
                        //         offset: Offset(2, 5), // changes position of shadow
                        //       ),
                        //     ],
                        //   ),
                        // //   decoration: BoxDecoration(
                        // //     color:Colors.grey[100],
                        // //       borderRadius: BorderRadius.only(
                        // //           topRight: Radius.circular(40.0),
                        // //           topLeft: Radius.circular(40.0)),
                        // //
                        // // )
                        //
                        // ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Card(
                            elevation: 2.0,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Price Details',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xFF000000),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          )),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Column(
                                      children:
                                          List.generate(cart.length, (index) {

                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                                cart[index]['productId']
                                                    ['name'],
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF393939),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                            Spacer(),
                                            Text('₹ ' + f4[index].nonSymbol,
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Color(0xFF474747),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    );
                                  })),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Delivery Fee',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xFF474747),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          )),
                                      Spacer(),
                                      Text("₹ " + delfee,
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xFF474747),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Tax',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xFF474747),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          )),
                                      Spacer(),
                                      Text("₹ " + tax,
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xFF474747),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Order Total',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xFF474747),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          )),
                                      Spacer(),
                                      Text("₹ " + total,
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                color: Color(0xFF474747),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Card(
                            elevation: 2.0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Total',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Color(0xFF6A6A6A),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400),
                                      )),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Text('₹ ' + total,
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    color: Color(0xFF474747),
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ))),
                                      SizedBox(
                                        width: 100,
                                      ),
                                      progress2
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : Expanded(
                                              child: FlatButton(
                                                height: 40,
                                                minWidth: 120,
                                                textColor: Colors.white,
                                                color: Color(0xFFFC4B4B),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0)),
                                                child: Text('Continue',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )),
                                                onPressed: () {
                                                  if (address['_id'] == null)
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "Please add delivery address",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                    );
                                                  else
                                                    senddata();
                                                },
                                              ),
                                            )
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ));
  }

  var id;
  bool progress2 = false;
  void senddata() async {
    setState(() {
      progress2 = true;
    });
    try {
      String token = await Prefmanager.getToken();
      var url = Prefmanager.baseurl + '/customer/placeorder';
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': token
      };

      Map data = {
        'deliveryAddressId': address['_id'],
        'orderTotal': total,
        'deliveryFee': delfee,
        'tax': tax
      };
      print(data);
      var body = json.encode(data);
      var response = await http.post(url, headers: requestHeaders, body: body);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)['status']) {
          print((json.decode(response.body)['token']));
          String token = await Prefmanager.getToken();
          print(token);
          id = json.decode(response.body)['id'];
          paymentSucess(id);
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new OrderSucess()));
        } else {
          print(json.decode(response.body)['msg']);
          checkstockOrder(json.decode(response.body)['msg']);
          // Fluttertoast.showToast(
          //     msg: json.decode(response.body)['msg'],
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.CENTER,
          //     backgroundColor: Colors.grey,
          //     textColor: Colors.white,
          //     fontSize: 20.0
          // );
          setState(() {
            progress2 = false;
          });
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } on SocketException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
    progress2 = false;
  }

  var qu;
  bool progress3=false;
  void senddata2(var id, quantity,color) async {
    setState(() {
      progress3=true;
    });
    try {
      String token = await Prefmanager.getToken();
      var url = Prefmanager.baseurl + '/cart/edit/' + id;
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': token
      };

      Map data = {
        'type': 'cart',
        'quantity': quantity,
        'color':color
      };
      qu = quantity;
      print(data);
      var body = json.encode(data);
      var response = await http.post(url, headers: requestHeaders, body: body);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)['status']) {
          print((json.decode(response.body)['token']));
          String token = await Prefmanager.getToken();
          print(token);
          cartList();
        } else {
          print(json.decode(response.body)['msg']);
          checkstock(json.decode(response.body)['msg']);
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } on SocketException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
    progress3=false;
  }

  void checkstock(var msg) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(msg,
              style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 12))),
          //content: new Text("This will delete your review"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void checkstockOrder(var msg) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(msg,
              style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 12))),
          //content: new Text("This will delete your review"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
