import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prokit_flutter/JobTune/gig-nomad/views/maintenance/JTMaintenanceScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:prokit_flutter/JobTune/gig-guest/views/forgot-password/JTForgotPasswordScreen.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/register-login/JTSignInScreen.dart';
import 'package:prokit_flutter/JobTune/gig-guest/models/JTApps.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/account/JTAccountScreen.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/index/JTDashboardScreenNomad.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDashboardScreenProduct.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/account/JTOnboardingScreenProvider.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';

import '../../../../../../main.dart';
import 'JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/main/screens/ProKitLauncher.dart';



class JTDrawerWidgetGuest extends StatefulWidget {
  static String tag = '/JTDrawerWidgetGuest';

  @override
  _JTDrawerWidgetGuestState createState() => _JTDrawerWidgetGuestState();
}

class _JTDrawerWidgetGuestState extends State<JTDrawerWidgetGuest> {
  // functions starts//

  int loginstat = 0;
  Future<void> readUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    setState(() {
      if(lgid == "null") {
        loginstat = 0;
      }
      else{
        loginstat = 1;
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
    this.readUser();
    init();
  }

  // functions ends//


  List<NavbarGuestItems> drawerItems = getDrawerItemsGuest();
  var scrollController = ScrollController();

  init() async {
    if (appStore.selectedDrawerItem > 7) {
      await Future.delayed(Duration(milliseconds: 300));
      scrollController.jumpTo(appStore.selectedDrawerItem * 27.0);

      setState(() {});
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    print(loginstat);
    return SafeArea(
      child: ClipPath(
        clipper: JTOvalRightBorderClipper(),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Drawer(
          child: Container(
            color: appStore.scaffoldBackground,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  16.height,
                  Text('Guest', style: secondaryTextStyle(size: 12)).paddingOnly(left: 16),
                  4.height,
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text('Home', style: boldTextStyle(color: Color(0xFF0A79DF))),
                  ).onTap(() {
                    appStore.setDrawerItemIndex(-1);
                    // ProKitLauncher().launch(context, isNewTask: true);
                    JTDashboardScreenGuest().launch(context, isNewTask: true);
                  }),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text('Gig Service', style: boldTextStyle(color: Colors.black)),
                  ).onTap(() {
                    appStore.setDrawerItemIndex(-1);
                    JTDashboardSreenUser().launch(context, isNewTask: true);
                  }),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text('Gig Nomad', style: boldTextStyle(color: Colors.black)),
                  ).onTap(() {
                    appStore.setDrawerItemIndex(-1);
                    JTDashboardScreenNomad().launch(context, isNewTask: true);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => JTMaintenanceScreen()),
                    // );
                  }),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text('Gig Product', style: boldTextStyle(color: Colors.black)),
                  ).onTap(() {
                    appStore.setDrawerItemIndex(-1);
                    JTDashboardScreenProduct().launch(context, isNewTask: true);
                  }),
                  Divider(height: 16, color: Colors.blueGrey),
                  (loginstat == 0)
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Text('Log In/ Create account', style: boldTextStyle(color: Colors.black)),
                      ).onTap(() {
                        appStore.setDrawerItemIndex(-1);
                        JTSignInScreen().launch(context, isNewTask: true);
                      }),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Text('Forgot Password', style: boldTextStyle(color: Colors.black)),
                      ).onTap(() {
                        appStore.setDrawerItemIndex(-1);
                        JTForgotPasswordScreen().launch(context, isNewTask: true);
                      }),
                    ],
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Container(
                      //       padding: EdgeInsets.all(16),
                      //       child: Text('Provider', style: boldTextStyle(color: Colors.black)),
                      //     ).onTap(() {
                      //       appStore.setDrawerItemIndex(-1);
                      //       if(loginstat == 0){
                      //         JTOnboardingScreenProvider().launch(context, isNewTask: true);
                      //       }
                      //       else{
                      //         JTAccountScreen().launch(context, isNewTask: true);
                      //       }
                      //     }),
                      //     SizedBox(width:150),
                      //     Icon(
                      //       Icons.arrow_forward_ios,
                      //       size: 15,
                      //     ),
                      //     SizedBox(width:0),
                      //   ],
                      // ),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Text('Logout', style: boldTextStyle(color: Colors.black)),
                      ).onTap(() {
                        appStore.setDrawerItemIndex(-1);
                        logout();
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class JTOvalRightBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width - 50, 0);
    path.quadraticBezierTo(size.width, size.height / 4, size.width, size.height / 2);
    path.quadraticBezierTo(size.width, size.height - (size.height / 4), size.width - 40, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}