import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:prokit_flutter/theme4/models/T4Models.dart';
import 'package:prokit_flutter/theme4/utils/T4Constant.dart';
import 'package:prokit_flutter/theme4/utils/T4DataGenerator.dart';
import 'package:prokit_flutter/theme4/utils/T4Strings.dart';
import 'package:prokit_flutter/theme4/utils/T4Widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import 'JTClockingRecordUser.dart';


class JTClockingScreenUser extends StatefulWidget {
  @override
  _JTClockingScreenUserState createState() => _JTClockingScreenUserState();
}

class _JTClockingScreenUserState extends State<JTClockingScreenUser> {
  int selectedPos = 1;
  late List<T4NewsModel> mListings;

  // function starts //

  List clocking = [];
  Future<void> readClocking() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selecttimesheet&id=" + lgid),
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
      body: Container(
        child: Column(
          children: <Widget>[
            TopBar("Clocking"),
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

  List clocking = [];
  String img = "no profile.png";

  Future<void> readClocking() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selecttimesheet&id=" +
                lgid),
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
                          imageUrl: "http://jobtune-dev.my1.cloudapp.myiacloud.com/gig/JobTune/assets/img/" + clocking[index]["profile_pic"],
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
                                  text(clocking[index]["name"],
                                      textColor: appStore.textPrimaryColor,
                                      fontSize: textSizeLargeMedium,
                                      maxLine: 3,
                                      fontFamily: fontBold),
                                  (clocking[index]["rate_by"] == "Package")
                                  ? text("(" + clocking[index]["package_name"] + ")",
                                      fontSize: textSizeMedium,
                                      maxLine: 3,
                                      textColor: appStore.textPrimaryColor)
                                  : Container(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      List<Location> locations = await locationFromAddress(clocking[index]["location"]);
//                                      var first = addresses.first;
                                      print("coordinate: ");
                                      print(locations[0].toString().split(",")[0].split(": ")[1]);
                                      print(locations[0].toString().split(",")[1].split(": ")[1]);
//                                      var coordinate = first.coordinates;
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
                                      clocking[index]["location"].replaceAll(",",",\n"),
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
                                      text(" " + clocking[index]["service_start"].split(" ")[0],
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
                                      text(" " + clocking[index]["service_start"].split(" ")[1],
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
                                      text(" " + clocking[index]["service_end"].split(" ")[1],
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
                                  builder: (context) => JTClockingRecordUser(
                                    timein: clocking[index]["clock_in"],
                                    timeout: clocking[index]["clock_out"],
                                    imgin: clocking[index]["evidence_in"],
                                    imgout: clocking[index]["evidence_out"],
                                    bookid: clocking[index]["booking_id"],
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
