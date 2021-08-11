import 'package:flutter/material.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTWidgets.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';

class JTMaintenanceScreen extends StatefulWidget {
  @override
  _JTMaintenanceScreenState createState() => _JTMaintenanceScreenState();
}

class _JTMaintenanceScreenState extends State<JTMaintenanceScreen> {
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBar(context, 'Maintenance'),
      // drawer: DTDrawerWidget(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: errorWidget(
          context,
          'images/defaultTheme/maintenance.png',
          'Coming Soon!',
          'Gig Nomad is currently under going some upgrades and will be online shortly, Thank you for your patience.',
        ),
      ),
    );
  }
}