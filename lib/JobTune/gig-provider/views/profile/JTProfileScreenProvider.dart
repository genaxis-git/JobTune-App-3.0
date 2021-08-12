import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:prokit_flutter/JobTune/gig-provider/views/account/JTAccountScreenUsers.dart';
import 'package:prokit_flutter/JobTune/gig-provider/views/profile-setting/JTAddressScreenProvider.dart';
import 'package:prokit_flutter/JobTune/gig-provider/views/profile-setting/JTBankScreenProvider.dart';
import 'package:prokit_flutter/JobTune/gig-provider/views/profile-setting/JTContactScreenProvider.dart';
import 'package:prokit_flutter/JobTune/gig-provider/views/profile-setting/JTPersonalScreenProvider.dart';

import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTAddressScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTBankScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTContactScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTEmergencyScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTPersonalScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileWidgetUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../main.dart';

class JTProfileScreenProvider extends StatefulWidget {
  static var tag = "/JTProfileScreenProvider";

  @override
  _JTProfileScreenProviderState createState() => _JTProfileScreenProviderState();
}

class _JTProfileScreenProviderState extends State<JTProfileScreenProvider> {
  // functions starts //

  List profile = [];
  String email = " ";
  String names = " ";
  String type = " ";
  String telno = " ";
  String address = " ";
  String banktype = " ";
  String bankno = " ";
  String desc = " ";
  String img = "no profile.png";
  Future<void> readProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selectprofile&lgid=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      profile = json.decode(response.body);
    });

    setState(() {
      email = lgid;
      names = profile[0]["name"];
      desc = profile[0]["description"];
      type = profile[0]["industry_type"];
      telno = profile[0]["phone_no"];
      address = profile[0]["address"];
      banktype = profile[0]["bank_type"];
      bankno = profile[0]["bank_acc_no"];

      if(profile[0]["profile_pic"] != "") {
        img = profile[0]["profile_pic"];
      }
      else {
        img = "no profile.png";
      }
    });
  }

  List done = [];
  String totaldone = "0";
  Future<void> readDone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_countdone&id=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      done = json.decode(response.body);
    });

    setState(() {
      totaldone = done.length.toString();
    });
  }

  List notdone = [];
  String totalnotdone = "0";
  Future<void> readNotDone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_countnotdone&id=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      notdone = json.decode(response.body);
    });

    setState(() {
      totalnotdone = notdone.length.toString();
    });
  }

  String spending = "0";
  Future<void> readSpending() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_countincome&id=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      spending = double.parse(response.body).toStringAsFixed(2);
    });
  }

  @override
  void initState() {
    super.initState();
    this.readProfile();
    this.readDone();
    this.readNotDone();
    this.readSpending();
  }

  // functions ends //

  @override
  Widget build(BuildContext context) {
    jtchangeStatusColor(appStore.appBarColor!);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appStore.appBarColor,
          title: jtprofile_appBarTitleWidget(context, 'My Profile'),
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
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 70, left: 2, right: 2),
          physics: ScrollPhysics(),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 55.0),
                        decoration: jtprofile_boxDecoration(bgColor: appStore.scaffoldBackground, radius: 10, showShadow: true),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 50),
                              jtprofile_text(
                                  (names == "")
                                      ? " "
                                      : names,
                                  textColor: appStore.textPrimaryColor,
                                  fontSize: 20.0, fontFamily: 'Medium'
                              ),
                              jtprofile_text(email, textColor: Colors.blueAccent, fontSize: 16.0, fontFamily: 'Medium'),
                              jtprofile_text(type, textColor: Colors.blueAccent, fontSize: 16.0, fontFamily: 'Medium'),
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  (desc == "")
                                      ? "Write something.."
                                      : desc,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Divider(color: Color(0XFFDADADA), height: 0.5),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                                    child: Column(
                                      children: [
                                        Text(
                                          totaldone + " / " + totalnotdone,
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          "Served",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16,
                                              letterSpacing: 1,
                                              fontFamily: 'Medium'
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                                    child: Column(
                                      children: [
                                        Text(
                                          spending,
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          "Received\n(RM)",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16,
                                              letterSpacing: 1,
                                              fontFamily: 'Medium'
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: FractionalOffset.center,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage("http://jobtune-dev.my1.cloudapp.myiacloud.com/gig/JobTune/assets/img/" + img),
                          radius: 50,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  decoration: jtprofile_boxDecoration(bgColor: appStore.scaffoldBackground, radius: 10, showShadow: true),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            jtprofile_rowHeading("PERSONAL"),
                            IconButton(
                              icon: Icon(AntDesign.edit, color: Colors.black,),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => JTPersonalScreenProvider()),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        jtprofile_profileText(
                            (names == "")
                                ? "Name.."
                                : names
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: jtprofile_view(),
                        ),
                        SizedBox(height: 8),
                        jtprofile_profileText(
                            (type == "")
                                ? "Industry Type.."
                                : type
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  decoration: jtprofile_boxDecoration(bgColor: appStore.scaffoldBackground, radius: 10, showShadow: true),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            jtprofile_rowHeading("CONTACTS"),
                            IconButton(
                              icon: Icon(AntDesign.edit, color: Colors.black,),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => JTContactScreenProvider()),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        jtprofile_profileText(
                            (telno == "")
                                ? "Phone No.."
                                : telno
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: jtprofile_view(),
                        ),
                        SizedBox(height: 8),
                        jtprofile_profileText(email),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  decoration: jtprofile_boxDecoration(bgColor: appStore.scaffoldBackground, radius: 10, showShadow: true),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            jtprofile_rowHeading("ADDRESS"),
                            IconButton(
                              icon: Icon(AntDesign.edit, color: Colors.black,),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => JTAddressScreenProvider()),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        jtprofile_profileText(
                            (address == "")
                                ? "Full Address.."
                                : address.replaceAll(",", ",\n")
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  decoration: jtprofile_boxDecoration(bgColor: appStore.scaffoldBackground, radius: 10, showShadow: true),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            jtprofile_rowHeading("BANK INFORMATION"),
                            IconButton(
                              icon: Icon(AntDesign.edit, color: Colors.black,),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => JTBankScreenProvider()),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        jtprofile_profileText(
                            (banktype == "")
                                ? "Bank Type.."
                                : banktype
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: jtprofile_view(),
                        ),
                        SizedBox(height: 8),
                        jtprofile_profileText(
                            (bankno == "")
                                ? "Account No.."
                                : bankno
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        )
    );
  }
}
