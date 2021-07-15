import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/Banking/utils/BankingContants.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-service/models/JTAccountUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:prokit_flutter/grocery/utils/GroceryWidget.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:prokit_flutter/theme4/utils/T4Colors.dart';
import 'package:prokit_flutter/theme4/utils/T4DataGenerator.dart';
import 'package:prokit_flutter/theme4/utils/T4Images.dart';
import 'package:prokit_flutter/theme4/utils/T4Strings.dart';
import 'package:prokit_flutter/theme4/models/T4Models.dart';
import 'package:prokit_flutter/theme4/utils/T4Widgets.dart';

import '../../../../main.dart';

class JTAccountScreenUser extends StatefulWidget {
  static var tag = "/JTAccountScreenUser";

  @override
  _JTAccountScreenUserState createState() => _JTAccountScreenUserState();
}

class _JTAccountScreenUserState extends State<JTAccountScreenUser> {
  int selectedPos = 1;
  List<AccountModel>? mListings;

  @override
  void initState() {
    super.initState();
    selectedPos = 1;
    mListings = getData();
  }

  Widget getItem(String name, String icon) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  SizedBox(width: 16),
                  SvgPicture.asset(icon, width: 20, height: 20, color: t4_colorPrimary),
                  SizedBox(width: 16),
                  text(name, textColor: appStore.textPrimaryColor)
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.keyboard_arrow_right),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Divider(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    changeStatusColor(appStore.appBarColor!);
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
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
      body: Observer(
        builder: (_) => Container(
          color: appStore.scaffoldBackground,
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(16.0),
                    decoration: boxDecoration(bgColor: appStore.scaffoldBackground, radius: 8, showShadow: true),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: <Widget>[
                          CachedNetworkImage(
                            placeholder: placeholderWidgetFn() as Widget Function(BuildContext, String)?,
                            imageUrl: t4_profile_covr_page,
                            height: height * 0.3,
                            fit: BoxFit.fill,
                          ),
                          Column(
                            children: <Widget>[
                              SizedBox(height: height * 0.225),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  SizedBox(width: 24),
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: white),
                                    child: CircleAvatar(backgroundImage: CachedNetworkImageProvider(t4_profile), radius: width * 0.15),
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      text(t4_username, textColor: appStore.textPrimaryColor, fontFamily: fontBold, fontSize: textSizeLargeMedium),
                                      text(t4_designation, fontFamily: fontMedium, fontSize: textSizeMedium),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 60),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      "PROVIDER ACCOUNT",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      )
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),
                              getItem("Provider Profile", t4_home),
                              getItem("Timetable", t4_home),
                              getItem("Manage Service", t4_home),
                              getItem("Clocking", t4_home),
                              getItem("Transaction Received", t4_home),
                              SizedBox(height: 40),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      "PRODUCTS",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      )
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),
                              getItem("Selling Item", t4_home),
                              getItem("Scheduled", t4_home),
                              getItem("Transaction Received", t4_home),
                              SizedBox(height: 40),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      "GENERAL",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      )
                                  ),
                                ],
                              ),
                              getItem(t4_lbl_notification, t4_bell),
                              getItem(t4_lbl_terms_conditions, t4_file),
                              getItem(t4_lbl_help_support, t4_help),
                              getItem(t4_lbl_logout, t4_logout),
                              SizedBox(height: 24),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
