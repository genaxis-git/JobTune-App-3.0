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
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDrawerWidgetProduct.dart';
import '../ongoing_order/JTOrderScreen.dart';
import '../co_de_booking/JTCoDeBookingScreen.dart';
import '../add_post/add_post.dart';

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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JTAddPost()),
            );
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
