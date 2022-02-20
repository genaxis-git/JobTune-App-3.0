import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/change-password/JTChangePasswordScreen.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDashboardScreenProduct.dart';
import 'package:prokit_flutter/JobTune/gig-provider/service-manage/JTManageServiceScreen.dart';
import 'package:prokit_flutter/JobTune/gig-provider/views/add_post/add_post_service.dart';
import 'package:prokit_flutter/JobTune/gig-provider/views/profile/JTProfileScreenProvider.dart';
import 'package:prokit_flutter/JobTune/gig-provider/views/service-history/JTServiceHistoryScreen.dart';
import 'package:prokit_flutter/JobTune/gig-provider/views/timetable/JTTimetableScreenProvider.dart';
import 'package:prokit_flutter/JobTune/gig-provider/views/transaction/JTTransactionProvider.dart';
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

class JTAccountServiceScreen extends StatefulWidget {
  static String tag = '/JTAccountServiceScreen';

  @override
  _JTAccountServiceScreenState createState() => _JTAccountServiceScreenState();
}

class _JTAccountServiceScreenState extends State<JTAccountServiceScreen> {
  List profile = [];
  String email = " ";
  String names = " ";
  String img = "no profile.png";
  Future<void> checkProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectprofile&lgid=" +
                lgid),
        headers: {"Accept": "application/json"});

    this.setState(() {
      profile = json.decode(response.body);
    });

    if (profile[0]["name"] == "" ||
        profile[0]["industry_type"] == "" ||
        profile[0]["phone_no"] == "" ||
        profile[0]["address"] == "" ||
        // profile[0]["bank_type"] == "" ||
        profile[0]["emergency_name"] == "" ||
        profile[0]["emergency_no"] == "" ||
        // profile[0]["bank_acc_no"] == "" ||
        profile[0]["profile_pic"] == "") {
      showInDialog(context,
          child: AlertCompleteProfile(),
          backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => JTAddPostService()),
      );
    }
  }

  Future<void> readProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectprofile&lgid=" +
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
      print("ayam");
      print(img);
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
              Image.network(
                  image + img,
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
          // settingItem(context, 'Timetable', onTap: () {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => WebViewTimetableProvider(id: email)),
          //   );
          // }, leading: Icon(MaterialIcons.event), detail: SizedBox()),
          settingItem(context, 'My Service', onTap: () {
            ServiceScreen().launch(context);
          }, leading: Icon(MaterialIcons.work_outline), detail: SizedBox()),
          // settingItem(context, 'Clocking', onTap: () {
          //   JTClockingScreenUser().launch(context);
          // }, leading: Icon(MaterialIcons.schedule), detail: SizedBox()),
          // settingItem(context, 'Service History', onTap: () {
          //   JTServiceHistoryScreen().launch(context);
          // }, leading: Icon(MaterialIcons.event_note), detail: SizedBox()),
          // settingItem(context, 'Transaction', onTap: () {
          //   JTTransactionProvider().launch(context);
          // }, leading: Icon(MaterialIcons.credit_card), detail: SizedBox()),
          // settingItem(context, 'Co-De', onTap: () {
          //   DTCartScreen1().launch(context);
          // }, leading: Icon(MaterialIcons.people_outline), detail: SizedBox()),
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
          settingItem(context, 'Change Password', onTap: () {
            JTChangePasswordScreen().launch(context);
          }, leading: Icon(MaterialIcons.security), detail: SizedBox()),
          settingItem(context, 'Logout', onTap: () {
            logout();
          }, leading: Icon(MaterialIcons.logout), detail: SizedBox()),
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: appBarTitleWidget(context, 'Provider Account'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => JTDashboardSreenUser()),
              );
            }),
      ),
      // drawer: JTDrawerWidgetProduct(),
      floatingActionButton: addServiceProduct(),
      body: SingleChildScrollView(
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
    );
  }
}

class AlertCompleteProfile extends StatefulWidget {
  @override
  _AlertCompleteProfileState createState() => _AlertCompleteProfileState();
}

class _AlertCompleteProfileState extends State<AlertCompleteProfile> {
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: appStore.iconColor),
                    onPressed: () {
                      finish(context);
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image.network(
                      "https://jobtune.ai/gig/JobTune/assets/mobile/warn.jpg",
                      width: context.width() * 0.70,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              10.height,
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Please complete your profile.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  15.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "Please make sure your details such as name, industry type, phone number, address, bank information, and profile picture has been completed by you before proceed with posting..",
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  20.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          finish(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Center(
                            child: Text("Later", style: boldTextStyle(color: white)),
                          ),
                        ),
                      ),
                      5.width,
                      GestureDetector(
                        onTap: () {
                          finish(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JTProfileScreenProvider()),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(color: appColorPrimary, borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Center(
                            child: Text("Go to Profile", style: boldTextStyle(color: white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              16.height,
            ],
          ),
        ),
      ),
    );
  }
}