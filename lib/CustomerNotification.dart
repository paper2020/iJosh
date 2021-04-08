import 'dart:convert';
import 'package:eram_app/TrackPackage.dart';
import 'package:http/http.dart' as http;
import 'package:eram_app/BottomNavigator.dart';
import 'package:eram_app/Prefmanager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class CustomerNotification extends StatefulWidget {
  @override
  _CustomerNotification createState() => _CustomerNotification();
}

class _CustomerNotification extends State<CustomerNotification> {
  bool isLoading = false;
  bool loadMore = false;
  int limit = 10, page = 1;
  var totalCount;
  Future<bool> _onWillPop() async {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new MyNavigationBar()));
    return false;
  }

  void initState() {
    notificationList();
    super.initState();
  }

  bool loading = false;
  List completeList = [];
  var length;
  Future<void> notificationList() async {
    setState(() {
      isLoading = true;
    });
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    Map data = {'page': page.toString(), 'limit': limit.toString()};
    print(data);
    var body = json.encode(data);
    var url = Prefmanager.baseurl + '/notifications/all/list';
    var response = await http.post(url, headers: requestHeaders, body: body);
    if (json.decode(response.body)['status']) {
      setState(() {
        isLoading = false;
      });
      length = json.decode(response.body)['totalLength'];
      for (int i = 0; i < json.decode(response.body)['data'].length; i++)
        completeList.add(json.decode(response.body)['data'][i]);
      page++;
      print(completeList.length);
      print(response.body);
      //totalCount = json.decode(response.body)['count'];
    } else {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: '${json.decode(response.body)['msg']}',
          textColor: Colors.white,
          backgroundColor: Colors.black);
    }
    loading = false;
  }

  Future<void> markRead(var id) async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    var url = Prefmanager.baseurl + '/notification/markasread/' + id;
    var response = await http.post(url, headers: requestHeaders);
    if (json.decode(response.body)['status']) {
      notificationList();
    } else {}
  }

  Future<void> removeNotification(var id) async {
    String token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': token
    };
    var url = Prefmanager.baseurl + '/notification/remove/' + id;
    var response = await http.post(url, headers: requestHeaders);
    if (json.decode(response.body)['status']) {
      page = 1;
      completeList.clear();
      await notificationList();
      Fluttertoast.showToast(
          msg: '${json.decode(response.body)['msg']}',
          textColor: Colors.white,
          backgroundColor: Colors.black);
    } else {
      Fluttertoast.showToast(
          msg: '${json.decode(response.body)['msg']}',
          textColor: Colors.white,
          backgroundColor: Colors.black);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Notifications',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                )),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new MyNavigationBar())),
            ),
          ),
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : completeList.length == 0
                  ? Center(child: Text("No notifications found"))
                  : Column(
                      children: [
                        Expanded(
                            child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (!loading &&
                                scrollInfo.metrics.pixels ==
                                    scrollInfo.metrics.maxScrollExtent) {
                              if (length > completeList.length) {
                                notificationList();
                                setState(() {
                                  loading = true;
                                });
                              } else {}
                            } else {}
                            //  setState(() =>loading = false);
                            return true;
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: completeList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return
                                            // completeList[index]['user']==null&&
                                            //     completeList[index]['message']==null?SizedBox.shrink():
                                            Dismissible(
                                          key: Key(completeList[index]['_id']),
                                          confirmDismiss: (direction) {
                                            return showDialog<bool>(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                    content: Text(
                                                        'Are you sure, You want to remove this Notification  ?'),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        child: Text('Cancel'),
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false),
                                                      ),
                                                      FlatButton(
                                                        child: Text('Ok'),
                                                        onPressed: () async {
                                                          // widget.controller.update();
                                                          Navigator.of(context)
                                                              .pop();
                                                          setState(() {
                                                            isLoading = true;
                                                          });
                                                          removeNotification(
                                                              completeList[
                                                                      index]
                                                                  ['_id']);
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                        },
                                                      )
                                                    ]);
                                              },
                                            );
                                          },
                                          background: Container(
                                            alignment:
                                                AlignmentDirectional.centerEnd,
                                            color: Color(0xffCD0402),
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0.0, 0.0, 20.0, 10.0),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          child: InkWell(
                                              child: Column(
                                                children: <Widget>[
                                                  Divider(
                                                    height: 0,
                                                  ),
                                                  Container(
                                                      decoration: BoxDecoration(
                                                        color: completeList[
                                                                        index][
                                                                    'status'] ==
                                                                'unread'
                                                            ? Colors.white
                                                            : Colors.grey[100],
                                                        // borderRadius: BorderRadius.circular(5)
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 20.0,
                                                                horizontal:
                                                                    10.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                              child: Text(completeList[index]['title'], style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)))),
                                                                          SizedBox(
                                                                              width: 20),
                                                                          Expanded(
                                                                              flex: 0,
                                                                              child: Text(
                                                                                  timeago.format(
                                                                                    DateTime.now().subtract(new Duration(minutes: DateTime.now().difference(DateTime.parse(completeList[index]['create_date'])).inMinutes)),
                                                                                  ),
                                                                                  style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xFF828282), fontSize: 10, fontWeight: FontWeight.w400))))
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            15,
                                                                      ),
                                                                      Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                                flex: 1,
                                                                                child: Text(completeList[index]['body'] ?? " ",
                                                                                    style: GoogleFonts.poppins(
                                                                                      textStyle: TextStyle(fontSize: 12, color: Colors.black54),
                                                                                    ))),
                                                                          ]),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 8.0,
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                  // Divider(),
                                                ],
                                              ),
                                              onTap: () async {
                                                markRead(
                                                    completeList[index]['_id']);

                                                if (completeList[index]
                                                        ['routetype'] ==
                                                    'orderProductStatusChange')
                                                  await Navigator.push(
                                                      context,
                                                      new MaterialPageRoute(
                                                          builder: (context) =>
                                                              new TrackPackage(
                                                                  completeList[
                                                                          index]
                                                                      [
                                                                      'routeId2'],
                                                                  completeList[
                                                                          index]
                                                                      [
                                                                      'routeId1'])));
                                                page = 1;
                                                completeList.clear();
                                                await notificationList();
                                                // return showDialog<bool>(
                                                //   context: context,
                                                //   builder: (context) {
                                                //     return AlertDialog(
                                                //         content: Text(
                                                //             'Are you sure, You want to mark this notification as Read  ?'),
                                                //         actions: <Widget>[
                                                //           FlatButton(
                                                //             child: Text('Cancel'),
                                                //             onPressed: () => Navigator.of(context).pop(false),
                                                //           ),
                                                //           FlatButton(
                                                //             child: Text('Ok'),
                                                //             onPressed: () async {
                                                //               // widget.controller.update();
                                                //               Navigator.of(context).pop();
                                                //               setState(() {
                                                //                 isLoading = true;
                                                //               });
                                                //
                                                //               notificationList();
                                                //               setState(() {
                                                //                 isLoading = false;
                                                //               });
                                                //             },
                                                //           )
                                                //         ]);
                                                //   },
                                                // );
                                              }),
                                        );
                                      }),
                                )
                              ],
                            ),
                          ),
                        )),
                      ],
                    )),
    );
  }

  var todayDate = DateTime.now();
}
