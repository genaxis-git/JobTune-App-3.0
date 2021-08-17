import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:prokit_flutter/JobTune/gig-guest/views/change-password/JTChangePasswordWidget.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-service/models/JTTransactionUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/account/JTAccountScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/account/JTAccountScreenUsers.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                MaterialPageRoute(builder: (context) => JTAccountScreenUser()),
              );
            }
        ),
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 1,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: Container(
                color: appStore.scaffoldBackground,
                child: SafeArea(
                  child: Container(
                    color: appStore.scaffoldBackground,
                    margin: EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20),
                        // trans_text("Transaction History", textColor: appStore.textPrimaryColor, fontSize: 24.0, fontFamily: 'Bold'),
                        // SizedBox(height: 9),
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
                                  "Spending History",
                                  style: TextStyle(fontSize: 18.0, fontFamily: 'Bold'),
                                ),
                              ),
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
                  child: SpendingList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class SpendingList extends StatefulWidget {
  static String tag = '/SpendingList';

  @override
  _SpendingListState createState() => _SpendingListState();
}

class _SpendingListState extends State<SpendingList> {

  // function start //

  List spendinglist = [];
  Future<void> readSpend() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectspend&id="+lgid
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      spendinglist = json.decode(response.body);
    });
  }

  // function ends //

  @override
  void initState() {
    super.initState();
    this.readSpend();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    List months = ['Jan', 'Feb', 'Mar', 'Apr', 'May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: spendinglist == null ? 0 : spendinglist.length,
        itemBuilder: (BuildContext context, int index) {
          print(spendinglist[index]["service_start"]);
          return Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 18, bottom: 18),
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        trans_text(months[DateTime.parse(spendinglist[index]["service_start"]).month-1].toString(), fontSize: 14.0),
                        trans_text(DateTime.parse(spendinglist[index]["service_start"]).day.toString(), fontSize: 18.0, textColor: appStore.textSecondaryColor),
                      ],
                    ),
                    Container(
                      decoration: trans_boxDecoration(radius: 8, showShadow: true),
                      margin: EdgeInsets.only(left: 16, right: 16),
                      width: width / 7.2,
                      height: width / 7.2,
                      child: DisplayImage(id:spendinglist[index]["provider_id"]),
//                                    padding: EdgeInsets.all(width / 30),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              DisplayName(id: spendinglist[index]["provider_id"]),
                              trans_text("RM "+spendinglist[index]["total_amount"], textColor: appStore.textSecondaryColor, fontSize: 14.0, fontFamily: 'Semibold')
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          (spendinglist[index]["name"] != spendinglist[index]["package_name"])
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              trans_text(spendinglist[index]["name"], fontSize: 14.0),
                              trans_text("("+spendinglist[index]["package_name"]+")", fontSize: 14.0)
                            ],
                          )
                          : trans_text(spendinglist[index]["name"], fontSize: 14.0)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Divider(height: 0.5, color: Color(0XFFB4BBC2))
            ],
          );
        });
  }
}

class DisplayImage extends StatefulWidget {
  static String tag = '/DisplayImage';
  const DisplayImage({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  _DisplayImageState createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {

  List spendinglist = [];
  String img = "no profile.png";
  Future<void> readSpend() async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selectprofile&lgid="+widget.id
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      spendinglist = json.decode(response.body);
    });

    setState(() {
      img = spendinglist[0]["profile_pic"];
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    readSpend();
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child:Image.network(
        "http://jobtune-dev.my1.cloudapp.myiacloud.com/gig/JobTune/assets/img/"+img,
        fit: BoxFit.fill,
      ),
    );
  }
}


class DisplayName extends StatefulWidget {
  static String tag = '/DisplayName';
  const DisplayName({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  _DisplayNameState createState() => _DisplayNameState();
}

class _DisplayNameState extends State<DisplayName> {

  List spendinglist = [];
  String name = "";
  Future<void> readSpend() async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selectprofile&lgid="+widget.id
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      spendinglist = json.decode(response.body);
    });
    setState(() {
      name = spendinglist[0]["name"];
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    readSpend();
    return trans_text(name, textColor: appStore.textPrimaryColor, fontSize: 14.0, fontFamily: 'Semibold');
  }
}

class ReceiveList extends StatefulWidget {
  static String tag = '/ReceiveList';

  @override
  _ReceiveListState createState() => _ReceiveListState();
}

class _ReceiveListState extends State<ReceiveList> {
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
              preferredSize: Size.fromHeight(60),
              child: Container(
                color: appStore.scaffoldBackground,
                child: SafeArea(
                  child: Container(
                    color: appStore.scaffoldBackground,
                    margin: EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20),
                        // trans_text("Transaction History", textColor: appStore.textPrimaryColor, fontSize: 24.0, fontFamily: 'Bold'),
                        // SizedBox(height: 9),
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
                                  "Spending History",
                                  style: TextStyle(fontSize: 18.0, fontFamily: 'Bold'),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Received Amount",
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
                                      trans_text("11", fontSize: 18.0, textColor: appStore.textSecondaryColor),
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
                                            trans_text("Akikah anak", textColor: appStore.textPrimaryColor, fontSize: 14.0, fontFamily: 'Semibold'),
                                            trans_text("RM 100.00", textColor: appStore.textSecondaryColor, fontSize: 14.0, fontFamily: 'Semibold')
                                          ],
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        ),
                                        trans_text("Shahirah Serba Boleh", fontSize: 14.0)
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