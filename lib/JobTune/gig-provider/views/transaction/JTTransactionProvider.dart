import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/change-password/JTChangePasswordWidget.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-provider/views/account/JTAccountScreenUsers.dart';
import 'package:prokit_flutter/JobTune/gig-service/models/JTTransactionUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/transaction/JTTransactionWidgetUser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';

class JTTransactionProvider extends StatefulWidget {
  static String tag = '/JTTransactionProvider';

  @override
  _JTTransactionProviderState createState() => _JTTransactionProviderState();
}

class _JTTransactionProviderState extends State<JTTransactionProvider> {
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
                MaterialPageRoute(builder: (context) => JTAccountScreenUsers()),
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
                                  "Pending / On-going",
                                  style: TextStyle(fontSize: 18.0, fontFamily: 'Bold'),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Completed",
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
                  child: SpendingList(),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: ReveiceList(),
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
print(server + "jtnew_provider_selectpending&id="+lgid);
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectpending&id="+lgid
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child:Image.network(
                          "http://jobtune.ai/gig/JobTune/assets/img/"+spendinglist[index]["profile_pic"],
                          fit: BoxFit.cover,
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
                              trans_text(spendinglist[index]["first_name"] + " " + spendinglist[index]["last_name"], textColor: appStore.textPrimaryColor, fontSize: 14.0, fontFamily: 'Semibold'),
                              trans_text("RM "+double.parse(spendinglist[index]["total_amount"]).toStringAsFixed(2), textColor: appStore.textSecondaryColor, fontSize: 14.0, fontFamily: 'Semibold'),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              trans_text(spendinglist[index]["package_name"], fontSize: 14.0),
                              trans_text("- RM "+spendinglist[index]["insurance_fee"], textColor: Colors.red, fontSize: 14.0, fontFamily: 'Semibold'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              trans_text("RM "+(double.parse(spendinglist[index]["total_amount"])-double.parse(spendinglist[index]["insurance_fee"])).toStringAsFixed(2), textColor: Colors.green, fontSize: 14.0, fontFamily: 'Bold'),
                            ],
                          )
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


class ReveiceList extends StatefulWidget {
  static String tag = '/ReveiceList';

  @override
  _ReveiceListState createState() => _ReveiceListState();
}

class _ReveiceListState extends State<ReveiceList> {

  // function start //

  List spendinglist = [];
  Future<void> readSpend() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectcomplete&id="+lgid
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child:Image.network(
                          "http://jobtune.ai/gig/JobTune/assets/img/"+spendinglist[index]["profile_pic"],
                          fit: BoxFit.cover,
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
                              trans_text(spendinglist[index]["first_name"] + " " + spendinglist[index]["last_name"], textColor: appStore.textPrimaryColor, fontSize: 14.0, fontFamily: 'Semibold'),
                              trans_text("RM "+double.parse(spendinglist[index]["total_amount"]).toStringAsFixed(2), textColor: appStore.textSecondaryColor, fontSize: 14.0, fontFamily: 'Semibold')
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              trans_text(spendinglist[index]["package_name"], fontSize: 14.0),
                              trans_text("- RM "+spendinglist[index]["insurance_fee"], textColor: Colors.red, fontSize: 14.0, fontFamily: 'Semibold'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              trans_text("RM "+(double.parse(spendinglist[index]["total_amount"])-double.parse(spendinglist[index]["insurance_fee"])).toStringAsFixed(2), textColor: Colors.green, fontSize: 14.0, fontFamily: 'Bold'),
                            ],
                          )
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