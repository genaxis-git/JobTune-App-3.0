import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/account/employee/JTAccountScreenEmployee.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:prokit_flutter/theme4/models/T4Models.dart';
import 'package:prokit_flutter/theme4/utils/T4Constant.dart';
import 'package:prokit_flutter/theme4/utils/T4DataGenerator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import 'JTClockingEmployee.dart';
import 'JTClockingRecordEmployee.dart';


class JTClockingScreenEmployee extends StatefulWidget {
  @override
  _JTClockingScreenEmployeeState createState() => _JTClockingScreenEmployeeState();
}

class _JTClockingScreenEmployeeState extends State<JTClockingScreenEmployee> {
  int selectedPos = 1;
  late List<T4NewsModel> mListings;

  // function starts //

  List clocking = [];
  Future<void> readClocking() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_employee_selecttimesheet&id=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      clocking = json.decode(response.body);
    });
  }

  @override
  void initState() {
    super.initState();
    this.readClocking();
    selectedPos = 1;
    mListings = getList1Data();
  }

  // function ends //


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    changeStatusColor(appStore.appBarColor!);

    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: appBarTitleWidget(context, 'Clocking'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => JTAccountScreenEmployee()),
              );
            }),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: ClockingListing(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ClockingListing extends StatefulWidget {
  @override
  _ClockingListingState createState() => _ClockingListingState();
}

class _ClockingListingState extends State<ClockingListing> {

  // function starts //

  String img = "no profile.png";
  List clocking = [];
  Future<void> readClocking() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_employee_selecttimesheet&id=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      clocking = json.decode(response.body);
    });
  }

  @override
  void initState() {
    super.initState();
    this.readClocking();
  }

  // function ends //

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    changeStatusColor(appStore.appBarColor!);
    return ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: clocking == null ? 0 : clocking.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 0, 16),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      ClipRRect(
                        child: CachedNetworkImage(
                          placeholder: placeholderWidgetFn() as Widget Function(BuildContext, String)?,
                          imageUrl: "https://jobtune.ai/gig/JobTune/assets/img/" + clocking[index]["profile_pic"],
                          width: width / 4,
                          height: width / 4.2,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  text(clocking[index]["job_name"],
                                      textColor: appStore.textPrimaryColor,
                                      fontSize: textSizeLargeMedium,
                                      maxLine: 3,
                                      fontFamily: fontBold),
                                  text("(" + clocking[index]["company_name"] + ")"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      List<Location> locations = await locationFromAddress(clocking[index]["job_address"]);
                                      print("coordinate: ");
                                      print(locations[0].toString().split(",")[0].split(": ")[1]);
                                      print(locations[0].toString().split(",")[1].split(": ")[1]);
                                      var latitude = locations[0].toString().split(",")[0].split(": ")[1];
                                      var longitude = locations[0].toString().split(",")[1].split(": ")[1];

                                      String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                                      if (await canLaunch(googleUrl)) {
                                        await launch(googleUrl);
                                      } else {
                                        throw 'Could not open the map.';
                                      }
                                    },
                                    child: Text(
                                      clocking[index]["address"].replaceAll(",",",\n"),
                                      style: TextStyle(
                                        fontSize: textSizeSMedium,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today_outlined,size: textSizeSMedium,color: Colors.blueAccent,),
                                      text(" " + clocking[index]["job_startdate"] + " - " + clocking[index]["job_enddate"],
                                          fontSize: textSizeSMedium, maxLine: 3),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      (clocking[index]["clock_in"] == "0000-00-00 00:00:00")
                                          ? Icon(Icons.directions_walk_outlined,size: textSizeSMedium,color: Colors.blueAccent,)
                                          : (clocking[index]["in_status"] != "")
                                          ? Icon(Icons.check_circle,size: textSizeSMedium,color: Colors.green,)
                                          : Icon(Icons.check_circle_outline,size: textSizeSMedium,color: Colors.orangeAccent,),
                                      text(" " + clocking[index]["job_starttime"],
                                          fontSize: textSizeSMedium, maxLine: 3),
                                      (clocking[index]["in_status"] != "")
                                          ? Text(
                                          clocking[index]["in_status"],
                                          style: TextStyle(
                                              fontSize: textSizeSMedium,
                                              color: Colors.green
                                          )
                                      )
                                          : Text(""),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      (clocking[index]["clock_out"] == "0000-00-00 00:00:00")
                                          ? Icon(Icons.logout_rounded,size: textSizeSMedium,color: Colors.blueAccent,)
                                          : (clocking[index]["out_status"] != "")
                                          ? Icon(Icons.check_circle,size: textSizeSMedium,color: Colors.green,)
                                          : Icon(Icons.check_circle_outline,size: textSizeSMedium,color: Colors.orangeAccent,),
                                      text(" " + clocking[index]["job_endtime"],
                                          fontSize: textSizeSMedium, maxLine: 3),
                                      (clocking[index]["out_status"] != "")
                                          ? Text(
                                          clocking[index]["out_status"],
                                          style: TextStyle(
                                              fontSize: textSizeSMedium,
                                              color: Colors.green
                                          )
                                      )
                                          : Text(""),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DayList(
                                    id: clocking[index]["job_id"],
                                  )),
                            );
                          },
                          icon: Icon(Icons.arrow_forward_ios,size: textSizeLargeMedium,)
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Divider()
                ],
              ));
        }
    );
  }
}

class DayList extends StatefulWidget {
  const DayList({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _DayListState createState() => _DayListState();
}

class _DayListState extends State<DayList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: appBarTitleWidget(context, 'Clocking'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Align(
        alignment: Alignment.center,
        child: DayScreen(id: widget.id),
      )
    );
  }
}

class DayScreen extends StatefulWidget {
  const DayScreen({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _DayScreenState createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  List joblist = [];
  String empr = "";
  Future<void> readMatch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(server + "jtnew_employee_selectday&jobid=" + widget.id
        + "&empid=" + lgid
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      joblist = json.decode(response.body);
      empr = lgid;
    });
  }


  @override
  void initState() {
    super.initState();
    this.readMatch();
  }


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: joblist == null ? 0 : joblist.length,
        itemBuilder: (BuildContext context, int index) {
          int adding = int.parse(joblist[index]["day"]) - 1;
          var today = DateTime.parse(joblist[index]["job_startdate"] + " " + joblist[index]["job_starttime"]);
          var after = today.add(Duration(days: adding));
          return Card(
            color: appStore.appBarColor,
            margin: EdgeInsets.all(8),
            elevation: 2,
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => JTClockingRegular(
                        timein: joblist[index]["clock_in"],
                        timeout: joblist[index]["clock_out"],
                        imgin: joblist[index]["in_evidence"],
                        imgout: joblist[index]["out_evidence"],
                        day: joblist[index]["day"],
                        jobid: joblist[index]["job_id"],
                      )),
                );
              },
              title: Text(
                "Day " + joblist[index]["day"],
                style: boldTextStyle(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Container(
                margin: EdgeInsets.only(top: 4),
                child: Text(after.toString().split(".")[0], style: secondaryTextStyle()),
              ),
              trailing: Container(
                padding: EdgeInsets.only(right: 4),
                child: Icon(Icons.chevron_right, color: appStore.iconColor),
              ),
            ),
          );
        });
  }
}