import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/account/JTAccountScreenUser.dart';

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
  String fullname = " ";
  String desc = " ";
  String nric = " ";
  String dob = " ";
  String race = " ";
  String gender = " ";
  String telno = " ";
  String address = " ";
  String ecname = " ";
  String ecno = " ";
  String img = "no profile.png";
  Future<void> readProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectprofile&lgid=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      profile = json.decode(response.body);
    });

    setState(() {
      email = lgid;
      fullname = profile[0]["first_name"] + " " + profile[0]["last_name"] ;
      desc = profile[0]["description"] ;
      nric = profile[0]["nric"] ;
      dob = profile[0]["dob"] ;
      race = profile[0]["race"] ;
      gender = profile[0]["gender"] ;
      telno = profile[0]["phone_no"] ;
      address = profile[0]["address"] ;
      ecname = profile[0]["ec_name"] ;
      ecno = profile[0]["ec_phone_no"] ;

      if(profile[0]["profile_pic"] != "") {
        img = profile[0]["profile_pic"];
      }
      else {
        img = "no profile.png";
      }
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
                MaterialPageRoute(builder: (context) => JTAccountScreenUser()),
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
                                (fullname == "")
                                    ? " "
                                    : fullname,
                                textColor: appStore.textPrimaryColor,
                                fontSize: 20.0, fontFamily: 'Medium'
                            ),
                            jtprofile_text(email, textColor: Colors.blueAccent, fontSize: 16.0, fontFamily: 'Medium'),
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
                                MaterialPageRoute(builder: (context) => JTPersonalScreenUser()),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      jtprofile_profileText(
                          (fullname == " ")
                              ? "Full name.."
                              : fullname
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: jtprofile_view(),
                      ),
                      SizedBox(height: 8),
                      jtprofile_profileText(
                          (nric == "")
                              ? "NRIC No.."
                              : nric
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: jtprofile_view(),
                      ),
                      SizedBox(height: 8),
                      jtprofile_profileText(
                          (dob == "")
                              ? "Date of birth.."
                              : dob
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: jtprofile_view(),
                      ),
                      SizedBox(height: 8),
                      jtprofile_profileText(
                          (race == "")
                              ? "Race.."
                              : race
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: jtprofile_view(),
                      ),
                      SizedBox(height: 8),
                      jtprofile_profileText(
                          (gender == "")
                              ? "Gender.."
                              : gender
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
                                MaterialPageRoute(builder: (context) => JTAddressScreenUser()),
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
                          (ecname == "")
                              ? "Guardian Name.."
                              : ecname
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: jtprofile_view(),
                      ),
                      SizedBox(height: 8),
                      jtprofile_profileText(
                          (ecno == "")
                              ? "Guardian Phone No.."
                              : ecno
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