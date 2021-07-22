import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDrawerWidgetProduct.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTDashboardWidget.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTDrawerWidget.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTDrawerWidget.dart';
import 'package:prokit_flutter/main.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';

import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDashboardProductWidget.dart';

class JTDashboardScreenProduct extends StatefulWidget {
  static String tag = '/JTDashboardScreenProduct';
  @override
  _JTDashboardScreenProductState createState() =>
      _JTDashboardScreenProductState();
}

class _JTDashboardScreenProductState extends State<JTDashboardScreenProduct> {
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
            title: appBarTitleWidget(context, 'Gig Product'),
          ),
          drawer: JTDrawerWidgetProduct(),
//          body: JTDashboardWidgetUser(),
          body: JTDashboardWidgetUser(),
        ),
      ),
    );
  }
}
