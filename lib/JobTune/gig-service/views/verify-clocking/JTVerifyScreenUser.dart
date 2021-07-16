import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/change-password/JTChangePasswordWidget.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';

import '../../../../main.dart';

class JTVerifyScreenUser extends StatefulWidget {
  @override
  _JTVerifyScreenUserState createState() => _JTVerifyScreenUserState();
}

class _JTVerifyScreenUserState extends State<JTVerifyScreenUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: jtchangepsw_appBarTitleWidget(context, 'Verify Clocking'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JTDashboardSreenUser()),
              );
            }
        ),
      ),
    );
  }
}
