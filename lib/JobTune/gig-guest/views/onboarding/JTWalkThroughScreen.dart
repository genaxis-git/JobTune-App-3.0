import 'package:flutter/material.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/account/JTAccountScreen.dart';
import 'package:prokit_flutter/main/utils/Lipsum.dart' as lipsum;
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';


class JTWalkThroughScreen extends StatefulWidget {
  static String tag = '/JTWalkThroughScreen';

  @override
  _JTWalkThroughScreenState createState() => _JTWalkThroughScreenState();
}

class _JTWalkThroughScreenState extends State<JTWalkThroughScreen> {
  var pageController = PageController();

  List<Widget>  pages = [];
  var selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  init() async {
    pages = [
      Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/defaultTheme/walkthrough1.png', height: context.height() * 0.45),
            Text('Title', style: boldTextStyle(size: 20)),
            Text(lipsum.createSentence(), textAlign: TextAlign.center, style: secondaryTextStyle()).paddingAll(8),
          ],
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/defaultTheme/walkthrough1.png', height: context.height() * 0.45),
            Text('Title', style: boldTextStyle(size: 20)),
            Text(lipsum.createSentence(), textAlign: TextAlign.center, style: secondaryTextStyle()).paddingAll(8),
          ],
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/defaultTheme/walkthrough1.png', height: context.height() * 0.45),
            Text('Title', style: boldTextStyle(size: 20)),
            Text(lipsum.createSentence(), textAlign: TextAlign.center, style: secondaryTextStyle()).paddingAll(8),
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
      appBar: appBar(context, 'WalkThrough'),
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
              child: DotIndicator(pageController: pageController, pages: pages, indicatorColor: appColorPrimary),
            ),
            Positioned(
              child: AnimatedCrossFade(
                firstChild: Container(
                  child: Text('Get Started', style: boldTextStyle(color: white)),
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  decoration: BoxDecoration(color: appColorPrimary, borderRadius: BorderRadius.circular(8)),
                ).onTap(() {
                  JTAccountScreen().launch(context);
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
                decoration: BoxDecoration(color: appColorPrimary, borderRadius: BorderRadius.circular(8)),
              ).onTap(() {
                finish(context);
                JTAccountScreen().launch(context);
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
