import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/main/utils/AppConstant.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';

import '../../../../main.dart';
import '../ongoing_order/JTOrderScreen.dart';
import '../co_de_booking/JTCoDeBookingScreen.dart';
import './post_service.dart';
import './post_product.dart';

class JTAddPostService extends StatefulWidget {
  static String tag = '/JTAccountScreenUsers';

  @override
  _JTAddPostServiceState createState() => _JTAddPostServiceState();
}

class _JTAddPostServiceState extends State<JTAddPostService> {
  var formKey = GlobalKey<FormState>();

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
              Image.asset(profileImage,
                  height: 70, width: 70, fit: BoxFit.cover)
                  .cornerRadiusWithClipRRect(40),
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
          settingItem(context, 'Timetable', onTap: () {
//            DTNotificationSettingScreen().launch(context);
          }, leading: Icon(MaterialIcons.event), detail: SizedBox()),
          settingItem(context, 'My Service', onTap: () {
//            DTNotificationSettingScreen().launch(context);
          }, leading: Icon(MaterialIcons.work_outline), detail: SizedBox()),
          settingItem(context, 'Clocking', onTap: () {
//            DTNotificationSettingScreen().launch(context);
          }, leading: Icon(MaterialIcons.schedule), detail: SizedBox()),
          settingItem(context, 'Service History', onTap: () {
//            DTNotificationSettingScreen().launch(context);
          }, leading: Icon(MaterialIcons.event_note), detail: SizedBox()),
          settingItem(context, 'Co-De', onTap: () {
            DTCartScreen1().launch(context);
          }, leading: Icon(MaterialIcons.people_outline), detail: SizedBox()),
        ],
      );
    }

    Widget options_product() {
      return Column(
        children: [
          settingItem(context, 'My Profile', onTap: () {
//            DTNotificationSettingScreen().launch(context);
          }, leading: Icon(MaterialIcons.person_outline), detail: SizedBox()),
          settingItem(context, 'My Product', onTap: () {
//            DTNotificationSettingScreen().launch(context);
          }, leading: Icon(MaterialIcons.inventory), detail: SizedBox()),
          settingItem(context, 'Ongoing Order', onTap: () {
            DTCartScreen().launch(context);
          }, leading: Icon(MaterialIcons.bookmark_border), detail: SizedBox()),
          settingItem(context, 'Order History', onTap: () {
//            DTNotificationSettingScreen().launch(context);
          }, leading: Icon(MaterialIcons.event_note), detail: SizedBox()),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        // title: Text(
        //   'Provider Account',
        //   style: boldTextStyle(
        //       color: appStore.textPrimaryColor, size: 20),
        // ),
        title: appBarTitleWidget(context, 'Add Post'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 16),
        child: Column(
          children: [
            // profileView(),
            PostService(),
            // Divider(color: appDividerColor, height: 8)
            //     .paddingOnly(top: 4, bottom: 4),
            // options(),
          ],
        ),
      ),
    );
  }
}
