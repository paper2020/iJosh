
import 'dart:convert';
import 'dart:io';
import 'package:eram_app/Prefmanager.dart';
import 'package:eram_app/SellerProductlist.dart';
import 'package:eram_app/SellerProfile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
class AddProduct extends StatefulWidget {
  @override
  _AddProduct createState() => _AddProduct();
}
class _AddProduct extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController specificationController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  String valueText;String codeDialog;
  bool check=false;
  bool addCheck=false;
  Color currentColor = Colors.transparent;
  List <Color>currentColors = [];
  void changeColor(var color){
    setState(() => currentColor = color);
    getHex();
  }

  void changeColors(List c) {
    setState(() => currentColors = c);
    print(currentColors);

  }
  List hex=[];
  void getHex(){
    //hex.clear();

      hex.add(currentColor.value);

  }
  List stockList=[];
  void getStock(){
    stockList.add(stockController.text);

  }
  List colorstock=[];
  // List hex=[];
  // void getHex(){
  //   hex.clear();
  //   for(int i=0;i<currentColors.length;i++)
  //     {
  //       hex.add(currentColors[i].value.toString());
  //     }
  // }
  void initState() {
    super.initState();
    profile();

  }

  bool isColor=false;
  var uid,listprofile,_mySelection;
  List subid=[];
  bool progress=true;
  void profile() async{
    var url=Prefmanager.baseurl+'/user/me';
    var token=await Prefmanager.getToken();
    print("Profile");
    print(token);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token,
    };
    var response = await http.post(url,headers:requestHeaders);
    print(json.decode(response.body));
    if(json.decode(response.body)['status'])
    {
       listprofile=json.decode(response.body)['data'];
       uid=json.decode(response.body)['data']['_id'];
      // print(listprofile);
      for(int i=0;i<json.decode(response.body)['data']['sellerid']['subcategory'].length;i++)
        subid.add(json.decode(response.body)['data']['sellerid']['subcategory'][i]);
      print(subid);
    }
    else
      Fluttertoast.showToast(msg:json.decode(response.body)['msg'],);
    progress=false;
    setState(() {});
  }
  List<File>files=[];
  var filename,fileslist,filepath;
  bool onPress=false;
  Future<void> filePicker()async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    for(int i=0;i<result.paths.length;i++) {
      if (files.length< 4) {
        files.add(File(result.paths[i]));
        setState(() {});
      }
      else
    Fluttertoast.showToast(
    msg: "Only 4 images can be added",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,

    );
    }
    print(result.files);
    fileslist=result.files;
    print(fileslist);
    filepath=result.paths;
    print(filepath);
    if(result != null) {
      //List<File> files = result.paths.map((path) => File(path)).toList();
      filename=result.names.toString();
      print(filename);
    } else {
      // User canceled the picker
    }
  }
  Widget add(){

    getStock();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width:5),
              //for(int i=0;i<hex.length;i++)
              for(int i=0;i<colorstock.length;i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:5.0),
                  child: Container(height:30,width:85,decoration:BoxDecoration(borderRadius: new BorderRadius.circular(50.0),color:Color(colorstock[i]['color']),),child: Padding(
                    padding: const EdgeInsets.only(left:15.0),
                    child: Row(
                      children: [
                        Text(colorstock[i]['stock'],style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFFFFFFF),fontSize:11,fontWeight: FontWeight.w300))),
                        Spacer(),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 15,
                          child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 15,
                              child: IconButton(
                                onPressed: () {
                                  colorstock
                                      .removeAt(
                                      i);
                                  // val1.removeAt(index);
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.close,
                                  size: 15,
                                  color: Color(colorstock[i]['color']),
                                ),
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                  ),
                ),
              SizedBox(width:10)
            ],
          ),
          SizedBox(height:20)
        ],
      ),

    );

  }
  Widget colorStock(){
    print("hi");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:15.0),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height:10),
            Padding(
              padding: const EdgeInsets.only(left:15.0),
              child: Text("Select Color and Stock",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 12,
                          fontWeight: FontWeight.w500))),
            ),
            SizedBox(height:10),
            Padding(
              padding: const EdgeInsets.only(left:10.0),
              child: Row(
                children: [
                  Text("Color",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Color(0xFF848484),
                              fontSize: 12,
                              fontWeight: FontWeight.w300))),
                  Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(width:15),
                          Container(
                            height:25,width:25,
                            child: RawMaterialButton(
                              shape: CircleBorder(),
                              fillColor: Colors.grey[100],
                              elevation: 3.0,
                              onPressed: () {
                                setState(() {
                                  addCheck=true;
                                });
                                print(addCheck);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Select color'),
                                      content: SingleChildScrollView(
                                        child:BlockPicker(
                                          pickerColor: currentColor,
                                          onColorChanged: changeColor,
                                        ),
                                      ),
                                    );

                                  },
                                );
                              },
                             child:  addCheck==true?CircleAvatar(backgroundColor:Color(currentColor.value)):Icon(Icons.add,color:Color(0xFF8E8E8E))
                              // color: currentColor,

                            ),
                          )

                        ]
                    ),
                  ),
                  SizedBox(width:20),
                  Text("Stock",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Color(0xFF848484),
                              fontSize: 12,
                              fontWeight: FontWeight.w300))),
                  SizedBox(width:10),
                  Container(
                    height:5,
                    width:50,
                    child: TextFormField(
                      // validator: (value) {
                      //   if (value.isEmpty) {
                      //     return 'Please enter product name';
                      //   }
                      //   else
                      //     return null;
                      // },
                      controller: stockController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                      decoration: InputDecoration(
                        labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                  SizedBox(width:10),
                  FlatButton(
                    //width:114,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Color(0xFFE8E8E8)),
                        borderRadius: BorderRadius.circular(7.0)),

                    height: 36,
                    minWidth:50,
                    color: Color(0xFFFFFFFF),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add,size:30,color:Color(0xFFC6C6C6)),
                        Text('  Add',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:11,fontWeight: FontWeight.w600),)),
                      ],
                    ),
                    onPressed: () {
                      setState(() {

                        if(isColor==true&&currentColor==Colors.transparent||stockController.text.isEmpty)
                          Fluttertoast.showToast(
                            msg: "Please select color and stock",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                          else {
                          addCheck = true;
                          colorstock.add({
                            "color": currentColor.value,
                            "stock": stockController.text
                          });
                          currentColor=Colors.transparent;
                          stockController.clear();
                          setState(() {
                            addCheck=false;
                          });
                        }
                      });

                    },
                  ),
                ],
              ),
            ),

            Divider(
              height: 30,
              thickness: 1,
              indent: 1,
            ),
          // addCheck?add():SizedBox.shrink()
add(),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Text("Add New Product",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:16,fontWeight: FontWeight.w600),)),
          automaticallyImplyLeading: true,
          actions: [
            progress?Center(child:CircularProgressIndicator(),):
            Padding(
              padding: const EdgeInsets.only(right:18.0),
              child: InkWell(child: Image(image: NetworkImage(Prefmanager.baseurl+"/file/get/"+listprofile['sellerid']["photo"]),width: 30,height: 30,),onTap: (){Navigator.push(context, new MaterialPageRoute(builder: (context) => SellerProfile(uid,listprofile['sellerid']['shopName'])));},),
            )

          ],
        ),

        body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical:10),
                  child: Column(
                    children: <Widget>[

                      SizedBox(height:10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:15.0),
                        child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Select item type",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
                                ],
                              ),
                              Container(
                                //padding: EdgeInsets.all(10),
                                child:DropdownButton(
                                  isExpanded: true,
                                  //hint: Text("Select Subategory"),
                                  items: subid.map((item) {
                                    return new DropdownMenuItem(
                                      child: new Text(item['name']),
                                      value: item['_id'].toString(),
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    setState(() {
                                      _mySelection = newVal;
                                      print(_mySelection);

                                    });
                                  },
                                  value: _mySelection,
                                ),
                              ),

                                  ],
                                ),
                              ),

                      SizedBox(height:10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:15.0),
                        child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Product Name",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
                                ],
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter product name';
                                  }
                                  else if(value.length>35)
                                    return 'Only 35 characters are allowed';
                                  else
                                    return null;
                                },
                               // maxLength: 35,
                                controller: nameController,
                                style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                                decoration: InputDecoration(
                                  labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                                ),
                              ),
                              SizedBox(height: 20,),

                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:15.0),
                        child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Product Details",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
                                ],
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter product details';
                                  }
                                  else if(value.length>35)
                                    return 'Only 35 characters are allowed';
                                  else
                                    return null;
                                },
                                //maxLength: 35,
                                //maxLengthEnforced: true,
                                //inputFormatters: [LengthLimitingTextInputFormatter(5)],
                                controller: descriptionController,
                                style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                                decoration: InputDecoration(
                                  labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                                ),
                              ),
                              SizedBox(height: 20,),


                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:15.0),
                        child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Price",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
                                ],
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter price';
                                  }
                                  else
                                    return null;
                                },
                                maxLength: 6,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ], //
                                controller: priceController,
                                style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                                decoration: InputDecoration(
                                  labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                                ),
                              ),
                              SizedBox(height: 20,),


                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:15.0),
                        child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Offer(%)",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
                                ],
                              ),
                              TextFormField(
                                validator: (value) {
                                  Pattern pattern =r'^[0-9][0-9]?$|^99$';
                                  RegExp regex = new RegExp(pattern);
                                  if (value.length==0) {
                                    return null;
                                  }

                                 else if (!regex.hasMatch(value))
                                    return 'Please enter offer between 0 to 99';
                                  else
                                    return null;
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ], //
                                controller: discountController,
                                style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                                decoration: InputDecoration(
                                  labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                                ),
                              ),
                              SizedBox(height: 20,),


                            ]),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:15.0),
                        child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Color Available ",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
                                  Spacer(),
                                  Switch(
                                    value: isColor,
                                    onChanged: (value) {
                                      isColor =! isColor;
                                      if(isColor){
                                       setState(() {
                                         check=true;
                                         //addCheck=false;

                                       });

                                      }
                                      else
                                        setState(() {
                                          check=false;
                                        });
                                      setState(() {

                                      });
                                    },
                                    activeTrackColor: Colors.red,
                                    activeColor: Colors.white,
                                  ),

                                ],
                              ),

                            ]),
                      ),
                      check?colorStock():SizedBox.shrink(),
                      SizedBox(height:10),
                      isColor==false?
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:15.0),
                        child: Column(
                            children: [
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
                                maxLength: 5,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ], //
                                controller: quantityController,
                                style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                                decoration: InputDecoration(
                                  labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                                ),
                              ),
                              SizedBox(height: 20,),


                            ]),
                      )
                      :SizedBox.shrink(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:15.0),
                        child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Specification",style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFFAFAFAF),fontSize:12,fontWeight: FontWeight.w400))),
                                ],
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter specification';
                                  }
                                  else if(value.length>100)
                                    return 'Only 100 characters are allowed';
                                  else
                                    return null;

                                },
                                //maxLength: 35,
                                  textInputAction: TextInputAction.newline,
                                keyboardType: TextInputType.multiline,
                                controller: specificationController,
                                style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:14,fontWeight: FontWeight.w400)),
                                decoration: InputDecoration(
                                  labelStyle: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF1C1C1C),fontSize:12,fontWeight: FontWeight.w700)),
                                ),
                              ),
                              SizedBox(height: 20,),


                            ]),
                      ),files.isEmpty?SizedBox.shrink():imageView(),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:4.0,vertical:10),
                        child: Container(
                          decoration:BoxDecoration( boxShadow: [
                            BoxShadow(
                              color: Colors.grey[100].withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 4,
                              offset: Offset(2, 5), // changes position of shadow
                            ),
                          ], ),
                          child:FlatButton(
                            height: 50,
                            minWidth:MediaQuery.of(context).size.width,
                            color:Color(0xFFFFFFFF),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(color: Color(0xFFE8E8E8))
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add,size:25,color:Color(0xFFC6C6C6)),
                                Text('  Add Product Image',style: GoogleFonts.poppins(textStyle:TextStyle(color:Color(0xFF000000),fontSize:11,fontWeight: FontWeight.w600),)),
                              ],
                            ),
                            onPressed: () async {
                              if(files.length==4)
                                Fluttertoast.showToast(
                                  msg:"Only 4 images can be added at a time",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                );
                              else
                              await filePicker();

                            },
                          ),),
                      ),
                      //SizedBox(height: 150,),
                      progress1?Center( child: CircularProgressIndicator(),):
                      Container(
                          height: 50,
                          width:MediaQuery.of(context).size.width,
                          padding:EdgeInsets.symmetric(horizontal: 5),
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
                                if(files.isEmpty)
                                  Fluttertoast.showToast(
                                    msg:"Please add product image",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                  );
                               else if(_mySelection==null)
                                  Fluttertoast.showToast(
                                    msg:"Please select subcategory",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                  );
                                else if(isColor==true&&colorstock.isEmpty)
                                  Fluttertoast.showToast(
                                    msg:"Please select color and stock",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                  );
                                else
                                 senddata();

                              }

                            },
                          )),
                    ],
                  ) )),
        ));
  }
  addSinglePhoto(var pid) async {
    var request = http.MultipartRequest('POST', Uri.parse(Prefmanager.baseurl + '/product/edit/'+pid));
    String token = await Prefmanager.getToken();
    request.headers.addAll({'Content-Type': 'application/form-data', 'token': token});
    if (files != null) {
      files.forEach((File f) {
        request.files.add(http.MultipartFile.fromBytes(
            'photos', f.readAsBytesSync(),
            filename: f.path
                .split('/')
                .last));
      });
    }
    try {
      http.Response response =
      await http.Response.fromStream(await request.send());
      print(json.decode(response.body));
      if(json.decode(response.body)['status'])
      {
        print(json.decode(response.body));
      }
    } catch (e) {
      print(e);
    }
  }
var pid;
  //List colorDetails=[];
bool progress1=false;
  void senddata() async {
    setState(() {
      progress1=true;
    });
    //getHex();
    // colorDetails = [
    //   <String, dynamic> {"color": , "stock": },
    //
    // ];
    try{
      String token = await Prefmanager.getToken();
      var url = Prefmanager.baseurl+'/product/add';
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': token,
      };

      Map data={
        'subcategoryId':_mySelection,
        'name':nameController.text,
        'description':descriptionController.text,
        'price': priceController.text,
        'stockQuantity':quantityController.text,
        'discount':discountController.text,
        'specification':specificationController.text,
        'isColor':isColor,
        'colorDetails':colorstock
      };

      print(data);
     var body=json.encode(data);
      var response = await http.post(url,body: body,headers: requestHeaders);
      //print(response);
      //print("yyu"+response.statusCode.toString());
      pid=json.decode(response.body)['pId'];
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if(json.decode(response.body)['status'])
        {
              await addSinglePhoto(pid);
          await Navigator.pushReplacement(
              context, new MaterialPageRoute(
              builder: (context) => new SellerProductlist()));
        }
        // else if(json.decode(response.body)['status']&&json.decode(response.body)['profileStatus']=='incomplete'&&json.decode(response.body)['role']=='seller')
        // {
        //   await Prefmanager.setToken(json.decode(response.body)['token']);
        //   // Navigator.push(
        //   //     context, new MaterialPageRoute(
        //   //     builder: (context) => new WorkingHour()));
        // }

        else{
          Fluttertoast.showToast(
            msg:json.decode(response.body)['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,

          );
          setState(() {
            progress1=false;
          });


        }
      }
      else {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
    on SocketException catch(e){
      Fluttertoast.showToast(
        msg: "No internet",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      print(e.toString());
    }
    catch(e){
      print(e.toString());
    }
    setState(() {
      progress1=false;
    });

  }
  Widget imageView(){
    print("imageview");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: files.isNotEmpty
          ? Column(
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          GridView.builder(
            shrinkWrap: true,
            physics:
            BouncingScrollPhysics(),
            itemCount:files.length,
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing:0.5,
                mainAxisSpacing: 0.5,
                crossAxisCount: 3),
            itemBuilder:
                (context, index) {
              return Row(
                children: [
                  Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(
                          files[index],
                          //  val1[index],
                          fit: BoxFit.cover,height:80,width:MediaQuery.of(context).size.width/5
                        ),
                      ),
                      Positioned(
                          right: 0,
                          top: 0,
                          child:
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 18,
                            child: CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 15,
                                child: IconButton(
                                  onPressed: () {
                                    files
                                        .removeAt(
                                        index);
                                    // val1.removeAt(index);
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                )
                            ),
                          )
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      )
          : Container(),
    );
  }
}



