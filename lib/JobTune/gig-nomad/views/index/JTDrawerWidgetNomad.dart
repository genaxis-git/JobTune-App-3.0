import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prokit_flutter/JobTune/gig-guest/views/forgot-password/JTForgotPasswordScreen.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/register-login/JTSignInScreen.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/account/employee/JTAccountScreenEmployee.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/account/employer/JTAccountScreenEmployer.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/maintenance/JTMaintenanceScreen.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/signup-login/JTSignInEmployer.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDashboardScreenProduct.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prokit_flutter/JobTune/gig-service/models/JTNavbarUser.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTDashboardScreen.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/widgets/materialWidgets/mwAppStrucutreWidgets/MWDrawerWidgets/MWDrawerScreen2.dart';

import '../../../../main.dart';
import 'JTDashboardScreenNomad.dart';

bool seen = false;

class JTDrawerWidgetNomad extends StatefulWidget {
  static String tag = '/JTDrawerWidgetNomad';

  @override
  _JTDrawerWidgetNomadState createState() => _JTDrawerWidgetNomadState();
}

class _JTDrawerWidgetNomadState extends State<JTDrawerWidgetNomad> {
  List<NavbarUserList> drawerItems = getDrawerItemsService();
  var scrollController = ScrollController();

  // functions starts//

  int loginstat = 0;
  Future<void> readUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('employerID').toString();

    setState(() {
      if(lgid == "null") {
        loginstat = 0;
      }
      else{
        loginstat = 1;
      }
    });
  }

  Future<void> checkID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('employerID').toString();

    if(lgid == "null"){
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JTSignInScreenEmployer()),
      );
    }
    else{
      JTAccountScreenEmployer().launch(context, isNewTask: true);
    }
  }

  @override
  void initState() {
    super.initState();
    this.readUser();
    init();
  }

  // functions ends//



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
        clipper: OvalRightBorderClipper(),
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
                  Text('Employer', style: secondaryTextStyle(size: 12)).paddingOnly(left: 16),
                  4.height,
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text('Home', style: boldTextStyle(color: Colors.black)),
                  ).onTap(() {
                    appStore.setDrawerItemIndex(-1);

                    if (isMobile) {
                      // ProKitLauncher().launch(context, isNewTask: true);
                      JTDashboardScreenGuest().launch(context, isNewTask: true);
                    } else {
                      DTDashboardScreen().launch(context, isNewTask: true);
                    }
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
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text('Company Profile', style: boldTextStyle(color: Colors.black)),
                            ).onTap(() {
                              appStore.setDrawerItemIndex(-1);
                              JTAccountScreenEmployee().launch(context, isNewTask: true);
                            }),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text('Post New Vacancy', style: boldTextStyle(color: Colors.black)),
                            ).onTap(() {
                              appStore.setDrawerItemIndex(-1);
                              JTAccountScreenEmployee().launch(context, isNewTask: true);
                            }),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text('Manage Job', style: boldTextStyle(color: Colors.black)),
                            ).onTap(() {
                              appStore.setDrawerItemIndex(-1);
                              JTAccountScreenEmployee().launch(context, isNewTask: true);
                            }),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text('Shortlisted Candidate', style: boldTextStyle(color: Colors.black)),
                            ).onTap(() {
                              appStore.setDrawerItemIndex(-1);
                              JTAccountScreenEmployee().launch(context, isNewTask: true);
                            }),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text('Verify Clocking', style: boldTextStyle(color: Colors.black)),
                            ).onTap(() {
                              appStore.setDrawerItemIndex(-1);
                              JTAccountScreenEmployee().launch(context, isNewTask: true);
                            }),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text('Vacancy History', style: boldTextStyle(color: Colors.black)),
                            ).onTap(() {
                              appStore.setDrawerItemIndex(-1);
                              JTAccountScreenEmployee().launch(context, isNewTask: true);
                            }),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text('Transaction', style: boldTextStyle(color: Colors.black)),
                            ).onTap(() {
                              appStore.setDrawerItemIndex(-1);
                              JTAccountScreenEmployee().launch(context, isNewTask: true);
                            }),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text('Change Password', style: boldTextStyle(color: Colors.black)),
                            ).onTap(() {
                              appStore.setDrawerItemIndex(-1);
                              JTAccountScreenEmployee().launch(context, isNewTask: true);
                            }),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text('Log Out As Hirer', style: boldTextStyle(color: Colors.black)),
                            ).onTap(() {
                              appStore.setDrawerItemIndex(-1);
                              JTAccountScreenEmployee().launch(context, isNewTask: true);
                            }),
                          ],
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


