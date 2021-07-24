import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:prokit_flutter/main.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';

import 'JTDashboardWidgetGuest.dart';
import 'JTDrawerWidgetGuest.dart';


class JTDashboardScreenGuest extends StatefulWidget {
  static String tag = '/JTDashboardScreenGuest';

  @override
  _JTDashboardScreenGuestState createState() => _JTDashboardScreenGuestState();
}

class _JTDashboardScreenGuestState extends State<JTDashboardScreenGuest> {
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
            title: appBarTitleWidget(context, 'Good Morning'),
          ),
          drawer: JTDrawerWidgetGuest(),
          body: JTDashboardWidgetGuest(),
        ),
      ),
    );
  }
}


