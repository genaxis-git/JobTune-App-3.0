import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/change-password/JTChangePasswordWidget.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-service/models/JTTransactionUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/account/JTAccountScreenUsers.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';

import '../../../../main.dart';
import 'JTTransactionWidgetUser.dart';

class JTTransactionScreen extends StatefulWidget {
  static String tag = '/JTTransactionScreen';

  @override
  _JTTransactionScreenState createState() => _JTTransactionScreenState();
}

class _JTTransactionScreenState extends State<JTTransactionScreen> {
  int selectedPos = 1;
  late List<SpendingModel> mListings;

  @override
  void initState() {
    super.initState();
    selectedPos = 1;
    mListings = getBillData();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: jtchangepsw_appBarTitleWidget(context, 'Transaction'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JTDashboardSreenUser()),
              );
            }
        ),
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(127),
              child: Container(
                color: appStore.scaffoldBackground,
                child: SafeArea(
                  child: Container(
                    color: appStore.scaffoldBackground,
                    margin: EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 50),
                        trans_text("Transaction History", textColor: appStore.textPrimaryColor, fontSize: 24.0, fontFamily: 'Bold'),
                        SizedBox(height: 9),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.3,
                          color: appStore.scaffoldBackground,
                          child: TabBar(
                            labelPadding: EdgeInsets.only(left: 0, right: 0),
                            indicatorWeight: 4.0,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: Colors.blueAccent,
                            labelColor: Colors.blueAccent,
                            isScrollable: true,
                            unselectedLabelColor: Colors.black45,
                            tabs: [
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Spending",
                                  style: TextStyle(fontSize: 18.0, fontFamily: 'Bold'),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Received",
                                  style: TextStyle(fontSize: 18.0, fontFamily: 'Bold'),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: mListings.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 18, bottom: 18),
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      trans_text("Oct", fontSize: 14.0),
                                      trans_text(mListings[index].day, fontSize: 18.0, textColor: appStore.textSecondaryColor),
                                    ],
                                  ),
                                  Container(
                                    decoration: trans_boxDecoration(radius: 8, showShadow: true),
                                    margin: EdgeInsets.only(left: 16, right: 16),
                                    width: width / 7.2,
                                    height: width / 7.2,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child:Image.asset(
                                        mListings[index].icon,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
//                                    padding: EdgeInsets.all(width / 30),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            trans_text(mListings[index].name, textColor: appStore.textPrimaryColor, fontSize: 14.0, fontFamily: 'Semibold'),
                                            trans_text(mListings[index].amount, textColor: appStore.textSecondaryColor, fontSize: 14.0, fontFamily: 'Semibold')
                                          ],
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        ),
                                        trans_text("Mastercard", fontSize: 14.0)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(height: 0.5, color: Color(0XFFB4BBC2))
                          ],
                        );
                      }),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: mListings.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 18, bottom: 18),
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      trans_text("Oct", fontSize: 14.0),
                                      trans_text(mListings[index].day, fontSize: 18.0, textColor: appStore.textSecondaryColor),
                                    ],
                                  ),
                                  Container(
                                    decoration: trans_boxDecoration(radius: 8, showShadow: true),
                                    margin: EdgeInsets.only(left: 16, right: 16),
                                    width: width / 7.2,
                                    height: width / 7.2,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child:Image.asset(
                                        mListings[index].icon,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
//                                    padding: EdgeInsets.all(width / 30),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            trans_text(mListings[index].name, textColor: appStore.textPrimaryColor, fontSize: 14.0, fontFamily: 'Semibold'),
                                            trans_text(mListings[index].amount, textColor: appStore.textSecondaryColor, fontSize: 14.0, fontFamily: 'Semibold')
                                          ],
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        ),
                                        trans_text("Mastercard", fontSize: 14.0)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(height: 0.5, color: Color(0XFFB4BBC2))
                          ],
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

