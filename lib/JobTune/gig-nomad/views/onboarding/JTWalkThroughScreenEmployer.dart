import 'package:flutter/material.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/index/JTDashboardScreenNomad.dart';
import 'package:prokit_flutter/main/utils/Lipsum.dart' as lipsum;
import 'package:nb_utils/nb_utils.dart';

import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTProductDetailWidget.dart';

class JTWalkThroughScreenEmployer extends StatefulWidget {
  static String tag = '/JTWalkThroughScreenEmployer';

  @override
  _JTWalkThroughScreenEmployerState createState() => _JTWalkThroughScreenEmployerState();
}

class _JTWalkThroughScreenEmployerState extends State<JTWalkThroughScreenEmployer> {
  var pageController = PageController();

  List<Widget>  pages = [];
  var selectedIndex = 0;

  final img1 = Image.network('https://jobtune.ai/gig/JobTune/assets/mobile/rsz_10118.jpg');
  final img2 = Image.network('https://jobtune.ai/gig/JobTune/assets/mobile/rsz_8619.jpg');
  final img3 = Image.network('https://jobtune.ai/gig/JobTune/assets/mobile/rsz_6308.jpg');
  final img4 = Image.network('https://jobtune.ai/gig/JobTune/assets/mobile/rsz_8732.jpg');


  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(img1.image, context);
    precacheImage(img2.image, context);
    precacheImage(img3.image, context);
    precacheImage(img4.image, context);
    super.didChangeDependencies();
  }

  init() async {
    pages = [
      Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            img1,
            Text('Post a Vacancy', style: boldTextStyle(size: 20)),
            Text("You can now advertise vacancies in your company and hire someone who is capable to fill the vacancies more easily and cost effectively.", textAlign: TextAlign.center, style: secondaryTextStyle()).paddingAll(8),
          ],
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            img2,
            Text('Shortlisting', style: boldTextStyle(size: 20)),
            Text("Perform scanning and necessary analysis on each candidate, add it to your shortlist to facilitate the selection process, and send offers to any qualified candidates.", textAlign: TextAlign.center, style: secondaryTextStyle()).paddingAll(8),
          ],
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: Column (
          mainAxisSize: MainAxisSize.min,
          children: [
            img4,
            Text('Verify & Rate', style: boldTextStyle(size: 20)),
            Text("As an employer, you need to verify your employee’s attendance record and you have the right to give your opinion on how the employee performance.", textAlign: TextAlign.center, style: secondaryTextStyle()).paddingAll(8),
          ],
        ),
      )
    ];
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    init();

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            PageView(
              controller: pageController,
              children: pages,
              onPageChanged: (index) {
                selectedIndex = index;
                setState(() {});
              },
            ),
            AnimatedPositioned(
              duration: Duration(seconds: 1),
              bottom: 20,
              left: 0,
              right: 0,
              child: DotIndicator(pageController: pageController, pages: pages, indicatorColor: Color(0xFF0A79DF)),
            ),
            Positioned(
              child: AnimatedCrossFade(
                firstChild: Container(
                  child: Text('Get Started', style: boldTextStyle(color: white)),
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(8)),
                ).onTap(() {
                  JTDashboardScreenNomad(id:"Employer").launch(context);
                }),
                secondChild: SizedBox(),
                duration: Duration(milliseconds: 300),
                firstCurve: Curves.easeIn,
                secondCurve: Curves.easeOut,
                crossFadeState: selectedIndex == (pages.length - 1) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              ),
              bottom: 20,
              right: 20,
            ),
            Positioned(
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                child: Text('Skip', style: boldTextStyle(color: white)),
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(8)),
              ).onTap(() {
                finish(context);
                JTDashboardScreenNomad(id:"Employer").launch(context);
              }),
              left: 20,
              bottom: 20,
            ),
          ],
        ),
      ),
    );
  }
}
