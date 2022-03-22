import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/change-password/JTChangePasswordScreen.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/forgot-password/JTForgotPasswordScreen.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/notification/JTNotificationScreen.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/register-login/JTSignInScreen.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/signup-login/JTSignInEmployer.dart';
import 'package:prokit_flutter/JobTune/gig-provider/service-manage/JTManageServiceScreen.dart';
import 'package:prokit_flutter/JobTune/gig-provider/views/add_post/add_post_service.dart';
import 'package:prokit_flutter/JobTune/gig-provider/views/profile/JTProfileScreenProvider.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/index/JTDashboardScreenNomad.dart';
import 'package:prokit_flutter/JobTune/gig-service/models/JTNavbarUser.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTDashboardScreen.dart';
import 'package:prokit_flutter/widgets/materialWidgets/mwAppStrucutreWidgets/MWDrawerWidgets/MWDrawerScreen2.dart';

import '../../../../../main.dart';



bool seen = false;

class JTSideMenuWidget extends StatefulWidget {
  static String tag = '/JTSideMenuWidget';

  const JTSideMenuWidget({
    Key? key,
    required this.name
  }) : super(key: key);
  final String name;

  @override
  _JTSideMenuWidgetState createState() => _JTSideMenuWidgetState();
}

class _JTSideMenuWidgetState extends State<JTSideMenuWidget> {
  List<NavbarUserList> drawerItems = getDrawerItemsService();
  var scrollController = ScrollController();

  // functions starts//

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

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    // await prefs.clear();

    JTDashboardScreenGuest().launch(context, isNewTask: true);
  }

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

  Future<void> gotoEmployer() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgemployer = prefs.getString('employerID').toString();
    if (lgemployer == "null") {
      JTSignInScreenEmployer().launch(context, isNewTask: true);
    } else {
      JTDashboardScreenNomad(id: "Employer").launch(context, isNewTask: true);
    }
  }

  List follows = [];
  Future<void> readNoti() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    print(server + "jtnew_user_countnoti&id="+ lgid);
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_countnoti&id="+ lgid
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      follows = json.decode(response.body);
    });
  }

  @override
  void initState() {
    super.initState();
    this.readUser();
    this.readNoti();
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
                children: [
                  (loginstat == 0)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            16.height,
                            Text(widget.name, style: secondaryTextStyle(size: 12)).paddingOnly(left: 16),
                            4.height,
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text('Home', style: boldTextStyle(color: Colors.black)),
                            ).onTap(() {
                              appStore.setDrawerItemIndex(-1);

                              if (isMobile) {
                                JTDashboardScreenGuest().launch(context, isNewTask: true);
                              } else {
                                DTDashboardScreen().launch(context, isNewTask: true);
                              }
                            }),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text('Explore Gig Service',
                                  style: boldTextStyle(color: Colors.black)),
                            ).onTap(() {
                              appStore.setDrawerItemIndex(-1);
                              JTDashboardSreenUser().launch(context, isNewTask: true);
                            }),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text('Explore Jobs',
                                  style: boldTextStyle(color: Colors.black)),
                            ).onTap(() {
                              appStore.setDrawerItemIndex(-1);
                              JTDashboardScreenNomad(id: "Employee").launch(context, isNewTask: true);
                            }),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text('For Employer',
                                  style: boldTextStyle(color: Colors.black)),
                            ).onTap(() {
                              gotoEmployer();
                            }),
                            Divider(height: 16, color: Colors.blueGrey),
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
                            16.height,
                            Text('Home', style: secondaryTextStyle(size: 12)).paddingOnly(left: 16),
                            4.height,
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text('Home', style: boldTextStyle(color: Colors.black)),
                            ).onTap(() {
                              appStore.setDrawerItemIndex(-1);

                              if (isMobile) {
                                JTDashboardScreenGuest().launch(context, isNewTask: true);
                              } else {
                                DTDashboardScreen().launch(context, isNewTask: true);
                              }
                            }),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text('My Profile',
                                  style: boldTextStyle(color: Colors.black)),
                            ).onTap(() {
                              appStore.setDrawerItemIndex(-1);
                              JTProfileScreenProvider().launch(context);
                            }),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Stack(
                                children: [
                                  Text(
                                    'Notifications          ',
                                    style: boldTextStyle(color: Colors.black
                                    )
                                  ),
                                  new Positioned(
                                    right: 0,
                                    top: 3,
                                    child: new Container(
                                      padding: EdgeInsets.fromLTRB(7, 2, 7, 2),
                                      decoration: new BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              Colors.purpleAccent,
                                              Colors.indigoAccent,
                                            ],
                                          ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 15,
                                        minHeight: 15,
                                      ),
                                      child: (follows.length > 99)
                                        ? Text(
                                        '99+',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w900
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                          : Text(
                                        follows.length.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w900
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                    ),
                                  )
                                ],
                              ),
                            ).onTap(() {
                              appStore.setDrawerItemIndex(-1);
                              JTNotificationScreen().launch(context);
                            }),
                            Divider(height: 16, color: Colors.blueGrey),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text('Explore Gig Service',
                                  style: boldTextStyle(color: Colors.black)),
                            ).onTap(() {
                              appStore.setDrawerItemIndex(-1);
                              JTDashboardSreenUser().launch(context, isNewTask: true);
                            }),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text('Add Post',
                                  style: boldTextStyle(color: Colors.black)),
                            ).onTap(() {
                              appStore.setDrawerItemIndex(-1);
                              checkProfile();
                            }),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text('My Service',
                                  style: boldTextStyle(color: Colors.black)),
                            ).onTap(() {
                              appStore.setDrawerItemIndex(-1);
                              ServiceScreen().launch(context);
                            }),
                            Divider(height: 16, color: Colors.blueGrey),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text('Explore Jobs',
                                  style: boldTextStyle(color: Colors.black)),
                            ).onTap(() {
                              appStore.setDrawerItemIndex(-1);
                              JTDashboardScreenNomad(id: "Employee").launch(context, isNewTask: true);
                            }),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text('For Employer',
                                  style: boldTextStyle(color: Colors.black)),
                            ).onTap(() {
                              gotoEmployer();
                            }),
                            Divider(height: 16, color: Colors.blueGrey),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text('Change Password',
                                  style: boldTextStyle(color: Colors.black)),
                            ).onTap(() {
                              appStore.setDrawerItemIndex(-1);
                              JTChangePasswordScreen().launch(context, isNewTask: true);
                            }),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text('Logout',
                                  style: boldTextStyle(color: Colors.black)),
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