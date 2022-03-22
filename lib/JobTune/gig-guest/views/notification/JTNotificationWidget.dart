import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/resume/JTResumeScreen.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import '../../../../main.dart';
import 'JTNotificationScreen.dart';
import 'JTOpenNotiScreen.dart';


class JTNotificationWidget extends StatefulWidget {
  static String tag = '/CartListView';

  bool? mIsEditable;
  bool? isOrderSummary;

  JTNotificationWidget({this.mIsEditable, this.isOrderSummary});

  @override
  JTNotificationWidgetState createState() => JTNotificationWidgetState();
}

class JTNotificationWidgetState extends State<JTNotificationWidget> {

  List follows = [];
  Future<void> readNoti() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectallnoti&id="+ lgid
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      follows = json.decode(response.body);
    });
  }

  Future<void> updateNoti(id) async {

    http.get(
        Uri.parse(
            server + "jtnew_user_updatenoti&id="+ id
        ),
        headers: {"Accept": "application/json"});

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JTOpenNotiScreen(id: id)),
    );
  }

  @override
  void initState() {
    super.initState();
    this.readNoti();
  }


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: follows == null ? 0 : follows.length,
        itemBuilder: (BuildContext context, int index) {
          final DateFormat formatter = DateFormat('d MMM yyyy kk:mm:ss');
          final String formatted01 = formatter.format(DateTime.parse(follows[index]["noti_date"]));
          if(follows[index]["status"] == "unseen"){
            return Card(
              color: appStore.appBarColor,
              margin: EdgeInsets.all(8),
              elevation: 2,
              child: ListTile(
                onTap: () {
                  setState(() {
                    follows[index]["status"] = "seen";
                  });
                  updateNoti(follows[index]["noti_id"]);
                },
                // leading: CircleAvatar(radius: 20, backgroundImage: Image.asset(userList[index].images!).image),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(image + follows[index]["profile_pic"]), // no matter how big it is, it won't overflow
                ),
                title: Text(
                  follows[index]["name"],
                  style: boldTextStyle(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Text(follows[index]["subject"], style: secondaryTextStyle()),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(7, 2, 7, 2),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.purpleAccent,
                            Colors.indigoAccent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 15,
                        minHeight: 15,
                      ),
                      child: Text(
                        'new',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right, color: appStore.iconColor),
                  ],
                )
              ),
            );
          }
          else{
            return Card(
              color: appStore.appBarColor,
              margin: EdgeInsets.all(8),
              elevation: 2,
              child: ListTile(
                onTap: () {
                  updateNoti(follows[index]["noti_id"]);
                },
                // leading: CircleAvatar(radius: 20, backgroundImage: Image.asset(userList[index].images!).image),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(image + follows[index]["profile_pic"]), // no matter how big it is, it won't overflow
                ),
                title: Text(
                  follows[index]["name"],
                  style: boldTextStyle(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Text(follows[index]["subject"], style: secondaryTextStyle()),
                ),
                trailing: Container(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(Icons.chevron_right, color: appStore.iconColor),
                ),
              ),
            );
          }
        });
  }
}

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({
    Key? key,
    required this.id,
    required this.cat
  }) : super(key: key);
  final String id;
  final String cat;

  @override
  _MatchingScreenState createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: appBarTitleWidget(context, 'Matching List'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => JTManageJobScreen()),
              // );
              Navigator.pop(context);
            }),
      ),
      body: MatchingList(id: widget.id,cat:widget.cat),
    );
  }
}


class MatchingList extends StatefulWidget {

  const MatchingList({
    Key? key,
    required this.id,
    required this.cat,
  }) : super(key: key);
  final String id;
  final String cat;

  @override
  MatchingListState createState() => MatchingListState();
}

class MatchingListState extends State<MatchingList> {

  List alertlist = [];
  String empr = "";
  Future<void> readMatch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('employerID').toString();

    http.Response response = await http.get(
        Uri.parse(server + "jtnew_employer_selectmatching&cat="+widget.cat),
        headers: {"Accept": "application/json"});

    this.setState(() {
      alertlist = json.decode(response.body);
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
        itemCount: alertlist == null ? 0 : alertlist.length,
        itemBuilder: (BuildContext context, int index) {
          if(alertlist.length > 0){
            return Container(
              decoration: boxDecorationRoundedWithShadow(8,
                  backgroundColor: appStore.appBarColor!),
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 80,
                      width: 80,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            image + alertlist[index]["profile_pic"]),
                        // radius: 35,
                      )
                  ),
                  12.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(alertlist[index]["city"],
                          style: primaryTextStyle(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      4.height,
                      Row(
                        children: [
                          Text(
                            alertlist[index]["first_name"] + " " + alertlist[index]["last_name"],
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: appStore.textPrimaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      8.height,
                      Text('Phone No : ' + alertlist[index]["phone_no"],
                          style: primaryTextStyle(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      8.height,
                      Text('Specialize : ' + alertlist[index]["category"],
                          style: primaryTextStyle(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      8.height,
                      Row(
                        children: [
                          Container(
                            decoration: boxDecorationWithRoundedCorners(
                              borderRadius: BorderRadius.circular(4),
                              backgroundColor: appDark_parrot_green,
                            ),
                            padding: EdgeInsets.all(6.5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                6.width,
                                Text('View',
                                    style: boldTextStyle(color: whiteColor)),
                                6.width,
                              ],
                            ),
                          ).onTap(() async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => JTResumeScreen(
                                id: alertlist[index]["email"],
                                job: widget.id,
                                empr: empr,
                              )),
                            );
                          }),
                          10.width,
                          Container(
                            decoration: boxDecorationWithRoundedCorners(
                              borderRadius: BorderRadius.circular(4),
                              backgroundColor: appColorPrimaryDark,
                            ),
                            padding: EdgeInsets.all(4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                6.width,
                                Text('Shortlist',
                                    style: boldTextStyle(color: whiteColor)),
                                6.width,
                                Icon(Icons.check_rounded, color: whiteColor)
                                    .onTap(() {}),
                              ],
                            ),
                          ).onTap(() async {
                            showInDialog(context,
                                child: AcceptRequestDialog(
                                  id: widget.id,
                                  emp: alertlist[index]["email"],
                                ),
                                backgroundColor: Colors.transparent,
                                contentPadding: EdgeInsets.all(0));
                          })
                        ],
                      ),
                    ],
                  ).expand(),
                ],
              ),
            );
          }
          else{
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network('https://jobtune.ai/gig/JobTune/assets/mobile/database.jpg'),
                Text("No matching candidate can be suggested yet.", textAlign: TextAlign.center, style: secondaryTextStyle()).paddingAll(8),
              ],
            );
          }
        });
  }
}


class AcceptRequestDialog extends StatefulWidget {
  var id;
  var emp;

  AcceptRequestDialog({
    this.id,
    this.emp,
  });

  @override
  _AcceptRequestDialogState createState() => _AcceptRequestDialogState();
}

class _AcceptRequestDialogState extends State<AcceptRequestDialog> {
  var autoValidate = false;
  var formKey = GlobalKey<FormState>();

  Future<void> addShortlist() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jobtuneUser = prefs.getString('employerID');
    http.get(
        Uri.parse(server +
            "jtnew_employer_insertshortlist&jpostid=" + widget.id +
            "&jemployeeid=" + widget.emp +
            "&jemployerid=" + jobtuneUser.toString()
        ),
        headers: {"Accept": "application/json"});

    Navigator.pop(context);
    showInDialog(context,
        child: AlertAdded(),
        backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));

    toast("Request accepted successfully");
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: dynamicBoxConstraints(),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appStore.scaffoldBackground,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shortlist Candidate', style: boldTextStyle(size: 18)),
                    IconButton(
                      icon: Icon(Icons.close, color: appStore.iconColor),
                      onPressed: () {
                        finish(context);
                      },
                    )
                  ],
                ),
                Text('Are you sure you want to add this candidate to your shortlist?'),
                16.height,
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            addShortlist();
                          },
                          child: Container(
                            // width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: appColorPrimary,
                                borderRadius:
                                BorderRadius.all(Radius.circular(5))),
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Center(
                              child: Text("Yes",
                                  style: boldTextStyle(color: white)),
                            ),
                          ),
                        )),
                    8.width,
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          // width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: redColor,
                              borderRadius:
                              BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Center(
                            child:
                            Text("Cancel", style: boldTextStyle(color: white)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                16.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
