import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDashboardScreenProduct.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDrawerWidgetProduct.dart';
import 'package:prokit_flutter/JobTune/gig-provider/views/profile/JTProfileScreenProvider.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/clocking/JTClockingScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTAboutScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTPaymentScreen.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppConstant.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';

class JTClockingRecordUser extends StatefulWidget {
  const JTClockingRecordUser({
    Key? key,
    required this.timein,
    required this.timeout,
    required this.imgin,
    required this.imgout,
  }) : super(key: key);
  final String timein;
  final String timeout;
  final String imgin;
  final String imgout;
  @override
  _JTClockingRecordUserState createState() => _JTClockingRecordUserState();
}

class _JTClockingRecordUserState extends State<JTClockingRecordUser> {

  // function starts //

  final String uploadUrl = 'https://jobtune.ai/gig/JobTune/assets/evidence/in/mobile_uploadPhoto_evidencein.php';
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> getImage() async{
    final pickerImage = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickerImage!.path);
    });
  }

  uploadImage(filepath, url) async {
    print(widget.timein);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['lgid'] = widget.timein;
    request.files.add(await http.MultipartFile.fromPath('image', filepath));
    var res = await request.send();
    return res.reasonPhrase;
  }

  // function ends //

  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (_) => SafeArea(
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: appStore.appBarColor,
                title: appBarTitleWidget(context, 'Clocking'),
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
                              children: [
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
                          SizedBox(height: 7,),
                          (widget.timein == "0000-00-00 00:00:00")
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
                                  child: (_image == null)
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
                          (widget.timein == "0000-00-00 00:00:00")
                          ? (_image != null)
                          ? Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Image.file(_image!),
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
                          : Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Image.network('https://jobtune.ai/gig/JobTune/assets/evidence/in/'+ widget.imgin),
                            ),
                          SizedBox(height: 20,),
                          (widget.timein == "0000-00-00 00:00:00")
                          ? (_image != null)
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
                          // isi outs
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
