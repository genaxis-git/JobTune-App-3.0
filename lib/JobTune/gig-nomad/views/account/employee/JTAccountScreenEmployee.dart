import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/change-password/JTChangePasswordScreen.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/clocking/JTClockingScreenEmployee.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/index/JTDashboardEmployee.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/index/JTDashboardScreenNomad.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/profile/employee/JTProfileScreenEmployee.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/timetable/JTScheduleScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/timetable/JTTimetableScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/transaction/JTTransactionScreen.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/verify-clocking/JTVerifyScreenUser.dart';
// import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileScreenUser.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTAboutScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTPaymentScreen.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppConstant.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../main.dart';

class JTAccountScreenEmployee extends StatefulWidget {
  static String tag = '/JTAccountScreenEmployee';

  @override
  _JTAccountScreenEmployeeState createState() => _JTAccountScreenEmployeeState();
}

class _JTAccountScreenEmployeeState extends State<JTAccountScreenEmployee> {
  // functions starts //

  List profile = [];
  String email = " ";
  String fullname = " ";
  String img = "no profile.png";
  Future<void> readProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectprofile&lgid=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      profile = json.decode(response.body);
    });

    setState(() {
      email = lgid;
      fullname = profile[0]["first_name"] + " " + profile[0]["last_name"];

      if(profile[0]["profile_pic"] != "") {
        img = profile[0]["profile_pic"];
      }
      else {
        img = "no profile.png";
      }
    });
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    // await prefs.clear();

    JTDashboardScreenGuest().launch(context, isNewTask: true);
  }

  @override
  void initState() {
    super.initState();
    this.readProfile();
  }

  // functions ends //

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget profileView() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.network("https://jobtune.ai/gig/JobTune/assets/img/" + img,
                  height: 70, width: 70, fit: BoxFit.cover)
                  .cornerRadiusWithClipRRect(40),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fullname, style: primaryTextStyle()),
                  2.height,
                  Text(email, style: primaryTextStyle()),
                ],
              )
            ],
          ),
          IconButton(
            icon: Icon(AntDesign.edit, color: appStore.iconSecondaryColor),
            onPressed: () {},
          ).visible(false)
        ],
      ).paddingAll(16);
    }

    Widget options() {
      return Column(
        children: [
          settingItem(context, 'My Profile', onTap: () {
            JTProfileScreenEmployee().launch(context);
          }, leading: Icon(MaterialIcons.person_outline), detail: SizedBox()),
          settingItem(context, 'Timetable', onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebViewTimetableUser(id: email)),
            );
          }, leading: Icon(MaterialIcons.calendar_today), detail: SizedBox()),
          settingItem(context, 'Clocking', onTap: () {
            JTClockingScreenEmployee().launch(context);
          }, leading: Icon(MaterialIcons.schedule), detail: SizedBox()),
          settingItem(context, 'My Jobs', onTap: () {
            JTVerifyScreenUser().launch(context);
          }, leading: Icon(MaterialIcons.work_outline), detail: SizedBox()),
          settingItem(context, 'Transaction', onTap: () {
            JTTransactionScreen().launch(context);
          }, leading: Icon(MaterialIcons.credit_card), detail: SizedBox()),
          settingItem(context, 'Job History', onTap: () {
            JTVerifyScreenUser().launch(context);
          }, leading: Icon(MaterialIcons.event_note), detail: SizedBox()),
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("   GENERAL",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  )),
            ],
          ),
          // settingItem(context, 'Help', onTap: () {
          //   launch('https://www.google.com');
          // }, leading: Icon(MaterialIcons.help_outline), detail: SizedBox()),
          // settingItem(context, 'About', onTap: () {
          //   DTAboutScreen().launch(context);
          // }, leading: Icon(MaterialIcons.info_outline), detail: SizedBox()),
          settingItem(context, 'Logout', onTap: () {
            logout();
          }, leading: Icon(MaterialIcons.logout), detail: SizedBox()),
        ],
      );
    }

    return Observer(
      builder: (_) => Scaffold(
        appBar: AppBar(
          backgroundColor: appStore.appBarColor,
          title: appBarTitleWidget(context, 'My Account'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => JTDashboardScreenNomad(id:"Employee")),
                );
              }),
        ),
        body: ContainerX(
          mobile: SingleChildScrollView(
            padding: EdgeInsets.only(top: 16),
            child: Column(
              children: [
                profileView(),
                Divider(color: appDividerColor, height: 8)
                    .paddingOnly(top: 4, bottom: 4),
                options(),
              ],
            ),
          ),
          web: Column(
            children: [
              profileView(),
              Divider(height: 8).paddingOnly(top: 4, bottom: 4),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: options(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
