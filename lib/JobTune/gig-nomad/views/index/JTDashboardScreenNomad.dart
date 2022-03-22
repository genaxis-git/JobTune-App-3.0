import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/manage-job/JTManageJobScreen.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardWidgetUser.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import '../../../../main.dart';
import 'JTDashboardWidgetNomad.dart';
import 'JTDrawerWidgetEmployee.dart';
import 'JTDrawerWidgetNomad.dart';

class JTDashboardScreenNomad extends StatefulWidget {
  const JTDashboardScreenNomad({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _JTDashboardScreenNomadState createState() => _JTDashboardScreenNomadState();
}

class _JTDashboardScreenNomadState extends State<JTDashboardScreenNomad> {
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
      child: (widget.id == "Employer")
          ? Observer(
              builder: (context) => Scaffold(
                drawer: JTDrawerWidgetNomad(),
                body: JTManageJobScreen(),
              ),
            )
          : Observer(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  backgroundColor: appStore.appBarColor,
                  title: appBarTitleWidget(context, 'Explore Jobs'),
                ),
                drawer: JTDrawerWidgetEmployee(),
                body: JTDashboardWidgetNomad(),
              ),
            ),
    );
  }
}
