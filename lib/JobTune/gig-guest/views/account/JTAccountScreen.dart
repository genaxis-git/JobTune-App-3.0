import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTAboutScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTPaymentScreen.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppConstant.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';

class JTAccountScreen extends StatefulWidget {
  static String tag = '/JTAccountScreen';

  @override
  _JTAccountScreenState createState() => _JTAccountScreenState();
}

class _JTAccountScreenState extends State<JTAccountScreen> {
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
          settingItem(context, 'Provider Profile', onTap: () {
//            DTNotificationSettingScreen().launch(context);
          }, leading: Icon(MaterialIcons.person_outline), detail: SizedBox()),
          settingItem(context, 'Schedule', onTap: () {
//            DTNotificationSettingScreen().launch(context);
          }, leading: Icon(MaterialIcons.calendar_today), detail: SizedBox()),
          settingItem(context, 'Post New Service', onTap: () {
//            DTNotificationSettingScreen().launch(context);
          }, leading: Icon(MaterialIcons.add_business), detail: SizedBox()),
          settingItem(context, 'Manage Service', onTap: () {
//            DTNotificationSettingScreen().launch(context);
          }, leading: Icon(MaterialIcons.list), detail: SizedBox()),
          settingItem(context, 'Clocking', onTap: () {
//            DTNotificationSettingScreen().launch(context);
          }, leading: Icon(MaterialIcons.access_alarms), detail: SizedBox()),
          settingItem(context, 'Transaction Received', onTap: () {
//            DTNotificationSettingScreen().launch(context);
          }, leading: Icon(MaterialIcons.payment), detail: SizedBox()),
          settingItem(context, 'Service History', onTap: () {
//            DTNotificationSettingScreen().launch(context);
          }, leading: Icon(MaterialIcons.history), detail: SizedBox()),

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
        ],
      );
    }

    return Observer(
      builder: (_) => Scaffold(
        appBar: AppBar(
          backgroundColor: appStore.appBarColor,
          title: appBarTitleWidget(context, 'Welcome Provider'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JTDashboardScreenGuest()),
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
