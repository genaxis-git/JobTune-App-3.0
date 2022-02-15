import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:prokit_flutter/main.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';

import 'JTDashboardWidgetGuest.dart';
import 'JTDrawerGSOnly.dart';
import 'JTDrawerWidgetGuest.dart';


class JTDashboardScreenGuest extends StatefulWidget {
  static String tag = '/JTDashboardScreenGuest';

  @override
  _JTDashboardScreenGuestState createState() => _JTDashboardScreenGuestState();
}

class _JTDashboardScreenGuestState extends State<JTDashboardScreenGuest> {
  String greet = "";

  void greeting() {

  }

  @override
  void initState() {
    super.initState();
    // greeting();
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
    var hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      setState(() {
        greet = "Good Morning";
      });
    }
    else if (hour >= 12 && hour < 17) {
      setState(() {
        greet = "Good Afternoon";
      });
    }
    else{
      setState(() {
        greet = "Good Evening";
      });
    }
    return SafeArea(
      child: Observer(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: appStore.appBarColor,
            title: appBarTitleWidget(context, greet),
          ),
          // drawer: JTDrawerWidgetGuest(),
          drawer: JTDrawerGSOnlyWidgetUser(),
          body: JTDashboardWidgetGuest(),
        ),
      ),
    );
  }
}


