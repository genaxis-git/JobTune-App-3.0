import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTDashboardWidget.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTDrawerWidget.dart';
import 'package:prokit_flutter/main.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';

import 'JTDashboardWidgetUser.dart';
import 'JTDrawerWidget.dart';

class JTDashboardSreenUser extends StatefulWidget {
  static String tag = '/JTDashboardScreenUser';

  @override
  _JTDashboardSreenUserState createState() => _JTDashboardSreenUserState();
}

class _JTDashboardSreenUserState extends State<JTDashboardSreenUser> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Observer(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: appStore.appBarColor,
            title: appBarTitleWidget(context, 'Gig Service'),
          ),
          drawer: JTDrawerWidgetUser(),
          body: JTDashboardWidgetUser(),
        ),
      ),
    );
  }
}
