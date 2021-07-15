import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTAboutScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTPaymentScreen.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppConstant.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';


class JTAccountScreenUsers extends StatefulWidget {
  static String tag = '/JTAccountScreenUsers';

  @override
  _JTAccountScreenUsersState createState() => _JTAccountScreenUsersState();
}

class _JTAccountScreenUsersState extends State<JTAccountScreenUsers> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

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
              Image.asset(profileImage, height: 70, width: 70, fit: BoxFit.cover).cornerRadiusWithClipRRect(40),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("John", style: primaryTextStyle()),
                  2.height,
                  Text("John@gmail.com", style: primaryTextStyle()),
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
//            DTNotificationSettingScreen().launch(context);
          }, leading: Icon(MaterialIcons.person_outline), detail: SizedBox()),
          settingItem(context, 'Change Password', onTap: () {
//            DTNotificationSettingScreen().launch(context);
          }, leading: Icon(MaterialIcons.security), detail: SizedBox()),
          settingItem(context, 'Notifications', onTap: () {
//            DTNotificationSettingScreen().launch(context);
          }, leading: Icon(MaterialIcons.notifications_none), detail: SizedBox()),
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                  "   GENERAL",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  )
              ),
            ],
          ),
          settingItem(context, 'Help', onTap: () {
            launch('https://www.google.com');
          }, leading: Icon(MaterialIcons.help_outline), detail: SizedBox()),
          settingItem(context, 'About', onTap: () {
            DTAboutScreen().launch(context);
          }, leading: Icon(MaterialIcons.info_outline), detail: SizedBox()),
          settingItem(context, 'Logout', onTap: () {
//            DTNotificationSettingScreen().launch(context);
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
                  MaterialPageRoute(builder: (context) => JTDashboardSreenUser()),
                );
              }
          ),
        ),
        body: ContainerX(
          mobile: SingleChildScrollView(
            padding: EdgeInsets.only(top: 16),
            child: Column(
              children: [
                profileView(),
                Divider(color: appDividerColor, height: 8).paddingOnly(top: 4, bottom: 4),
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
