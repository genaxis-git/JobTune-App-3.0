import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:prokit_flutter/JobTune/gig-service/views/account/JTAccountScreenUsers.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTAddressScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTBankScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTContactScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTEmergencyScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTPersonalScreenUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../main.dart';
import 'JTProfileWidgetUser.dart';


class JTProfileScreenUser extends StatefulWidget {
  static var tag = "/JTProfileScreenUser";
  
  @override
  _JTProfileScreenUserState createState() => _JTProfileScreenUserState();
}

class _JTProfileScreenUserState extends State<JTProfileScreenUser> {

  // functions starts //

  List profile = [];
  String email = " ";
  Future<void> readProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectprofile&lgid=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      email = lgid;
      profile = json.decode(response.body);
    });
  }

  @override
  void initState() {
    super.initState();
    this.readProfile();
  }

  // functions ends //

  @override
  Widget build(BuildContext context) {
    print(profile[0]["email"]);
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
                                (profile[0]["first_name"] == null && profile[0]["last_name"] == null)
                                    ? " "
                                    : profile[0]["first_name"] + " " + profile[0]["last_name"],
                                textColor: appStore.textPrimaryColor,
                                fontSize: 20.0, fontFamily: 'Medium'
                            ),
                            jtprofile_text(email, textColor: Colors.blueAccent, fontSize: 16.0, fontFamily: 'Medium'),
                            SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                (profile[0]["description"] == null)
                                    ? "Write something.."
                                    : profile[0]["description"],
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
                                        "50",
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Booking",
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
                                        "500",
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Spent (RM)",
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
                        backgroundImage: AssetImage("images/dashboard/db_profile.jpeg"),
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
                                MaterialPageRoute(builder: (context) => JTPersonalScreenUser()),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      jtprofile_profileText(
                          (profile[0]["first_name"] == null && profile[0]["last_name"] == null)
                              ? "Full name.."
                              : profile[0]["first_name"] + " " + profile[0]["last_name"]
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: jtprofile_view(),
                      ),
                      SizedBox(height: 8),
                      jtprofile_profileText(
                          (profile[0]["nric"] == null)
                              ? "NRIC No.."
                              : profile[0]["nric"]
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: jtprofile_view(),
                      ),
                      SizedBox(height: 8),
                      jtprofile_profileText(
                          (profile[0]["dob"] == null)
                              ? "Date of birth.."
                              : profile[0]["dob"]
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: jtprofile_view(),
                      ),
                      SizedBox(height: 8),
                      jtprofile_profileText(
                          (profile[0]["race"] == null)
                              ? "Race.."
                              : profile[0]["race"]
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: jtprofile_view(),
                      ),
                      SizedBox(height: 8),
                      jtprofile_profileText(
                          (profile[0]["gender"] == null)
                              ? "Gender.."
                              : profile[0]["gender"]
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: jtprofile_view(),
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
                                MaterialPageRoute(builder: (context) => JTContactScreenUser()),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      jtprofile_profileText(
                          (profile[0]["phone_no"] == null)
                              ? "Phone No.."
                              : profile[0]["phone_no"]
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
                                MaterialPageRoute(builder: (context) => JTAddressScreenUser()),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      jtprofile_profileText(
                          (profile[0]["address"] == null)
                              ? "Full Address.."
                              : profile[0]["address"]
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
                          jtprofile_rowHeading("EMERGENCY CONTACT"),
                          IconButton(
                            icon: Icon(AntDesign.edit, color: Colors.black,),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => JTEmergencyScreenUser()),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      jtprofile_profileText(
                          (profile[0]["ec_name"] == null)
                              ? "Guardian Name.."
                              : profile[0]["ec_name"]
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: jtprofile_view(),
                      ),
                      SizedBox(height: 8),
                      jtprofile_profileText(
                          (profile[0]["ec_phone_no"] == null)
                              ? "Guardian Phone No.."
                              : profile[0]["ec_phone_no"]
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