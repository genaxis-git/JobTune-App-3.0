import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/manage-job/JTManagJobScreen.dart';
import 'JTDrawerWidgetNomad.dart';


class JTDashboardScreenNomad extends StatefulWidget {
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
      child: Observer(
        builder: (context) => Scaffold(
          drawer: JTDrawerWidgetNomad(),
          body: JTManageJobScreen(),
        ),
      ),
    );
  }
}
