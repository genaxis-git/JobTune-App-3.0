import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDashboardScreenProduct.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDrawerWidgetProduct.dart';
import 'package:prokit_flutter/JobTune/gig-provider/views/profile/JTProfileScreenProvider.dart';
import 'package:prokit_flutter/JobTune/gig-service/models/JTflutter_rating_bar.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/clocking/JTClockingScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:prokit_flutter/defaultTheme/model/DTReviewModel.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTAboutScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTPaymentScreen.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppConstant.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';
import 'JTVerifyScreenUser.dart';


class JTVerifyRecordScreen extends StatefulWidget {
  const JTVerifyRecordScreen({
    Key? key,
    required this.timein,
    required this.timeout,
    required this.imgin,
    required this.imgout,
    required this.bookid,
    required this.ins,
    required this.outs,
    required this.serviceid,
    required this.provider,
    required this.actualstart,
    required this.actualend,
  }) : super(key: key);
  final String timein;
  final String timeout;
  final String imgin;
  final String imgout;
  final String bookid;
  final String ins;
  final String outs;
  final String serviceid;
  final String provider;
  final String actualstart;
  final String actualend;
  @override
  _JTVerifyRecordScreenState createState() => _JTVerifyRecordScreenState();
}

class _JTVerifyRecordScreenState extends State<JTVerifyRecordScreen> {
  // function starts //

  final String uploadUrlin = clockingIn;
  final String uploadUrlout = clockingOut;
  final ImagePicker _pickerin = ImagePicker();
  final ImagePicker _pickerout = ImagePicker();
  File? _imagein;
  File? _imageout;

  @override
  void didChangeDependencies() {
    precacheImage(Image.network('https://jobtune.ai/gig/JobTune/assets/evidence/in/'+ widget.imgin, scale:10).image, context);
    precacheImage(Image.network('https://jobtune.ai/gig/JobTune/assets/evidence/out/'+ widget.imgout).image, context);
    super.didChangeDependencies();
  }


  Future<void> getImage() async{
    final pickerImage = await _pickerin.getImage(source: ImageSource.camera);
    setState(() {
      _imagein = File(pickerImage!.path);
    });
  }

  Future<void> pickImage() async{
    final pickerImageout = await _pickerout.getImage(source: ImageSource.camera);
    setState(() {
      _imageout = File(pickerImageout!.path);
    });
  }

  Future<String?> uploadImage(filepath, url) async {
    print(widget.bookid);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss d MMM y').format(now);
    final snackBar = SnackBar(content: Text('Clock-in record sent at ' + formattedDate + ' !'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['lgid'] = widget.bookid;
    request.files.add(await http.MultipartFile.fromPath('image', filepath));
    var res = await request.send();
    return res.reasonPhrase;
  }

  Future<String?> uploadImageout(filepath, url) async {
    print(widget.bookid);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss d MMM y').format(now);
    final snackBar = SnackBar(content: Text('Clock-out record sent at ' + formattedDate + ' !'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['lgid'] = widget.bookid;
    request.files.add(await http.MultipartFile.fromPath('image', filepath));
    var res = await request.send();
    return res.reasonPhrase;
  }

  Future<void> sendVerifyin(status) async {
    if(status == "Absent") {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd kk:mm:ss.000').format(now);

      final differenceDays = DateTime.parse(formattedDate).difference(DateTime.parse(widget.actualstart)).inDays;
      final differenceTimes = DateTime.parse(formattedDate).difference(DateTime.parse(widget.actualstart)).inMinutes;
      print(differenceTimes);
      if(differenceDays < 0){
        toast("Please wait and proceed action on " + DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.actualstart)));
      }
      else{
        if(differenceTimes < 0) {
          toast("Please wait and proceed action on " + DateFormat('kk:mm:ss').format(DateTime.parse(widget.actualstart)));
        }
        else if(differenceTimes == 0){
          toast("Please wait for next 1 hour to confirm Absent");
        }
        else if(differenceTimes >= 1) {
          http.get(
              Uri.parse(
                  server + "jtnew_user_updatestatusin&id=" + widget.bookid
                      + "&status=" + status
              ),
              headers: {"Accept": "application/json"}
          );

          http.get(
              Uri.parse(
                  server + "jtnew_user_updatestatusout&id=" + widget.bookid
                      + "&status=" + status
              ),
              headers: {"Accept": "application/json"}
          );

          toast("Your respond for both clocking has been sent.");

          setState(() {
            displaybtnin = status;
            displaybtnout = status;
          });

          showInDialog(context,
              child: WriteReviewDialog(
                bid: widget.bookid,
                sid: widget.serviceid,
                provider: widget.provider,
              ),
              backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));
        }
      }
    }
    else {
      http.get(
          Uri.parse(
              server + "jtnew_user_updatestatusin&id=" + widget.bookid
                  + "&status=" + status
          ),
          headers: {"Accept": "application/json"}
      );

      toast("Your respond has been sent.");

      setState(() {
        displaybtnin = status;
      });
    }
  }

  Future<void> sendVerifyout(status) async {
    if(status == "Absent") {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd kk:mm:ss.000').format(now);

      final differenceDays = DateTime.parse(formattedDate).difference(DateTime.parse(widget.actualstart)).inDays;
      final differenceTimes = DateTime.parse(formattedDate).difference(DateTime.parse(widget.actualstart)).inMinutes;
      print(differenceTimes);
      if(differenceDays < 0){
        toast("Please wait and proceed action on " + DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.actualstart)));
      }
      else{
        if(differenceTimes < 0) {
          toast("Please wait and proceed action on " + DateFormat('kk:mm:ss').format(DateTime.parse(widget.actualstart)));
        }
        else if(differenceTimes == 0){
          toast("Please wait for next 1 hour to confirm Absent");
        }
        else if(differenceTimes >= 1) {
          http.get(
              Uri.parse(
                  server + "jtnew_user_updatestatusin&id=" + widget.bookid
                      + "&status=" + status
              ),
              headers: {"Accept": "application/json"}
          );

          http.get(
              Uri.parse(
                  server + "jtnew_user_updatestatusout&id=" + widget.bookid
                      + "&status=" + status
              ),
              headers: {"Accept": "application/json"}
          );

          toast("Your respond for both clocking has been sent.");

          setState(() {
            displaybtnin = status;
            displaybtnout = status;
          });

          showInDialog(context,
              child: WriteReviewDialog(
                bid: widget.bookid,
                sid: widget.serviceid,
                provider: widget.provider,
              ),
              backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));
        }
      }
    }
    else {
      http.get(
          Uri.parse(
              server + "jtnew_user_updatestatusout&id=" + widget.bookid
                  + "&status=" + status
          ),
          headers: {"Accept": "application/json"}
      );

      http.get(
          Uri.parse(
              server + "jtnew_user_updatebooking&id=" + widget.bookid
          ),
          headers: {"Accept": "application/json"}
      );

      setState(() {
        displaybtnout = status;
      });

      toast("Your respond has been sent.");

      showInDialog(context,
          child: WriteReviewDialog(
            bid: widget.bookid,
            sid: widget.serviceid,
            provider: widget.provider,
          ),
          backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));
    }
  }

  String displaytime = "";
  String displaytimeout = "";
  String displaypicin = "";
  String displaypicout = "";
  String displaybtnin = "";
  String displaybtnout = "";
  Future<void> checkStatus() async {
    setState(() {
      displaytime = widget.timein;
      displaytimeout = widget.timeout;
      displaypicin = widget.imgin;
      displaypicout = widget.imgout;
      displaybtnin = widget.ins;
      displaybtnout = widget.outs;
    });
  }

  String _timeString = '0000-00-00 00:00:00';
  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy hh:mm:ss').format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    this.checkStatus();
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _getTime();
    });
  }
  // function ends //

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: appStore.appBarColor,
            title: appBarTitleWidget(context, 'Verify Clocking'),
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => JTVerifyScreenUser()),
                  );
                }
            ),
            bottom: TabBar(
              onTap: (index) {
                print(index);
              },
              indicatorColor: Colors.blue,
              labelColor: appStore.textPrimaryColor,
              labelStyle: boldTextStyle(),
              tabs: [
                Tab(
                  text: "Clock-in",
                ),
                Tab(
                  text: "Clock-out",
                ),
              ],
            ),
          ),
          drawer: JTDrawerWidgetProduct(),
          body: TabBarView(
            children: [
              ContainerX(
                mobile: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsets.only(top: 16),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (displaytime == "0000-00-00 00:00:00")
                                ? Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 18,
                                    ),
                                    Text(
                                      "  Current time: ",
                                      textAlign: TextAlign.start,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      _timeString,
                                      textAlign: TextAlign.start,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.blueAccent
                                      ),
                                    ),
                                  ],
                                )
                                : Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 18,
                                    ),
                                    Text(
                                      "  Clock-in time: ",
                                      textAlign: TextAlign.start,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      displaytime,
                                      textAlign: TextAlign.start,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.blueAccent
                                      ),
                                    ),
                                  ],
                                ),
                                35.height,
                                (displaytime != "0000-00-00 00:00:00")
                                ? Text(
                                  "Evidence for their attendence:-",
                                  textAlign: TextAlign.start,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                                : Container(),
                              ],
                            ),
                          ),
                          (displaytime == "0000-00-00 00:00:00")
                          ? (_imagein != null)
                            ? Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Image.file(_imagein!),
                          )
                            : (displaybtnin == "Absent")
                              ? Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Container(
                              height: 200,
                              color: Colors.white,
                              child: Center(
                                child: Text(
                                  "Absent has been confirmed",
                                  style: TextStyle(
                                      color: Colors.black54
                                  ),
                                ),
                              ),
                            ),
                          )
                              : Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Container(
                              height: 200,
                              color: Colors.white,
                              child: Center(
                                child: Text(
                                  "Not clock-in yet.",
                                  style: TextStyle(
                                      color: Colors.black26
                                  ),
                                ),
                              ),
                            ),
                          )
                          : (_imagein != null)
                            ? Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Image.file(_imagein!),
                          )
                            : Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Image.network('https://jobtune.ai/gig/JobTune/assets/evidence/in/'+ widget.imgin),
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ),
                    (displaytime != "0000-00-00 00:00:00")
                    ? (displaybtnin == "")
                      ? Positioned(
                        bottom: 0,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              height: 50,
                              width: context.width() / 2,
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: Color(0xFF0A79DF), boxShadow: defaultBoxShadow()),
                              child: Text('Verify', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            ).onTap(() {
                              var status = "Verified";
                              sendVerifyin(status);
                            }),
                            Container(
                              height: 50,
                              width: context.width() / 2,
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: appStore.scaffoldBackground, boxShadow: defaultBoxShadow(spreadRadius: 3.0)),
                              child: Text('Not verify', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                            ).onTap(() {
                              var status = "Not Verified";
                              sendVerifyin(status);
                            }),
                          ],
                        ),
                      )
                      : Container()
                    : (displaybtnin == "Absent")
                      ? Container()
                      : Positioned(
                      bottom: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            height: 50,
                            width: context.width(),
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: appStore.scaffoldBackground, boxShadow: defaultBoxShadow(spreadRadius: 3.0)),
                            child: Text('Absent', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                          ).onTap(() {
                            var status = "Absent";
                            sendVerifyin(status);
                          }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              ContainerX(
                mobile: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsets.only(top: 16),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (displaytimeout == "0000-00-00 00:00:00")
                                    ? Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 18,
                                    ),
                                    Text(
                                      "  Current time: ",
                                      textAlign: TextAlign.start,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      _timeString,
                                      textAlign: TextAlign.start,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.blueAccent
                                      ),
                                    ),
                                  ],
                                )
                                    : Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 18,
                                    ),
                                    Text(
                                      "  Clock-out time: ",
                                      textAlign: TextAlign.start,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      displaytimeout,
                                      textAlign: TextAlign.start,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.blueAccent
                                      ),
                                    ),
                                  ],
                                ),
                                35.height,
                                (displaytimeout != "0000-00-00 00:00:00")
                                    ? Text(
                                  "Evidence for their job completion:-",
                                  textAlign: TextAlign.start,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                                    : Container(),
                              ],
                            ),
                          ),
                          (displaytimeout == "0000-00-00 00:00:00")
                              ? (_imageout != null)
                              ? Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Image.file(_imageout!),
                          )
                              : (displaybtnout == "Absent")
                                ? Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Container(
                              height: 200,
                              color: Colors.white,
                              child: Center(
                                child: Text(
                                  "Absent has been confirmed",
                                  style: TextStyle(
                                      color: Colors.black54
                                  ),
                                ),
                              ),
                            ),
                          )
                                : Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Container(
                              height: 200,
                              color: Colors.white,
                              child: Center(
                                child: Text(
                                  "Not clock-out yet.",
                                  style: TextStyle(
                                      color: Colors.black26
                                  ),
                                ),
                              ),
                            ),
                          )
                              : (_imageout != null)
                              ? Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Image.file(_imageout!),
                          )
                              : Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Image.network('https://jobtune.ai/gig/JobTune/assets/evidence/out/'+ widget.imgout),
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ),
                    (displaytimeout != "0000-00-00 00:00:00") //ada clocking
                    ? (displaybtnout == "")
                      ? Positioned(
                        bottom: 0,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              height: 50,
                              width: context.width() / 2,
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: Color(0xFF0A79DF), boxShadow: defaultBoxShadow()),
                              child: Text('Verify', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            ).onTap(() {
                              var status = "Verified";
                              sendVerifyout(status);
                            }),
                            Container(
                              height: 50,
                              width: context.width() / 2,
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: appStore.scaffoldBackground, boxShadow: defaultBoxShadow(spreadRadius: 3.0)),
                              child: Text('Not verify', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                            ).onTap(() {
                              var status = "Not Verified";
                              sendVerifyout(status);
                            }),

                          ],
                        ),
                      )
                      : Container()
                    : (displaytime == "0000-00-00 00:00:00")
                        ? (displaybtnout == "Absent")
                          ? Container()
                          : Positioned(
                              bottom: 0,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    height: 50,
                                    width: context.width(),
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(color: appStore.scaffoldBackground, boxShadow: defaultBoxShadow(spreadRadius: 3.0)),
                                    child: Text('Absent', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                  ).onTap(() {
                                    var status = "Absent";
                                    sendVerifyout(status);
                                  }),
                                ],
                              ),
                            )
                        : Positioned(
                      bottom: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            height: 50,
                            width: context.width() / 2,
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Color(0xFF0A79DF), boxShadow: defaultBoxShadow()),
                            child: Text('Verify', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          ).onTap(() {
                            var status = "Verified";
                            sendVerifyout(status);
                          }),
                          Container(
                            height: 50,
                            width: context.width() / 2,
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: appStore.scaffoldBackground, boxShadow: defaultBoxShadow(spreadRadius: 3.0)),
                            child: Text('Not verify', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                          ).onTap(() {
                            var status = "Not Verified";
                            sendVerifyout(status);
                          }),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WriteReviewDialog extends StatefulWidget {
  const WriteReviewDialog({
    Key? key,
    required this.bid,
    required this.sid,
    required this.provider,
  }) : super(key: key);
  final String bid;
  final String sid;
  final String provider;
  @override
  _WriteReviewDialogState createState() => _WriteReviewDialogState();
}

class _WriteReviewDialogState extends State<WriteReviewDialog> {
  var reviewCont = TextEditingController();
  var reviewFocus = FocusNode();
  double ratting = 0.0;

  // function starts //

  Future<void> sendRating(rate,comm) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.get(
        Uri.parse(
            server + "jtnew_user_insertrating&bid=" + widget.bid
                + "&sid=" + widget.sid
                + "&to=" + widget.provider
                + "&rating=" + rate
                + "&comment=" + comm
                + "&from=" + lgid
        ),
        headers: {"Accept": "application/json"}
    );
    
    finish(context);
    toast("Your rating have been submitted. Thank you!");
  }

  // function ends //

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: dynamicBoxConstraints(),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appStore.scaffoldBackground,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Write a Review', style: boldTextStyle(size: 18)),
                  IconButton(
                    icon: Icon(Icons.close, color: appStore.iconColor),
                    onPressed: () {
                      finish(context);
                    },
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  finish(context);
                },
                child: Container(padding: EdgeInsets.all(4), alignment: Alignment.centerRight),
              ),
              8.height,
              Center(
                child: RatingBar(
                  onRatingUpdate: (r) {
                    ratting = r;
                  },
                  itemSize: 35.0,
                  glow: false,
                  initialRating: 0.0,
                  allowHalfRating: false,
                  ratingWidget: RatingWidget(
                    full: Icon(Icons.star, color: Colors.amber),
                    half: Icon(Icons.star, color: Colors.amber),
                    empty: Icon(Icons.star_border, color: Colors.amber),
                  ),
                ),
              ),
              16.height,
              TextField(
                controller: reviewCont,
                focusNode: reviewFocus,
                style: primaryTextStyle(),
                decoration: InputDecoration(
                  labelText: 'Write here',
                  contentPadding: EdgeInsets.all(16),
                  labelStyle: secondaryTextStyle(),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appColorPrimary)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                ),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                //Normal textInputField will be displayed
                maxLines: 5,
                textInputAction: TextInputAction.newline, // when user presses enter it will adapt to it
              ),
              30.height,
              GestureDetector(
                onTap: () {
                  sendRating(ratting.toString(),reviewCont.text);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: appColorPrimary, borderRadius: BorderRadius.all(Radius.circular(5))),
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Center(
                    child: Text("Submit", style: boldTextStyle(color: white)),
                  ),
                ),
              ),
              16.height,
            ],
          ),
        ),
      ),
    );
  }
}