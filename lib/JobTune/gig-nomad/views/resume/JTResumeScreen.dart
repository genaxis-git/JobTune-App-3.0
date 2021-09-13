import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/manage-job/JTManageJobScreen.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTProductDetailWidget.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileWidgetUser.dart';
import 'package:prokit_flutter/theme14/utils/T14Colors.dart';
import 'package:prokit_flutter/theme14/utils/T14Strings.dart';
import 'package:prokit_flutter/theme14/utils/T14Widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../main.dart';

class JTResumeScreen extends StatefulWidget {
  const JTResumeScreen({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  _JTResumeScreenState createState() => _JTResumeScreenState();
}

class _JTResumeScreenState extends State<JTResumeScreen> {

  // function starts //

  List profile = [];
  String email = " ";
  String fullname = " ";
  String desc = " ";
  String nric = " ";
  String dob = " ";
  String race = " ";
  String gender = " ";
  String telno = " ";
  String address = " ";
  String ecname = " ";
  String ecno = " ";
  String category = "";
  String banktype = "";
  String bankno = "";
  String img = "no profile.png";
  Future<void> readProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            dev + "jtnew_user_selectprofile&lgid=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      profile = json.decode(response.body);
    });

    setState(() {
      email = lgid;
      fullname = profile[0]["first_name"] + " " + profile[0]["last_name"] ;
      desc = profile[0]["description"] ;
      nric = profile[0]["nric"] ;
      dob = profile[0]["dob"] ;
      race = profile[0]["race"] ;
      gender = profile[0]["gender"] ;
      telno = profile[0]["phone_no"] ;
      address = profile[0]["address"] ;
      ecname = profile[0]["ec_name"] ;
      ecno = profile[0]["ec_phone_no"] ;
      category = profile[0]["category"] ;
      banktype = profile[0]["bank_type"] ;
      bankno = profile[0]["bank_account_no"] ;

      if(profile[0]["profile_pic"] != "") {
        img = profile[0]["profile_pic"];
      }
      else {
        img = "no profile.png";
      }
    });
  }

  // function ends //
  @override
  void initState() {
    super.initState();
    this.readProfile();
    init();
  }

  init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: jtprofile_appBarTitleWidget(context, 'Candidate Profile'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JTManageJobScreen()),
              );
            }
        ),
      ),
      body: JTContainerX(
        mobile: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 150),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.height,
                  Container(
                    width: context.width(),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Color(0xff8cb5f6), Colors.white],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 45,
                              width: 45,
                              decoration: boxDecorationWithShadow(
                                decorationImage: DecorationImage(image: Image.network(imagedev+img).image, fit: BoxFit.cover),
                                boxShape: BoxShape.circle,
                              ),
                            ),
                            16.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(fullname, style: boldTextStyle(color: t14_colorBlue)),
                                Text(category, style: secondaryTextStyle()),
                              ],
                            ),
                          ],
                        ),
                        16.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text('122', style: boldTextStyle(size: 14, color: t14_colorBlue)),
                                4.height,
                                Text('Gig', style: secondaryTextStyle(size: 12)),
                              ],
                            ),
                            Column(
                              children: [
                                Text('20', style: boldTextStyle(size: 14, color: t14_colorBlue)),
                                4.height,
                                Text('Contract', style: secondaryTextStyle(size: 12)),
                              ],
                            ),
                            Column(
                              children: [
                                Text('10', style: boldTextStyle(size: 14, color: t14_colorBlue)),
                                4.height,
                                Text('Permanent', style: secondaryTextStyle(size: 12)),
                              ],
                            ),
                            Column(
                              children: [
                                Text('4.6', style: boldTextStyle(size: 14, color: t14_colorBlue)),
                                4.height,
                                Text('Rating', style: secondaryTextStyle(size: 12)),
                              ],
                            )
                          ],
                        ),
                      ],
                    ).paddingAll(24),
                  ),
                  Text('About', style: boldTextStyle(color: t14_colorBlue)).paddingOnly(top: 16, bottom: 8),
                  Text(desc, style: secondaryTextStyle()).paddingOnly(bottom: 16),
                  20.height,
                  Text('Personal', style: boldTextStyle(color: t14_colorBlue)).paddingOnly(bottom: 8),
                  Padding(
                    padding: EdgeInsets.only(left: 20, top:5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name: " + fullname, style: secondaryTextStyle()).paddingOnly(bottom: 7),
                        Text("Gender: " + gender, style: secondaryTextStyle()).paddingOnly(bottom: 7),
                        Text("Race: " + race, style: secondaryTextStyle()).paddingOnly(bottom: 7),
                        Text("Dob: " + dob, style: secondaryTextStyle()).paddingOnly(bottom: 7),
                      ],
                    ),
                  ),
                  20.height,
                  Text('Working Experience', style: boldTextStyle(color: t14_colorBlue)).paddingOnly(bottom: 8),
                  Padding(
                    padding: EdgeInsets.only(left: 20, top:5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Data Entry Part Time', style: secondaryTextStyle()).paddingOnly(bottom: 7),
                        Text('Part Time Cashier', style: secondaryTextStyle()).paddingOnly(bottom: 7),
                        Text('Web UI/UX', style: secondaryTextStyle()).paddingOnly(bottom: 7),
                        Text('Tukang Jahit Mak Jah', style: secondaryTextStyle()).paddingOnly(bottom: 7),
                      ],
                    ),
                  ),
                  20.height,
                  Text('Contact Detail', style: boldTextStyle(color: t14_colorBlue)).paddingOnly(bottom: 8),
                  Padding(
                    padding: EdgeInsets.only(left: 20, top:5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Phone No: " + telno, style: secondaryTextStyle()).paddingOnly(bottom: 7),
                        Text("Email: " + email, style: secondaryTextStyle()).paddingOnly(bottom: 7),
                      ],
                    ),
                  ),

                  // Text('Interests', style: boldTextStyle(color: t14_colorBlue)).paddingOnly(bottom: 8),
                  // Wrap(
                  //   spacing: 16.0,
                  //   runSpacing: 8.0,
                  //   children: [
                  //     t14InterestsWrap(txtInterestsName: 'photography'),
                  //     t14InterestsWrap(txtInterestsName: 'publishing'),
                  //     t14InterestsWrap(txtInterestsName: 'design'),
                  //     t14InterestsWrap(txtInterestsName: 'crafts'),
                  //     t14InterestsWrap(txtInterestsName: 'architecture'),
                  //     t14InterestsWrap(txtInterestsName: 'museums'),
                  //   ],
                  // ),
                ],
              ).paddingOnly(left: 16, right: 16, bottom: 16),
            ),
            Positioned(
                bottom: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      alignment: Alignment.center,
                      width: context.width(),
                      decoration: BoxDecoration(color: Color(0xFF0A79DF), boxShadow: defaultBoxShadow()),
                      child: Text('Shortlist Candidate', style: boldTextStyle(color: white)),
                    ).onTap(() {

                    })
                  ],
                )
            ),
          ],
        ),
        useFullWidth: true,
      )
    );
  }
}