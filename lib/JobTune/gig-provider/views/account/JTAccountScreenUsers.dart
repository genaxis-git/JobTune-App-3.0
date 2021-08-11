import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDashboardScreenProduct.dart';
import 'package:prokit_flutter/JobTune/gig-provider/service-manage/JTManageServiceScreen.dart';
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
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDrawerWidgetProduct.dart';
import '../ongoing_order/JTOrderScreen.dart';
import '../co_de_booking/JTCoDeBookingScreen.dart';
import '../add_post/add_post.dart';
import '../my_product/JTMyProduct.dart';
import '../co_de_product/JTCoDeBookingScreen.dart';
import '../order_history/JTOrderHistory.dart';

class JTAccountScreenUsers extends StatefulWidget {
  static String tag = '/JTAccountScreenUsers';

  @override
  _JTAccountScreenUsersState createState() => _JTAccountScreenUsersState();
}

class _JTAccountScreenUsersState extends State<JTAccountScreenUsers> {
  List profile = [];
  String email = " ";
  String names = " ";
  String img = "no profile.png";
  Future<void> checkProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selectprofile&lgid=" +
                lgid),
        headers: {"Accept": "application/json"});

    this.setState(() {
      profile = json.decode(response.body);
    });

    if (profile[0]["name"] == "" ||
        profile[0]["industry_type"] == "" ||
        profile[0]["phone_no"] == "" ||
        profile[0]["address"] == "" ||
        profile[0]["city"] == "" ||
        profile[0]["state"] == "" ||
        profile[0]["postcode"] == "0" ||
        profile[0]["country"] == "" ||
        profile[0]["profile_pic"] == "") {
      // alert:  please update
      print("update profile");
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => JTAddPost()),
      );
    }
  }

  Future<void> readProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selectprofile&lgid=" +
                lgid),
        headers: {"Accept": "application/json"});

    this.setState(() {
      profile = json.decode(response.body);
    });

    setState(() {
      email = lgid;
      names = profile[0]["name"];

      if (profile[0]["profile_pic"] != "") {
        img = profile[0]["profile_pic"];
      } else {
        img = "no profile.png";
      }
    });
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
              Image.network(
                      "http://jobtune-dev.my1.cloudapp.myiacloud.com/gig/JobTune/assets/img/" +
                          img,
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover)
                  .cornerRadiusWithClipRRect(40),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(names, style: primaryTextStyle()),
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
            JTProfileScreenProvider().launch(context);
          }, leading: Icon(MaterialIcons.person_outline), detail: SizedBox()),
          settingItem(context, 'Timetable', onTap: () {
//            DTNotificationSettingScreen().launch(context);
          }, leading: Icon(MaterialIcons.event), detail: SizedBox()),
          settingItem(context, 'My Service', onTap: () {
            ServiceScreen().launch(context);
          }, leading: Icon(MaterialIcons.work_outline), detail: SizedBox()),
          settingItem(context, 'Clocking', onTap: () {
            JTClockingScreenUser().launch(context);
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
            JTProfileScreenProvider().launch(context);
          }, leading: Icon(MaterialIcons.person_outline), detail: SizedBox()),
          settingItem(context, 'My Product', onTap: () {
            JTMyProduct().launch(context);
          }, leading: Icon(MaterialIcons.inventory), detail: SizedBox()),
          settingItem(context, 'Ongoing Order', onTap: () {
            DTCartScreen().launch(context);
          }, leading: Icon(MaterialIcons.bookmark_border), detail: SizedBox()),
          settingItem(context, 'Order History', onTap: () {
            JTOrderHistory().launch(context);
          }, leading: Icon(MaterialIcons.event_note), detail: SizedBox()),
          settingItem(context, 'Co-De', onTap: () {
            JTCoDeProduct().launch(context);
          }, leading: Icon(MaterialIcons.people_outline), detail: SizedBox()),
        ],
      );
    }

    Widget addServiceProduct() {
      return FloatingActionButton.extended(
          heroTag: '5',
          label: Text(
            "Post",
            style: primaryTextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            // toast('Icon with Label Fab');
            checkProfile();
          });
    }

    return Observer(
        builder: (_) => SafeArea(
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: appStore.appBarColor,
                    // title: Text(
                    //   'Provider Account',
                    //   style: boldTextStyle(
                    //       color: appStore.textPrimaryColor, size: 20),
                    // ),
                    title: appBarTitleWidget(context, 'Provider Account'),
                    bottom: TabBar(
                      onTap: (index) {
                        print(index);
                      },
                      indicatorColor: Colors.blue,
                      labelColor: appStore.textPrimaryColor,
                      labelStyle: boldTextStyle(),
                      tabs: [
                        Tab(
                          text: "Service",
                        ),
                        Tab(
                          text: "Product",
                        ),
                      ],
                    ),
                  ),
                  drawer: JTDrawerWidgetProduct(),
                  floatingActionButton: addServiceProduct(),
                  body: TabBarView(
                    children: [
                      ContainerX(
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
                      ContainerX(
                        mobile: SingleChildScrollView(
                          padding: EdgeInsets.only(top: 16),
                          child: Column(
                            children: [
                              profileView(),
                              Divider(color: appDividerColor, height: 8)
                                  .paddingOnly(top: 4, bottom: 4),
                              options_product(),
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
                                  child: options_product(),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
