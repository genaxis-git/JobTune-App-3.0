import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:prokit_flutter/JobTune/gig-guest/views/change-password/JTChangePasswordWidget.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-provider/views/account/JTAccountScreenUsers.dart';
import 'package:prokit_flutter/JobTune/gig-service/models/JTTransactionUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/account/JTAccountScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/transaction/JTTransactionWidgetUser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';

class JTServiceHistoryScreen extends StatefulWidget {
  static String tag = '/JTServiceHistoryScreen';

  @override
  _JTServiceHistoryScreenState createState() => _JTServiceHistoryScreenState();
}

class _JTServiceHistoryScreenState extends State<JTServiceHistoryScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: jtchangepsw_appBarTitleWidget(context, 'Service History'),
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
        child: Padding(
          padding: EdgeInsets.all(10),
          child: HistoryList(),
        ),
      ),
    );
  }
}


class HistoryList extends StatefulWidget {
  static String tag = '/HistoryList';

  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {

  // function start //

  List spendinglist = [];
  Future<void> readSpend() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selecthistory&id="+lgid
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
                        trans_text(months[DateTime.parse(spendinglist[index]["booking_date"]).month-1].toString(), fontSize: 14.0),
                        trans_text(DateTime.parse(spendinglist[index]["booking_date"]).day.toString(), fontSize: 18.0, textColor: appStore.textSecondaryColor),
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
                              // trans_text("RM "+spendinglist[index]["total_amount"], textColor: appStore.textSecondaryColor, fontSize: 14.0, fontFamily: 'Semibold')
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          (spendinglist[index]["name"] != spendinglist[index]["name"])
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              trans_text(spendinglist[index]["name"], fontSize: 14.0),
                              trans_text("("+spendinglist[index]["name"]+")", fontSize: 14.0)
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
