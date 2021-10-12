import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDrawerWidgetProduct.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';

import '../../../../main.dart';

class JTClockingRegular extends StatefulWidget {
  const JTClockingRegular({
    Key? key,
    required this.timein,
    required this.timeout,
    required this.imgin,
    required this.imgout,
    required this.day,
    required this.jobid,
  }) : super(key: key);
  final String timein;
  final String timeout;
  final String imgin;
  final String imgout;
  final String day;
  final String jobid;
  @override
  _JTClockingRegularState createState() => _JTClockingRegularState();
}

class _JTClockingRegularState extends State<JTClockingRegular> {

  // function starts //

  final String uploadUrlin = clockingIn;
  final String uploadUrlout = clockingOut;
  final ImagePicker _pickerin = ImagePicker();
  final ImagePicker _pickerout = ImagePicker();
  File? _imagein;
  File? _imageout;

  Future<void> getImage() async{
    final pickerImage = await _pickerin.getImage(source: ImageSource.camera, maxHeight: 1000, maxWidth: 1000);
    setState(() {
      _imagein = File(pickerImage!.path);
    });
  }

  Future<void> pickImage() async{
    final pickerImageout = await _pickerout.getImage(source: ImageSource.camera, maxHeight: 1000, maxWidth: 1000);
    setState(() {
      _imageout = File(pickerImageout!.path);
    });
  }

  Future<String?> uploadImage(filepath, url) async {
    print(widget.day);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss d MMM y').format(now);
    final snackBar = SnackBar(content: Text('Clock-in record sent at ' + formattedDate + ' !'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['lgid'] = widget.day;
    request.files.add(await http.MultipartFile.fromPath('image', filepath));
    var res = await request.send();
    return res.reasonPhrase;
  }

  Future<String?> uploadImageout(filepath, url) async {
    print(widget.day);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss d MMM y').format(now);
    final snackBar = SnackBar(content: Text('Clock-out record sent at ' + formattedDate + ' !'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['lgid'] = widget.day;
    request.files.add(await http.MultipartFile.fromPath('image', filepath));
    var res = await request.send();
    return res.reasonPhrase;
  }

  Future<void> sendClockin(timein,img) async {
    http.get(
        Uri.parse(
            server + "jtnew_provider_updateclockin&id=" + widget.day
                + "&ins=" + timein
                + "&img=" + img
        ),
        headers: {"Accept": "application/json"}
    );

    http.get(
        Uri.parse(
            server + "jtnew_provider_updatebooking&id=" + widget.day
        ),
        headers: {"Accept": "application/json"}
    );

    setState(() {
      displaytime = timein;
      displaypicin = img;
    });
  }

  Future<void> sendClockout(timein,img) async {
    http.get(
        Uri.parse(
            server + "jtnew_provider_updateclockout&id=" + widget.day
                + "&outs=" + timein
                + "&img=" + img
        ),
        headers: {"Accept": "application/json"}
    );

    setState(() {
      displaytimeout = timein;
      displaypicout = img;
    });
  }

  String displaytime = "";
  String displaytimeout = "";
  String displaypicin = "";
  String displaypicout = "";
  Future<void> checkStatus() async {
    setState(() {
      displaytime = widget.timein;
      displaytimeout = widget.timeout;
      displaypicin = widget.imgin;
      displaypicout = widget.imgout;
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
            title: appBarTitleWidget(context, 'Clocking'),
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
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
                mobile: SingleChildScrollView(
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
                            Text(
                              "We would like you to capture one (1) image as an evidence for your attendence.",
                              textAlign: TextAlign.start,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      (displaytime == "0000-00-00 00:00:00")
                          ? Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: ButtonTheme(
                          minWidth: 500,
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.blueAccent,
                            onPressed: () {
                              getImage();
                            },
                            child: (_imagein == null)
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('1. Capture Now',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,letterSpacing: 1),),
                                SizedBox(width:5),
                                Icon(Icons.camera,size: 15,)
                              ],
                            )
                                : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('1. Retake',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,letterSpacing: 1),),
                                SizedBox(width:5),
                                Icon(Icons.replay,size: 15,)
                              ],
                            ),
                          ),
                        ),
                      )
                          : Container(),
                      SizedBox(height: 10,),
                      (displaytime == "0000-00-00 00:00:00")
                          ? (_imagein != null)
                          ? Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Image.file(_imagein!),
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
                        child: Image.network('https://jobtune.ai/gig/JobTune/assets/evidence/in/'+ displaypicin),
                      ),
                      SizedBox(height: 20,),
                      (displaytime == "0000-00-00 00:00:00")
                          ? (_imagein != null)
                          ? Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: ButtonTheme(
                          minWidth: 500,
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.blueAccent,
                            onPressed: () async {
                              uploadImage(_imagein!.path, uploadUrlin);
                              var filename = Path.basename(_imagein!.path);
                              DateTime now = DateTime.now();
                              String formattedDate = DateFormat('y-MM-dd kk:mm:ss').format(now);
                              sendClockin(formattedDate.toString(),filename.toString());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('2. Register Clock-in',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,letterSpacing: 1),),
                                SizedBox(width:5),
                                Icon(Icons.send,size: 15,)
                              ],
                            ),
                          ),
                        ),
                      )
                          : Container()
                          : Container(),
                    ],
                  ),
                ),
              ),
              ContainerX(
                mobile: SingleChildScrollView(
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
                            Text(
                              "We would like you to capture one (1) image as an evidence for your job completion.",
                              textAlign: TextAlign.start,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      (displaytimeout == "0000-00-00 00:00:00")
                          ? Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: ButtonTheme(
                          minWidth: 500,
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.blueAccent,
                            onPressed: () {
                              pickImage();
                            },
                            child: (_imageout == null)
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('1. Capture Now',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,letterSpacing: 1),),
                                SizedBox(width:5),
                                Icon(Icons.camera,size: 15,)
                              ],
                            )
                                : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('1. Retake',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,letterSpacing: 1),),
                                SizedBox(width:5),
                                Icon(Icons.replay,size: 15,)
                              ],
                            ),
                          ),
                        ),
                      )
                          : Container(),
                      SizedBox(height: 10,),
                      (displaytimeout == "0000-00-00 00:00:00")
                          ? (_imageout != null)
                          ? Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Image.file(_imageout!),
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
                        child: Image.network('https://jobtune.ai/gig/JobTune/assets/evidence/out/'+ displaypicout),
                      ),
                      SizedBox(height: 20,),
                      (displaytimeout == "0000-00-00 00:00:00")
                          ? (_imageout != null)
                          ? Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: ButtonTheme(
                          minWidth: 500,
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.blueAccent,
                            onPressed: () async {
                              uploadImageout(_imageout!.path, uploadUrlout);
                              var filename = Path.basename(_imageout!.path);
                              DateTime now = DateTime.now();
                              String formattedDate = DateFormat('y-MM-dd kk:mm:ss').format(now);
                              sendClockout(formattedDate.toString(),filename.toString());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('2. Register Clock-out',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,letterSpacing: 1),),
                                SizedBox(width:5),
                                Icon(Icons.send,size: 15,)
                              ],
                            ),
                          ),
                        ),
                      )
                          : Container()
                          : Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
