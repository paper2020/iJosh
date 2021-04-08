
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/SellerProductSearch.dart';
import 'package:eram_app/SellerProductview.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class StocksPage extends StatefulWidget {
  final check,id;
  StocksPage(this.check,this.id);
  @override
  _StocksPage  createState() => _StocksPage();
}
class _StocksPage  extends State<StocksPage > {
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  void initState() {
    super.initState();
    widget.check=='Out of Stock'?s=1:widget.check=='Limited Stock'?s=2:widget.check=='Best Selling'?s=3:s=0;
    stocklist();
    sellerview();
  }
  var stock,total;
  bool progress=true;
  var length,off;
  var products=[];
  void stocklist() async{
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    Map data = {
      'productType':s==0?null:s==1?'outofstock':s==2?'limitedstock':'bestselling'
    };
    print(data);
    var body = json.encode(data);
    print(token);
    var url=Prefmanager.baseurl+'/seller/my/product/grouped/list';
    var response = await http.post(url,headers:requestHeaders,body:body);
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
      length = json.decode(response.body)['totalLength'];
        stock=json.decode(response.body)['data'];
      total=json.decode(response.body)['totalProducts'];
      print(total);
      // for(int i=0;i<json.decode(response.body)['data'][i]['products'].length;i++)
      //   products=json.decode(response.body)['data'][i]['products'];
      // for(int i=0;i<products.length;i++)
      //   products=json.decode(response.body)['data'][i]['products'];

    }
    else
      Fluttertoast.showToast(
        msg:json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress=false;
    loading=false;
    setState(() {
    });
  }
  List sub=[];
  bool progress1=true;
  void sellerview() async{
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    var url=Prefmanager.baseurl+'/seller/view/'+widget.id;
    var response = await http.get(url,headers: requestHeaders);
    print(json.decode(response.body));
    print(widget.id);
    print(token);
    if(json.decode(response.body)['status']) {

      for (int i = 0; i < json.decode(response.body)['data']['sellerid']['subcategory'].length; i++)
        sub.add(json.decode(response.body)['data']['sellerid']['subcategory'][i]);

    }
    else
      Fluttertoast.showToast(
        msg:json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    progress1=false;
    setState(() {
    });
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
      searchOnStopTyping = new Timer(duration, ()async {

        await senddata1();
        await Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SellerProductSearch(keyword.text,widget.id))).then((value) {
          //This makes sure the textfield is cleared after page is pushed.
        });
        setState(() {

        });
      });
      check1=false;
    });
    //keyword.clear();
  }
  TextEditingController keyword = TextEditingController();
  TextEditingController quantityController=TextEditingController();
  //TextEditingController stockController=TextEditingController();
  List<TextEditingController> stockController = [];
  List stocks=[];
  void displayBottomSheet(BuildContext context,var id,var q,bool isColor) {
    quantityController.text=q;
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            height:MediaQuery.of(context).size.height/2,
            child: Form(
              key:_formKey1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child: Center(
                  child: Column(
                      children: [
                        SizedBox(height:10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Stock Quantity",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
                          ],
                        ),

                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter stock quantity';
                            }
                            else
                              return null;

                          },
                          keyboardType: TextInputType.number,
                          controller: quantityController,
                          style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                          decoration: InputDecoration(
                            labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                          ),
                        ),
                        SizedBox(height:10),
                        progress2?Center( child: CircularProgressIndicator(),):
                        Container(
                            height: 50,
                            width:MediaQuery.of(context).size.width,
                           // padding:EdgeInsets.symmetric(horizontal: 15),
                            child: FlatButton(
                              textColor: Colors.white,
                              color: Color(0xFFFC4B4B),
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Color(0xFFD2D2D2)),
                                  borderRadius: BorderRadius.circular(7.0)),
                              child: Text('Submit',style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.white,fontSize:10,fontWeight: FontWeight.w700),)),
                              onPressed: () {
                                if (_formKey1.currentState.validate()) {
                                  _formKey1.currentState.save();
                                  senddata(id,isColor,null);
                                  //addSinglePhoto();
                                }

                              },
                            )),

                      ]),
                ),
              ),
            ),
          );
        });
  }
  void displayBottomSheet1(BuildContext context,var id,List colors,bool isColor) {
    for (int i = 0;
    i < colors.length;
    i++)
    stocks.add(colors[i]['stock'].toString());
     //stockController.text=colors[i]['stock'].toString();
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            height:MediaQuery.of(context).size.height/2,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child: Column(
                    children: [
                      SizedBox(height:10),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: <Widget>[
                              for (int i = 0;
                              i < colors.length;
                              i++)

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 5),
                                    Container(
                                      height: 25,
                                      width: 25,
                                      decoration:
                                      BoxDecoration(
                                          color: Color(int
                                              .parse(colors[i]['color'])),
                                          shape: BoxShape
                                              .circle,


                                      ),
                                    ),
                                    SizedBox(width:20),
                                    Container(
                                      width:70,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter stock';
                                          }
                                          else
                                            return null;

                                        },
                                        initialValue: stocks[i].toString(),
                                        //maxLength: 5,
                                        //maxLengthEnforced: true,
                                        inputFormatters: [LengthLimitingTextInputFormatter(5)],
                                        keyboardType: TextInputType.number,
                                        //controller: stockController[i],
                                        style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                                        decoration: InputDecoration(
                                          labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                                        ),
                                        onSaved: (val) {
                                         stocks[i]=val;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 60,
                                    ),
                                  ],
                                ),
                               SizedBox(height:10),
                            ]),
                      ),
                      progress2?Center( child: CircularProgressIndicator(),):
                      Container(
                          height: 50,
                          width:MediaQuery.of(context).size.width,
                          // padding:EdgeInsets.symmetric(horizontal: 15),
                          child: FlatButton(
                            textColor: Colors.white,
                            color: Color(0xFFFC4B4B),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Color(0xFFD2D2D2)),
                                borderRadius: BorderRadius.circular(7.0)),
                            child: Text('Submit',style: GoogleFonts.poppins(textStyle:TextStyle(color:Colors.white,fontSize:10,fontWeight: FontWeight.w700),)),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                for(int i=0;i<colors.length;i++)
                                colorstock.add({
                                  "color": colors[i]['color'],
                                  "stock": stocks[i]
                                });
                                senddata(id,isColor,colorstock);
                                //addSinglePhoto();
                              }

                            },
                          )),

                    ]),
              ),
            ),
          );
        });
  }
  var a,q;
  int s=0;
  bool check=true;
  bool loading=false;
  bool hasPressed=false;
  bool hasPressed1,hasPressed2,hasPressed3=false;
  List img=['assets/Mobile.png','assets/Mobile.png','assets/Mobile.png'];
  List product=['Oppo 10v','Oppo 10v','Oppo 10v'];
  List d=['1TB SSD, 16gm ram, retina display','1TB SSD, 16gm ram, retina display','1TB SSD, 16gm ram, retina display'];
  List price=['Rs. 10,000.00','Rs. 10,000.00','Rs. 10,000.00'];
  List titles=['All Products','Out of Stock','Limited Stock','Best Selling'];
  List offer=['800','800','800'];
  @override

  Widget build(BuildContext context) {
    // List f=[];
    //
    // for(int i=0;i<stock.length;i++) {
    //   for(int j=0;i<stock[i]['products'][j].length;j++)
    //   fmf = ;
    //   fo = fmf.output;
    //   f.add(fo);
    // }
    return Scaffold(
      key:_scaffoldKey,
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Text("Stocks", style: GoogleFonts.poppins(textStyle: TextStyle(
              color: Color(0xFF000000),
              fontSize: 16,
              fontWeight: FontWeight.w600),)),
          actions: [
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [


                    Icon(Icons.filter_alt_sharp,size:20,color: Color(0xFFBABABA)),
                    Text("Filter",style: GoogleFonts.poppins(textStyle: TextStyle(
                        color: Color(0xFF9D9D9D),
                        fontSize: 10,
                        fontWeight: FontWeight.w300),)),
                  ],
                ),
              ),
              onTap: () => _scaffoldKey.currentState.openEndDrawer(),
            ),

          ],
        ),
        endDrawer: Theme(
          data: Theme.of(context).copyWith(
            primaryColor: Colors.white,
            //canvasColor: Colors.black, //This will change the drawer background to blue.
            //other styles
          ),
          child: Drawer(child: new ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height:100,
                  child: DrawerHeader(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:15.0),
                      child: Row(
                        children: [
                          Icon(Icons.filter_alt_sharp,size:25,color: Color(0xFF2B2B2B)),SizedBox(width:5),
                          Text('Filter',style: GoogleFonts.poppins(textStyle: TextStyle(
                              color: Color(0xFF2B2B2B),
                              fontSize: 13,
                              fontWeight: FontWeight.w300),)),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:15.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    //width:MediaQuery.of(context).size.width/8,
                    child: ListView.builder(
    itemCount: sub.length,
    itemBuilder: (context, i) {
      return Column(
        children: [
          ListTile(
            leading:Image(image: NetworkImage(Prefmanager.baseurl+"/file/get/"+sub[i]['icon']),width: 30,height:30),
            title: Text(sub[i]['name'],style: GoogleFonts.poppins(textStyle: TextStyle(
                color: Color(0xFF848484),
                fontSize: 10,
                fontWeight: FontWeight.w300),)),
            onTap: () {
             senddata2(sub[i]['_id']);

            },
          ),
          SizedBox(height:10)
        ],
      );
    }
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body:
        ///progress?Center(child:CircularProgressIndicator(),):
        progress?Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              enabled: progress,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      color:Colors.white,
                      width:double.infinity,height:50
                    ),
                    SizedBox(height:10),
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
                                    SizedBox(height:10),
                                    Container(
                                      width: double.infinity,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    SizedBox(height:10),
                                    Container(
                                      alignment: Alignment.bottomRight,
                                      width: 40.0,
                                      height: 8.0,
                                      color: Colors.white,
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
          child: Column(
            children: [
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:15.0),
                child: Container(
                  height:50,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200].withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 4,
                        offset: Offset(2, 5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.search,color:Colors.red),
                        suffixIcon: check1?IconButton(
                          onPressed: () => keyword.clear(),
                          icon: Icon(Icons.clear,color: Colors.red),
                        ):SizedBox.shrink(),
                        hintText: ' What are you looking for?',
                        hintStyle: GoogleFonts.poppins(textStyle:TextStyle(fontWeight:FontWeight.w400,fontSize: 12,color: Color(0xFFB8B8B8))),
                        border: OutlineInputBorder( borderSide: BorderSide.none,
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),)
                    ),
                      controller: keyword,
                    onFieldSubmitted: callSearch,
                    onChanged: displayClose,
                  ),
                ),
              ),
              SizedBox(height:20),
              Container(
                height: 40,
                child: ListView.builder(
                  //                       padding: const EdgeInsets.all(10.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,

                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context,int index){
                      return
                        InkWell(
                            child: Row(
                              //                            mainAxisAlignment: MainAxisAlignment.start,
                              //                               crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width:30),
                                Column(
                                  children: [
                                    // Text(titles[index],style: GoogleFonts.poppins(textStyle:TextStyle(color:s==index?Color(0xFF373737):Color(0xFF9B9B9B),fontSize:13,fontWeight: FontWeight.w600))),
                                    // s==index?Container(
                                    //   height:2,
                                    //   width:90,
                                    //   color:Color(0xFFFF4A4A),
                                    //
                                    //   // indent: 1,
                                    // ):SizedBox.shrink(),
                                    Text(titles[index], style: GoogleFonts.poppins(textStyle: TextStyle(
                                        color: s==index&&titles[index]=="Out of Stock"?Color(0xFFD62F2F):s==index&&titles[index]=="Limited Stock"?Color(0xFF127EFC):s==index&&titles[index]=="Best Selling"?Color(0xFFFCB912):s==index&&titles[index]=="All Products"?Color(0xFF29D089):Color(0xFF9D9D9D),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300),)),
                                    s==index?Container(
                                        height:2,
                                        width:65,
                                        color: s==index&&titles[index]=="Out of Stock"?Color(0xFFD62F2F):s==index&&titles[index]=="Limited Stock"?Color(0xFF127EFC):s==index&&titles[index]=="Best Selling"?Color(0xFFFCB912):s==index&&titles[index]=="All Products"?Color(0xFF29D089):Color(0xFF9D9D9D),

                                        // indent: 1,
                                      )
                                        :SizedBox.shrink()
                                  ],
                                ),
                                SizedBox(width:30),


                              ],
                            ),
                            onTap:() {
                              //Navigator.push(context,new MaterialPageRoute(builder: (context)=>new VieweachProduct(profile[index]['_id'],profile[index]['seller']['_id'],widget.deldate)));
                              setState(() {
                                check=true;
                                s=index;
                                print(s);
                                stock.clear();
                                stocklist();

                              });
                            }
                        );
                    }
                ),
              ),
              //progress?Center(child:CircularProgressIndicator(),):
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:25.0),
                child: Row(
                  children: [
                    Image(image:AssetImage('assets/basket1.png'),color:Color(0xFF9F9F9F),width:20,height:18),SizedBox(width:5),
                    Text(total.toString()+" Products",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:11,fontWeight: FontWeight.w600))),
                    Spacer(),Text(total==0?"":"Add Stock",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF9D9D9D),fontSize:8,fontWeight: FontWeight.w500))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right:35.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children:[
                  Text(total==0?"":"QTY",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF9D9D9D),fontSize:8,fontWeight: FontWeight.w500))),
                ]
        ),
              ),
              SizedBox(height:5),

            //progress?Center(child:CircularProgressIndicator(),):
            NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!loading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
              if(length>stock.length){
                print(length);
                print(stock.length);

                //stocklist();
                setState(() {
                  loading = true;
                });
              }
              else{}

            }
            else{}
            //  setState(() =>loading = false);
            return true;
          },
          child: Column(
                children: List.generate(stock.length, (index) {
                  return
                    Column(
                      children: [
                    Padding(
                    padding: const EdgeInsets.only(left:25.0,right:10),
                    child: Row(
                        children: [
                    Image(image: NetworkImage(Prefmanager.baseurl+"/file/get/"+stock[index]['_id']['icon']),color:Color(0xFF9F9F9F),width:20,height:20),SizedBox(width:5),
                  Text(stock[index]['_id']['name'],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF9F9F9F),fontSize:12,fontWeight: FontWeight.w600))),
                  ],
                  ),
                  ),
                        SizedBox(height:10),
                        Column(
                          children:  List.generate(stock[index]['products'].length, (i) {
                  return InkWell(
                    child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0),
                    child: Column(
                      children: [
                        Row(
                        children: [
                        // SizedBox(
                        //   width: 5,
                        // ),

                        Expanded(
                        child: new Row(
                        // crossAxisAlignment: CrossAxisAlignment
                        //     .center,
                        children: [
                        // Checkbox(value: _isChecked,
                        // //checkColor: Colors.green,
                        // activeColor: Colors.green,
                        // onChanged:(bool newValue){
                        // setState(() {
                        // _isChecked = newValue;
                        // });
                        // }),
                      Checkbox(
                        value: stock[index]['products'][i]['status']=='active'?true:false,
                        //value:checkValue[index],
                        activeColor: Colors.green,
                        onChanged:(bool newValue){
                          setState(() {
                            //checkValue[index] = newValue;
                            a=stock[index]['products'][i]['_id'];
                            senddata3(a);
                          });
                        },
                      ),
                        Stack(
                          alignment: Alignment.center,

                      children: [

                        Container(
                          width:60,
                          child: Image(image:stock[index]['products'][i]['photos']==null||stock[index]['products'][i]['photos'].isEmpty?NetworkImage(Prefmanager.baseurl+"/file/get/noimage.jpg"):NetworkImage(Prefmanager.baseurl+"/file/get/"+stock[index]['products'][i]['photos'][0]),
                      height: 68,
                      width: 68,
                      fit: BoxFit.fill),
                        ),
                        stock[index]['products'][i]['status']=='inactive'?
                        Positioned(
                          child: Card(
                            elevation:5,
                              child: Container(
                                width:60,
                                child: Column(
                                  children: [
                                    Row(
                                        children:[
                                          Expanded(child: Text("Item",textAlign:TextAlign.center,style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFE23636),fontSize:8,fontWeight: FontWeight.w400))))
                                        ]
                                    ),
                            Row(
                                  children:[
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text("   Disabled",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFE23636),fontSize:8,fontWeight: FontWeight.w400,),)))
                                  ]
                            )
                                  ],

                                ),
                              )
                          ),
                        )
                            :SizedBox.shrink()
                              ]
                        ),
                        Expanded(
                        child: Padding(
                        padding: const EdgeInsets
                        .symmetric(
                        horizontal: 5.0),
                        child: Column(
                        children: [
                        Row(
                        children: [
                        Expanded(
                      child: Text(
                      stock[index]['products'][i]['name'],
                      style: GoogleFonts
                          .poppins(
                      textStyle: TextStyle(
                      color: Color(
                      0xFF373737),
                      fontSize: 12,
                      fontWeight: FontWeight
                          .w500),)),
                        ),

                        ],
                        ),
                        Row(
                        children: [
                        Expanded(flex:1,
                      child: Text(stock[index]['products'][i]['description'],
                      style: GoogleFonts
                          .poppins(
                      textStyle: TextStyle(
                      color: Color(
                      0xFF828282),
                      fontSize: 10,
                      fontWeight: FontWeight
                          .w400),)),
                        ),
                        // SizedBox(width:5),
                        Spacer(),

                        ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Text("Rs. "+stock[index]['products'][i]['price'].toString(),
                        style: GoogleFonts
                        .poppins(
                        textStyle: TextStyle(
                        color: Color(
                        0xFF1C1C1C),
                        fontSize: 11,
                        fontWeight: FontWeight
                        .w500),)),
                        SizedBox(width:10),

                        Expanded(
                          child: Text('${(stock[index]['products'][i]['price']-stock[index]['products'][i]['offerPrice']).toStringAsFixed(2)}'
                          +"  off",
                          style: GoogleFonts
                              .poppins(
                            textStyle: TextStyle(
                                color: Color(
                                    0xFFD83D3D),
                                fontSize: 9,
                                fontWeight: FontWeight
                                    .w300),)),
                        ),

                        ]

                        ),
                        SizedBox(
                        height: 3,
                        ),
                        ])
                        ),

                        ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 40.0,
                              width: 60.0,
                              color: Colors.white,
                              child: Container(
                                  decoration: BoxDecoration(
                                    //color: Colors.white,
                                      border: Border.all(color: Color(0xFFD6D6D6)),
                                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                                  ),
                                  child: new Center(
                                      child: new IconButton(icon: Icon(Icons.add),color:Color(0xFFBEBEBE),alignment: Alignment.center, onPressed: (){
                                        if(stock[index]['products'][i]['isColor']==false)
                                        displayBottomSheet(context,stock[index]['products'][i]['_id'],stock[index]['products'][i]['stockQuantity'].toString(),stock[index]['products'][i]['isColor']);
                                      else
                                        displayBottomSheet1(context,stock[index]['products'][i]['_id'],stock[index]['products'][i]['colorDetails'],stock[index]['products'][i]['isColor']);
                                      })

                                  )),),
                            SizedBox(height:5),
                            Padding(
                              padding: const EdgeInsets.only(right:15.0),
                              child: Text(stock[index]['products'][i]['stockQuantity'].toString()+" left",
                                  style: GoogleFonts
                                      .poppins(
                                    textStyle: TextStyle(
                                        color: Color(
                                            0xFFD83D3D),
                                        fontSize: 9,
                                        fontWeight: FontWeight
                                            .w500),)),
                            ),
                          ],
                        ),
                      )
                        ],
                        ),
                        ),

                        ],
                        ),

                        Divider(
                      height: 30,
                      thickness: 1,
                      indent: 1,
                        ),

                      ],
                    ),

                    ),
                      onTap: () {
                        stock[index]['products'][i]['status']=='inactive'?SizedBox.shrink()
                        :Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SellerProductview(stock[index]['products'][i]['_id'])));
                      }
                  );

                  })
                        ),


                      ],
                    );
                }
                ),
              ),
            ),
              Container(
                height: loading?20:0,
                width:double.infinity,
                child: Center(
                    child:CircularProgressIndicator()
                ),
              ),
            ],
          ),
        ));
  }
  List colorstock=[];
  bool progress2=false;
  void senddata(var id,bool isColor,List colorstock) async {
    setState(() {
      progress2=true;
    });
    try{
      var url = Prefmanager.baseurl+'/product/edit/'+id;
      var token=await Prefmanager.getToken();
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': token,
      };
      Map data={

        "stockQuantity":quantityController.text,
        "isColor":isColor,
        'colorDetails':colorstock
      };
      print(data.toString());
      print(id);
      var body=json.encode(data);
      var response = await http.post(url,headers:requestHeaders,body:body);
      print(response);
      print("yyu"+response.statusCode.toString());
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if(json.decode(response.body)['status'])
        {
         Navigator.of(context).pop(true);
          Navigator.pushReplacement(context,new MaterialPageRoute(builder: (context)=>new StocksPage(null,widget.id)));
        }

        else{
          print(json.decode(response.body)['message']);
          Fluttertoast.showToast(
            msg:json.decode(response.body)['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,

          );
        }
      }
      else {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
    on SocketException catch(e){
      print(e.toString());
    }
    catch(e){
      print(e.toString());
    }
    progress2=false;
  }
  Future<void>senddata1() async {
    try{
      var url = Prefmanager.baseurl+'/product/search';
      var token=await Prefmanager.getToken();
      Map data={
        'keyword':keyword.text,
        'userid':widget.id
      };
      print(data.toString());
      var body=json.encode(data);
      var response = await http.post(url,headers:{"Content-Type":"application/json","token":token},body:body);
      print("yyu"+response.statusCode.toString());
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if(json.decode(response.body)['status'])
        {
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
      }
      else {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
    on SocketException catch(e){
      print(e.toString());
    }
    catch(e){
      print(e.toString());
    }
  }

  void senddata2(var id) async {
    try{
      String token = await Prefmanager.getToken();
      var url = Prefmanager.baseurl+'/seller/my/product/grouped/list';
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': token,
      };

      Map data={
        'productType':s==0?null:s==1?'outofstock':s==2?'limitedstock':'bestselling',
        'subcategoryId':id
      };
      print(data);
      var body=json.encode(data);
      var response = await http.post(url,body: body,headers: requestHeaders);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if(json.decode(response.body)['status'])
        {
          Navigator.of(context).pop(true);
          setState(() {
            stock=json.decode(response.body)['data'];
          });


        //stocklist();
        //   Navigator.push(
        //         context, new MaterialPageRoute(
        //         builder: (context) => new StocksPage(widget.id)));
        }

        else{
          // Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SearchProduct(keyword.text,searchMsg))).then((value) {
          //   //This makes sure the textfield is cleared after page is pushed.
          //
          // });
          print(json.decode(response.body)['msg']);
          // Fluttertoast.showToast(
          //   msg:json.decode(response.body)['msg'],
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.CENTER,
          //
          // );
        }
      }
      else {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
    on SocketException catch(e){
      print(e.toString());
    }
    catch(e){
      print(e.toString());
    }

  }
  var status;
  void senddata3(var id) async {
    try{
      String token = await Prefmanager.getToken();
      var url = Prefmanager.baseurl+'/product/status/change/'+id;
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': token,
      };

      var response = await http.post(url,headers: requestHeaders);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if(json.decode(response.body)['status'])
        {

           setState(() {
             stocklist();
           });

          //   Navigator.push(
          //         context, new MaterialPageRoute(
          //         builder: (context) => new StocksPage(widget.id)));
        }

        else{
          // Navigator.push(context,new MaterialPageRoute(builder: (context)=>new SearchProduct(keyword.text,searchMsg))).then((value) {
          //   //This makes sure the textfield is cleared after page is pushed.
          //
          // });
          print(json.decode(response.body)['msg']);
          // Fluttertoast.showToast(
          //   msg:json.decode(response.body)['msg'],
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.CENTER,
          //
          // );
        }
      }
      else {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
    on SocketException catch(e){
      print(e.toString());
    }
    catch(e){
      print(e.toString());
    }

  }
}