import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/gig-guest/models/JTApps.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/account/JTAccountScreen.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/index/JTDashboardScreenNomad.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDashboardScreenProduct.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/account/JTAccountScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/account/JTOnboardingScreenProvider.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTDashboardScreen.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTDataProvider.dart';
import 'package:prokit_flutter/main/model/ListModels.dart';
import 'package:prokit_flutter/main/screens/ProKitLauncher.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/widgets/materialWidgets/mwAppStrucutreWidgets/MWDrawerWidgets/MWDrawerScreen2.dart';

import '../../../../../../main.dart';
import 'JTDashboardScreenGuest.dart';

bool login = false;
//bool login = true;
bool seen = false;


class JTDrawerWidgetGuest extends StatefulWidget {
  static String tag = '/JTDrawerWidgetGuest';

  @override
  _JTDrawerWidgetGuestState createState() => _JTDrawerWidgetGuestState();
}

class _JTDrawerWidgetGuestState extends State<JTDrawerWidgetGuest> {
  List<NavbarGuestItems> drawerItems = getDrawerItemsGuest();
  var scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

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
                  Text('Guest', style: secondaryTextStyle(size: 12)).paddingOnly(left: 16),
                  4.height,
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text('Home', style: boldTextStyle(color: appColorPrimary)),
                  ).onTap(() {
                    appStore.setDrawerItemIndex(-1);

                    if (isMobile) {
                      ProKitLauncher().launch(context, isNewTask: true);
//                      JTDashboardScreenGuest().launch(context, isNewTask: true);
                    } else {
                      DTDashboardScreen().launch(context, isNewTask: true);
                    }
                  }),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text('Gig Service', style: boldTextStyle(color: Colors.black)),
                  ).onTap(() {
                    appStore.setDrawerItemIndex(-1);

                    if (isMobile) {
//                      ProKitLauncher().launch(context, isNewTask: true);
                      JTDashboardSreenUser().launch(context, isNewTask: true);
                    } else {
                      DTDashboardScreen().launch(context, isNewTask: true);
                    }
                  }),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text('Gig Nomad', style: boldTextStyle(color: Colors.black)),
                  ).onTap(() {
                    appStore.setDrawerItemIndex(-1);

                    if (isMobile) {
//                      ProKitLauncher().launch(context, isNewTask: true);
                      JTDashboardScreenNomad().launch(context, isNewTask: true);
                    } else {
                      DTDashboardScreen().launch(context, isNewTask: true);
                    }
                  }),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text('Gig Product', style: boldTextStyle(color: Colors.black)),
                  ).onTap(() {
                    appStore.setDrawerItemIndex(-1);

                    if (isMobile) {
//                      ProKitLauncher().launch(context, isNewTask: true);
                      JTDashboardScreenProduct().launch(context, isNewTask: true);
                    } else {
                      DTDashboardScreen().launch(context, isNewTask: true);
                    }
                  }),
                  Divider(height: 16, color: Colors.blueGrey),
                  (login == true)
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Text('Log In/ Create account', style: boldTextStyle(color: Colors.black)),
                      ).onTap(() {
                        appStore.setDrawerItemIndex(-1);

                        if (isMobile) {
//                      ProKitLauncher().launch(context, isNewTask: true);
                          JTDashboardScreenProduct().launch(context, isNewTask: true);
                        } else {
                          DTDashboardScreen().launch(context, isNewTask: true);
                        }
                      }),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Text('Forgot Password', style: boldTextStyle(color: Colors.black)),
                      ).onTap(() {
                        appStore.setDrawerItemIndex(-1);

                        if (isMobile) {
//                      ProKitLauncher().launch(context, isNewTask: true);
                          JTDashboardScreenProduct().launch(context, isNewTask: true);
                        } else {
                          DTDashboardScreen().launch(context, isNewTask: true);
                        }
                      }),
                    ],
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            child: Text('Provider', style: boldTextStyle(color: Colors.black)),
                          ).onTap(() {
                            appStore.setDrawerItemIndex(-1);

                            if (isMobile) {
//                      ProKitLauncher().launch(context, isNewTask: true);
                              if(seen == false){
                                JTOnboardingScreenProvider().launch(context, isNewTask: true);
                              }
                              else{
                                JTAccountScreen().launch(context, isNewTask: true);
                              }
                            } else {
                              DTDashboardScreen().launch(context, isNewTask: true);
                            }
                          }),
                          SizedBox(width:150),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                          SizedBox(width:0),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Text('Logout', style: boldTextStyle(color: Colors.black)),
                      ).onTap(() {
                        appStore.setDrawerItemIndex(-1);

                        if (isMobile) {
//                      ProKitLauncher().launch(context, isNewTask: true);
                          JTDashboardScreenProduct().launch(context, isNewTask: true);
                        } else {
                          DTDashboardScreen().launch(context, isNewTask: true);
                        }
                      }),
                    ],
                  ),
//                  Divider(height: 16, color: Colors.blueGrey),
//                  ListView.builder(
//                    itemBuilder: (context, index) {
//                      return Container(
//                        padding: EdgeInsets.all(16),
//                        child: Text(
//                          drawerItems[index].name!,
//                          style: boldTextStyle(color: Colors.black),
//                        ),
//                      ).onTap(() {
//                        finish(context);
//                        appStore.setDrawerItemIndex(index);
//
//                        drawerItems[index].widget.launch(context);
//                      });
//                    },
//                    physics: NeverScrollableScrollPhysics(),
//                    padding: EdgeInsets.only(top: 8, bottom: 8),
//                    itemCount: drawerItems.length,
//                    shrinkWrap: true,
//                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


