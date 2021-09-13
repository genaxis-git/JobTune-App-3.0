import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/index/JTDashboardScreenNomad.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/profile-settings/employer/JTAddressScreenEmployer.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/profile-settings/employer/JTContactScreenEmployer.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/profile-settings/employer/JTPersonalScreenEmployer.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/account/JTAccountScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTAddressScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTContactScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTPersonalScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileWidgetUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../main.dart';


class JTProfileScreenEmployer extends StatefulWidget {
  static var tag = "/JTProfileScreenEmployer";

  @override
  _JTProfileScreenEmployerState createState() => _JTProfileScreenEmployerState();
}

class _JTProfileScreenEmployerState extends State<JTProfileScreenEmployer> {

  // functions starts //

  List profile = [];
  String email = " ";
  String telno = " ";
  String fullname = " ";
  String desc = " ";
  String address = " ";
  String regno = " ";
  String type = " ";
  String website = " ";
  String fb = " ";
  String img = "no profile.png";
  Future<void> readProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('employerID').toString();

    http.Response response = await http.get(
        Uri.parse(
            dev + "jtnew_employer_selectprofile&lgid=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      profile = json.decode(response.body);
    });

    setState(() {
      email = lgid;
      fullname = profile[0]["company_name"];
      desc = profile[0]["description"] ;
      telno = profile[0]["phone_no"] ;
      regno = profile[0]["company_reg_no"] ;
      type = profile[0]["industry_type"] ;
      website = profile[0]["social_website"] ;
      fb = profile[0]["social_fb"] ;
      address = profile[0]["address"] ;

      if(profile[0]["profile_pic"] != "") {
        img = profile[0]["profile_pic"];
      }
      else {
        img = "no profile.png";
      }
    });
  }

  List booking = [];
  String booktotal = "0";
  Future<void> readBooking() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            dev + "jtnew_user_countbooking&id=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      booking = json.decode(response.body);
    });

    setState(() {
      booktotal = booking.length.toString();
    });
  }

  String spending = "0";
  Future<void> readSpending() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            dev + "jtnew_user_countspending&id=" + lgid),
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
    this.readSpending();
    this.readBooking();
  }

  // functions ends //

  @override
  Widget build(BuildContext context) {
    jtchangeStatusColor(appStore.appBarColor!);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appStore.appBarColor,
          title: jtprofile_appBarTitleWidget(context, 'Company Profile'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JTDashboardScreenNomad(id:"Employer")),
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
                                          booktotal,
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          "Posted",
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
                                          "Hired",
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
                          backgroundImage: NetworkImage(imagedev + img),
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
                            jtprofile_rowHeading("COMPANY OVERVIEW"),
                            IconButton(
                              icon: Icon(AntDesign.edit, color: Colors.black,),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => JTPersonalScreenEmployer()),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        jtprofile_profileText(
                            (fullname == "")
                                ? "Company name.."
                                : fullname
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: jtprofile_view(),
                        ),
                        jtprofile_profileText(
                            (regno == "")
                                ? "Registration No.."
                                : regno
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: jtprofile_view(),
                        ),
                        jtprofile_profileText(
                            (type == "")
                                ? "Industry type.."
                                : type
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: jtprofile_view(),
                        ),
                        jtprofile_profileText(
                            (website == "")
                                ? "Social website.."
                                : website
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: jtprofile_view(),
                        ),
                        jtprofile_profileText(
                            (fb == "")
                                ? "Social media.."
                                : fb
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
                                  MaterialPageRoute(builder: (context) => JTContactScreenEmployer()),
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
                                  MaterialPageRoute(builder: (context) => JTAddressScreenEmployer()),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        jtprofile_profileText(
                            (address == "")
                                ? "Full Address.."
                                : " "+address.replaceAll(",", ",\n")
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