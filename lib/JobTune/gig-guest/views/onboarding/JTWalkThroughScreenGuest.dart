import 'package:flutter/material.dart';
import 'package:prokit_flutter/main/utils/Lipsum.dart' as lipsum;
import 'package:nb_utils/nb_utils.dart';

import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTProductDetailWidget.dart';

class JTWalkThroughScreenGuest extends StatefulWidget {
  static String tag = '/JTWalkThroughScreenGuest';

  @override
  _JTWalkThroughScreenGuestState createState() => _JTWalkThroughScreenGuestState();
}

class _JTWalkThroughScreenGuestState extends State<JTWalkThroughScreenGuest> {
  var pageController = PageController();

  List<Widget>  pages = [];
  var selectedIndex = 0;

  final img1 = Image.network('https://jobtune.ai/gig/JobTune/assets/onboard/services.jpg');
  final img2 = Image.network('https://jobtune.ai/gig/JobTune/assets/onboard/product.jpg');
  final img3 = Image.network('https://jobtune.ai/gig/JobTune/assets/onboard/nomad.jpg');


  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(img1.image, context);
    precacheImage(img2.image, context);
    precacheImage(img3.image, context);
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
            Text('Gig Service', style: boldTextStyle(size: 20)),
            Text("Enabling gig economists to showcase their skills and turn their skills into a service that is able to generate side income. And at the same time, users also get an advantage in lightening the load of their daily routine.", textAlign: TextAlign.center, style: secondaryTextStyle()).paddingAll(8),
          ],
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            img2,
            Text('Gig Product', style: boldTextStyle(size: 20)),
            Text("We also invite small businesses to be part in our family. Here. you may now showcase products you are selling.", textAlign: TextAlign.center, style: secondaryTextStyle()).paddingAll(8),
          ],
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: Column (
          mainAxisSize: MainAxisSize.min,
          children: [
            img3,
            Text('Gig Nomad', style: boldTextStyle(size: 20)),
            Text("The world is getting increasingly advanced, everything is at your fingertips. You can now create job vacancy advertisements, and wait for job applications to come in your line.", textAlign: TextAlign.center, style: secondaryTextStyle()).paddingAll(8),
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
                  JTDashboardScreenGuest().launch(context);
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
                JTDashboardScreenGuest().launch(context);
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
